import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:rental_prototype/AdminHome/homepage.dart';
import 'package:rental_prototype/main.dart';
import 'auth.dart';


class AdminLogin extends StatefulWidget {

  @override
  _State createState() => _State();
}
 
class _State extends State<AdminLogin> {
  final _loginFormKey = GlobalKey<FormState>();
  String _password;
  String _email;

   bool _obscureText = true;
   bool isLoading = false;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

   String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

   String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
            ? LoadingCircle()
            :
    Scaffold(
        appBar: AppBar(
          title: Text('Admin Login'),
          backgroundColor: Colors.redAccent,
          elevation: 20,
        ),
        body:  Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.redAccent,
        image: DecorationImage(
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.1), BlendMode.dstATop),
          image: AssetImage('assets/skyscraper.jpg'),
          fit: BoxFit.cover,
        ),
      ),
            child:  ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(41),
                    child: Text(
                      'Login with your credentials',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign in',
                      style: TextStyle(color: Colors.white, 
                      fontSize: 30),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _loginFormKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            onSaved: (value) => _email = value,
                             keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                               border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(35.0),
                              ),
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.mail, color: Colors.black,),
                    ),
                    validator: emailValidator,
                  ),
                   SizedBox(
                  height: 40.0,
                ),
                  TextFormField(
                    onSaved: (value) => _password = value,
                    decoration: InputDecoration(
                       border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(35.0),
                              ),
                       labelText: 'Password',
                      prefixIcon: Icon(Icons.lock, color: Colors.black,),
                       suffixIcon:  IconButton(
                onPressed: _toggle,
                icon: new Icon(_obscureText ? Icons.visibility : Icons.visibility_off, color: Colors.black,)),
                    ),
                     obscureText: _obscureText,
                     validator: pwdValidator
                  ),
                   SizedBox(
                  height: 120.0,
                ),
                  Container(
                    height:50,
                    width: 500,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child:
                  FloatingActionButton.extended(
                      backgroundColor: Colors.white,
                      label: Text('Login',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 20,
                      ),),
                    onPressed: ()  async{
                      setState(() {
                        isLoading = true;
                      });
                      final form = _loginFormKey.currentState;
                      form.save();
                      if (form.validate()) {
                          try {
                          FirebaseUser result =
                             await Provider.of<AuthService>(context).loginUser(
                                  email: _email,password: _password);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomePage(currentUser: result)));
                        Navigator.pop(context);
                        setState(() {
                          isLoading = false;
                        });
                        } on AuthException catch (error) {
                          return _buildErrorDialog(context, error.message);
                        } on Exception catch (error) {
                          return _buildErrorDialog(context, error.toString());
                        }
                      }
                      }
                    ),
                  ),
                   SizedBox(
                  height: 140.0,
                ),
                      ],)
                    )
                  )
                  
                ),
                // FlatButton(
                //   onPressed: (){
                //     //forgot password screen
                //   },
                //   textColor: Colors.white,
                //   child: Text('Forgot Password'),
                // ),
              ],
            )));
  }
    Future _buildErrorDialog(BuildContext context, _message) {
    return showDialog(
      builder: (context) {
        return AlertDialog(
          title: Text('Error Message'),
          content: Text(_message),
          actions: <Widget>[
            FlatButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                })
          ],
        );
      },
      context: context,
    );
  }
}