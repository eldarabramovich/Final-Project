
const express = require('express');
const router = express.Router();
const {
    downloadFile,
    getSubmissions,
    upload,
    getClassStudents,
    editTeacher, 
    deleteTeacher,
    CreateSubClass,
    AddStudentToSubClass,
    AddAssignment ,
    getTeacherData ,
    SendMessageToClass,
    GetStudentBySubClass,
    addAttendance,
    downloadSubmission,
    getAttendanceRecords,
    editAttendance,
    getAttendanceById,
    getStudentAttendance,
    updateFinalGrade,
    updateSubmissionGrade
} = require('../controllers/teacherController.js');

router.post('/updateSubmissionGrade',updateSubmissionGrade);
router.post('/updateFinalGrade',updateFinalGrade);
router.post('/AddAssignment',upload,AddAssignment);
router.post('/addAttendance',addAttendance);
router.post('/addmess',SendMessageToClass);
router.post('/CreateSubClass',CreateSubClass);
router.post('/AddStudentToSubClass',AddStudentToSubClass);
router.post('/downloadSubmission', downloadSubmission);
router.post('/getAttendanceById', getAttendanceById);
router.post('/getAttendanceRecords',getAttendanceRecords);
router.post('/editAttendance',editAttendance);
router.put('/editteachers/:teacherId', editTeacher);
router.delete('/deleteachers/:teacherId', deleteTeacher);
router.get('/downloadFile/:fileId',downloadFile );
router.get('/getStudentAttendance/:studentId', getStudentAttendance);
router.get('/:classId', getClassStudents);
router.get('/teacher/:userId', getTeacherData);
router.get('/getstudents/:classname', GetStudentBySubClass);
router.get('/getSubmissions/:assignmentID', getSubmissions);
module.exports = router;