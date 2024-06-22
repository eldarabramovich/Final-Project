const admin = require('firebase-admin');
const subClassModel = require('../models/subclassModel.js');



const CreateSubClass = async (req, res) => {
  const { homeroomTeacherName, parentClassLetter, classNumber, students, subjects } = req.body;

  if (!homeroomTeacherName || !parentClassLetter || !classNumber) {
      return res.status(400).send("Missing data!");
  }

  try {
      const db = admin.firestore();
      const classesRef = db.collection('Classes');
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
          homeroomTeacherName,
          parentClass: parentClassId,
          classNumber,
          students: students || [],
          subjects: subjects || []
      };

      const subClassRef = db.collection('SubClasses').doc();
      await subClassRef.set(newSubClass);

      // Update the parent class to include this subclass
      const parentClassRef = db.collection('Classes').doc(parentClassId);
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
  const { studentNames, subClassId } = req.body;

  if (!studentNames || !subClassId) {
      return res.status(400).send("Missing data!");
  }

  // Separate the class letter from the subclass number
  const classLetter = subClassId.charAt(0);
  const subClassName = subClassId.slice(1);

  try {
      const db = admin.firestore();

      // Find the parent class by class letter
      const classesRef = db.collection('Classes');
      const classSnapshot = await classesRef.where('classLetter', '==', classLetter).get();

      if (classSnapshot.empty) {
          return res.status(404).send(`Class ${classLetter} not found`);
      }

      let parentClassId;
      classSnapshot.forEach(doc => {
          parentClassId = doc.id;
      });

      // Find the subclass by name and parent class ID
      const subClassesRef = db.collection('SubClasses');
      const subClassSnapshot = await subClassesRef
          .where('classNumber', '==', subClassName)
          .where('parentClass', '==', parentClassId)
          .get();

      if (subClassSnapshot.empty) {
          return res.status(404).send(`SubClass ${subClassId} not found in class ${classLetter}`);
      }

      let subClassDocId;
      subClassSnapshot.forEach(doc => {
          subClassDocId = doc.id;
      });

      // Search for student IDs and names by student names
      const studentsRef = db.collection('Students');
      const studentEntries = [];

      for (const name of studentNames) {
          const studentSnapshot = await studentsRef.where('fullname', '==', name).get();

          if (studentSnapshot.empty) {
              return res.status(404).send(`Student ${name} not found`);
          }

          studentSnapshot.forEach(doc => {
              studentEntries.push({ id: doc.id, name: doc.data().fullname });

              // Update each student's document with the subclass information
              doc.ref.update({
                  subClassName: subClassId,
                  classname: classLetter
              });
          });
      }

      const subClassRef = db.collection('SubClasses').doc(subClassDocId);
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
    const assigmentRef = db.collection('assigments').doc();

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


module.exports = {
  CreateSubClass,
  AddStudentToSubClass,
  AddAssigment,
  getTeacherData,
  SendMessageToClass,
  GetStudentByClass,
  AddAttendance };
