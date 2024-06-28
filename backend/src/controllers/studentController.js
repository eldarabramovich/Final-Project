const { db , admin , bucket } = require('../firebase/firebaseAdmin.js');
const downloadFile = async (req, res) => {
  const { fileId } = req.params;

  try {
    console.log(`Fetching file with ID: ${fileId}`);

    // Fetch file details from Firestore using the fileId
    const fileDoc = await db.collection('files').doc(fileId).get();

    if (!fileDoc.exists) {
      console.log(`File with ID: ${fileId} not found`);
      return res.status(404).send('File not found');
    }

    const fileData = fileDoc.data();
    const filePath = `${fileData.userId}/${fileData.fileName}`;

    console.log(`File path: ${filePath}`);

    // Create a reference to the file in the bucket
    const fileRef = bucket.file(filePath);

    // Get the file metadata
    const [metadata] = await fileRef.getMetadata();

    console.log(`File metadata: ${JSON.stringify(metadata)}`);

    // Set response headers for the file download
    res.setHeader('Content-Type', metadata.contentType);
    res.setHeader('Content-Disposition', `attachment; filename="${fileData.fileName}"`);

    // Create a read stream for the file and pipe it to the response
    const fileStream = fileRef.createReadStream();

    fileStream.on('error', (err) => {
      console.error('File stream error:', err);
      res.status(500).send('Error downloading file');
    });

    fileStream.pipe(res);
  } catch (error) {
    console.error('Error downloading file:', error);
    res.status(500).send('Error downloading file');
  }
};

const getStudent = async (req, res) => {
  const { studentId } = req.params;

  try {
      const studentRef = db.collection('students').doc(studentId);
      const studentDoc = await studentRef.get();

      if (!studentDoc.exists) {
          return res.status(404).send("Student not found");
      }

      res.status(200).json(studentDoc.data());
  } catch (error) {
      console.error("Error getting student: ", error);
      res.status(500).send("Error getting student");
  }
};

const editStudent = async (req, res) => {
  const { studentId } = req.params;
  const { username, password, fullname, classname, subClassName } = req.body;

  try {
      const studentRef = db.collection('students').doc(studentId);
      const studentDoc = await studentRef.get();

      if (!studentDoc.exists) {
          return res.status(404).send("Student not found");
      }

      await studentRef.update({
          username: username || studentDoc.data().username,
          password: password || studentDoc.data().password,
          fullname: fullname || studentDoc.data().fullname,
          classname: classname || studentDoc.data().classname,
          subClassName: subClassName || studentDoc.data().subClassName
      });

      res.status(200).send("Student updated successfully");
  } catch (error) {
      console.error("Error editing student: ", error);
      res.status(500).send("Error editing student");
  }
};

const deleteStudent = async (req, res) => {
  const { studentId } = req.params;

  try {
      const studentRef = db.collection('students').doc(studentId);
      const studentDoc = await studentRef.get();

      if (!studentDoc.exists) {
          return res.status(404).send("Student not found");
      }

      const { fullname, classname, subClassName } = studentDoc.data();

      // Remove the student from the class document
      const classSnapshot = await db.collection('classes').where('classLetter', '==', classname.charAt(0)).get();
      if (!classSnapshot.empty) {
          classSnapshot.forEach(async (doc) => {
              await doc.ref.update({
                  students: admin.firestore.FieldValue.arrayRemove({ id: studentId, name: fullname })
              });
          });
      }

      // Remove the student from the subclass document if assigned
      if (subClassName) {
          const subClassSnapshot = await db.collection('subClasses').where('classNumber', '==', subClassName).get();
          if (!subClassSnapshot.empty) {
              subClassSnapshot.forEach(async (doc) => {
                  await doc.ref.update({
                      students: admin.firestore.FieldValue.arrayRemove({ id: studentId, name: fullname })
                  });
              });
          }
      }

      // Delete the student document from the students collection
      await studentRef.delete();

      res.status(200).send("Student deleted successfully");
  } catch (error) {
      console.error("Error deleting student: ", error);
      res.status(500).send("Error deleting student");
  }
};

const getStudentData = async (req, res) => {
  const userId = req.params.userId;

  try {
    const teacherRef = admin.firestore().collection('students').doc(userId);
    const doc = await teacherRef.get();

    if (doc.exists) {
      res.status(200).json(doc.data());
    } else {
      res.status(404).send('student not found');
    }
  } catch (error) {
    console.error('Error student teacher data:', error);
    res.status(500).send('Internal Server Error');
  }
};

const GetMessageByClassname = async (req, res) => {
  try {
    const classname = req.params.classname; // Changed from req.query.classname to req.params.classname
    const db = admin.firestore();

    const classQuerySnapshot = await db.collection('subClasses')
                                      .where('classname', '==', classname)
                                      .get();
    
    if (classQuerySnapshot.empty) {
      return res.status(404).send('SubClass not found');
    }

    // Assuming there is only one class with this classname
    const classDoc = classQuerySnapshot.docs[0];

    if (!classDoc.exists) {
      return res.status(404).send("Class not found");
    }
    const classData = classDoc.data();
    const messages = classData.messages || []; // Default to an empty array if messages field is missing
    res.status(200).json(messages);
  } catch (error) {
    console.error('Error fetching messages:', error); // Corrected the error message to 'messages' instead of 'assignments'
    res.status(500).send('Error fetching messages');
  }
};

const GetAssignById = async (req, res) => {
  try {
    const userId = req.params.userId;
    const db = admin.firestore();
    console.log(`Fetching assignments for student with ID: ${userId}`);
    const studentRef = db.collection('students').doc(userId);
    const studentDoc = await studentRef.get();

    if (!studentDoc.exists) {
      return res.status(404).send('Student not found');
    }

    const studentData = studentDoc.data();
    const studentClass = studentData.classname;
    console.log(`Student class: ${studentClass}`);

    const assignments = [];
    const assignmentsRef = db.collection('assignments').where('classname', '==', studentClass);
    const snapshot = await assignmentsRef.get();

    snapshot.forEach(doc => {
      assignments.push({ id: doc.id, ...doc.data() });
    });
    console.log(`Found ${assignments.length} assignments`);
    res.status(200).json(assignments);
  } catch (error) {
    console.error('Error fetching assignments:', error);
    res.status(500).send('Error fetching assignments');
  }
};

module.exports = {downloadFile,GetAssignById,GetMessageByClassname,getStudentData,editStudent,deleteStudent};