const sql = require('mssql');

// Configure the database connection
const config = {
    user: 'sa',
    password: 'Wahabkhawaja12',
    server: 'localhost',
    database: 'JashanEsehat',
    options: {
      encrypt: true, // Use encryption
      enableArithAbort: true, // Enable ArithAbort
      trustServerCertificate: true // Disable certificate validation
    }
  };
  

// Create a pool of connections
const poolPromise = new sql.ConnectionPool(config)
  .connect()
  .then(pool => {
    console.log('Connected to SQL Server');
    return pool;
  })
  .catch(err => {
    console.error('Database connection failed:', err);
    process.exit(1); // Exit the process if the connection fails
  });

module.exports = poolPromise; // Export the pool for use in other modules
