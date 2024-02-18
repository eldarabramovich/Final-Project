
const express = require('express');

const { addStudent, addTeacher,addAdmin , addClass , addAssignmentToClass} = require('../controllers/adminController.js');

const router = express.Router();


router.post('/admin/addstudent',addStudent);
router.post('/admin/addteacher',addTeacher);
router.post('/admin/addadmin',addAdmin);
router.post('/admin/addclass',addClass);
router.post('/admin/addassi',addAssignmentToClass);

module.exports = router;