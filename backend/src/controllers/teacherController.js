const multer = require('multer');
const { db ,admin} = require('../firebase/firebaseAdmin'); // Import only what you need


// Explicitly initialize the bucket here
const bucket = admin.storage().bucket('teachtouch-20b98.appspot.com');
console.log('Bucket explicitly initialized:', bucket);

const storage = multer.memoryStorage();
const upload = multer({ storage }).single('file');

const uploadFile = (req, res) => {
  
  console.log('Received file upload request');
  
  // Check if bucket is initialized
  if (!bucket) {
    console.error("Bucket not initialized");
    return res.status(500).send("Bucket not initialized");
  }

  // console.log('Bucket object:', bucket);
  const explicitBucket = admin.storage().bucket('teachtouch-20b98.appspot.com'); // Explicitly set bucket name
  // console.log('Explicit Bucket object:', explicitBucket);

  upload(req, res, async (err) => {
    if (err) {
      console.error("Error during file upload process: ", err);
      return res.status(500).send("Error uploading file");
    }

    const file = req.file;
    const { teacherId, description } = req.body;

    if (!file || !teacherId) {
      return res.status(400).send("Missing file or teacher ID");
    }
    console.log("File: ", file);
    console.log("Teacher ID: ", teacherId);
    console.log('Description:', description);
    
    try {
      const blob = explicitBucket.file(`${teacherId}/${file.originalname}`);
      console.log('Blob object:', blob);

      const blobStream = blob.createWriteStream({
        metadata: {
          contentType: file.mimetype,
        },
      });

      blobStream.on('error', (err) => {
        console.error("Blob stream error: ", err);
        res.status(500).send("Error uploading file");
      });

      blobStream.on('finish', async () => {
        const fileUrl = `https://storage.googleapis.com/${explicitBucket.name}/${blob.name}`;
        console.log('File uploaded to', fileUrl);
        await db.collection('files').add({
          userId: teacherId,
          fileName: file.originalname,
          fileUrl,
          description,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        res.status(200).send({ fileUrl });
      });

      blobStream.end(file.buffer);
    } catch (error) {
      console.error("Error during file upload: ", error);
      res.status(500).send("Error uploading file");
    }
  });
};


const CreateSubClass = async (req, res) => {

  const { homeroomTeacher, parentClassLetter, classNumber, students, subjects } = req.body;

  if (!homeroomTeacher || !parentClassLetter || !classNumber) {
      return res.status(400).send("Missing data!");
  }

  try {
      const db = admin.firestore();
      const classesRef = db.collection('classes');
      const classSnapshot = await classesRef.where('classLetter', '==', parentClassLetter).get();

      if (classSnapshot.empty) {
          return res.status(404).send('Parent class not found');
      }

      let parentClassId;
      classSnapshot.forEach(doc => {
          parentClassId = doc.id;
      });

      const newSubClass = {
          ...subClassModel,
          homeroomTeacher,
          parentClass: parentClassId,
          classNumber,
          students: students || [],
          subjects: subjects || []
      };

      const subClassRef = db.collection('subClasses').doc();
      await subClassRef.set(newSubClass);

      // Update the parent class to include this subclass
      const parentClassRef = db.collection('classes').doc(parentClassId);
      await parentClassRef.update({
          subClasses: admin.firestore.FieldValue.arrayUnion(subClassRef.id)
      });

      res.status(200).send('SubClass added successfully');
  } catch (error) {
      console.error("Error adding subclass: ", error);
      res.status(500).send("Error adding subclass");
  }
};
const AddStudentToSubClass = async (req, res) => {
  const { classId, students } = req.body;

  if (!classId || !students || !Array.isArray(students) || students.length === 0) {
      return res.status(400).send("Missing data or invalid input!");
  }

  try {
      const db = admin.firestore();

      // Find the subclass by class ID
      const subClassRef = db.collection('subClasses').doc(classId);
      const subClassDoc = await subClassRef.get();

      if (!subClassDoc.exists) {
          return res.status(404).send(`SubClass with ID ${classId} not found`);
      }

      // Prepare the student entries to be added
      const studentEntries = [];
      const studentIds = students.map(student => student.id);

      // Search for student IDs and names by student objects
      const studentsRef = db.collection('students');

      for (const student of students) {
          const studentSnapshot = await studentsRef.doc(student.id).get();

          if (!studentSnapshot.exists) {
              return res.status(404).send(`Student with ID ${student.id} not found`);
          }

          studentEntries.push({ id: student.id, name: student.fullname });

          // Update each student's document with the subclass information
          await studentSnapshot.ref.update({
              subClassName: subClassDoc.id,
              classname: subClassDoc.data().parentClass
          });
      }

      // Add the student entries to the subclass document
      await subClassRef.update({
          students: admin.firestore.FieldValue.arrayUnion(...studentEntries)
      });

      res.status(200).send('Students added to subclass successfully');
  } catch (error) {
      console.error("Error adding students to subclass: ", error);
      res.status(500).send("Error adding students to subclass");
  }
};
const AddAttendance = async (req, res) => {
  const { classname, subjectname, students } = req.body;

  if (!classname || !subjectname || !students || students.length === 0 ) {
    return res.status(400).send("Missing data!");
  }

  try {
    const db = admin.firestore();
    const attendanceRef = db.collection('attendance').doc();

    await attendanceRef.set({
      classname,
      subjectname,
      students,
      presdate:"20.4.2024",
    });
    console.error(' adding attendance sucseful:');
    res.status(200).send('Attendance added successfully');
  } catch (error) {
    console.error('Error adding attendance:', error);
    res.status(500).send('Error adding attendance');
  }
};
const AddAssigment = async (req,res) =>{
    const { classname, subjectname, description, lastDate } = req.body;
    const db = admin.firestore();
    

  try {
    const newAssignment = {
      classname,
      subjectname,
      description,
      lastDate,
    };

    await db.collection('assignments').add(newAssignment);
    res.status(200).send('Assignment added successfully');
  } catch (error) {
    console.error('Error adding assignment:', error);
    res.status(500).send('Error adding assignment');
  }

}
const SendMessageToClass = async (req, res) => {
  const { classname, description } = req.body;

  if (!classname || !description) {
    return res.status(400).send('Classname and description are required.');
  }

  try {
    const db = admin.firestore();
    // Query for the class document by classname
    const classQuerySnapshot = await db.collection('classes').where('classname', '==', classname).get();

    if (classQuerySnapshot.empty) {
      return res.status(404).send('Class not found.');
    }

    // Assuming there is only one document for each class
    const classDoc = classQuerySnapshot.docs[0];

    // Create a new message object with a server timestamp
    const newMessage = {
      description,
      date: new Date(), // Gets the current server time
    };

    // Update the class document with the new message
    await db.collection('classes').doc(classDoc.id).update({
      messages: admin.firestore.FieldValue.arrayUnion(newMessage)
    });

    res.status(200).send('Message sent successfully');
  } catch (error) {
    console.error('Error sending message:', error);
    res.status(500).send('Error adding message');
  }
};
const GetStudentByClass = async (req, res) => {
  const classname = req.params.classname;
  const db = admin.firestore();
  if (!classname) {
    return res.status(400).send('Classname is required.');
  }

  try {
    // Fetch student documents where classname matches the provided value
    const studentDocs = await db.collection('students').where('classname', '==', classname).get();

    if (studentDocs.empty) {
      return res.status(404).json({ error: 'No students found for the given class' });
    }

    const students = studentDocs.docs.map(doc => ({ id: doc.id, ...doc.data() }));

    res.json(students);
  } catch (error) {
    console.error('Error fetching students:', error);
    res.status(500).json({ error: 'An error occurred while fetching students' });
  }
};
const getTeacherData = async (req, res) => {
  const userId = req.params.userId;

  try {
    const teacherRef = admin.firestore().collection('teachers').doc(userId);
    const doc = await teacherRef.get();

    if (doc.exists) {
      console.error('Find teacher data !');
      res.status(200).json(doc.data());
    } else {
      res.status(404).send('Teacher not found');
    }
  } catch (error) {
    console.error('Error fetching teacher data:', error);
    res.status(500).send('Internal Server Error');
  }
};
const editTeacher = async (req, res) => {
  const { teacherId } = req.params;
  const { username, password, fullname, email, classesHomeroom, classesSubject } = req.body;

  try {
      const teacherRef = db.collection('teachers').doc(teacherId);
      const teacherDoc = await teacherRef.get();

      if (!teacherDoc.exists) {
          return res.status(404).send("Teacher not found");
      }

      await teacherRef.update({
          username: username || teacherDoc.data().username,
          password: password || teacherDoc.data().password,
          fullname: fullname || teacherDoc.data().fullname,
          email: email || teacherDoc.data().email,
          classesHomeroom: classesHomeroom || teacherDoc.data().classesHomeroom,
          classesSubject: classesSubject || teacherDoc.data().classesSubject
      });

      res.status(200).send("Teacher updated successfully");
  } catch (error) {
      console.error("Error editing teacher: ", error);
      res.status(500).send("Error editing teacher");
  }
};
const deleteTeacher = async (req, res) => {
  const { teacherId } = req.params;

  try {
      const teacherRef = db.collection('teachers').doc(teacherId);
      const teacherDoc = await teacherRef.get();

      if (!teacherDoc.exists) {
          return res.status(404).send("Teacher not found");
      }

      await teacherRef.delete();
      res.status(200).send("Teacher deleted successfully");
  } catch (error) {
      console.error("Error deleting teacher: ", error);
      res.status(500).send("Error deleting teacher");
  }
};
const getClassStudents = async (req, res) => {
  const { classId } = req.params;

  try {
      // Find the class by class ID
      const classRef = db.collection('classes').doc(classId);
      const classDoc = await classRef.get();

      if (!classDoc.exists) {
          return res.status(404).send("Class not found");
      }

      // Extract the list of student IDs from the class document
      const studentIds = classDoc.data().students.map(student => student.id);

      // Query the students collection to get the details of each student
      const students = [];
      for (const studentId of studentIds) {
          const studentRef = db.collection('students').doc(studentId);
          const studentDoc = await studentRef.get();
          if (studentDoc.exists) {
              students.push(studentDoc.data());
          }
      }

      res.status(200).json(students);
  } catch (error) {
      console.error("Error getting class students: ", error);
      res.status(500).send("Error getting class students");
  }
};

module.exports = {
  CreateSubClass,
  AddStudentToSubClass,
  AddAssigment,
  getTeacherData,
  SendMessageToClass,
  GetStudentByClass,
  AddAttendance,
  editTeacher,
  deleteTeacher,
  getClassStudents,
  uploadFile
 };
