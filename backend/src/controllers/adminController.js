
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

const updateParent = async (req, res) => {
  const { fullname, newUsername, newPassword, newFullname, children } = req.body;

  if (!fullname) {
    return res.status(400).send("Missing fullname");
  }

  try {
    const db = admin.firestore();
    const parentRef = db.collection('parents').where('fullname', '==', fullname);
    const parentSnapshot = await parentRef.get();

    if (parentSnapshot.empty) {
      return res.status(404).send('Parent not found');
    }

    let parentDocId;
    parentSnapshot.forEach(doc => {
      parentDocId = doc.id;
    });

    const updates = {};
    if (newUsername) updates.username = newUsername;
    if (newPassword) updates.password = newPassword;
    if (newFullname) updates.fullname = newFullname;
    if (Array.isArray(children)) updates.children = children;

    const parentDocRef = db.collection('parents').doc(parentDocId);
    await parentDocRef.update(updates);

    res.status(200).send('Parent updated successfully');
  } catch (error) {
    console.error('Error updating parent:', error);
    res.status(500).send('Error updating parent');
  }
};

const deleteParent = async (req, res) => {
  const { fullname } = req.body;

  if (!fullname) {
    return res.status(400).send("Missing required fields");
  }

  try {
    const db = admin.firestore();

    // Find the parent document by fullname
    const parentRef = db.collection('parents').where('fullname', '==', fullname);
    const parentSnapshot = await parentRef.get();

    if (parentSnapshot.empty) {
      return res.status(404).send('Parent not found');
    }

    let parentDocId;
    parentSnapshot.forEach(doc => {
      parentDocId = doc.id;
    });

    // Delete parent from 'parents' collection
    const parentDocRef = db.collection('parents').doc(parentDocId);
    await parentDocRef.delete();

    res.status(200).send('Parent deleted successfully');
  } catch (error) {
    console.error('Error deleting parent:', error);
    res.status(500).send('Error deleting parent');
  }
};


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

//____________________________________________Teacher Calls___________________________

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


const deleteTeacher = async (req, res) => {
  const { fullname } = req.body;

  if (!fullname) {
    return res.status(400).send("Missing required fields");
  }

  try {
    const db = admin.firestore();

    // Find the teacher document by fullname
    const teacherRef = db.collection('teachers').where('fullname', '==', fullname);
    const teacherSnapshot = await teacherRef.get();

    if (teacherSnapshot.empty) {
      return res.status(404).send('Teacher not found');
    }

    let teacherDocId;
    teacherSnapshot.forEach(doc => {
      teacherDocId = doc.id;
    });


    const teacherData = teacherSnapshot.docs[0].data();
    const classesSubject = teacherData.classesSubject;

    // Remove all assignments and their submissions related to the teacher
    for (const cls of classesSubject) {
      const assignmentsRef = db.collection('assignments')
        .where('classname', '==', cls.classname)
        .where('subjectname', '==', cls.subjectname)
        .where('teacherId', '==', teacherDocId);
      const assignmentsSnapshot = await assignmentsRef.get();

      assignmentsSnapshot.forEach(async (doc) => {
        const assignmentId = doc.id;

        // Remove all submissions related to the assignment
        const submissionsRef = db.collection('submissions').where('assignmentID', '==', assignmentId);
        const submissionSnapshot = await submissionsRef.get();
        submissionSnapshot.forEach(async (submissionDoc) => {
          await db.collection('submissions').doc(submissionDoc.id).delete();
        });

        // Delete the assignment
        await db.collection('assignments').doc(assignmentId).delete();
      });
    }
    // Remove teacher from the subjects
    for (const cls of classesSubject) {
      const subjectRef = db.collection('subjects').where('subClassName', '==', cls.classname).where('subjectname', '==', cls.subjectname).where('teacherId', '==', teacherDocId);
      const subjectSnapshot = await subjectRef.get();
      subjectSnapshot.forEach(async (doc) => {
        const subjectDocRef = db.collection('subjects').doc(doc.id);
        await subjectDocRef.update({
          teacherId: admin.firestore.FieldValue.delete()
        });
      });
    }
    const subClassSnapshot = await db.collection('subClasses').get();
    subClassSnapshot.forEach(async (doc) => {
      const subClassDocRef = db.collection('subClasses').doc(doc.id);
      const subClassData = doc.data();

      // Update the teacherId to be an empty string
      const updatedSubjects = subClassData.subjects.map((subject) => {
        if (subject.teacherId === teacherDocId) {
          return {
            ...subject,
            teacherId: ''
          };
        }
        return subject;
      });

      await subClassDocRef.update({ subjects: updatedSubjects });
    });


    // Remove teacher from professionalTeachers in classes collection
    const classSnapshot = await db.collection('classes').get();
    classSnapshot.forEach(async (doc) => {
      const classDocRef = db.collection('classes').doc(doc.id);
      const classData = doc.data();

      // Filter out the professional teachers that match the teacherId
      const updatedProfessionalTeachers = classData.professionalTeachers.filter(teacher => teacher.id !== teacherDocId);

      await classDocRef.update({
        professionalTeachers: updatedProfessionalTeachers
      });
    });

    // Finally, delete the teacher document
    const teacherDocRef = db.collection('teachers').doc(teacherDocId);
    await teacherDocRef.delete();

    res.status(200).send('Teacher deleted successfully');
  } catch (error) {
    console.error("Error deleting teacher: ", error);
    res.status(500).send("Error deleting teacher");
  }
};

