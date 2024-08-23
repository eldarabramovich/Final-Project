const express = require('express');
const router = express.Router();
const { getFinalGrades, getAssignmentGrades,getParentData,GetStudentAttendance } = require('../controllers/parentController');
router.get('/GetStudentAttendance/:studentId', GetStudentAttendance);
router.get('/getParentData/:parentId', getParentData);
router.post('/finalGrades', getFinalGrades);
router.post('/assignmentGrades', getAssignmentGrades);


module.exports = router;