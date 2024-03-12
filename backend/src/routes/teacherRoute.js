const express = require('express');
const { AddAssigment ,getTeacherData ,SendMessageToClass,GetStudentByClass,AddAttendance} = require('../controllers/teacherController.js');
const router = express.Router();
router.post('/addassi',AddAssigment);
router.post('/addatte',AddAttendance);
router.get('/:userId', getTeacherData);
router.post('/addmess',SendMessageToClass);
router.get('/getstudents/:classname', GetStudentByClass);

module.exports = router;