const updateTeacher = async (req, res) => {
  const { fullname, newUsername, newPassword, newEmail, newClassesSubject, newClassHomeroom } = req.body;

  if (!fullname) {
    return res.status(400).send("Missing required fields");
  }

  try {
    const db = admin.firestore();

    // Find the teacher document by fullname
    const teacherRef = db.collection('teachers').where('fullname', '==', fullname);
    const teacherSnapshot = await teacherRef.get();

    if (teacherSnapshot.empty) {
      return res.status(404).send('Teacher not found');
    }

    let teacherDocId;
    teacherSnapshot.forEach(doc => {
      teacherDocId = doc.id;
    });

    const teacherDocRef = db.collection('teachers').doc(teacherDocId);
    const teacherData = teacherSnapshot.docs[0].data();
    const oldClassesSubject = teacherData.classesSubject;

    // Update teacher's basic information
    const updatedTeacherData = {
      username: newUsername || teacherData.username,
      password: newPassword || teacherData.password,
      email: newEmail || teacherData.email,
      classesSubject: newClassesSubject || [],
      classHomeroom: newClassHomeroom || teacherData.classHomeroom,
    };

    // If the teacher is changing homeroom class
    if (newClassHomeroom && newClassHomeroom !== teacherData.classHomeroom) {
      // Remove old homeroom assignment
      if (teacherData.classHomeroom) {
        const oldClassRef = db.collection('classes').where('classLetter', '==', teacherData.classHomeroom.charAt(0));
        const oldClassSnapshot = await oldClassRef.get();

        oldClassSnapshot.forEach(async (doc) => {
          const oldClassDocRef = db.collection('classes').doc(doc.id);
          await oldClassDocRef.update({
            HomeRoomTeachers: admin.firestore.FieldValue.arrayRemove({ teacherid: teacherDocId, name: fullname, subClass: teacherData.classHomeroom })
          });
        });
      }

      // Assign new homeroom class
      const newClassRef = db.collection('classes').where('classLetter', '==', newClassHomeroom.charAt(0));
      const newClassSnapshot = await newClassRef.get();

      newClassSnapshot.forEach(async (doc) => {
        const newClassDocRef = db.collection('classes').doc(doc.id);
        await newClassDocRef.update({
          HomeRoomTeachers: admin.firestore.FieldValue.arrayUnion({ teacherid: teacherDocId, name: fullname, subClass: newClassHomeroom })
        });
      });
    }

    // If the teacher is changing professional subjects
    if (newClassesSubject && newClassesSubject.length > 0) {
      for (const cls of oldClassesSubject) {
        // Remove old assignments and submissions
        const assignmentsRef = db.collection('assignments')
          .where('classname', '==', cls.classname)
          .where('subjectname', '==', cls.subjectname)
          .where('teacherId', '==', teacherDocId);
        const assignmentsSnapshot = await assignmentsRef.get();

        assignmentsSnapshot.forEach(async (doc) => {
          const assignmentId = doc.id;

          // Remove all submissions related to the assignment
          const submissionsRef = db.collection('submissions').where('assignmentID', '==', assignmentId);
          const submissionSnapshot = await submissionsRef.get();
          submissionSnapshot.forEach(async (submissionDoc) => {
            await db.collection('submissions').doc(submissionDoc.id).delete();
          });

          // Delete the assignment
          await db.collection('assignments').doc(assignmentId).delete();
        });
      }

      // Remove old subjects from subClasses
      const subClassSnapshot = await db.collection('subClasses').get();
      subClassSnapshot.forEach(async (doc) => {
        const subClassDocRef = db.collection('subClasses').doc(doc.id);
        const subClassData = doc.data();

        // Update the teacherId to be an empty string for old subjects
        const updatedSubjects = subClassData.subjects.map((subject) => {
          if (subject.teacherId === teacherDocId) {
            return {
              ...subject,
              teacherId: ''
            };
          }
          return subject;
        });

        await subClassDocRef.update({ subjects: updatedSubjects });
      });
      const classSnapshot = await db.collection('classes').get();
      classSnapshot.forEach(async (doc) => {
        const classDocRef = db.collection('classes').doc(doc.id);
        const classData = doc.data();
      
        // Filter out the professional teachers that match the teacherId
        const updatedProfessionalTeachers = classData.professionalTeachers.filter((teacher) => teacher.id !== teacherDocId);
      
        await classDocRef.update({
          professionalTeachers: updatedProfessionalTeachers
        });
      });

      // Assign new subjects to subClasses and classes
      for (const cls of newClassesSubject) {
        const subjectRef = db.collection('subjects').doc();
        await subjectRef.set({
          subjectname: cls.subjectname,
          teacherId: teacherDocId,
          subClassName: cls.classname
        });

        const subClassQuery = db.collection('subClasses').where('classNumber', '==', cls.classname);
        const subClassSnapshot = await subClassQuery.get();

        let subClassDocRef;
        if (subClassSnapshot.empty) {
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

        await subClassDocRef.update({
          subjects: admin.firestore.FieldValue.arrayUnion({
            subjectname: cls.subjectname,
            subjectId: subjectRef.id,
            teacherId: teacherDocId
          })
        });

        const classQuery = db.collection('classes').where('classLetter', '==', cls.classname.charAt(0));
        const classSnapshot = await classQuery.get();

        classSnapshot.forEach(async (doc) => {
          await doc.ref.update({
            professionalTeachers: admin.firestore.FieldValue.arrayUnion({
              id: teacherDocId,
              name: fullname,
              subject: cls.subjectname,
              subClass: cls.classname
            }),
            subClasses: admin.firestore.FieldValue.arrayUnion(subClassDocRef.id)
          });
        });
      }
    }

    // Update the teacher document with the updated information
    await teacherDocRef.update(updatedTeacherData);

    res.status(200).send('Teacher updated successfully');

  } catch (error) {
    console.error("Error updating teacher: ", error);
    res.status(500).send("Error updating teacher");
  }
};

//____________________________________________Student Calls___________________________

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

    // Update the subject documents to include the new student
    const subjectsRef = db.collection('subjects');
    const subjectSnapshot = await subjectsRef
      .where('subClassName', '==', subClassName)
      .get();

    if (!subjectSnapshot.empty) {
      subjectSnapshot.forEach(async (doc) => {
        const subjectRef = db.collection('subjects').doc(doc.id);
        await subjectRef.update({
          students: admin.firestore.FieldValue.arrayUnion({ fullname: fullname, finalGrade: '' })
        });
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

const deleteStudent = async (req, res) => {
  const { fullname, classname, subClassName } = req.body;

  if (!fullname || !classname || !subClassName) {
    return res.status(400).send("Missing required fields");
  }

  try {
    const db = admin.firestore();

    // Find the student document by fullname
    const studentRef = db.collection('students').where('fullname', '==', fullname);
    const studentSnapshot = await studentRef.get();

    if (studentSnapshot.empty) {
      return res.status(404).send('Student not found');
    }

    let studentDocId;
    studentSnapshot.forEach(doc => {
      studentDocId = doc.id;
    });

    // Delete student from 'students' collection
    const studentDocRef = db.collection('students').doc(studentDocId);
    await studentDocRef.delete();

    // Remove student from the class document
    const classRef = db.collection('classes').where('classLetter', '==', classname);
    const classSnapshot = await classRef.get();
    classSnapshot.forEach(async (doc) => {
      const classDocRef = db.collection('classes').doc(doc.id);
      await classDocRef.update({
        students: admin.firestore.FieldValue.arrayRemove({ id: studentDocId, fullname })
      });
    });

    // Remove student from the subclass document
    const subClassRef = db.collection('subClasses').where('classNumber', '==', subClassName);
    const subClassSnapshot = await subClassRef.get();
    subClassSnapshot.forEach(async (doc) => {
      const subClassDocRef = db.collection('subClasses').doc(doc.id);
      await subClassDocRef.update({
        students: admin.firestore.FieldValue.arrayRemove({ id: studentDocId, fullname })
      });
    });

    // Remove student from the subjects
    const subjectRef = db.collection('subjects').where('subClassName', '==', subClassName);
    const subjectSnapshot = await subjectRef.get();
    subjectSnapshot.forEach(async (doc) => {
      const subjectDocRef = db.collection('subjects').doc(doc.id);
      await subjectDocRef.update({
        students: admin.firestore.FieldValue.arrayRemove({ fullname, finalGrade: '' })
      });
    });

    // Delete all submissions
    const submissionsRef = db.collection('submissions');
    const submissionSnapshot = await submissionsRef.where('studentsubmission.fullname', '==', fullname).get();
    submissionSnapshot.forEach(async (doc) => {
      const submissionRef = db.collection('submissions').doc(doc.id);
      await submissionRef.update({
        studentsubmission: admin.firestore.FieldValue.arrayRemove({ fullname })
      });
    });

    res.status(200).send('Student deleted successfully');
  } catch (error) {
    console.error("Error deleting student: ", error);
    res.status(500).send("Error deleting student");
  }
};

const updateStudent = async (req, res) => {
  const { fullname, newUsername, newPassword, newClassname, newSubClassName } = req.body;

  if (!fullname || !newUsername || !newPassword) {
    return res.status(400).send("Missing required fields");
  }

  try {
    // Find the student document by fullname
    const studentRef = db.collection('students').where('fullname', '==', fullname);
    const studentSnapshot = await studentRef.get();

    if (studentSnapshot.empty) {
      return res.status(404).send('Student not found');
    }

    let studentDocId;
    studentSnapshot.forEach(doc => {
      studentDocId = doc.id;
    });

    const studentDocRef = db.collection('students').doc(studentDocId);
    const studentData = (await studentDocRef.get()).data();
    const { classname: oldClassname, subClassName: oldSubClassName } = studentData;

    // Update student document in 'students' collection
    await studentDocRef.update({
      username: newUsername,
      password: newPassword,
      classname: newClassname || oldClassname,
      subClassName: newSubClassName || oldSubClassName
    });

    // Update class and subclass documents if necessary
    if (newClassname && newClassname !== oldClassname) {
      if (!newSubClassName) {
        return res.status(400).send("Missing newSubClassName when changing class");
      }

      // Remove from old class
      const oldClassRef = db.collection('classes').where('classLetter', '==', oldClassname);
      const oldClassSnapshot = await oldClassRef.get();
      oldClassSnapshot.forEach(async (doc) => {
        const oldClassDocRef = db.collection('classes').doc(doc.id);
        await oldClassDocRef.update({
          students: admin.firestore.FieldValue.arrayRemove({ id: studentDocId, fullname })
        });
      });

      // Add to new class
      const newClassRef = db.collection('classes').where('classLetter', '==', newClassname);
      const newClassSnapshot = await newClassRef.get();
      newClassSnapshot.forEach(async (doc) => {
        const newClassDocRef = db.collection('classes').doc(doc.id);
        await newClassDocRef.update({
          students: admin.firestore.FieldValue.arrayUnion({ id: studentDocId, fullname })
        });
      });

      // Remove from old subclass
      const oldSubClassRef = db.collection('subClasses').where('classNumber', '==', oldSubClassName);
      const oldSubClassSnapshot = await oldSubClassRef.get();
      oldSubClassSnapshot.forEach(async (doc) => {
        const oldSubClassDocRef = db.collection('subClasses').doc(doc.id);
        await oldSubClassDocRef.update({
          students: admin.firestore.FieldValue.arrayRemove({ id: studentDocId, fullname })
        });
      });

      // Add to new subclass
      const newSubClassRef = db.collection('subClasses').where('classNumber', '==', newSubClassName);
      const newSubClassSnapshot = await newSubClassRef.get();
      newSubClassSnapshot.forEach(async (doc) => {
        const newSubClassDocRef = db.collection('subClasses').doc(doc.id);
        await newSubClassDocRef.update({
          students: admin.firestore.FieldValue.arrayUnion({ id: studentDocId, fullname })
        });
      });

      // Update subjects documents
      const oldSubjectRef = db.collection('subjects').where('subClassName', '==', oldSubClassName);
      const oldSubjectSnapshot = await oldSubjectRef.get();
      oldSubjectSnapshot.forEach(async (doc) => {
        const oldSubjectDocRef = db.collection('subjects').doc(doc.id);
        await oldSubjectDocRef.update({
          students: admin.firestore.FieldValue.arrayRemove({ fullname, finalGrade: '' })
        });
      });

      const newSubjectRef = db.collection('subjects').where('subClassName', '==', newSubClassName);
      const newSubjectSnapshot = await newSubjectRef.get();
      newSubjectSnapshot.forEach(async (doc) => {
        const newSubjectDocRef = db.collection('subjects').doc(doc.id);
        await newSubjectDocRef.update({
          students: admin.firestore.FieldValue.arrayUnion({ fullname, finalGrade: '' })
        });
      });
    } else if (newSubClassName && newSubClassName !== oldSubClassName) {
      // Remove from old subclass
      const oldSubClassRef = db.collection('subClasses').where('classNumber', '==', oldSubClassName);
      const oldSubClassSnapshot = await oldSubClassRef.get();
      oldSubClassSnapshot.forEach(async (doc) => {
        const oldSubClassDocRef = db.collection('subClasses').doc(doc.id);
        await oldSubClassDocRef.update({
          students: admin.firestore.FieldValue.arrayRemove({ id: studentDocId, fullname })
        });
      });

      // Add to new subclass
      const newSubClassRef = db.collection('subClasses').where('classNumber', '==', newSubClassName);
      const newSubClassSnapshot = await newSubClassRef.get();
      newSubClassSnapshot.forEach(async (doc) => {
        const newSubClassDocRef = db.collection('subClasses').doc(doc.id);
        await newSubClassDocRef.update({
          students: admin.firestore.FieldValue.arrayUnion({ id: studentDocId, fullname })
        });
      });

      // Update subjects documents
      const oldSubjectRef = db.collection('subjects').where('subClassName', '==', oldSubClassName);
      const oldSubjectSnapshot = await oldSubjectRef.get();
      oldSubjectSnapshot.forEach(async (doc) => {
        const oldSubjectDocRef = db.collection('subjects').doc(doc.id);
        await oldSubjectDocRef.update({
          students: admin.firestore.FieldValue.arrayRemove({ fullname, finalGrade: '' })
        });
      });

      const newSubjectRef = db.collection('subjects').where('subClassName', '==', newSubClassName);
      const newSubjectSnapshot = await newSubjectRef.get();
      newSubjectSnapshot.forEach(async (doc) => {
        const newSubjectDocRef = db.collection('subjects').doc(doc.id);
        await newSubjectDocRef.update({
          students: admin.firestore.FieldValue.arrayUnion({ fullname, finalGrade: '' })
        });
      });
    }


    res.status(200).send('Student updated successfully');
  } catch (error) {
    console.error("Error updating student: ", error);
    res.status(500).send("Error updating student");
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






module.exports = {
  updateTeacher,
  deleteTeacher,
  deleteStudent,
  updateStudent,
  getAssignmentsByClassAndSubject,
  getAssignmentsBySubject,
  CreateAndAddStudent,
  CreateClass, 
  CreateStudent, 
  CreateTeacher, 
  AddStudentToClass,
  addAdmin,
  GetAllStudents,
  AddParent,
  updateParent,
  deleteParent}




