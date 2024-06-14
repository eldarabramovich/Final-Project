
const router = express.Router();
const { addStudent, addTeacher,addAdmin , addAssignmentToSubject,addClasswithsubject} = require('../controllers/adminController.js');

router.post('/admin/addstudent',addStudent);
router.post('/admin/addteacher',addTeacher);
router.post('/admin/addadmin',addAdmin);
//הוספת כיתות
//הוספת מקצועות



router.post('/admin/addassi',addAssignmentToSubject);
router.post('/admin/addclasubj',addClasswithsubject);

module.exports = router;