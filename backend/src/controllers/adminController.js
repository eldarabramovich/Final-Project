
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
}; // Adjust the path accordingly

const CreateTeacher = async (req, res) => {
    const { username, password, fullname, email, classesSubject, classesHomeroom } = req.body;

    if (!username || !email || !password || !fullname) {
        return res.status(500).send("Missing data!");
    }

    if (classesHomeroom && classesSubject) {
        return res.status(400).send("Teacher can't be homeroom and subjects");
    }

    const newTeacherUser = {
        username,
        password,
        fullname,
        email,
        role: "teacher",
        classesHomeroom: classesHomeroom || '',
        classesSubject: classesSubject ? classesSubject.map(cls => ({
            classname: cls.classname,
            subjectname: cls.subjectname,
            subjectId: cls.subjectId
        })) : ''
    };

    try {

        const teacherRef = db.collection('teachers').doc();
        await teacherRef.set(newTeacherUser);

        // If the teacher is a homeroom teacher
        if (classesHomeroom) {
            const classRef = db.collection('classes').where('classLetter', '==', classesHomeroom.charAt(0));
            const classSnapshot = await classRef.get();

            if (classSnapshot.empty) {
                return res.status(404).send(`Class ${classesHomeroom} not found`);
            }

            classSnapshot.forEach(async (doc) => {
                await doc.ref.update({
                    homeroomTeachers: admin.firestore.FieldValue.arrayUnion({ id: teacherRef.id, name: fullname, subClass: classesHomeroom })
                });
            });
        }
        if (classesSubject && !classesHomeroom) {
            for (const cls of classesSubject) {
                if (!cls.classname || !cls.subjectname) {
                    return res.status(400).send("Missing classname or subject in classes array");
                }

                const subjectRef = db.collection('subjects').doc();
                await subjectRef.set({
                    name: cls.subjectname,
                    teacherId: teacherRef.id,
                    subClassId: cls.classname
                });

                // Update the teacher's classesSubject field with the subject ID
                await teacherRef.update({
                    classesSubject: admin.firestore.FieldValue.arrayUnion({
                        classname: cls.classname,
                        subjectname: cls.subjectname,
                        subjectId: subjectRef.id
                    })
                });

                const subClassRef = db.collection('subClasses').doc(cls.classname);
                const subClassDoc = await subClassRef.get();

                if (!subClassDoc.exists) {
                    // Create the subclass if it doesn't exist
                    await subClassRef.set({
                        name: cls.classname,
                        parentClass: cls.classname.charAt(0),
                        homeroomTeacherId: '',
                        students: [],
                        subjects: []
                    });
                }

                // Update the subclass document with the new subject
                await subClassRef.update({
                    subjects: admin.firestore.FieldValue.arrayUnion({
                        subjectname: cls.subjectname,
                        subjectId: subjectRef.id,
                        teacherId: teacherRef.id
                    })
                });

                // Update the class document to include the professional teacher
                const classRef = db.collection('classes').where('classLetter', '==', cls.classname.charAt(0));
                const classSnapshot = await classRef.get();

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
                        })
                    });
                });
            }
        }
        res.status(200).send('Teacher added successfully');

    } catch (error) {
        console.error("Error adding teacher: ", error);
        res.status(500).send("Error adding teacher");
    }
};

// const CreateTeacher = async (req, res) => {

//     const { username , password , fullname, email , classesSubject,classesHomeroom } = req.body; 

//     if(!username || !email || !password || !fullname){
//         res.status(500).send("missing data !");
//     }

//     if(classesHomeroom && classesSubject)
//     {
//         return res.status(400).send("Teacher can't be homeroom and subjects");
//     }

//     if(classesSubject){    
//         for (const cls of classesSubject) {
//             if (!cls.classname || !cls.subject || !cls.subjectId) {
//                 return res.status(400).send("Missing classname or subject in classes array");
//             }
//         }
//     }
   
//     const newTeacherUser = {
//         ...teacherUserModel,
//         fullname,
//         username,
//         password,
//         email,
//         role:"teacher",
//         classesHomeroom: classesHomeroom || '',
//         classesSubject: classesSubject.map((cls) => ({
//             classname: cls.classname,
//             subjectname: cls.subjectname,
//             subjectId :cls.subjectId
//         })) || ''
//     };
    
