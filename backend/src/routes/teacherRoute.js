
const express = require('express');
const router = express.Router();
const { CreateSubClass , AddStudentToSubClass,AddAssigment ,getTeacherData ,SendMessageToClass,GetStudentByClass,AddAttendance} = require('../controllers/teacherController.js');

//הקמת תת כיתה והוספת תלמידים ומקצועות
router.post('/addassi',AddAssigment);
router.post('/addatte',AddAttendance);
router.post('/addmess',SendMessageToClass);
router.post('/teacher/CreateSubClass',CreateSubClass);
router.post('/teacher/AddStudentToSubClass',AddStudentToSubClass);



router.get('/:userId', getTeacherData);
router.get('/getstudents/:classname', GetStudentByClass);




module.exports = router;