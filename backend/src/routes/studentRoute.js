const express = require('express');
const { GetAssignById,GetMessageByClassname,getStudentData ,deleteStudent,editStudent} = require('../controllers/studentController');
const router = express.Router();
router.get('/getassi/:userId',GetAssignById );
router.post('/student/editStudent',editStudent );
router.delete('/deletestudents/:studentId', deleteStudent);
router.get('/getmess/:classname',GetMessageByClassname);
router.get('/getstudent/:userId',getStudentData);
module.exports = router;
