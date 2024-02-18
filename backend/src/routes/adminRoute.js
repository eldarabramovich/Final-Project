
const express = require('express');

const { addStudent, addTeacher,addAdmin , addClass} = require('../controllers/adminController.js');

const router = express.Router();


router.post('/admin/addstudent',addStudent);
router.post('/admin/addteacher',addTeacher);
router.post('/admin/addadmin',addAdmin);
router.post('/admin/addclass',addClass);

module.exports = router;