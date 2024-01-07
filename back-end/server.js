import mysql from 'mysql2';
import express from 'express';

var con = mysql.createConnection({
    host: '15.164.95.87',
    user: 'root',
    database: 'footprint',
	password: '',
  });


con.connect(function(err){
  if (err){
    console.log('error: ', err);
  }
	else{
  console.log('Connected');
	}
})

const app = express();

app.get('/get', function(req, res){
    var sql = 'select * from user';
    con.query(sql, function(err, id, fields){
      var user_id = req.params.id;
      if(id){
        var sql='select * from user'
        con.query(sql, function(err, result, fields){
          if(err){
            console.log(err);
          }else{
            res.json(id);
            console.log('user:', fields);
          }
        })
      }
    })
  })

app.post("/sendUserInfo", function(req,res){
        const body = req.body;
        var sql = 'INSERT INTO user (user_email, user_name) VALUES (?, ?)';
        con.query(sql, [body.user_email, body.user_name], function(error, result, field){
            if(error){
            console.error(error);
            }
        })
      })
