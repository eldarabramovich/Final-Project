const multer = require('multer');
const { db ,admin} = require('../firebase/firebaseAdmin'); // Import only what you need
const path = require('path');
const bucket = admin.storage().bucket('teachtouch-20b98.appspot.com');
const storage = multer.memoryStorage();
const upload = multer({ storage }).single('file');



// assigments page 
const AddAssignment = async (req, res) => {
  console.error('Step 1: Starting to add assignment');
  const { classname, subjectname, description, lastDate } = req.body;
  const file = req.file;
  const db = admin.firestore();
  const bucket = admin.storage().bucket();
  console.error('Step 2: Retrieved request data');
  if(!classname || !subjectname || !description || !lastDate)
  {
    return res.status(400).send('missing data');
  }
  if (!file) {
    console.error('Step 3: No file uploaded');
    return res.status(400).send('No file uploaded.');
  }

  try {
    console.error('Step 4: Preparing to upload file');
    const blob = bucket.file(`assignments/${file.originalname}`);
    const blobStream = blob.createWriteStream({
      metadata: {
        contentType: file.mimetype,
      },
    });

    blobStream.on('error', (err) => {
      console.error('Step 5: Error during file upload:', err);
      res.status(500).send('Error uploading file.');
    });

    blobStream.on('finish', async () => {
      console.error('Step 6: File upload finished');
      const fileUrl = `https://storage.googleapis.com/${bucket.name}/${blob.name}`;
      const newAssignment = {
        classname,
        subjectname,
        description,
        lastDate,
        fileUrl,
      };

      try {
        console.error('Step 7: Saving assignment to Firestore');
        const assignmentRef = await db.collection('assignments').add(newAssignment);
        const assignmentID = assignmentRef.id;

        const newSubmission = {
          assignmentID: assignmentID,
          studentsubmission: [],
        };

        await db.collection('submissions').doc(assignmentID).set(newSubmission);

        console.error('Step 8: Updating subject document');
        const subjectSnapshot = await db.collection('subjects')
          .where('subClassName', '==', classname)
          .where('subjectname', '==', subjectname)
          .get();

          if (subjectSnapshot.empty) {
            console.error('No matching subjects found');
            return res.status(404).send('Subject not found');
          }
  
          subjectSnapshot.forEach(async doc => {
            console.log(`Updating subject doc: ${doc.id}`);
            await doc.ref.update({
              assignments: admin.firestore.FieldValue.arrayUnion(assignmentID)
            });
            console.log(`Assignment ID ${assignmentID} added to subject doc ${doc.id}`);
          });

        console.error('Step 9: Assignment record added successfully');
        res.status(200).send('Assignment added successfully');
      } catch (firestoreError) {
        console.error('Step 7.1: Error saving assignment to Firestore:', firestoreError);
        res.status(500).send('Error saving assignment');
      }
    });

    blobStream.end(file.buffer);
  } catch (error) {
    console.error('Step 4.1: Error in file upload process:', error);
    res.status(500).send('Error adding assignment');
  }
};

//______________________________________________________________________________________________________________________________________
// for homroomtecher
const CreateSubClass = async (req, res) => {

  const { homeroomTeacher, parentClassLetter, classNumber, students, subjects } = req.body;

  if (!homeroomTeacher || !parentClassLetter || !classNumber) {
      return res.status(400).send("Missing data!");
  }

  try {
      const db = admin.firestore();
      const classesRef = db.collection('classes');
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
          homeroomTeacher,
          parentClass: parentClassId,
          classNumber,
          students: students || [],
          subjects: subjects || []
      };

      const subClassRef = db.collection('subClasses').doc();
      await subClassRef.set(newSubClass);

      // Update the parent class to include this subclass
      const parentClassRef = db.collection('classes').doc(parentClassId);
      await parentClassRef.update({
          subClasses: admin.firestore.FieldValue.arrayUnion(subClassRef.id)
      });

      res.status(200).send('SubClass added successfully');
  } catch (error) {
      console.error("Error adding subclass: ", error);
      res.status(500).send("Error adding subclass");
  }
};

//______________________________________________________________________________________________________________________________________
// attendance page 
const AddAttendance = async (req, res) => {
  const { classname, subjectname, students } = req.body;

  if (!classname || !subjectname || !students || students.length === 0 ) {
    return res.status(400).send("Missing data!");
  }

  try {
    const db = admin.firestore();
    const attendanceRef = db.collection('attendance').doc();

    await attendanceRef.set({
      classname,
      subjectname,
      students,
      presdate:"20.4.2024",
    });
    console.error(' adding attendance sucseful:');
    res.status(200).send('Attendance added successfully');
  } catch (error) {
    console.error('Error adding attendance:', error);
    res.status(500).send('Error adding attendance');
  }
};

