const express = require('express');
const { AddAssigment ,getTeacherData } = require('../controllers/teacherController.js');
const router = express.Router();
router.post('/addassi',AddAssigment);
router.get('/:userId', getTeacherData);

module.exports = router;