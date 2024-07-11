const express = require('express');
const router = express.Router();
const {getAssignmentsByClassAndSubject,getAssignmentsBySubject,AddParent,GetAllStudents,CreateAndAddStudent,CreateClass,CreateTeacher,addAdmin} = require('../controllers/adminController.js');
router.post('/createStudent', CreateAndAddStudent);
router.post('/CreateClass',CreateClass);
router.post('/CreateTeacher',CreateTeacher);
router.post('/addadmin',addAdmin);
router.post('/AddParent',AddParent);
router.get('/GetAllStudents',GetAllStudents);
router.get('/getAssignmentsByClassAndSubject',getAssignmentsByClassAndSubject);
module.exports = router;