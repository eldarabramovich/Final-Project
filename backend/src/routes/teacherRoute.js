
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
    AddAttendance,
    downloadSubmission,
    updateSubmissionGrade,
    updateFinalGrade,
    addEvent,getEvents
} = require('../controllers/teacherController.js');

router.post('/AddAssignment',upload,AddAssignment);
router.post('/addatte',AddAttendance);
router.post('/addmess',SendMessageToClass);
router.post('/CreateSubClass',CreateSubClass);
router.post('/AddStudentToSubClass',AddStudentToSubClass);
router.post('/downloadSubmission', downloadSubmission);
router.post('/updateSubmissionGrade', updateSubmissionGrade);
router.post('/updateFinalGrade', updateFinalGrade);
router.post('/addEvent', addEvent);
router.get('/getEvents',getEvents );


router.put('/editteachers/:teacherId', editTeacher);
router.delete('/deleteachers/:teacherId', deleteTeacher);
router.get('/downloadFile/:fileId',downloadFile );

router.get('/:classId', getClassStudents);
router.get('/teacher/:userId', getTeacherData);
router.get('/getstudents/:classname', GetStudentBySubClass);
router.get('/getSubmissions/:assignmentID', getSubmissions);
module.exports = router;