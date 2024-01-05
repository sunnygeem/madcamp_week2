const express = require('express');
const path = require('path');
const mysql = require('mysql2');
const bodyParser = require('body-parser');

const app = express();

app.use(express.json());
var cors = require('cors');

app.use(cors());

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({extended:true}));

app.listen(8000, function () {
  console.log('listening on 8000')
});

const pool = mysql.createPool({
    host: 3309,
    user: 'root',
    password: '0220',
    database: 'week2',
    debug: false,
});

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
//
app.get('/get', function(req, res){
    var sql = 'select * from table1';
    con.query(sql, function(err, id, fields){
      var user_id = req.params.id;
      if(id){
        var sql='select * from table1'
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

app.post("/send", function(req,res){
//      var id = req.body.id;
//      var name = req.body.name;
//
//        const query = 'INSERT INTO table1 (id, name) VALUES (?, ?)';
//        connection.query(query, [id, name], function(error, result, field) {
//        if (error) {
//          console.error('Error inserting data: ', error);
//          res.status(500).send('Internal Server Error');
//        } else {
//          console.log('Data inserted successfully');
//          res.status(200).send('Data inserted successfully');
//        }
//    })

    const body = req.body;
    var sql = 'INSERT INTO table1 (id, name) VALUES (?, ?)';
    con.query(sql, [body.id, body.name], function(error, result, field){})
  })