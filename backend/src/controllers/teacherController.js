const admin = require('firebase-admin');
const AddAssigment = async (req,res) =>{
    const { classname, subjectname, description, lastDate } = req.body;
    const db = admin.firestore();
    const assigmentRef = db.collection('assigments').doc();

  try {
    const newAssignment = {
      classname,
      subjectname,
      description,
      lastDate,
    };

    await db.collection('assignments').add(newAssignment);
    res.status(200).send('Assignment added successfully');
  } catch (error) {
    console.error('Error adding assignment:', error);
    res.status(500).send('Error adding assignment');
  }

}

module.exports = {AddAssigment};
