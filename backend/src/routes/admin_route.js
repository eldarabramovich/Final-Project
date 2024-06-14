const express = require('express');
const router = express.Router();
const {CreateClass, CreateStudent, CreateTeacher, AddStudentToClass} = require('../controllers/admin_controller.js');

router.post('/admin/CreateClass', CreateClass);
router.post('/admin/CreateStudent', CreateStudent);
router.post('/admin/CreateTeacher', CreateTeacher);
router.post('/admin/AddStudentToClass', AddStudentToClass);

module.exports = router;