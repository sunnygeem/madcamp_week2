const express = require('express');
const path = require('path');
const mysql = require('mysql2');
const bodyParser = require('body-parser');



var con = mysql.createConnection({
    host: '127.0.0.1',
    user: 'root',
    password: '0220',
    port: 3309,
    database: 'week2'

  });



con.connect(function(err){
  if (err) throw err;
  console.log('Connected');
})


 const app = express();
 app.use(express.json());

 app.use(bodyParser.json());
 app.use(bodyParser.urlencoded({extended:true}));

// app.use("/",function(req,res,next) {
// 	res.writeHead("200", {"Content-Type":"text/html;charset=utf-8"});
// 	res.end("<h1>Express 서버에서 " + req.user + " 응답한 결과입니다</h1>");
// 	// res.write로 길게 안쓰고 res.end에 간결하게 보내줌
// });

 app.listen(8000, function () {
   console.log('listening on 8000')
 });

//
app.get('/get', function(req, res){
    var sql = 'select * from account';
    con.query(sql, function(err, id, fields){
      var user_id = req.params.id;
      if(id){
        var sql='select * from account'
        con.query(sql, function(err, result, fields){
          if(err){
            console.log(err);
          }else{
            res.json(id);
            console.log('user:', user_id);
            console.log('user:', fields);
          }
        })
      }
    })
  })

app.post("/sendAcc", function(req,res){
        const body = req.body;
        var sql = 'INSERT INTO account (account_email, account_name) VALUES (?, ?)';
        con.query(sql, [body.account_email, body.account_name], function(error, result, field){
            if(error){
            console.error(error);
            }
        })
      })

app.post("/send", function(req,res){
    const body = req.body;
    var sql = 'INSERT INTO table1 (id, name) VALUES (?, ?)';
    con.query(sql, [body.id, body.name], function(error, result, field){})
  })

