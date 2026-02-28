require('dotenv').config();
const { Sequelize } = require('sequelize');

let sequelize;

if (process.env.DATABASE_URL) {
  // For production and hosted environments, use the DATABASE_URL.
  sequelize = new Sequelize(process.env.DATABASE_URL, {
    dialect: 'mysql',
    protocol: 'mysql',
    dialectOptions: {
      // Aiven requires SSL, and this ensures the connection is secure.
      ssl: {
        require: true,
        // This line may be needed if you encounter SSL certificate errors.
        // It disables certificate verification, which is less secure but often necessary.
        rejectUnauthorized: false
      }
    }
  });
} else {
  // For local development, use individual environment variables.
  sequelize = new Sequelize(
    process.env.DB_NAME || 'shopeasy',
    process.env.DB_USER || 'root',
    process.env.DB_PASSWORD || '',
    {
      host: process.env.DB_HOST || 'localhost',
      dialect: 'mysql',
    }
  );
}

module.exports = sequelize;
