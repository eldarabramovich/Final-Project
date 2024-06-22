const express = require('express');
const router = express.Router();
const {CreateAndAddStudent,CreateClass, CreateStudent, CreateTeacher, AddStudentToClass,addAdmin} = require('../controllers/adminController.js');

router.post('/admin/CreateClass',CreateClass);
router.post('/admin/CreateStudent',CreateStudent);
router.post('/admin/CreateTeacher',CreateTeacher);
router.post('/admin/addadmin',addAdmin);

module.exports = router;