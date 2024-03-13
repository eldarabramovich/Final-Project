const admin = require('firebase-admin');


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
}













const getTeacherData = async (req, res) => {
  const userId = req.params.userId;

  try {
    const teacherRef = admin.firestore().collection('teachers').doc(userId);
    const doc = await teacherRef.get();

    if (doc.exists) {
      res.status(200).json(doc.data());
    } else {
      res.status(404).send('Teacher not found');
    }
  } catch (error) {
    console.error('Error fetching teacher data:', error);
    res.status(500).send('Internal Server Error');
  }
};


module.exports = {AddAssigment,getTeacherData,SendMessageToClass ,GetStudentByClass,AddAttendance};
