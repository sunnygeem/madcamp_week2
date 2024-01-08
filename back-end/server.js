import mysql from 'mysql2';
import express from 'express';
import bodyParser from 'body-parser';

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

app.use(bodyParser.json());
 app.use(bodyParser.urlencoded({extended:true}));

const PORT = process.env.PORT || 5000;

app.get('/', function(req, res){
res.send('hi');
})

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

app.get('/getRow/user_email', function(req, res){
	var user_email = req.query.encodedEmail;
	console.log(user_email);
    var sql = 'select user_nickname from user where user_email = ?';
    con.query(sql, [user_email], function(err, result, fields){
      if(err){
	console.log(err);
      }
	    else{
		    console.log(result);
		if(result.length>0){
			res.json(result[0]);
		}else{
			res.json(null);
		}
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

app.patch('/update/user_nickname', (req, res) => {
	console.log(req.body.user_nickname);
	con.query(
    `UPDATE user SET user_nickname=? WHERE user_email=? `,
    [req.body.user_nickname, req.query.encodedEmail],
    (err, results, field) => {
      if (err) throw err;
	    else{
      		console.log('results: ', results);
      		res.send('update ok');
    	}
    }
  )
})

app.listen(PORT, function(){console.log('now on port 5000')})
