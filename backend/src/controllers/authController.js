const admin = require('firebase-admin');
const db = admin.firestore();



const loginUser = async (req, res) => {
    const { username, password } = req.body;
    try {
        // Check each collection for the username
        const collections = ['admin', 'students', 'teachers'];
        let userData = null;
        let userId = null; // Variable to store the user's document ID
        let userRole = null; // Variable to store the user's role

        for (const collection of collections) {
            const userRef = db.collection(collection).where('username', '==', username);
            const snapshot = await userRef.get();
            if (!snapshot.empty) {
                snapshot.forEach(doc => {
                    userData = doc.data();
                    userId = doc.id; // Store the document ID
                    userRole = collection; // Store the user's role
                });
                // If a matching user is found, break out of the loop
                break;
            }
        }

        if (!userData) {
            return res.status(404).send('User not found');
           
        }
        
        
        if (userData.password !== password) {
            return res.status(401).send('Invalid password');
        }

        // If authentication is successful, generate a custom token using the document ID
        const token = await admin.auth().createCustomToken(userId);
        res.status(200).json({ token, role: userRole });
    } catch (error) {
        console.error("Error logging in: ", error);
        res.status(500).send("Error logging in");
    }
};














































// const loginUser = async (req, res) => {
//     const { username, password } = req.body;
//     try {
//         // Check each collection for the username
//         const collections = ['admin', 'students', 'teachers'];
//         let userData = null;
//         for (const collection of collections) {
//             const userRef = db.collection(collection).where('username', '==', username);
//             const snapshot = await userRef.get();
//             if (!snapshot.empty) {
//                 snapshot.forEach(doc => {
//                     userData = doc.data();
//                 });
//                 // If a matching user is found, break out of the loop
//                 break;
//             }
//         }
//         console.log(userData);
//         if (!userData) {
//             return res.status(404).send('User not found');
//         }

//         // Here you should compare the hashed password
//         if (userData.password !== password) {
//             return res.status(401).send('Invalid password');
//         }

//         // If authentication is successful, generate a custom token or return user details
//         const token = await admin.auth().createCustomToken(userData.uid);
//         res.status(200).json({ token, role: collection  });
//     } catch (error) {
//         console.error("Error logging in: ", error);
//         res.status(500).send("Error logging in");
//     }
// };

module.exports = { loginUser };
