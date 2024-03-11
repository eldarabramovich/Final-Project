const express = require('express');
const { GetAssignById,GetMessageByClassname } = require('../controllers/studentController');
const router = express.Router();
router.get('/getassi/:userId',GetAssignById );
router.get('/getmess/:classname',GetMessageByClassname);
module.exports = router;
