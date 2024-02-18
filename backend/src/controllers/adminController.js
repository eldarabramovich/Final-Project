
const admin = require('firebase-admin');
const db = require('../firebase/firebaseAdmin.js');

// const addAssignmentToClass = async (req,res) => {
//     const {classId, title, description, dueDate, createdBy } = req.body;
//     try {
//       const assignmentRef = db.collection('assignments').doc();
//       await assignmentRef.set({
//         classId: classId,
//         title: title,
//         description: description,
//         dueDate: dueDate,
//         createdBy: createdBy,
//         createdAt: admin.firestore.Timestamp.now()
//       });
//       console.log('Assignment added successfully!');
//     } catch (error) {
//       console.error('Error adding assignment:', error);
//     }
//   }

const addAssignmentToClass = async (req,res) => {

    const {title, description, classId , lastdate} = req.body;

    if (!classId || !title || !description , lastdate) {
        return res.status(400).send("Missing data!");
    }

    try {
      const db = admin.firestore();
      const classRef = db.collection('class').doc(classId);

      await classRef.update({
        assignments: admin.firestore.FieldValue.arrayUnion({
            title,
            description,
            dueDate: admin.firestore.Timestamp.fromDate(new Date(dueDate)),
            lastdate
        })
    });
      console.log('Assignment saved successfully!');
    } catch (error) {
      console.error('Error saving assignment:', error);
    }
  }
  

const addAdmin = async (req, res) => {
    const { username,password } = req.body; // Example fields
    if(!username || !password ){
        res.status(500).send("missing data !");
    }
    
    try {
        const db = admin.firestore();
        const teacherRef = db.collection('admin').doc(); // Create a new doc in 'teachers' collection
        await teacherRef.set({
            username,
            password,
        });
        res.status(200).send('admin user added successfully');
    } catch (error) {
        console.error("Error adding teacher: ", error);
        res.status(500).send("Error adding admin");
    }
};


const addTeacher = async (req, res) => {
    const { username , password , fullname, subject, email  } = req.body; // Example fields
    if(!username || !subject || !email || !password || !fullname){
        res.status(500).send("missing data !");
    }
    
    try {
        const db = admin.firestore();
        const teacherRef = db.collection('users').doc(); // Create a new doc in 'teachers' collection
        await teacherRef.set({
            username,
            password,
            subject,
            fullname,
            email,
            role:"teacher",
            grades:[]
        });

        res.status(200).send('Teacher added successfully');

    } catch (error) {
        console.error("Error adding teacher: ", error);
        res.status(500).send("Error adding teacher");
    }
};


const addStudent = async (req, res) => {
    const { username , password , fullname ,grade } = req.body; // Example fields
    if(!username || !password || !fullname || !grade){
        res.status(500).send("missing data !");
    }
    try {
        const db = admin.firestore();
        const studentRef = db.collection('users').doc(); // Create a new doc in 'students' collection
        await studentRef.set({
            username,
            password,
            fullname,
            grade,
            role:"student",
            assignment:[]
        });
        res.status(200).send('Student added successfully');
    } catch (error) {
        console.error("Error adding student: ", error);
        res.status(500).send("Error adding student");
    }
};

const addClass = async (req, res) => {
    const { grade , number  } = req.body; 
    // Example fields
    if(!grade || !number ){
        res.status(500).send("missing data !");
    }
    
    try {
        const db = admin.firestore();
        const teacherRef = db.collection('class').doc(); // Create a new doc in 'teachers' collection
        await teacherRef.set({
            grade,
            number,
            teachers:[],
            students:[],
            assignment:[]
        });
        res.status(200).send('class added successfully');
    } catch (error) {
        console.error("Error adding teacher: ", error);
        res.status(500).send("Error adding admin");
    }
};

const addgradestoteacher = async (req, res) => {
    const { username,password } = req.body; // Example fields
    if(!username || !password ){
        res.status(500).send("missing data !");
    }
    
    try {
        const db = admin.firestore();
        const teacherRef = db.collection('admin').doc(); // Create a new doc in 'teachers' collection
        await teacherRef.set({
            username,
            password,
        });
        res.status(200).send('admin user added successfully');
    } catch (error) {
        console.error("Error adding teacher: ", error);
        res.status(500).send("Error adding admin");
    }
};

 module.exports = { addStudent ,addTeacher , addAdmin, addClass};