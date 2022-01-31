import "package:flutter/material.dart";
import 'package:iotcontrol/authenticate/authenticate.dart';
import 'package:iotcontrol/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:iotcontrol/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Users>(context);

    //return home or auth widget

    if (user == null) {
      return Authenticate();
    } else {
      return Home();
    }
  }
}
