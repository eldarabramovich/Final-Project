const express = require('express');
const router = express.Router();
const { getParentData } = require('../controllers/parentController');

router.get('/getParentData/:parentId', getParentData);

module.exports = router;