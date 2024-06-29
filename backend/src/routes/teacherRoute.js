
const express = require('express');
const router = express.Router();
const { upload , getClassStudents, editTeacher, deleteTeacher,CreateSubClass , AddStudentToSubClass,AddAssignment ,getTeacherData ,SendMessageToClass,GetStudentByClass,AddAttendance} = require('../controllers/teacherController.js');
router.post('/AddAssignment',upload,AddAssignment);
router.post('/teacher/addatte',AddAttendance);
router.post('/teacher/addmess',SendMessageToClass);
router.post('/teacher/CreateSubClass',CreateSubClass);
router.post('/teacher/AddStudentToSubClass',AddStudentToSubClass);

router.put('/teacher/editteachers/:teacherId', editTeacher);
router.delete('/teacher/deleteachers/:teacherId', deleteTeacher);

router.get('/teacher/:classId', getClassStudents);
router.get('/:userId', getTeacherData);
router.get('/teacher/getstudents/:classname', GetStudentByClass);
module.exports = router;