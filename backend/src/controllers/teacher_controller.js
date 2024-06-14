const admin = require('firebase-admin');
const {db} = require('../firebase/firebaseAdmin.js');


const CreateSubClass = async (req, res) => {
    const { ClassName, SubClassName, StudentsList } = req.body;

    // if (!classId || !name || !educatorTeacherId || !professionalTeachers || !subjects) {
    //     return res.status(400).send("Missing data!");
    // }
    
    if (!SubClassName) {
         return res.status(400).send("Missing data!");
    }
    try {
        const subClassRef = db.collection('SubClasses').doc();
        await subClassRef.set({
            ClassName,
            SubClassName,
            StudentsList: []
        });
        res.status(200).send('Subclass created successfully');
    } catch (error) {
        console.error("Error creating subclass: ", error);
        res.status(500).send("Error creating subclass");
    }
};

// Function to add a student to an existing subclass
const AddStudentToSubClass = async (req, res) => {
    const { studentId, subClassId } = req.body;

    if (!studentId || !subClassId) {
        return res.status(400).send("Missing data!");
    }

    try {
        const subClassRef = db.collection('SubClasses').doc(subClassId);
        const subClassDoc = await subClassRef.get();

        if (!subClassDoc.exists) {
            return res.status(404).send('Subclass not found');
        }

        await subClassRef.update({
            StudentsList: admin.firestore.FieldValue.arrayUnion(studentId)
        });

        res.status(200).send('Student added to subclass successfully');
    } catch (error) {
        console.error("Error adding student to subclass: ", error);
        res.status(500).send("Error adding student to subclass");
    }
};

module.exports = {
    CreateSubClass,
    AddStudentToSubClass,
};