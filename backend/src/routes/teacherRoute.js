
const express = require('express');
const router = express.Router();
const { getAssignmentsBySubjectAndClass,downloadFile,getSubmissions,upload , getClassStudents, editTeacher, deleteTeacher,CreateSubClass , AddStudentToSubClass,AddAssignment ,getTeacherData ,SendMessageToClass,GetStudentByClass,AddAttendance} = require('../controllers/teacherController.js');
router.post('/AddAssignment',upload,AddAssignment);
router.post('/addatte',AddAttendance);
router.post('/addmess',SendMessageToClass);
router.post('/CreateSubClass',CreateSubClass);
router.post('/AddStudentToSubClass',AddStudentToSubClass);
router.get('/downloadFile/:fileId',downloadFile );
router.put('/editteachers/:teacherId', editTeacher);
router.delete('/deleteachers/:teacherId', deleteTeacher);
router.get('/:classId', getClassStudents);
router.get('/teacher/:userId', getTeacherData);
router.get('/getstudents/:classname', GetStudentByClass);
router.get('/getSubmissions/:assignmentID', getSubmissions);
router.get('/getSubmissions/', getAssignmentsBySubjectAndClass);
module.exports = router;