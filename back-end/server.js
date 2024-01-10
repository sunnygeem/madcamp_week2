import mysql from 'mysql2';
import express from 'express';
import bodyParser from 'body-parser';

var con = mysql.createConnection({
    host: '13.124.111.253',
    user: 'root',
    database: 'footprint',
	password: ' ',
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

// for test
app.get('/', function(req, res){
res.send('hi');
})


// table: user
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

app.get('/getRow/user_img', function(req, res){
        var user_email = req.query.encodedEmail;
        console.log(user_email);
    var sql = 'select user_img from user where user_email = ?';
    con.query(sql, [user_email], function(err, result, fields){
      if(err){
        console.log(err);
      }
           else{
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

app.patch('/update/user_img', (req, res) => {
        const imageBuffer = Buffer.from(req.body.user_img, 'base64');
        con.query(
    `UPDATE user SET user_img=? WHERE user_email=? `,
    [imageBuffer, req.query.encodedEmail],
    (err, results, field) => {
      if (err) throw err;
            else{
                res.send('update ok');
        }
    }
  )
})


// table: position
app.post("/sendPosition", function(req,res){
        const body = req.body;
        var sql = 'INSERT INTO _position (trail_name, location1, location2, location3, location4, location5) VALUES (?, ?, ?, ?, ?, ?)';
        con.query(sql, [body.trail_name, body.location1, body.location2, body.location3, body.location4, body.location5], function(error, result, field){
            if(error){
            console.error(error);
            }
        })
      })

app.get('/getPosition', function(req, res){ // trail_name으로 pos 정보 가져오기
        var trail_name = req.query.encodedName;
	console.log(trail_name);
    var sql = 'SELECT CONCAT(location1, ", ", location2, ", ", location3, ", ", location4, ", ", location5) AS positions FROM _position WHERE trail_name = ?';
    con.query(sql, [trail_name], function(err, result, fields){
      if(err){
        console.log(err);
      }
            else{
                    console.log(result);
		    res.json(result);
            }
    })
  })

// table: trail
app.post("/sendTrail", function(req,res){
        const body = req.body;
        var sql = 'INSERT INTO trail (trail_name, user_email) VALUES (?, ?)';
        con.query(sql, [body.trail_name, body.user_email], function(error, result, field){
            if(error){
            console.error(error);
            }
        })
      })

app.get('/getTrail', function(req, res){ // trail_name으로 pos 정보 가져오기
        var trail_name = req.query.trailName;
        console.log(trail_name);
    var sql = 'select user_email from trail where trail_name = ?';
    con.query(sql, [trail_name], function(err, result, fields){
      if(err){
        console.log(err);
      }
            else{
                    console.log(result);
		    res.json(result);
            }
    })
  })

app.get('/getTrailTable', function(req, res){
    var sql = 'select * from trail';
    con.query(sql, function(err, id, fields){
      var user_id = req.params.id;
      if(id){
        var sql='select * from trail'
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

// table: review
app.post("/sendReview", function(req,res){
        const body = req.body;
        var sql = 'INSERT INTO review (trail_name, review, rev_nickname) VALUES (?, ?, ?)';
        con.query(sql, [body.trail_name, body.review, body.rev_nickname], function(error, result, field){
            if(error){
            console.error(error);
            }
        })
      })

app.get('/getReview', function(req, res){ // trail_name으로 pos 정보 가져오기
        var trail_name = req.query.trailName;
        console.log(trail_name);
    var sql = 'select (review, rev_nickname) from trail where trail_name = ?';
    con.query(sql, [trail_name], function(err, result, fields){
      if(err){
        console.log(err);
      }
            else{
                    console.log(result);
		    res.json(result);
            }
    })
  })


// check port listening
app.listen(PORT, function(){console.log('now on port 5000')})
