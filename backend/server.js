
const express = require('express');
const cors = require('cors');
const adminRoutes = require('../backend/src/routes/adminRoute.js');
const authRoutes = require('../backend/src/routes/authRoutes.js');
const studentRoutes = require('../backend/src/routes/studentRoute.js');
const teacherRoutes = require('../backend/src/routes/teacherRoute.js');
const parentRoutes = require('../backend/src/routes/parentRoute.js');

const app = express();
const port = process.env.PORT || 3000;


app.use(cors()); 
app.use(express.json());
app.use('/', adminRoutes);
app.use('/auth', authRoutes);
app.use('/', studentRoutes);
app.use('/teacher', teacherRoutes);
// app.use('/', parentRoutes);
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).send('Something broke!');
});


app.listen(port, () => {
    console.log('Running on port ${port}');
});


