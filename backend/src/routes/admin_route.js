const express = require('express');
const router = express.Router();
const {CreateClass, CreateStudent, CreateTeacher, AddStudentToClass,Addsubject,CreateSubClass,AddStudentToSubClass} = require('../controllers/admin_controller.js');

router.post('/admin/CreateClass', CreateClass);
router.post('/admin/CreateStudent', CreateStudent);
router.post('/admin/CreateTeacher', CreateTeacher);
router.post('/admin/AddStudentToClass', AddStudentToClass);
router.post('/admin/Addsubject', Addsubject);
 

module.exports = router;