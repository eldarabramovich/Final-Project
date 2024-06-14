const admin = require('firebase-admin');
const {db} = require('../firebase/firebaseAdmin.js');


const CreateClass = async (req, res) => {
    const { classname, studentsList } = req.body;

    if (!classname) {
        return res.status(400).send("Missing data!");
    }

    try {
        let studentIds = [];

        if (studentsList && studentsList.length > 0) {
            const studentsRef = db.collection('students');
            const snapshot = await studentsRef.where('name', 'in', studentsList).get();

            if (snapshot.empty) {
                return res.status(404).send('No matching students found');
            }

            snapshot.forEach(doc => {
                studentIds.push(doc.id);
            });
        }

        const classRef = db.collection('Classes').doc();
        await classRef.set({
            classname,
            StudentsList: studentIds, 
        });

        res.status(200).send('Class added successfully');
    } catch (error) {
        console.error("Error adding class: ", error);
        res.status(500).send("Error adding class");
    }
};


const CreateTeacher = async (req, res) => {
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

const CreateStudent = async (req, res) => {
    const { username , password , fullname , classname } = req.body; 
    if(!username || !password || !fullname || !classname ){
        res.status(500).send("missing data !");
    }
    try {
        const db = admin.firestore();
        const studentRef = db.collection('Students').doc(); 
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


const AddStudentToClass = async (req, res) => {
    const { studentId, ClassId } = req.body;

    if (!studentId || !ClassId) {
        return res.status(400).send("Missing data!");
    }

    try {
        const ClassRef = db.collection('Classes').doc(ClassId);
        const ClassDoc = await ClassRef.get();

        if (!ClassDoc.exists) {
            return res.status(404).send('class not found');
        }

        await ClassRef.update({
            StudentsList: admin.firestore.FieldValue.arrayUnion(studentId)
        });

        res.status(200).send('Student added to class successfully');
    } catch (error) {
        console.error("Error adding student to subclass: ", error);
        res.status(500).send("Error adding student to class");
    }
};


module.exports = {CreateClass, CreateStudent, CreateTeacher, AddStudentToClass};

