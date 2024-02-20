
const express = require('express');

const { addStudent, addTeacher,addAdmin , addClass , addAssignmentToSubject,addClasswithsubject} = require('../controllers/adminController.js');

const router = express.Router();


router.post('/admin/addstudent',addStudent);
router.post('/admin/addteacher',addTeacher);
router.post('/admin/addadmin',addAdmin);
router.post('/admin/addclass',addClass);
router.post('/admin/addassi',addAssignmentToSubject);
router.post('/admin/addclsub',addClasswithsubject);
module.exports = router;