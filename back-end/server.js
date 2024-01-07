import mysql from 'mysql2';

var con = mysql.createConnection({
    host: '15.164.95.87',
    user: 'root',
    database: 'footprint',
	password: '1234abcd',
  });


con.connect(function(err){
  if (err){
    console.log('error: ', err);
  }
	else{
  console.log('Connected');
	}
})

