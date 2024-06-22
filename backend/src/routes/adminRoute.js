const express = require('express');
const router = express.Router();
const { CreateClass,CreateTeacher} = require('../controllers/adminController.js');

router.post('/admin/CreateClass',CreateClass);
// router.post('/admin/addstudent',addStudent);
router.post('/admin/CreateTeacher',CreateTeacher);
// router.post('/admin/addadmin',addAdmin);
// //הוספת כיתות
// //הוספת מקצועות
// router.post('/admin/addassi',addAssignmentToSubject);
// router.post('/admin/addclasubj',addClasswithsubject);

module.exports = router;