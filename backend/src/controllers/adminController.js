
const { db ,admin } = require('../firebase/firebaseAdmin.js');
const teacherUserModel = require('../models/teacherModel');
const subjectModel = require('../models/subjectModel.js');
const classModel = require('../models/classModel.js');
const studentModel = require('../models/studentModel.js');

const addAdmin = async (req, res) => {
    const { username,password } = req.body; // Example fields
    if(!username || !password ){
        res.status(500).send("missing data !");
    }
    
    try {
        const db = admin.firestore();
        const teacherRef = db.collection('admin').doc(); // Create a new doc in 'teachers' collection
        await teacherRef.set({
            username,
            password,
        });
        res.status(200).send('admin user added successfully');
    } catch (error) {
        console.error("Error adding teacher: ", error);
        res.status(500).send("Error adding admin");
    }
}; 

const CreateTeacher = async (req, res) => {
    const { username, password, fullname, email, classesSubject, classHomeroom } = req.body;

    if (!username || !email || !password || !fullname) {
        return res.status(500).send("Missing data!");
    }

    if (classHomeroom && classesSubject) {
        return res.status(400).send("Teacher can't be homeroom and subjects");
    }

    const newTeacherUser = {
        username,
        password,
        fullname,
        email,
        role: "teacher",
        classHomeroom: classHomeroom || '',
        classesSubject: [] // Initialize as an empty array
    };

    try {
        const teacherRef = db.collection('teachers').doc();
        await teacherRef.set(newTeacherUser);

        // If the teacher is a homeroom teacher
        if (classHomeroom) {
            const classRef = db.collection('classes').where('classLetter', '==', classHomeroom.charAt(0));
            const classSnapshot = await classRef.get();

            if (classSnapshot.empty) {
                return res.status(404).send(`Class ${classHomeroom} not found`);
            }

            classSnapshot.forEach(async (doc) => {
                await doc.ref.update({
                    HomeRoomTeachers: admin.firestore.FieldValue.arrayUnion({ teacherid: teacherRef.id, name: fullname, subClass: classHomeroom })
                });
            });
        }

        // If the teacher is a professional teacher
        if (classesSubject && !classHomeroom) {
            const updatedClassesSubject = [];

            for (const cls of classesSubject) {
                if (!cls.classname || !cls.subjectname) {
                    return res.status(400).send("Missing classname or subject in classes array");
                }

                const subjectRef = db.collection('subjects').doc();
                await subjectRef.set({
                    subjectname: cls.subjectname,
                    teacherId: teacherRef.id,
                    subClassName: cls.classname
                });

                updatedClassesSubject.push({
                    classname: cls.classname,
                    subjectname: cls.subjectname,
                    subjectId: subjectRef.id
                });

                // Check if the subclass exists
                const subClassQuery = db.collection('subClasses').where('classNumber', '==', cls.classname);
                const subClassSnapshot = await subClassQuery.get();

                let subClassDocRef;
                if (subClassSnapshot.empty) {
                    // Create the subclass if it doesn't exist
                    subClassDocRef = db.collection('subClasses').doc();
                    await subClassDocRef.set({
                        classNumber: cls.classname,
                        parentClass: cls.classname.charAt(0),
                        homeroomTeacherId: '',
                        students: [],
                        subjects: []
                    });
                } else {
                    subClassDocRef = subClassSnapshot.docs[0].ref;
                }

                // Update the subclass document with the new subject
                await subClassDocRef.update({
                    subjects: admin.firestore.FieldValue.arrayUnion({
                        subjectname: cls.subjectname,
                        subjectId: subjectRef.id,
                        teacherId: teacherRef.id
                    })
                });

                // Update the class document to include the professional teacher
                const classQuery = db.collection('classes').where('classLetter', '==', cls.classname.charAt(0));
                const classSnapshot = await classQuery.get();

                if (classSnapshot.empty) {
                    return res.status(404).send(`Class ${cls.classname} not found`);
                } 

                classSnapshot.forEach(async (doc) => {
                    await doc.ref.update({
                        professionalTeachers: admin.firestore.FieldValue.arrayUnion({
                            id: teacherRef.id,
                            name: fullname,
                            subject: cls.subjectname,
                            subClass: cls.classname
                        }),
                        subClasses: admin.firestore.FieldValue.arrayUnion(subClassDocRef.id)
                    });
                });
            }

            // Update the teacher document with the updated classesSubject array
            await teacherRef.update({
                classesSubject: updatedClassesSubject
            });
        }


        res.status(200).send('Teacher added successfully');

    } catch (error) {
        console.error("Error adding teacher: ", error);
        res.status(500).send("Error adding teacher");
    }
};
//create and add student to a classes 
const CreateStudent = async (req, res) => {

    const { username, password, fullname, classname } = req.body;

    if (!username || !password || !fullname || !classname) {
        return res.status(400).send("Missing data!");
    }

    const newStudent = {
        ...studentModel,
        username,
        password,
        fullname,
        classname,
        subClassName: ''  // Initialize as empty since it's not assigned yet
    };

    try {
        const studentRef = db.collection('students').doc();
        await studentRef.set(newStudent);

        // Update the class document to include this student
        const classesRef = db.collection('classes');
        const classSnapshot = await classesRef.where('classLetter', '==', classname).get();

        if (!classSnapshot.empty) {
            classSnapshot.forEach(async (doc) => {
                await doc.ref.update({
                    students: admin.firestore.FieldValue.arrayUnion({ id: studentRef.id, name: fullname })
                });
            });
        }

        res.status(200).send('Student added successfully');
    } catch (error) {
        console.error("Error adding student: ", error);
        res.status(500).send("Error adding student");
    }
};
//create class
const CreateClass = async (req, res) => {

    const { classLetter,students,Subjects } = req.body;

    if (!classLetter || !Subjects) {
        return res.status(400).send("Missing data!");
    }

    // Create the new class object using the classModel as a template
    const newClass = {
        ...classModel,
        classLetter,
        students: students || [],
        SubjectsTeachers: [],
        HomeRoomTeachers: [],
        Subjects: Subjects || []
    };

    try {
        const db = admin.firestore();
        const classRef = db.collection('classes').doc();
        await classRef.set(newClass);
        res.status(200).send('Class added successfully');
    } catch (error) {
        console.error("Error adding class: ", error);
        res.status(500).send("Error adding class");
    }
};

