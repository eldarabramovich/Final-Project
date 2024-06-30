const assignmentModel = {
    classname: '',
    subjectname: '',
    description: '',
    lastDate: '',
    fileUrl: '',
    submissions: [], // List of submissions
  };
  
  const submissionModel = {
    studentId: '',
    fileUrl: '',
    submittedAt: admin.firestore.FieldValue.serverTimestamp(),
  };
  
  module.exports = { assignmentModel, submissionModel };