//______________________________________________________________________________________________________________________________________
// message page
const SendMessageToClass = async (req, res) => {
  const { classname, description } = req.body;

  if (!classname || !description) {
    return res.status(400).send('Classname and description are required.');
  }

  try {
    const db = admin.firestore();
    // Query for the class document by classname
    const classQuerySnapshot = await db.collection('subClasses').where('classNumber', '==', classname).get();

    if (classQuerySnapshot.empty) {
      return res.status(404).send('Class not found.');
    }

    // Assuming there is only one document for each class
    const classDoc = classQuerySnapshot.docs[0];

    // Create a new message object with a server timestamp
    const newMessage = {
      description,
      date: new Date(), // Server timestamp
    };

    // Update the class document with the new message
    await db.collection('subClasses').doc(classDoc.id).update({
      messages: admin.firestore.FieldValue.arrayUnion(newMessage)
    });

    res.status(200).send('Message sent successfully');
  } catch (error) {
    console.error('Error sending message:', error);
    res.status(500).send('Error adding message');
  }
};



//______________________________________________________________________________________________________________________________________

const AddStudentToSubClass = async (req, res) => {
  const { classId, students } = req.body;

  if (!classId || !students || !Array.isArray(students) || students.length === 0) {
      return res.status(400).send("Missing data or invalid input!");
  }

  try {
      const db = admin.firestore();

      // Find the subclass by class ID
      const subClassRef = db.collection('subClasses').doc(classId);
      const subClassDoc = await subClassRef.get();

      if (!subClassDoc.exists) {
          return res.status(404).send(`SubClass with ID ${classId} not found`);
      }

      // Prepare the student entries to be added
      const studentEntries = [];
      const studentIds = students.map(student => student.id);

      // Search for student IDs and names by student objects
      const studentsRef = db.collection('students');

      for (const student of students) {
          const studentSnapshot = await studentsRef.doc(student.id).get();

          if (!studentSnapshot.exists) {
              return res.status(404).send(`Student with ID ${student.id} not found`);
          }

          studentEntries.push({ id: student.id, name: student.fullname });

          // Update each student's document with the subclass information
          await studentSnapshot.ref.update({
              subClassName: subClassDoc.id,
              classname: subClassDoc.data().parentClass
          });
      }

      // Add the student entries to the subclass document
      await subClassRef.update({
          students: admin.firestore.FieldValue.arrayUnion(...studentEntries)
      });

      res.status(200).send('Students added to subclass successfully');
  } catch (error) {
      console.error("Error adding students to subclass: ", error);
      res.status(500).send("Error adding students to subclass");
  }
};

const GetStudentBySubClass = async (req, res) => {
  const classname = req.params.classname;
  const db = admin.firestore();
  if (!classname) {
    return res.status(400).send('Classname is required.');
  }

  try {
    // Fetch subclass documents where classNumber matches the provided value
    const subClassDocs = await db.collection('subClasses').where('classNumber', '==', classname).get();

    if (subClassDocs.empty) {
      return res.status(404).json({ error: 'No students found for the given class' });
    }

    let students = [];
    subClassDocs.forEach(doc => {
      const data = doc.data();
      if (data.students && Array.isArray(data.students)) {
        students = students.concat(data.students);
      }
    });

    res.json(students);
  } catch (error) {
    console.error('Error fetching students:', error);
    res.status(500).json({ error: 'An error occurred while fetching students' });
  }
};


const getStudentsByClass = async (req, res) => {
  const className = req.body.className;
  console.log('Received className:', className);
  if (!className) {
    return res.status(400).send('Missing class parameter');
  }

  try {
    const subClassesRef = db.collection('subClasses');
    const snapshot = await subClassesRef.where('classNumber', '==', className).get();

    if (snapshot.empty) {
      return res.status(404).send('No students found');
    }
    console.error('Step 2 find subclass');
    console.error('Step 6: File upload finished');
    let students = [];
    snapshot.forEach(doc => {
      const data = doc.data();
      if (data.students) {
        students = students.concat(data.students);
      }
    });

    res.status(200).json(students);
  } catch (error) {
    console.error('Error fetching students:', error);
    res.status(500).send('Error fetching students');
  }
};