//     try {
//         const db = admin.firestore();
       
//         const teacherRef = db.collection('teachers').doc(); 
//         await teacherRef.set(newTeacherUser)
        


//         res.status(200).send('Teacher added successfully');
//     } catch (error) {
//         console.error("Error adding teacher: ", error);
//         res.status(500).send("Error adding teacher");
//     }
// };

const CreateStudent = async (req, res) => {

    const { username, password, fullname, classlatter, subClassName } = req.body;

    if (!username || !password || !fullname || !classlatter) {
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
        const db = admin.firestore();
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

const CreateAndAddStudent = async (req, res) => {
    const { username, password, fullname, classLetter, subClassId } = req.body;

    if (!username || !password || !fullname || !classLetter) {
        return res.status(400).send("Missing data!");
    }

    const newStudent = {
        ...studentModel,
        username,
        password,
        fullname,
        classLetter: classLetter,
        subClassLetter: subClassId || ''  // Initialize as empty if not provided
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

        // If a subclass ID is provided, update the subclass document
        if (subClassId) {
            // Separate the class letter from the subclass number
            const subclassLetter = subClassId.charAt(0);
            const subClassName = subClassId.slice(1);

            const subClassesRef = db.collection('subClasses');
            const subClassSnapshot = await subClassesRef
                .where('classNumber', '==', subClassName)
                .where('parentClass', '==', classId)
                .get();

            if (subClassSnapshot.empty) {
                return res.status(404).send(`SubClass ${subClassId} not found in class ${classLetter}`);
            }

            let subClassDocId;
            subClassSnapshot.forEach(doc => {
                subClassDocId = doc.id;
            });

            const subClassRef = db.collection('subClasses').doc(subClassDocId);
            await subClassRef.update({
                students: admin.firestore.FieldValue.arrayUnion({ id: studentRef.id, name: fullname })
            });
        }

        res.status(200).send('Student added successfully');
    } catch (error) {
        console.error("Error adding student: ", error);
        res.status(500).send("Error adding student");
    }
};

const CreateClass = async (req, res) => {

    const { classLetter, subClasses, students, SubjectsTeachers,HomeRoomTeachers,Subjects } = req.body;

    if (!classLetter) {
        return res.status(400).send("Missing data!");
    }

    // Create the new class object using the classModel as a template
    const newClass = {
        ...classModel,
        classLetter,
        subClasses: subClasses || [],
        students: students || [],
        SubjectsTeachers: SubjectsTeachers || [],
        HomeRoomTeachers: HomeRoomTeachers || [],
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


module.exports = {CreateClass, CreateStudent, CreateTeacher, AddStudentToClass,addAdmin,}





// //--------------------------class and objects and adding assigments
// const addClasswithsubject = async (req, res) => {
//     const { classname, subjects } = req.body; // Example fields

//     if (!classname || !subjects || subjects.length === 0) {
//         return res.status(400).send("Missing data!");
//     }

//     try {
//         const db = admin.firestore();
//         const batch = db.batch();
//         const classRef = db.collection('classes').doc();

//         // Create an array to hold the references to the added subjects
//         const subjectRefs = [];

//         // Add each subject to the 'subjects' collection and store the reference
//         for (i=0;i<subjects.length;i++) {
//             const subjectRef = db.collection('subjects').doc();
//             batch.set(subjectRef, {
//                 className: classname ,
//                 subject:subjects[i],
//                 studentassign:[],
//                 assignments:[],
//                 attendance:[],
//             });
//             subjectRefs.push(subjectRef);
//         }

//         // Add the class with the references to the subjects
//         batch.set(classRef, {
//             classname,
//             messages:[],
//             subjects: subjectRefs.map(ref => ref.id) // Store only the IDs of the subject documents
//         });

//         await batch.commit();
//         res.status(200).send('Class added successfully');
//     } catch (error) {
//         console.error("Error adding class: ", error);
//         res.status(500).send("Error adding class");
//     }
// };
// const addAssignmentToSubject = async (req, res) => {
//     const { classname, subjectName, assignment } = req.body;

//     if (!classname || !subjectName || !assignment) {
//         return res.status(400).send("Missing data!");
//     }

//     try {
//         const db = admin.firestore();

//         // First, find the subject document ID using the classname and subjectName
//         const subjectsQuerySnapshot = await db.collection('subjects')
//             .where('className', '==', classname)
//             .where('subject', '==', subjectName)
//             .limit(1)
//             .get();

//         if (subjectsQuerySnapshot.empty) {
//             return res.status(404).send('Subject not found for the provided class');
//         }

//         // Get the document reference for the found subject
//         const subjectDocRef = subjectsQuerySnapshot.docs[0].ref;

//         // Update the subject document's 'assignments' array with the new assignment
//         const updateResult = await subjectDocRef.update({
//             assignments: admin.firestore.FieldValue.arrayUnion(assignment)
//         });

//         res.status(200).send('Assignment added successfully to the subject');
//     } catch (error) {
//         console.error("Error adding assignment to subject: ", error);
//         res.status(500).send("Error adding assignment to subject");
//     }
//  };
// const addAdmin = async (req, res) => {
//     const { username,password } = req.body; // Example fields
//     if(!username || !password ){
//         res.status(500).send("missing data !");
//     }
    
//     try {
//         const db = admin.firestore();
//         const teacherRef = db.collection('admin').doc(); // Create a new doc in 'teachers' collection
//         await teacherRef.set({
//             username,
//             password,
//         });
//         res.status(200).send('admin user added successfully');
//     } catch (error) {
//         console.error("Error adding teacher: ", error);
//         res.status(500).send("Error adding admin");
//     }
// };
// const addTeacher = async (req, res) => {
//     const { username , password , fullname, email , classesSubject,classesHomeroom  } = req.body; 

//     if(!username || !email || !password || !fullname){
//         res.status(500).send("missing data !");
//     }

//     if(classesSubject){    
//         for (const cls of classesSubject) {
//             if (!cls.classname || !cls.subject) {
//                 return res.status(400).send("Missing classname or subject in classes array");
//             }
//         }
//     }
   
//     const newTeacherUser = {
//         ...teacherUserModel,
//         fullname,
//         username,
//         password,
//         email,
//         role:"teacher",
//         classesHomeroom: classesHomeroom || '',
//         classesSubject: classesSubject.map((cls) => ({
//             classname: cls.classname,
//             subject: cls.subject
//         })) || ''
//     };
    
//     try {
//         const db = admin.firestore();
       
//         const teacherRef = db.collection('teachers').doc(); 
//         await teacherRef.set(newTeacherUser)
        


//         res.status(200).send('Teacher added successfully');
//     } catch (error) {
//         console.error("Error adding teacher: ", error);
//         res.status(500).send("Error adding teacher");
//     }
// };
// const addStudent = async (req, res) => {
//     const { username , password , fullname , classname } = req.body; // Example fields
//     if(!username || !password || !fullname || !classname ){
//         res.status(500).send("missing data !");
//     }
//     try {
//         const db = admin.firestore();
//         const studentRef = db.collection('students').doc(); // Create a new doc in 'students' collection
//         await studentRef.set({
//             username,
//             password,
//             fullname,
//             classname,
//             role:"student",
//         });
//         res.status(200).send('Student added successfully');
//     } catch (error) {
//         console.error("Error adding student: ", error);
//         res.status(500).send("Error adding student");
//     }
// };

//  module.exports = { addStudent ,addTeacher , addAdmin,addAssignmentToSubject,addClasswithsubject};

//  //_______________________old add teacher___
 
// const addTeacher = async (req, res) => {
//     const { username , password , fullname, subject, email , classname  } = req.body; 

//     if(!username || !subject || !email || !password || !fullname || !classname){
//         res.status(500).send("missing data !");
//     }
    
//     try {
//         const db = admin.firestore();
//         const batch = db.batch();
//         const teacherRef = db.collection('teachers').doc(); 


//         await teacherRef.set({
//             teacaherID : teacherRef.id,
//             fullname,
//             username,
//             password,
//             subject,
//             classname,
//             email,
//             role:"teacher",
//         });

//         await batch.commit();

//         res.status(200).send('Teacher added successfully');

//     } catch (error) {
//         console.error("Error adding teacher: ", error);
//         res.status(500).send("Error adding teacher");
//     }
// };

