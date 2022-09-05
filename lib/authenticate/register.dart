import 'package:flutter/material.dart';
import 'package:iotcontrol/screens/loading.dart';
import 'package:iotcontrol/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

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
              title: Text('Sign Up',
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
                    icon: Icon(Icons.person, color: Colors.amber),
                    label: Text('Sign In',
                        style: TextStyle(
                            fontFamily: 'customFonts',
                            fontSize: 20,
                            color: Colors.amber)))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(22, 70, 22, 0),
              child: SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints.expand(
                      width: double.infinity, height: 315),
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
                              val.isEmpty ? 'enter an email' : null,
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
                          validator: (val) => val.length < 6
                              ? 'enter a password with 6 characters'
                              : null,
                          obscureText: true,
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
                          child: Text('Register',
                              style: TextStyle(
                                  fontFamily: 'customFonts2',
                                  fontSize: 23,
                                  color: Colors.white)),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result = await _auth.registerWithEmail(
                                  email, password);
                              if (result == null) {
                                setState(() {
                                  error = "Enter Valid Email";
                                  loading = false;
                                });
                              }
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
