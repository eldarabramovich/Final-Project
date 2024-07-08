<<<<<<< HEAD
const { db , admin , bucket } = require('../firebase/firebaseAdmin.js');
=======
const { db , admin } = require('../firebase/firebaseAdmin.js');
const multer = require('multer');
const storage = multer.memoryStorage();
const upload = multer({ storage }).single('file');
const bucket = admin.storage().bucket('teachtouch-20b98.appspot.com');


const addSubmission = async (req, res) => {
  console.log('Received request: POST /student/addSubmission');

  const { assignmentID, fullName } = req.body;
  const file = req.file;
  const db = admin.firestore();
  const bucket = admin.storage().bucket();

  if (!assignmentID || !fullName) {
    return res.status(400).send('Missing assignment ID or full name');
  }

  if (!file) {
    console.log('No file uploaded');
    return res.status(400).send('No file uploaded.');
  }

  try {
    console.log('Preparing to upload file');
    const blob = bucket.file(`submissions/${file.originalname}`);
    const blobStream = blob.createWriteStream({
      metadata: {
        contentType: file.mimetype,
      },
    });

    blobStream.on('error', (err) => {
      console.error('Error during file upload:', err);
      res.status(500).send('Error uploading file.');
    });

    blobStream.on('finish', async () => {
      console.log('File upload finished');
      const fileUrl = `https://storage.googleapis.com/${bucket.name}/${blob.name}`;

      // Create the new submission object
      const newSubmission = {
        fileUrl: fileUrl,
        fullName: fullName,
        submittedDate: new Date(), // Using Date object for date
        grade: '' // Add grade field if required
      };

      try {
        // Update the submissions document with the new submission
        const submissionDocRef = db.collection('submissions').doc(assignmentID);
        await submissionDocRef.update({
          studentsubmission: admin.firestore.FieldValue.arrayUnion(newSubmission)
        });

        console.log('Submission added successfully');
        res.status(200).send('Submission added successfully');
      } catch (firestoreError) {
        console.error('Error updating submission document:', firestoreError);
        res.status(500).send('Error updating submission document');
      }
    });

    blobStream.end(file.buffer);
  } catch (error) {
    console.error('Error in file upload process:', error);
    res.status(500).send('Error adding submission');
  }
};

const getAssignments = async (req, res) => {
  const { userId } = req.params;
  const db = admin.firestore();

  try {
    // Fetch the student document to get the class information
    const studentDoc = await db.collection('students').doc(userId).get();
    if (!studentDoc.exists) {
      console.log('Step 2: Student not found');
      return res.status(404).send('Student not found');
    }

    const studentData = studentDoc.data();
    console.log('Step 3: Student data retrieved:', studentData);

    const studentClass = studentData.classname;
    const studentSubClass = studentData.subClassName;
    console.log('Step 4: Student class:', studentClass, ', subclass:', studentSubClass);

    // Query assignments for the student's class and subclass
    const assignmentsSnapshot = await db.collection('assignments')
      .where('classname', 'in', [studentClass, studentSubClass])
      .get();

    const assignments = [];
    assignmentsSnapshot.forEach(doc => {
      assignments.push({ id: doc.id, ...doc.data() });
    });

    console.log('Step 5: Total assignments fetched:', assignments.length);
    res.status(200).json(assignments);
  } catch (error) {
    console.error('Error fetching assignments:', error);
    res.status(500).send('Internal Server Error');
  }
};
>>>>>>> 43a9c70fe73be010dbdd065f985d1b6fa280a889

const downloadFile = async (req, res) => {
  const { fileId } = req.params;

  try {
    // Fetch file details from Firestore using the fileId
    const fileDoc = await db.collection('files').doc(fileId).get();

    if (!fileDoc.exists) {
      return res.status(404).send('File not found');
    }

    const fileData = fileDoc.data();
    const filePath = `${fileData.userId}/${fileData.fileName}`;

    // Create a reference to the file in the bucket
    const fileRef = bucket.file(filePath);

    // Get the file metadata
    const [metadata] = await fileRef.getMetadata();

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
<<<<<<< HEAD

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

=======
//as a admin i want to edit all my students for fordur changes 
>>>>>>> 43a9c70fe73be010dbdd065f985d1b6fa280a889
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
    const studentRef = admin.firestore().collection('students').doc(userId);
    const doc = await studentRef.get();

    if (doc.exists) {
      const data = doc.data();
      const studentData = {
        id: doc.id,
        fullname: data.fullname,
        classname: data.classname,
        subClassName: data.subClassName
      };
      res.status(200).json(studentData);
    } else {
      res.status(404).send('Student not found');
    }
  } catch (error) {
    console.error('Error fetching student data:', error);
    res.status(500).send('Internal Server Error');
  }
};



//think about get massage buy subclass name and class
const GetMessageByClassname = async (req, res) => {
  try {
    const classname = req.params.classname; // Changed from req.query.classname to req.params.classname
    const db = admin.firestore();

    const classQuerySnapshot = await db.collection('subClasses')
                                      .where('classNumber', '==', classname)
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

<<<<<<< HEAD

// const GetAssignById = async (req, res) => {
//     const userId = req.params.userId;
  
//     try {
//       // Query Firestore for assignments belonging to the user
//       const db = admin.firestore();
//       const assignments = [];

//         // Find the student document to get the classname
//         const studentDoc = await db.collection('students').doc(userId).get();
//         if (!studentDoc.exists) {
//             return res.status(404).send('Student not found');
//         }
//         const classname = studentDoc.data().classname;
//         console.error(classname);
//         const classDoc = await db.collection('classes').where('className', '==', classname).limit(1).get();
//         if (classDoc.empty) {
//             return res.status(404).send('Class not found for the provided student');
//         }

//         const subjects = classDoc.docs[0].data().subjects;

//         // For each subject ID, fetch the subject document and extract the assignments
//         for (const subjectId of subjects) {
//             const subjectDoc = await db.collection('subjects').doc(subjectId).get();
//             if (subjectDoc.exists) {
//                 const subjectData = subjectDoc.data();
//                 assignments.push(...subjectData.assignments);
//             }
//         }

//       // Send the assignments as a response
//       res.status(200).json(assignments);
//     } catch (error) {
//       console.error('Error fetching assignments:', error);
//       res.status(500).send('Error fetching assignments');
//     }
//   }


  module.exports = {downloadFile,GetAssignById,GetMessageByClassname,getStudentData,editStudent,deleteStudent};
=======
module.exports = {
  getAssignments,
  addSubmission,
  upload,
  downloadFile,
  GetAssignById,
  GetMessageByClassname,
  getStudentData,
  editStudent,
  deleteStudent};
>>>>>>> 43a9c70fe73be010dbdd065f985d1b6fa280a889
