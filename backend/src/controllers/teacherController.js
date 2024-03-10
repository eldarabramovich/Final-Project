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



 
const SendMessageToClass = async (req,res) =>{

  const { classname , description } = req.body;

  const db = admin.firestore();
  const messagesRef = db.collection('messages').doc();
  try {
    const newMessages = {
      classname,
      description,
      date,
    };

    await db.collection('messages').add(newMessages);
    res.status(200).send('Message send successfully');
  } catch (error) {
    console.error('Error sending message:', error);
    res.status(500).send('Error adding message');
  }

}























const getTeacherData = async (req, res) => {
  const userId = req.params.userId;

  try {
    const teacherRef = admin.firestore().collection('teachers').doc(userId);
    const doc = await teacherRef.get();

    if (doc.exists) {
      res.status(200).json(doc.data());
    } else {
      res.status(404).send('Teacher not found');
    }
  } catch (error) {
    console.error('Error fetching teacher data:', error);
    res.status(500).send('Internal Server Error');
  }
};


module.exports = {AddAssigment,getTeacherData,SendMessageToClass };
