import 'package:iotcontrol/screens/loading.dart';
import 'package:flutter/material.dart';
import 'package:iotcontrol/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //state
  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.grey[800],
            appBar: AppBar(
              elevation: 0,
              title: Text('Sign In',
                  style: TextStyle(
                    fontFamily: 'customFonts2',
                    fontSize: 30,
                    letterSpacing: 0.6,
                  )),
              backgroundColor: Colors.grey[900],
              actions: <Widget>[
                TextButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    icon: Icon(Icons.person_add, color: Colors.amber),
                    label: Text('Register',
                        style: TextStyle(
                            fontFamily: 'customFonts',
                            fontSize: 20,
                            color: Colors.amber)))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(22, 70, 22, 0),
              child: Container(
                height: 315,
                width: 400,
                decoration: BoxDecoration(
                    color: Colors.grey[350],
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (val) =>
                            val.isEmpty ? 'Enter an Email' : null,
                        decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10),
                              borderSide: new BorderSide()),
                          fillColor: Colors.white,
                          labelText: 'Email',
                        ),
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val) =>
                            val.length < 6 ? 'Enter valid Password' : null,
                        decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(10),
                              borderSide: new BorderSide()),
                          fillColor: Colors.white,
                          labelText: 'Password',
                        ),
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          child: Text('Sign In',
                              style: TextStyle(
                                  fontFamily: 'customFonts2',
                                  fontSize: 23,
                                  color: Colors.white)),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result =
                                  await _auth.signInWithEmail(email, password);
                              if (result == null) {
                                setState(() {
                                  error = "Could Not Sign In";
                                  loading = false;
                                });
                              }
                            }
                          })
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