//______________________________________________________________________________________________________________________________________
//login pages 
const getTeacherData = async (req, res) => {
  const userId = req.params.userId;
  console.log(`Fetching data for teacher ID: ${userId}`);

  try {
      const teacherRef = admin.firestore().collection('teachers').doc(userId);
      const doc = await teacherRef.get();

      if (doc.exists) {
          console.log('Teacher data found:', doc.data());
          res.status(200).json(doc.data());
      } else {
          console.log('Teacher not found');
          res.status(404).send('Teacher not found');
      }
  } catch (error) {
      console.error('Error fetching teacher data:', error);
      res.status(500).send('Internal Server Error');
  }
};


//______________________________________________________________________________________________________________________________________
//crud
const editTeacher = async (req, res) => {
  const { teacherId } = req.params;
  const { username, password, fullname, email, classesHomeroom, classesSubject } = req.body;

  try {
      const teacherRef = db.collection('teachers').doc(teacherId);
      const teacherDoc = await teacherRef.get();

      if (!teacherDoc.exists) {
          return res.status(404).send("Teacher not found");
      }

      await teacherRef.update({
          username: username || teacherDoc.data().username,
          password: password || teacherDoc.data().password,
          fullname: fullname || teacherDoc.data().fullname,
          email: email || teacherDoc.data().email,
          classesHomeroom: classesHomeroom || teacherDoc.data().classesHomeroom,
          classesSubject: classesSubject || teacherDoc.data().classesSubject
      });

      res.status(200).send("Teacher updated successfully");
  } catch (error) {
      console.error("Error editing teacher: ", error);
      res.status(500).send("Error editing teacher");
  }
};
const deleteTeacher = async (req, res) => {
  const { teacherId } = req.params;

  try {
      const teacherRef = db.collection('teachers').doc(teacherId);
      const teacherDoc = await teacherRef.get();

      if (!teacherDoc.exists) {
          return res.status(404).send("Teacher not found");
      }

      await teacherRef.delete();
      res.status(200).send("Teacher deleted successfully");
  } catch (error) {
      console.error("Error deleting teacher: ", error);
      res.status(500).send("Error deleting teacher");
  }
};


//______________________________________________________________________________________________________________________________________

const getClassStudents = async (req, res) => {
  const { classId } = req.params;

  try {
      // Find the class by class ID
      const classRef = db.collection('classes').doc(classId);
      const classDoc = await classRef.get();

      if (!classDoc.exists) {
          return res.status(404).send("Class not found");
      }

      // Extract the list of student IDs from the class document
      const studentIds = classDoc.data().students.map(student => student.id);

      // Query the students collection to get the details of each student
      const students = [];
      for (const studentId of studentIds) {
          const studentRef = db.collection('students').doc(studentId);
          const studentDoc = await studentRef.get();
          if (studentDoc.exists) {
              students.push(studentDoc.data());
          }
      }

      res.status(200).json(students);
  } catch (error) {
      console.error("Error getting class students: ", error);
      res.status(500).send("Error getting class students");
  }
};


//______________________________________________________________________________________________________________________________________
//upload download 
const downloadFile = async (req, res) => {
  const { fileId } = req.params;
  console.log(`Received request to download file: ${fileId}`);

  try {
    // Find the file document in Firestore by the fileId
    const fileDoc = await admin.firestore().collection('assignments').doc(fileId).get();

    if (!fileDoc.exists) {
      console.log(`File with ID: ${fileId} not found`);
      return res.status(404).send('File not found');
    }

    const fileData = fileDoc.data();
    const fileUrl = fileData.fileUrl;
    console.log(`File URL: ${fileUrl}`);

    // Extract and decode the file path from the URL
    const filePath = decodeURIComponent(fileUrl.split('/assignments/')[1]);
    console.log(`File path: ${filePath}`);

    // Create a reference to the file in Google Cloud Storage
    const fileRef = bucket.file(`assignments/${filePath}`);
    const [metadata] = await fileRef.getMetadata();
    console.log(`File metadata: ${JSON.stringify(metadata)}`);

    // Setting the headers for the download response
    res.setHeader('Content-Type', metadata.contentType);
    res.setHeader('Content-Disposition', `attachment; filename*=UTF-8''${filePath}`);

    // Create a stream to read the file and transfer it to the response
    const fileStream = fileRef.createReadStream();

    fileStream.on('error', (err) => {
      console.error('File stream error:', err);
      res.status(500).send('Error downloading file');
    });

    fileStream.pipe(res);
  } catch (error) {
    console.error('Error downloading file:', error);
    res.status(500).send('Error downloading file');
  }
};

