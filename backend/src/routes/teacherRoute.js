const express = require('express');
const { AddAssigment ,getTeacherData ,SendMessageToClass} = require('../controllers/teacherController.js');
const router = express.Router();
router.post('/addassi',AddAssigment);
router.get('/:userId', getTeacherData);
router.post('/addmess',SendMessageToClass);

module.exports = router;