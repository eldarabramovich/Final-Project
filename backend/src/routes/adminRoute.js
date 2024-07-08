const express = require('express');
const router = express.Router();
const {CreateAndAddStudent,CreateClass,CreateTeacher,addAdmin} = require('../controllers/adminController.js');
router.post('/createStudent', CreateAndAddStudent);
router.post('/CreateClass',CreateClass);
router.post('/CreateTeacher',CreateTeacher);
router.post('/addadmin',addAdmin);

module.exports = router;