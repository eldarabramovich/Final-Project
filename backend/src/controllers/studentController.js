const admin = require('firebase-admin');


const GetAssignById = async (req, res) => {
    const userId = req.params.userId;
  
    try {
      // Query Firestore for assignments belonging to the user
      const db = admin.firestore();
      const assignments = [];

        // Find the student document to get the classname
        const studentDoc = await db.collection('students').doc(userId).get();
        if (!studentDoc.exists) {
            return res.status(404).send('Student not found');
        }
        const classname = studentDoc.data().classname;
        console.error(classname);
        const classDoc = await db.collection('classes').where('className', '==', classname).limit(1).get();
        if (classDoc.empty) {
            return res.status(404).send('Class not found for the provided student');
        }

        const subjects = classDoc.docs[0].data().subjects;

        // For each subject ID, fetch the subject document and extract the assignments
        for (const subjectId of subjects) {
            const subjectDoc = await db.collection('subjects').doc(subjectId).get();
            if (subjectDoc.exists) {
                const subjectData = subjectDoc.data();
                assignments.push(...subjectData.assignments);
            }
        }

      // Send the assignments as a response
      res.status(200).json(assignments);
    } catch (error) {
      console.error('Error fetching assignments:', error);
      res.status(500).send('Error fetching assignments');
    }
  }



  module.exports = {GetAssignById};