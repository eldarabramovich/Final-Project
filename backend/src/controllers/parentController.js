const admin = require('firebase-admin');
const db = admin.firestore();

const getParentData = async (req, res) => {
    const parentId = req.params.parentId;
  
    try {
      const parentRef = db.collection('parents').doc(parentId);
      const doc = await parentRef.get();
  
      if (!doc.exists) {
        return res.status(404).send('Parent not found');
      }
  
      const parentData = doc.data();
  
      // Fetch the children details
      const childrenPromises = parentData.children.map(async (child) => {
        const childRef = db.collection('students').doc(child.id);
        const childDoc = await childRef.get();
        if (childDoc.exists) {
          return {
            id: childDoc.id,
            fullname: childDoc.data().fullname,
          };
        }
        return null;
      });
  
      const childrenDetails = await Promise.all(childrenPromises);
  
      // Filter out any null values in case some children do not exist
      const validChildrenDetails = childrenDetails.filter(child => child !== null);
  
      res.status(200).json({
        ...parentData,
        children: validChildrenDetails,
      });
    } catch (error) {
      console.error('Error fetching parent data:', error);
      res.status(500).send('Internal Server Error');
    }
  };
  
  module.exports = {
    getParentData,
  };
//get parent data by id 