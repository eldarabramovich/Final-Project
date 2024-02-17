const admin = require('firebase-admin');
const db = require('../firebase/firebaseAdmin.js');


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
    const { name, subject, email } = req.body; // Example fields
    if(!name || !subject || !email){
        res.status(500).send("missing data !");
    }
    
    try {
        const db = admin.firestore();
        const teacherRef = db.collection('teachers').doc(); // Create a new doc in 'teachers' collection
        await teacherRef.set({
            name,
            subject,
            email
        });
        res.status(200).send('Teacher added successfully');
    } catch (error) {
        console.error("Error adding teacher: ", error);
        res.status(500).send("Error adding teacher");
    }
};


const addStudent = async (req, res) => {
    const { username , password , fullname ,clas } = req.body; // Example fields
    if(!username || !password || !fullname || !clas){
        res.status(500).send("missing data !");
    }
    try {
        const db = admin.firestore();
        const studentRef = db.collection('students').doc(); // Create a new doc in 'students' collection
        await studentRef.set({
            username,
            password,
            fullname,
            clas,
            assignment:[]
        });
        res.status(200).send('Student added successfully');
    } catch (error) {
        console.error("Error adding student: ", error);
        res.status(500).send("Error adding student");
    }
};
 module.exports = { addStudent ,addTeacher , addAdmin};