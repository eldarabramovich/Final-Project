const express = require('express');
const router = express.Router();
const { 
    updateTeacher,
    deleteTeacher,
    deleteStudent,
    updateStudent,
    getAssignmentsByClassAndSubject,
    CreateAndAddStudent,
    CreateClass, 
    CreateTeacher, 
    addAdmin,
    GetAllStudents,
    AddParent,
    updateParent,
    deleteParent} = require('../controllers/adminController.js');



router.post('/CreateClass',CreateClass);
router.post('/addadmin',addAdmin);

router.post('/AddParent',AddParent);
router.post('/deleteParent', updateParent);
router.post('/updateParent', deleteParent);
    
    
router.post('/CreateTeacher',CreateTeacher);    
router.post('/deleteTeacher', deleteTeacher);
router.post('/updateTeacher', updateTeacher);



router.post('/createStudent', CreateAndAddStudent);
router.post('/updateStudent', updateStudent);
router.post('/deleteStudent', deleteStudent);


router.post('/CreateClass',CreateClass);
router.post('/addadmin',addAdmin);
router.post('/AddParent',AddParent);


router.get('/GetAllStudents',GetAllStudents);
router.get('/getAssignmentsByClassAndSubject',getAssignmentsByClassAndSubject);

module.exports = router;