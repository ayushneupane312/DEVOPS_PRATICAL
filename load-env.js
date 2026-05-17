require('dotenv').config();
const required = ['NODE_ENV', 'JWT_SECRET', 'DB_HOST'];
required.forEach(key => {
  if (!process.env[key]) {
    console.error(`ERROR: Missing required env variable: ${key}`);
    process.exit(1);
  }
});
console.log('Environment variables loaded successfully');
console.log('NODE_ENV:', process.env.NODE_ENV);
console.log('JWT_SECRET:', '***hidden***');