const CreateAndAddStudent = async (req, res) => {
    const { username, password, fullname, classLetter, subClassName } = req.body;
  
    if (!username || !password || !fullname || !classLetter) {
      return res.status(400).send("Missing data!");
    }
  
    const newStudent = {
      ...studentModel,
      username,
      password,
      fullname,
      classname: classLetter,
      subClassName: subClassName || '' // Initialize as empty if not provided
    };
  
    try {
      const db = admin.firestore();
      const studentRef = db.collection('students').doc();
      await studentRef.set(newStudent);
  
      // Find the class by class letter
      const classesRef = db.collection('classes');
      const classSnapshot = await classesRef.where('classLetter', '==', classLetter).get();
  
      if (classSnapshot.empty) {
        return res.status(404).send(`Class ${classLetter} not found`);
      }
  
      let classId;
      classSnapshot.forEach(doc => {
        classId = doc.id;
      });
  
      // Update the class document to include the new student
      const classRef = db.collection('classes').doc(classId);
      await classRef.update({
        students: admin.firestore.FieldValue.arrayUnion({ id: studentRef.id, name: fullname })
      });
  
      // If a subclass name is provided, update the subclass document
      if (subClassName) {
        const subClassesRef = db.collection('subClasses');
        const subClassSnapshot = await subClassesRef
          .where('classNumber', '==', subClassName)
          .where('parentClass', '==', classId)
          .get();
  
        if (subClassSnapshot.empty) {
          return res.status(404).send(`SubClass ${subClassName} not found in class ${classLetter}`);
        }
  
        let subClassDocId;
        subClassSnapshot.forEach(doc => {
          subClassDocId = doc.id;
        });
  
        const subClassRef = db.collection('subClasses').doc(subClassDocId);
        await subClassRef.update({
          students: admin.firestore.FieldValue.arrayUnion({ id: studentRef.id, fullname: fullname })
        });
      }
  
      res.status(200).send('Student added successfully');
    } catch (error) {
      console.error("Error adding student: ", error);
      res.status(500).send("Error adding student");
    }
  };
  
