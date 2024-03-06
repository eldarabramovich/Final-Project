const express = require('express');
const { AddAssigment} = require('../controllers/teacherController.js');
const router = express.Router();
router.post('/addassi',AddAssigment);
module.exports = router;