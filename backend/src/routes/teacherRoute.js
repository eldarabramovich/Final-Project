const express = require('express');
const { AddAssigment} = require('../controllers/teacherController.js');
const router = express.Router();
router.post('/teacher/addassi',AddAssigment);
module.exports = router;