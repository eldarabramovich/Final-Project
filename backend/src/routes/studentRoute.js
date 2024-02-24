const express = require('express');
const { GetAssignById } = require('../controllers/studentController');
const router = express.Router();
router.get('/assignments/:userId',GetAssignById );
module.exports = router;
