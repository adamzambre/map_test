import 'package:flutter/material.dart';
import 'package:map_test/Routes/HomePage.dart';
import 'package:map_test/Routes/homeScreen.dart';
import 'package:map_test/wrapper2.dart';
import 'package:provider/provider.dart';
import 'package:map_test/Model/user.dart';
import 'package:map_test/Map.dart';
import 'package:map_test/Routes/login.dart';
import 'package:map_test/Routes/InfoPersonnel2.dart';
import 'package:map_test/Routes/Registration.dart';


class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final userInWrapper = Provider.of<MyUser?>(context);
    print('user in wrapper is $userInWrapper');
    //return home or authentication widget

    if(userInWrapper == null){//kalau bukan null then it is the user uid(tak log out lagi)
      //return Registration();
      return Login();
    //return HomePage();
    }else{
      return Wrapper2();//Firebase automatically persists the user credentials locally, and tries to restore those when the app is restarted.
      //To sign the user out, you have to explicitly sign the user out by calling await FirebaseAuth.instance.signOut().
      return InfoPersonnel();
    };
  }
}
