// users.js

const sql = require('mssql');
const express = require('express');
const router = express.Router();
const path = require('path'); // Import the path module to work with file paths
const poolPromise = require('./connection'); // Import the database connection pool
const ejs = require('ejs'); // Import EJS

// Route to serve index.html
router.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'index.html'));
});

// Route to serve CSS files
router.get('/style.css', (req, res) => {
  res.sendFile(path.join(__dirname, 'style.css'));
});

// Route to serve images
router.get('/img/:filename', (req, res) => {
  const filename = req.params.filename;
  res.sendFile(path.join(__dirname, 'img', filename));
});
router.get('/login', (req, res) => {
  res.sendFile(path.join(__dirname, 'login.html')); // Serve the login.html file
});

router.get('/Doctorslogin', (req, res) => {
  res.sendFile(path.join(__dirname, 'DoctorLogin.html')); // Serve the login.html file
});

// Route to handle doctor login
router.post('/Doctorslogin', async (req, res) => {
  const { name, password } = req.body;
  try {
    const pool = await poolPromise;
    const result = await pool.request()
      .input('name', name)
      .input('password', password)
      .query('SELECT * FROM Doctor WHERE Name = @name AND passWord = @password');
    
    if (result.recordset.length > 0) {
      console.log('Successful');
      const doctor = result.recordset[0]; // Assuming there's only one doctor with the given name and password
      res.redirect(`/profile?name=${doctor.Name}&qualifications=${doctor.Qualifications}&docID=${doctor.Dno}`); // Redirect to /profile with doctor's name and qualifications
    } else {
      console.log('Invalid credentials');
      res.send('Invalid credentials');
    }
  } catch (err) {
    console.error('Error executing query:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Route to serve profile.html
const fs = require('fs');

router.get('/profile', async (req, res) => {
  try {
    const { name, qualifications, docID } = req.query;
    const pool = await poolPromise;
    const result = await pool.request()
      .input('docID', docID)
      .query('SELECT * FROM Patients WHERE DoctorID = @docID');

    const patients = result.recordset;
    fs.readFile('profile.html', 'utf8', (err, data) => {
      if (err) {
        console.error('Error reading file:', err);
        res.status(500).json({ error: 'Internal server error' });
        return;
      }

      // Replace placeholders with actual values and patient data
      let updatedData = data.replace('<%= Name %>', name)
                            .replace('<%= Qualifications %>', qualifications)
                            .replace('<%= DocID %>', docID);

      // Populate patient table with fetched data
      const patientTableBody = patients.map(patient => `
      <tr>
        <td>${patient.Pno}</td>
        <td>${patient.Name}</td>
        <td>${patient.Dob ? patient.Dob.toDateString() : 'N/A'}</td>
        <td>${patient.Sex}</td>
        <td>${patient.ContactInfo}</td>
        <td><button onclick="openPopup('${patient.Pno}')">Check Medical History</button></td>
      </tr>
      `).join('');

      updatedData = updatedData.replace('<!-- Add more rows as needed -->', patientTableBody);

      res.send(updatedData); // Send the updated HTML data
    });
  } catch (err) {
    console.error('Error rendering profile:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

router.get('/getMedicalHistory', async (req, res) => {
  try {
    const { patientId } = req.query;
    const pool = await poolPromise;
    const result = await pool.request()
      .input('patientId', patientId)
      .query('SELECT * FROM MedicalHistory WHERE PatientID = @patientId');

    const medicalHistory = result.recordset;
    res.json(medicalHistory);
  } catch (err) {
    console.error('Error fetching medical history:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});



router.post('/login', async (req, res) => {
  const { name, password } = req.body;
  try {
    const pool = await poolPromise;
    const result = await pool.request()
      .input('name', name)
      .input('password', password)
      .query('SELECT * FROM Admin WHERE Name = @name AND passWord = @password');
    
    if (result.recordset.length > 0) {
      console.log('Successful');
      res.redirect('/login/homepage'); // Redirect to /login/homepage on successful login
    } else {
      console.log('Invalid credentials');
      res.send('Invalid credentials');
    }
  } catch (err) {
    console.error('Error executing query:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

router.get('/login/homepage', async (req, res) => { // Changed route to /login/homepage
    try {
        const pool = await poolPromise;
        const result = await pool.request().query('SELECT * FROM Doctor');
        const doctors = result.recordset;
        
        // Render the homepage.ejs file with the doctors data and CRUD actions
        ejs.renderFile('homepage.ejs', { doctors: doctors, crudActions: true }, (err, html) => {
            if (err) {
                console.error('Error rendering EJS:', err);
                res.status(500).json({ error: 'Internal server error' });
            } else {
                res.send(html);
            }
        });
    } catch (err) {
        console.error('Error executing query:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});

router.post('/login/homepage', async (req, res) => {
  const { name, dob, sex, qualifications, salary, class: doctorClass, contactInfo } = req.body;
  try {
      const pool = await poolPromise;

      // Get the next available Dno
      const result = await pool.request().query('SELECT MAX(Dno) AS MaxDno FROM Doctor');
      const nextDno = result.recordset[0].MaxDno + 1;

      // Insert the new doctor with the next available Dno
      await pool.request()
          .input('name', name)
          .input('dob', dob)
          .input('sex', sex)
          .input('qualifications', qualifications)
          .input('salary', salary)
          .input('class', doctorClass)
          .input('contactInfo', contactInfo)
          .input('dno', nextDno) // Declare and use the @dno variable
          .query('INSERT INTO Doctor (Dno, Name, Dob, Sex, Qualifications, Salary, Class, ContactInfo) VALUES (@dno, @name, @dob, @sex, @qualifications, @salary, @class, @contactInfo)');

      console.log('Doctor added successfully');

      // Retrieve updated list of doctors from the database
      const updatedResult = await pool.request().query('SELECT * FROM Doctor');
      const doctors = updatedResult.recordset;

      // Render the homepage.ejs file with the updated list of doctors
      ejs.renderFile('homepage.ejs', { doctors: doctors, crudActions: true }, (err, html) => {
          if (err) {
              console.error('Error rendering EJS:', err);
              res.status(500).json({ error: 'Internal server error' });
          } else {
              res.send(html);
          }
      });
  } catch (err) {
      console.error('Error executing query:', err);
      res.status(500).json({ error: 'Internal server error' });
  }
});

// Delete doctor route
router.get('/login/homepage/delete/:id', async (req, res) => {
  const doctorId = req.params.id;
  try {
    const pool = await poolPromise;

    // Start a transaction
    const transaction = pool.transaction();
    await transaction.begin();

    try {
      // Set DoctorID to NULL for all patients that reference the doctor
      await transaction.request()
        .input('id', doctorId)
        .query('UPDATE Patients SET DoctorID = NULL WHERE DoctorID = @id');

      // Set DoctorID to NULL for all appointments that reference the doctor
      await transaction.request()
        .input('id', doctorId)
        .query('UPDATE Appointment SET DoctorID = NULL WHERE DoctorID = @id');

      await transaction.request()
        .input('id', doctorId)
        .query('UPDATE Prescription SET DoctorID = NULL WHERE DoctorID = @id');

      await transaction.request()
        .input('id', doctorId)
        .query('UPDATE LabTest SET DoctorID = NULL WHERE DoctorID = @id');
      
      await transaction.request()
        .input('id', doctorId)
        .query('UPDATE Billing SET DoctorID = NULL WHERE DoctorID = @id');

      await transaction.request()
        .input('id', doctorId)
        .query('UPDATE Surgery SET DoctorID = NULL WHERE DoctorID = @id');

      await transaction.request()
        .input('id', doctorId)
        .query('UPDATE MedicalHistory SET DoctorID = NULL WHERE DoctorID = @id');

      // Continue updating other tables as needed...

      // Delete the doctor
      await transaction.request()
        .input('id', doctorId)
        .query('DELETE FROM Doctor WHERE Dno = @id');

      // Commit the transaction
      await transaction.commit();

      console.log('Doctor deleted successfully and related records updated');
      res.redirect('/login/homepage');
    } catch (err) {
      // Rollback the transaction in case of an error
      await transaction.rollback();
      throw err;
    }
  } catch (err) {
    console.error('Error executing query:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});


router.get('/login/patients', async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().query('SELECT * FROM Patients');
    const patients = result.recordset;
    // Render the patients.ejs file with the patients data and CRUD actions
    ejs.renderFile('Patients.ejs', { patients: patients, crudActions: true }, (err, html) => {
      if (err) {
        console.error('Error rendering EJS:', err);
        res.status(500).json({ error: 'Internal server error' });
      } else {
        res.send(html);
      }
    });
  } catch (err) {
    console.error('Error executing query:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});


router.get('/login/medications', async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().query('SELECT * FROM Medication');
    const medications = result.recordset;
    // Render the medications.ejs file with the medications data and CRUD actions
    ejs.renderFile('Medications.ejs', { medications: medications, crudActions: true }, (err, html) => {
      if (err) {
        console.error('Error rendering EJS:', err);
        res.status(500).json({ error: 'Internal server error' });
      } else {
        res.send(html);
      }
    });
  } catch (err) {
    console.error('Error executing query:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});


router.get('/login/appointments', async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().query('SELECT * FROM Appointment');
    const appointments = result.recordset;
    // Render the Appointments.ejs file with the medications data and CRUD actions
    ejs.renderFile('Appointments.ejs', { appointments: appointments, crudActions: true }, (err, html) => {
      if (err) {
        console.error('Error rendering EJS:', err);
        res.status(500).json({ error: 'Internal server error' });
      } else {
        res.send(html);
      }
    });
  } catch (err) {
    console.error('Error executing query:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

router.get('/login/hospitals', async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().query('SELECT * FROM Hospital');
    const hospitals = result.recordset;
    // Render the Appointments.ejs file with the medications data and CRUD actions
    ejs.renderFile('Hospitals.ejs', { hospitals: hospitals, crudActions: true }, (err, html) => {
      if (err) {
        console.error('Error rendering EJS:', err);
        res.status(500).json({ error: 'Internal server error' });
      } else {
        res.send(html);
      }
    });
  } catch (err) {
    console.error('Error executing query:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Route to fetch doctor and disease names
router.get('/getDoctorAndDiseaseNames', async (req, res) => {
  try {
      const pool = await poolPromise;
      const doctorsResult = await pool.request().query('SELECT Name FROM Doctor');
      const diseasesResult = await pool.request().query('SELECT Name FROM Disease');

      const doctors = doctorsResult.recordset.map(record => record.Name);
      const diseases = diseasesResult.recordset.map(record => record.Name);

      res.json({ doctors, diseases });
  } catch (err) {
      console.error('Error fetching doctor and disease names:', err);
      res.status(500).json({ error: 'Internal server error' });
  }
});

// Server-side script to handle booking appointments
router.post('/bookAppointment', async (req, res) => {
  const { patientName, email, phone, disease, doctor, date, message } = req.body;

  function generatePatientID() {
    return 'P' + Math.floor(Math.random() * 1000000);
  }

  function generateAppointmentID() {
    return 'A' + Math.floor(Math.random() * 1000000);
  }

  try {
    const pool = await poolPromise;

    // Get doctor ID
    const doctorResult = await pool.request()
      .input('doctorName', sql.VarChar, doctor)
      .query('SELECT Dno FROM Doctor WHERE Name = @doctorName');

    if (doctorResult.recordset.length === 0) {
      throw new Error('Doctor not found');
    }
    const doctorID = doctorResult.recordset[0].Dno;

    // Generate IDs
    const patientID = generatePatientID();
    const appointmentID = generateAppointmentID();

    // Check if patient already exists
    const patientResult = await pool.request()
      .input('patientName', sql.VarChar, patientName)
      .input('contactInfo', sql.VarChar, `${email}, ${phone}`)
      .query('SELECT Pno FROM Patients WHERE Name = @patientName AND ContactInfo = @contactInfo');

    let finalPatientID;
    if (patientResult.recordset.length === 0) {
      // Insert new patient
      await pool.request()
        .input('Pno', sql.VarChar, patientID)
        .input('Name', sql.VarChar, patientName)
        .input('Dob', sql.Date, null)
        .input('Sex', sql.Char, null)
        .input('DoctorID', sql.VarChar, doctorID)
        .input('Disease', sql.VarChar, disease)
        .input('Condition', sql.VarChar, message)
        .input('ContactInfo', sql.VarChar, `${email}, ${phone}`)
        .query('INSERT INTO Patients (Pno, Name, Dob, Sex, DoctorID, Disease, Condition, ContactInfo) VALUES (@Pno, @Name, @Dob, @Sex, @DoctorID, @Disease, @Condition, @ContactInfo)');
      finalPatientID = patientID;
    } else {
      // Use existing patient ID
      finalPatientID = patientResult.recordset[0].Pno;
    }

    // Insert into Appointment table
    await pool.request()
      .input('ApptID', sql.VarChar, appointmentID)
      .input('PatientID', sql.VarChar, finalPatientID)
      .input('DoctorID', sql.VarChar, doctorID)
      .input('Date', sql.Date, date)
      .input('Time', sql.Time, '09:00:00') // Example time, replace with actual time if needed
      .query('INSERT INTO Appointment (ApptID, PatientID, DoctorID, Date, Time) VALUES (@ApptID, @PatientID, @DoctorID, @Date, @Time)');

    res.send('Appointment booked successfully');
  } catch (err) {
    console.error('Error booking appointment:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
});



module.exports = router;
