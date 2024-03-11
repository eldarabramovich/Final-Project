const admin = require('firebase-admin');



const getStudentData = async (req, res) => {
  const userId = req.params.userId;

  try {
    const teacherRef = admin.firestore().collection('students').doc(userId);
    const doc = await teacherRef.get();

    if (doc.exists) {
      res.status(200).json(doc.data());
    } else {
      res.status(404).send('student not found');
    }
  } catch (error) {
    console.error('Error student teacher data:', error);
    res.status(500).send('Internal Server Error');
  }
};

const GetMessageByClassname = async (req, res) => {
  try {
    const classname = req.params.classname; // Changed from req.query.classname to req.params.classname
    const db = admin.firestore();

    const classQuerySnapshot = await db.collection('classes')
                                      .where('classname', '==', classname)
                                      .get();
    
    if (classQuerySnapshot.empty) {
      return res.status(404).send('Class not found');
    }

    // Assuming there is only one class with this classname
    const classDoc = classQuerySnapshot.docs[0];

    if (!classDoc.exists) {
      return res.status(404).send("Class not found");
    }
    const classData = classDoc.data();
    const messages = classData.messages || []; // Default to an empty array if messages field is missing
    res.status(200).json(messages);
  } catch (error) {
    console.error('Error fetching messages:', error); // Corrected the error message to 'messages' instead of 'assignments'
    res.status(500).send('Error fetching messages');
  }
}



const GetAssignById = async (req, res) => {
  try {
    const userId = req.params.userId;
    const db = admin.firestore();
    console.log(`Fetching assignments for student with ID: ${userId}`);
    const studentRef = db.collection('students').doc(userId);
    const studentDoc = await studentRef.get();

    if (!studentDoc.exists) {
      return res.status(404).send('Student not found');
    }

    const studentData = studentDoc.data();
    const studentClass = studentData.classname;
    console.log(`Student class: ${studentClass}`);

    const assignments = [];
    const assignmentsRef = db.collection('assignments').where('classname', '==', studentClass);
    const snapshot = await assignmentsRef.get();

    snapshot.forEach(doc => {
      assignments.push({ id: doc.id, ...doc.data() });
    });
    console.log(`Found ${assignments.length} assignments`);
    res.status(200).json(assignments);
  } catch (error) {
    console.error('Error fetching assignments:', error);
    res.status(500).send('Error fetching assignments');
  }
}


// const GetAssignById = async (req, res) => {
//     const userId = req.params.userId;
  
//     try {
//       // Query Firestore for assignments belonging to the user
//       const db = admin.firestore();
//       const assignments = [];

//         // Find the student document to get the classname
//         const studentDoc = await db.collection('students').doc(userId).get();
//         if (!studentDoc.exists) {
//             return res.status(404).send('Student not found');
//         }
//         const classname = studentDoc.data().classname;
//         console.error(classname);
//         const classDoc = await db.collection('classes').where('className', '==', classname).limit(1).get();
//         if (classDoc.empty) {
//             return res.status(404).send('Class not found for the provided student');
//         }

//         const subjects = classDoc.docs[0].data().subjects;

//         // For each subject ID, fetch the subject document and extract the assignments
//         for (const subjectId of subjects) {
//             const subjectDoc = await db.collection('subjects').doc(subjectId).get();
//             if (subjectDoc.exists) {
//                 const subjectData = subjectDoc.data();
//                 assignments.push(...subjectData.assignments);
//             }
//         }

//       // Send the assignments as a response
//       res.status(200).json(assignments);
//     } catch (error) {
//       console.error('Error fetching assignments:', error);
//       res.status(500).send('Error fetching assignments');
//     }
//   }


  module.exports = {GetAssignById,GetMessageByClassname,getStudentData};