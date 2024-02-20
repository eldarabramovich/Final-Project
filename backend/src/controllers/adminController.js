
const admin = require('firebase-admin');
const db = require('../firebase/firebaseAdmin.js');

const addClasswithsubject = async (req, res) => {
    const { classname , subjects } = req.body; 
    // Example fields
    if(!classname || !subjects || subjects.length === 0 ){
        res.status(500).send("missing data !");
    }
    
    try {
        const db = admin.firestore();
        const batch = db.batch();

        const classRef = db.collection('classes').doc(classname);
        const subjectRef = db.collection('subjects').doc();
          // Prepare the subjects object, where each key is a subject name and each value is an array
          const subjectsObject = {};
          subjects.forEach(subject => {
              subjectsObject[subject] = []; // Assuming each subject is just a string name
          });
  
          // Set the subjects document
          await subjectRef.set({
              ...subjectsObject,
              className: classname
          });
  
          // Set the class document with a reference to the subjects document
          await classRef.set({
              classname,
              subjects: subjectRef.id // Store the ID of the subjects document
          });


        await batch.commit();
        res.status(200).send('class added successfully');
    } catch (error) {
        console.error("Error adding teacher: ", error);
        res.status(500).send("Error adding admin");
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
    const { className  } = req.body; 
    // Example fields
    if(!className){
        res.status(500).send("missing data !");
    }
    
    try {
        const db = admin.firestore();
        const teacherRef = db.collection('classes').doc(); 
        await teacherRef.set({
            className,
            students:[],
            
        });
        res.status(200).send('class added successfully');
    } catch (error) {
        console.error("Error adding teacher: ", error);
        res.status(500).send("Error adding admin");
    }
};


const addAssignmentToSubject = async (req, res) => {
    const { className, subjectName, subjectDescription } = req.body;

    if (!className || !subjectName) {
        return res.status(400).send("Missing data!");
    }

    try {
        const db = admin.firestore();
        const classRef = db.collection('Classes').doc();
        const subjectRef = classRef.collection('Subjects').doc();

        await subjectRef.set({
            name: subjectName,
            description: subjectDescription
        });

        res.status(200).send('Subject added successfully to class');
    } catch (error) {
        console.error("Error adding subject to class:", error);
        res.status(500).send("Error adding subject to class");
    }
};

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

// const addAssignmentToClass = async (req,res) => {

//     const {title, description, classId , lastdate} = req.body;

//     if (!classId || !title || !description || !lastdate) {
//         return res.status(400).send("Missing data!");
//     }

//     try {
//       const db = admin.firestore();
//       const classRef = db.collection('class').doc(classId);

//       await classRef.update({
//         assignments: admin.firestore.FieldValue.arrayUnion({
//             title,
//             description,
//             lastdate
//         })
//     });
//       console.log('Assignment saved successfully!');
//     } catch (error) {
//       console.error('Error saving assignment:', error);
//     }
//   }
 module.exports = { addStudent ,addTeacher , addAdmin, addClass,addAssignmentToSubject,addClasswithsubject};

