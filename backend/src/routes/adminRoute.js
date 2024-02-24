
const express = require('express');

const { addStudent, addTeacher,addAdmin , addAssignmentToSubject,addClasswithsubject} = require('../controllers/adminController.js');

const router = express.Router();


router.post('/admin/addstudent',addStudent);
router.post('/admin/addteacher',addTeacher);
router.post('/admin/addadmin',addAdmin);
router.post('/admin/addassi',addAssignmentToSubject);
router.post('/admin/addclasubj',addClasswithsubject);
module.exports = router;