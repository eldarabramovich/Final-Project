
const admin = require('firebase-admin');
const db = require('../firebase/firebaseAdmin.js');


//--------------------------class and objects and adding assigments
const addClasswithsubject = async (req, res) => {
    const { classname, subjects } = req.body; // Example fields

    if (!classname || !subjects || subjects.length === 0) {
        return res.status(400).send("Missing data!");
    }

    try {
        const db = admin.firestore();
        const batch = db.batch();
        const classRef = db.collection('classes').doc();

        // Create an array to hold the references to the added subjects
        const subjectRefs = [];

        // Add each subject to the 'subjects' collection and store the reference
        for (i=0;i<subjects.length;i++) {
            const subjectRef = db.collection('subjects').doc();
            batch.set(subjectRef, {
                className: classname ,
                subject:subjects[i],
                studentassign:[],
                assignments:[],
                attendance:[],
            });
            subjectRefs.push(subjectRef);
        }

        // Add the class with the references to the subjects
        batch.set(classRef, {
            classname,
            subjects: subjectRefs.map(ref => ref.id) // Store only the IDs of the subject documents
        });

        await batch.commit();
        res.status(200).send('Class added successfully');
    } catch (error) {
        console.error("Error adding class: ", error);
        res.status(500).send("Error adding class");
    }
};


const addAssignmentToSubject = async (req, res) => {
    const { classname, subjectName, assignment } = req.body;

    if (!classname || !subjectName || !assignment) {
        return res.status(400).send("Missing data!");
    }

    try {
        const db = admin.firestore();

        // First, find the subject document ID using the classname and subjectName
        const subjectsQuerySnapshot = await db.collection('subjects')
            .where('className', '==', classname)
            .where('subject', '==', subjectName)
            .limit(1)
            .get();

        if (subjectsQuerySnapshot.empty) {
            return res.status(404).send('Subject not found for the provided class');
        }

        // Get the document reference for the found subject
        const subjectDocRef = subjectsQuerySnapshot.docs[0].ref;

        // Update the subject document's 'assignments' array with the new assignment
        const updateResult = await subjectDocRef.update({
            assignments: admin.firestore.FieldValue.arrayUnion(assignment)
        });

        res.status(200).send('Assignment added successfully to the subject');
    } catch (error) {
        console.error("Error adding assignment to subject: ", error);
        res.status(500).send("Error adding assignment to subject");
    }
 };


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
    const { username , password , fullname, email , classes  } = req.body; 

    if(!username || !email || !password || !fullname || !classes){
        res.status(500).send("missing data !");
    }

    for (const cls of classes) {
        if (!cls.classname || !cls.subject) {
            return res.status(400).send("Missing classname or subject in classes array");
        }
    }
    
    try {
        const db = admin.firestore();
        const batch = db.batch();
        const teacherRef = db.collection('teachers').doc(); 


        await teacherRef.set({
            teacaherID : teacherRef.id,
            fullname,
            username,
            password,
            email,
            role:"teacher",
            classes: classes.map((cls) => ({
                classname: cls.classname,
                subject: cls.subject
            }))
        });

        await batch.commit();

        res.status(200).send('Teacher added successfully');

    } catch (error) {
        console.error("Error adding teacher: ", error);
        res.status(500).send("Error adding teacher");
    }
};


const addStudent = async (req, res) => {
    const { username , password , fullname , classname } = req.body; // Example fields
    if(!username || !password || !fullname || !classname ){
        res.status(500).send("missing data !");
    }
    try {
        const db = admin.firestore();
        const studentRef = db.collection('students').doc(); // Create a new doc in 'students' collection
        await studentRef.set({
            username,
            password,
            fullname,
            classname,
            role:"student",
        });
        res.status(200).send('Student added successfully');
    } catch (error) {
        console.error("Error adding student: ", error);
        res.status(500).send("Error adding student");
    }
};

 module.exports = { addStudent ,addTeacher , addAdmin,addAssignmentToSubject,addClasswithsubject};

 //_______________________old add teacher___
 
// const addTeacher = async (req, res) => {
//     const { username , password , fullname, subject, email , classname  } = req.body; 

//     if(!username || !subject || !email || !password || !fullname || !classname){
//         res.status(500).send("missing data !");
//     }
    
//     try {
//         const db = admin.firestore();
//         const batch = db.batch();
//         const teacherRef = db.collection('teachers').doc(); 


//         await teacherRef.set({
//             teacaherID : teacherRef.id,
//             fullname,
//             username,
//             password,
//             subject,
//             classname,
//             email,
//             role:"teacher",
//         });

//         await batch.commit();

//         res.status(200).send('Teacher added successfully');

//     } catch (error) {
//         console.error("Error adding teacher: ", error);
//         res.status(500).send("Error adding teacher");
//     }
// };