const uploadFile = (req, res) => {
  
  console.log('Received file upload request');
  
  // Check if bucket is initialized
  if (!bucket) {
    console.error("Bucket not initialized");
    return res.status(500).send("Bucket not initialized");
  }

  // console.log('Bucket object:', bucket);
  const explicitBucket = admin.storage().bucket('teachtouch-20b98.appspot.com'); // Explicitly set bucket name
  // console.log('Explicit Bucket object:', explicitBucket);

  upload(req, res, async (err) => {
    if (err) {
      console.error("Error during file upload process: ", err);
      return res.status(500).send("Error uploading file");
    }

    const file = req.file;
    const { teacherId, description } = req.body;

    if (!file || !teacherId) {
      return res.status(400).send("Missing file or teacher ID");
    }
    console.log("File: ", file);
    console.log("Teacher ID: ", teacherId);
    console.log('Description:', description);
    
    try {
      const blob = explicitBucket.file(`${teacherId}/${file.originalname}`);
      console.log('Blob object:', blob);

      const blobStream = blob.createWriteStream({
        metadata: {
          contentType: file.mimetype,
        },
      });

      blobStream.on('error', (err) => {
        console.error("Blob stream error: ", err);
        res.status(500).send("Error uploading file");
      });

      blobStream.on('finish', async () => {
        const fileUrl = `https://storage.googleapis.com/${explicitBucket.name}/${blob.name}`;
        console.log('File uploaded to', fileUrl);
        await db.collection('files').add({
          userId: teacherId,
          fileName: file.originalname,
          fileUrl,
          description,
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
        });
        res.status(200).send({ fileUrl });
      });

      blobStream.end(file.buffer);
    } catch (error) {
      console.error("Error during file upload: ", error);
      res.status(500).send("Error uploading file");
    }
  });
};


//______________________________________________________________________________________________________________________________________

//submition page 
const downloadSubmission = async (req, res) => {
  const { submissionId, fileUrl } = req.body;
  console.log(`Received request to download submission: ${submissionId} with file URL: ${fileUrl}`);

  try {
    // Find the submission document in Firestore by the submissionId
    const submissionDoc = await admin.firestore().collection('submissions').doc(submissionId).get();

    if (!submissionDoc.exists) {
      console.log(`Submission with ID: ${submissionId} not found`);
      return res.status(404).send('Submission not found');
    }

    const submissionData = submissionDoc.data();
    const studentsubmissions = submissionData.studentsubmission;

    // Find the specific fileUrl in the studentsubmission array
    const submission = studentsubmissions.find(sub => sub.fileUrl === fileUrl);

    if (!submission) {
      console.log(`File with URL: ${fileUrl} not found in submissions`);
      return res.status(404).send('File not found in submissions');
    }

    const bucket = admin.storage().bucket();
    const file = bucket.file(decodeURIComponent(fileUrl.split('https://storage.googleapis.com/teachtouch-20b98.appspot.com/')[1]));

    // Set the appropriate headers
    res.setHeader('Content-Type', 'application/octet-stream');
    res.setHeader('Content-Disposition', `attachment; filename="${path.basename(fileUrl)}"`);

    // Pipe the file to the response
    file.createReadStream().pipe(res);
  } catch (error) {
    console.error('Error downloading submission:', error);
    res.status(500).send('Error downloading submission');
  }
};

const updateSubmissionGrade = async (req, res) => {
  const { submissionId, fullName, grade } = req.body;
  console.log('Received parameters:', { submissionId, fullName, grade });
  if (!submissionId || !fullName || grade === undefined) {
    return res.status(400).send('Missing submission ID, student full name, or grade');
  }

  try {
    const db = admin.firestore();
    const submissionDocRef = db.collection('submissions').doc(submissionId);
    const submissionDoc = await submissionDocRef.get();

    if (!submissionDoc.exists) {
      return res.status(404).send('Submission not found');
    }

    const submissionData = submissionDoc.data();
    const studentsubmission = submissionData.studentsubmission;

    let found = false;

    for (let i = 0; i < studentsubmission.length; i++) {
      if (studentsubmission[i].fullName === fullName) {
        studentsubmission[i].grade = grade;
        found = true;
        break;
      }
    }

    if (!found) {
      return res.status(404).send('Student submission not found');
    }

    await submissionDocRef.update({ studentsubmission });

    res.status(200).send('Grade updated successfully');
  } catch (error) {
    console.error('Error updating grade:', error);
    res.status(500).send('Error updating grade');
  }
};

