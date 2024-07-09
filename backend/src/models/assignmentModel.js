const assignmentModel = {
    classname: '',
    subjectname: '',
    description: '',
    lastDate: '',
    fileUrl: '',
    submissionID: '', // List of submissions
  };
  
  const submissionModel = {
    assignmentID: '',
    studentsubmission:[],
  };
  
  
  const studentsubmissionsModel = {
    fullname: '',
    Grade:'',
    fileUrl: '',
    submittedDate: admin.firestore.FieldValue.serverTimestamp(),
  };



  const attendancemodel = {
    subClassname:'',
    Date: '',
    students:[],
    subjectname:'',
  };









  module.exports = { assignmentModel, submissionModel ,studentsubmissionsModel,attendancemodel};