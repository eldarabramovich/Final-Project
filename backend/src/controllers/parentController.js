const admin = require('firebase-admin');
const db = admin.firestore();

const getParentData = async (req, res) => {
    const parentId = req.params.parentId;
  
    try {
      const parentRef = db.collection('parents').doc(parentId);
      const doc = await parentRef.get();
  
      if (!doc.exists) {
        return res.status(404).send('Parent not found');
      }
  
      const parentData = doc.data();
  
      // Fetch the children details
      const childrenPromises = parentData.children.map(async (child) => {
        const childRef = db.collection('students').doc(child.id);
        const childDoc = await childRef.get();
        if (childDoc.exists) {
          return {
            id: childDoc.id,
            fullname: childDoc.data().fullname,
          };
        }
        return null;
      });
  
      const childrenDetails = await Promise.all(childrenPromises);
  
      // Filter out any null values in case some children do not exist
      const validChildrenDetails = childrenDetails.filter(child => child !== null);
  
      res.status(200).json({
        ...parentData,
        children: validChildrenDetails,
      });
    } catch (error) {
      console.error('Error fetching parent data:', error);
      res.status(500).send('Internal Server Error');
    }
};
  const getFinalGrades = async (req, res) => {
    const { studentId, fullname } = req.body; // שים לב לשימוש ב-body במקום query
    console.log(`Received request to get final grades for student ID: ${studentId} and full name: ${fullname}`);

    if (!studentId || !fullname) {
        return res.status(400).send('Missing student ID or full name');
    }

    try {
        const subjectsSnapshot = await db.collection('subjects').get();
        let finalGrades = [];
        console.log('Subjects snapshot size:', subjectsSnapshot.size);

        subjectsSnapshot.forEach(doc => {
            const data = doc.data();
            console.log(`Processing subject: ${data.subjectname}`, data);

            if (data.students && Array.isArray(data.students)) {
                console.log(`Students array: ${JSON.stringify(data.students)}`);
                const student = data.students.find(s => s.fullname.trim() === fullname.trim());
                console.log(`Found student: ${JSON.stringify(student)}`);
                if (student) {
                    finalGrades.push({
                        subjectName: data.subjectname,
                        finalGrade: student.finalGrade
                    });
                }
            }
        });

        console.log('Final grades:', finalGrades);
        res.status(200).json(finalGrades);
    } catch (error) {
        console.error('Error fetching final grades:', error);
        res.status(500).send('Error fetching final grades');
    }
};
const getAssignmentGrades = async (req, res) => {
  const { studentId, fullName } = req.body; // שימוש ב-body במקום query
  console.log(`Received request to get assignment grades for student ID: ${studentId} and full name: ${fullName}`);

  if (!studentId || !fullName) {
      return res.status(400).send('Missing student ID or full name');
  }

  try {
      const assignmentsSnapshot = await db.collection('assignments').get();
      let assignmentGrades = [];

      for (const doc of assignmentsSnapshot.docs) {
          const assignmentData = doc.data();
          console.log(`Processing assignment: ${doc.id}`);

          const submissionsSnapshot = await db.collection('submissions').where('assignmentID', '==', doc.id).get();

          submissionsSnapshot.forEach(subDoc => {
              const submissionData = subDoc.data();

              if (submissionData.studentsubmission && Array.isArray(submissionData.studentsubmission)) {
                  submissionData.studentsubmission.forEach(submission => {
                      if (submission.fullName === fullName) {
                          assignmentGrades.push({
                              assignmentName: assignmentData.description,
                              subjectName: assignmentData.subjectname || 'Unknown',
                              grade: submission.grade,
                          });
                      }
                  });
              }
          });
      }

      res.status(200).json(assignmentGrades);
  } catch (error) {
      console.error('Error fetching assignment grades:', error);
      res.status(500).send('Error fetching assignment grades');
  }
};
const GetStudentAttendance = async (req, res) => {
  const { studentId } = req.params;

  if (!studentId) {
      return res.status(400).send("Student ID is required.");
  }

  try {
      const db = admin.firestore();
      const studentRef = db.collection('students').doc(studentId);
      const studentDoc = await studentRef.get();

      if (!studentDoc.exists) {
          return res.status(404).send("Student not found.");
      }

      const attendance = studentDoc.data().attendance || [];
      res.status(200).json(attendance);
  } catch (error) {
      console.error("Error fetching attendance: ", error);
      res.status(500).send("Error fetching attendance.");
  }
};


  module.exports = {
    GetStudentAttendance,
    getParentData, getFinalGrades,
    getAssignmentGrades,
  };
//get parent data by id 