const getSubmissions = async (req, res) => {
  const { assignmentID } = req.params;

  try {
    const submissionDoc = await admin.firestore().collection('submissions').doc(assignmentID).get();

    if (!submissionDoc.exists) {
      return res.status(404).send('Submissions not found');
    }

    const submissionData = submissionDoc.data();

    // Ensure the data structure is correct
    const formattedSubmissions = submissionData.studentsubmission.map(submission => ({
      fileUrl: submission.fileUrl,
      fullName: submission.fullName,
      submittedDate: submission.submittedDate.toDate(), // Convert Firestore Timestamp to JavaScript Date
      grade: submission.grade
    }));

    res.status(200).json(formattedSubmissions);
  } catch (error) {
    console.error('Error fetching submissions:', error);
    res.status(500).send('Error fetching submissions');
  }
};


//______________________________________________________________________________________________________________________________________

//teacher calendar 
const addEvent = async (req, res) => {
  const { date, time, event } = req.body;

  if (!date || !time || !event) {
    return res.status(400).send('Missing date, time or event description');
  }

  try {
    await db.collection('events').add({
      date: new Date(date),
      time: time,
      event: event,
    });

    res.status(200).send('Event added successfully');
  } catch (error) {
    console.error('Error adding event:', error);
    res.status(500).send('Error adding event');
  }
};
const getEvents = async (req, res) => {
  try {
    const snapshot = await db.collection('events').get();
    const events = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    }));

    res.status(200).json(events);
  } catch (error) {
    console.error('Error fetching events:', error);
    res.status(500).send('Error fetching events');
  }
};

//______________________________________________________________________________________________________________________________________

// teacher grade page
const getStudentsBySubject = async (req, res) => {
  const { subClassName, subjectname } = req.query;

  if (!subClassName || !subjectname) {
    return res.status(400).send('Missing subClassName or subjectname');
  }

  try {
    const subjectSnapshot = await db.collection('subjects')
      .where('subClassName', '==', subClassName)
      .where('subjectname', '==', subjectname)
      .get();

    if (subjectSnapshot.empty) {
      return res.status(404).send('No subjects found with the given subClassName and subjectname');
    }

    let students = [];

    subjectSnapshot.forEach(doc => {
      const data = doc.data();
      if (data.students && Array.isArray(data.students)) {
        students = students.concat(data.students);
      }
    });

    res.status(200).json(students);
  } catch (error) {
    console.error('Error fetching students:', error);
    res.status(500).send('Error fetching students');
  }
};

const updateFinalGrade = async (req, res) => {
  const { subClassName, subjectName, fullName, finalGrade } = req.body;
  console.log('Received parameters:', { subClassName, subjectName, fullName , finalGrade});

  if (!subClassName || !subjectName || !fullName || finalGrade === undefined) {
    return res.status(400).send('Missing subClassName, subjectName, fullName, or finalGrade');
  }

  try {
    const db = admin.firestore();
    const subjectsRef = db.collection('subjects');
    const subjectSnapshot = await subjectsRef
      .where('subClassName', '==', subClassName)
      .where('subjectname', '==', subjectName)
      .get();
      
    if (subjectSnapshot.empty) {
      return res.status(404).send('Subject not found');
    }

    let updated = false;

    subjectSnapshot.forEach(async (doc) => {
      const subjectData = doc.data();
      const students = subjectData.students;

      for (let i = 0; i < students.length; i++) {
        if (students[i].fullname === fullName) {
          students[i].finalGrade = finalGrade;
          updated = true;
          break;
        }
      }
      if (updated) {
        await doc.ref.update({ students });
      }
    });

    if (!updated) {
      return res.status(404).send('Student not found in subject');
    }

    res.status(200).send('Final grade updated successfully');
  } catch (error) {
    console.error('Error updating final grade:', error);
    res.status(500).send('Error updating final grade');
  }
};






module.exports = {
  downloadFile,
  getSubmissions,
  CreateSubClass,
  AddStudentToSubClass,
  AddAssignment,
  getTeacherData,
  SendMessageToClass,
  GetStudentBySubClass,
  AddAttendance,
  editTeacher,
  deleteTeacher,
  getClassStudents,
  uploadFile,
  upload,
  downloadSubmission,
  updateSubmissionGrade,
  updateFinalGrade,
  addEvent,getEvents,
  getStudentsBySubject,
  getStudentsByClass
}
