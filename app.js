const express = require('express');
const session = require('express-session');
const app = express();

const passport = require('passport');

if (process.env.NODE_ENV !== 'production') {
  require('dotenv').config();
}

//Bodyparser
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

//Session__________________________________________________________________________________________________
app.use(
  session({
    secret: process.env.SESSION_SECRET,
    resave: false,
    saveUninitialized: false,
  })
);
//Session__________________________________________________________________________________________________

app.use(passport.initialize());
app.use(passport.session());

const supabase = require('./supabase')
app.get('/', async (req, res, next)=>{
let { data, error } = await supabase
  .from('recipes')
  .select('*')
console.log(data)
res.send(data)
})

// app.use('/', require('./routes/index'));
// app.use('/users', require('./routes/users'));
// app.use('/products', require('./routes/products'));
// app.use('/carts', require('./routes/carts'));
// app.use('/checkout', require('./routes/checkout'));
// app.use('/orders', require('./routes/orders'));

const PORT = process.env.PORT || 3000;
app.listen(PORT, console.log(`Server started on port ${PORT}`));
