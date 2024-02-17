
const express = require('express');

const { addStudent, addTeacher,addAdmin} = require('../controllers/adminController.js');

const router = express.Router();


router.post('/admin/addstudent',addStudent);
router.post('/admin/addteacher',addTeacher);
router.post('/admin/addadmin',addAdmin);

module.exports = router;