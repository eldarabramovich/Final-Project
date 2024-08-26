const express = require('express');
const router = express.Router();
const { getFinalGrades, getAssignmentGrades,getParentData,GetStudentAttendance,sendMessageToTeacher,getStudentByFullName,getHomeroomTeacherByClassName } = require('../controllers/parentController');
router.get('/GetStudentAttendance/:studentId', GetStudentAttendance);
router.get('/getParentData/:parentId', getParentData);
router.post('/finalGrades', getFinalGrades);
router.post('/sendMessageToTeacher', sendMessageToTeacher);
router.post('/assignmentGrades', getAssignmentGrades);
router.post('/sendMessageToTeacher', sendMessageToTeacher);

router.post('/getStudentByFullName/', getStudentByFullName);
router.post('/getHomeroomTeacherByClassName', getHomeroomTeacherByClassName);

module.exports = router;