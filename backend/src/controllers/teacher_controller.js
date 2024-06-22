const admin = require('firebase-admin');
const {db} = require('../firebase/firebaseAdmin.js');
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
// Function to add a student to an existing subclass
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

module.exports = {
    CreateSubClass,
    AddStudentToSubClass,
};