const admin = require('firebase-admin');
const {db} = require('../firebase/firebaseAdmin.js');
const subjectModel = require('../models/subjectModel.js');
const teacherUserModel = require('../models/teacherModel');
const classModel = require('../models/classModel.js');
const studentModel = require('../models/studentModel.js');




const CreateSubject = async (req, res) => {

    const { professionalTeacherName, associatedClasses, associatedStudents } = req.body;

    if (!professionalTeacherName || !associatedClasses || !associatedStudents) {
        return res.status(400).send("Missing data!");
    }

    const newSubject = {
        ...subjectModel,
        professionalTeacherName,
        associatedClasses,
        associatedStudents
    };

    try {
        const db = admin.firestore();
        const subjectRef = db.collection('subjects').doc();
        await subjectRef.set(newSubject);
        res.status(200).send('Subject added successfully');
    } catch (error) {
        console.error("Error adding subject: ", error);
        res.status(500).send("Error adding subject");
    }
};

const Addsubject = async (req, res) => {

    const {subjectname } = req.body;
    
    if (!subjectname) {
        return res.status(400).send("Missing data!");
    }

    try {
        const db = admin.firestore();
        const SubjectRef = db.collection('Subjects').doc();
        
        if (!SubjectRef.exists) {
        return res.status(404).send('Subjects no found');
        }

        await SubjectRef.set({
            subjectname
        });
        
        res.status(200).send('Subject added successfully');
    } catch (error) {
        console.error("Error adding Subject", error);
        res.status(500).send("Error adding Subject");
    }

}
        


module.exports = {CreateClass, CreateStudent, CreateTeacher, AddStudentToClass,Addsubject,CreateSubject};

