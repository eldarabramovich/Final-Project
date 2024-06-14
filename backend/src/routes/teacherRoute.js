const router = express.Router();
const { AddAssigment ,getTeacherData ,SendMessageToClass,GetStudentByClass,AddAttendance} = require('../controllers/teacherController.js');

//הקמת תת כיתה והוספת תלמידים ומקצועות
//
router.post('/addassi',AddAssigment);
router.post('/addatte',AddAttendance);
router.get('/:userId', getTeacherData);
router.post('/addmess',SendMessageToClass);
router.get('/getstudents/:classname', GetStudentByClass);

module.exports = router;