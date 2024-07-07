
const express = require('express');
const router = express.Router();
<<<<<<< HEAD
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




=======
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
>>>>>>> 43a9c70fe73be010dbdd065f985d1b6fa280a889
module.exports = router;