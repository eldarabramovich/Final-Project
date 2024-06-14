const express = require('express');
const router = express.Router();
const { CreateSubClass , AddStudentToSubClass} = require('../controllers/teacher_controller.js');

router.post('/teacher/CreateSubClass',CreateSubClass);
router.post('/teacher/AddStudentToSubClass',AddStudentToSubClass);


module.exports = router;