
const express = require('express');
const router = express.Router();
const {uploadFile,getClassStudents,editTeacher,deleteTeacher,CreateSubClass , AddStudentToSubClass,AddAssigment ,getTeacherData ,SendMessageToClass,GetStudentByClass,AddAttendance} = require('../controllers/teacherController.js');


router.post('/addassi',AddAssigment);
router.post('/addatte',AddAttendance);
router.post('/addmess',SendMessageToClass);
router.post('/teacher/CreateSubClass',CreateSubClass);
router.post('/teacher/AddStudentToSubClass',AddStudentToSubClass);



router.put('/editteachers/:teacherId', editTeacher);
router.delete('/deleteachers/:teacherId', deleteTeacher);



router.get('/:classId', getClassStudents);
router.get('/:userId', getTeacherData);
router.get('/getstudents/:classname', GetStudentByClass);

router.post('/upload', uploadFile);




module.exports = router;