const AddStudentToClass = async (req, res) => {
    const { studentName, classLetter } = req.body;

    if (!studentName || !classLetter) {
        return res.status(400).send("Missing data!");
    }

    try {
        const db = admin.firestore();

        // Find the class by class letter
        const classesRef = db.collection('classes');
        const classSnapshot = await classesRef.where('classLetter', '==', classLetter).get();

        if (classSnapshot.empty) {
            return res.status(404).send(`Class ${classLetter} not found`);
        }

        let classId;
        classSnapshot.forEach(doc => {
            classId = doc.id;
        });

        // Find the student by name
        const studentsRef = db.collection('students');
        const studentSnapshot = await studentsRef.where('fullname', '==', studentName).get();

        if (studentSnapshot.empty) {
            return res.status(404).send(`Student ${studentName} not found`);
        }

        let studentId;
        studentSnapshot.forEach(doc => {
            studentId = doc.id;
        });

        // Update the class document to include the student ID
        const classRef = db.collection('classes').doc(classId);
        await classRef.update({
            students: admin.firestore.FieldValue.arrayUnion({ id: studentId, name: studentName })
        });

        // Update the student document to include the class letter
        const studentRef = db.collection('students').doc(studentId);
        await studentRef.update({
            classname: classLetter
        });

        res.status(200).send('Student added to class successfully');
    } catch (error) {
        console.error("Error adding student to class: ", error);
        res.status(500).send("Error adding student to class");
    }
};

const GetAllStudents = async (req, res) => {
    try {
      const studentsRef = admin.firestore().collection('students');
      const snapshot = await studentsRef.get();
      const students = [];
  
      snapshot.forEach((doc) => {
        students.push({
          id: doc.id,
          fullname: doc.data().fullname,
        });
      });
  
      res.status(200).json(students);
    } catch (error) {
      console.error('Error fetching students:', error);
      res.status(500).send('Internal Server Error');
    }
  };


 const AddParent = async (req, res) => {
    const { username, password, fullname, children } = req.body;
  
    if (!username || !password || !fullname || !Array.isArray(children)) {
      return res.status(400).send("Missing data!");
    }
  
    const newParent = {
      username,
      password,
      fullname,
      role: 'parent',
      children: children || [],
    };
  
    try {
      const db = admin.firestore();
      const parentRef = db.collection('parents').doc();
      await parentRef.set(newParent);
  
      res.status(200).send('Parent added successfully');
    } catch (error) {
      console.error('Error adding parent:', error);
      res.status(500).send('Error adding parent');
    }
  };



  const getAssignmentsByClassAndSubject = async (req, res) => {
    const { classname, subjectname } = req.query;
  
    console.log(`Query parameters - classname: ${classname}, subjectname: ${subjectname}`); // Debugging line
  
    try {
      const assignmentsCollection = admin.firestore().collection('assignments');
      console.log(`Querying assignments collection: ${assignmentsCollection.path}`); // Debugging line
  
      const assignmentsSnapshot = await assignmentsCollection
        .where('classname', '==', classname)
        .where('subjectname', '==', subjectname)
        .get();
  
      console.log(`Query executed with classname: ${classname} and subjectname: ${subjectname}`);
  
      if (assignmentsSnapshot.empty) {
        console.log('No assignments found'); // Debugging line
        return res.status(404).send('Class not found');
      }
  
      const assignments = assignmentsSnapshot.docs.map(doc => {
        const assignmentData = doc.data();
        console.log(`Found assignment with ID: ${doc.id} and data: ${JSON.stringify(assignmentData)}`);
        return { id: doc.id, ...assignmentData };
      });
  
      console.log('Assignments found:', assignments); // Debugging line
  
      res.status(200).json(assignments);
    } catch (error) {
      console.error('Error fetching assignments:', error);
      res.status(500).send('Error fetching assignments');
    }
  };





  
const getAssignmentsBySubject = async (req, res) => {
    const { subjectname } = req.query;
    if (!subjectname) {
      console.log('Error: subjectname query parameter is missing.');
      return res.status(400).send('subjectname is required.');
    }
  
    try {
      const assignmentsSnapshot = await admin.firestore().collection('assignments')
        .where('subjectname', '==', subjectname)
        .get();
  
      if (assignmentsSnapshot.empty) {
        console.log('No assignments found for the subject:', subjectname);
        return res.status(404).send('No assignments found for this subject');
      }
  
      const assignments = assignmentsSnapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data()
      }));
  
      console.log('Assignments retrieved:', assignments);
      res.status(200).json(assignments);
    } catch (error) {
      console.error('Error fetching assignments by subject:', error);
      res.status(500).send('Error fetching assignments');
    }
  };

module.exports = {getAssignmentsByClassAndSubject,getAssignmentsBySubject,CreateAndAddStudent,CreateClass, CreateStudent, CreateTeacher, AddStudentToClass,addAdmin,GetAllStudents,AddParent}




