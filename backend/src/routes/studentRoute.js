const express = require('express');
const { GetAssignById,GetMessageByClassname,getStudentData } = require('../controllers/studentController');
const router = express.Router();
router.get('/getassi/:userId',GetAssignById );
router.get('/getmess/:classname',GetMessageByClassname);
router.get('/getstudent/:userId',getStudentData);
module.exports = router;
