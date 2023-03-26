import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:map_test/Routes/HomePage.dart';
import 'package:map_test/Routes/homeScreen.dart';
import 'package:map_test/Routes/local_tour_guides/HomePageLTG.dart';
import 'package:provider/provider.dart';
import 'package:map_test/Model/user.dart';
import 'package:map_test/Map.dart';
import 'package:map_test/Routes/login.dart';
import 'package:map_test/Routes/InfoPersonnel2.dart';
import 'package:map_test/Routes/Registration.dart';


// class Wrapper2 extends StatelessWidget {
//
//   String userType = "";
//   @override
//   Widget build(BuildContext context) {
//     // return FutureBuilder(
//     //   future: getUserType(),
//     //   builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//     //     if (snapshot.hasData) {
//     //       if (snapshot.data == "local tour guide") {
//     //         return HomePageLTG();
//     //       } else if (snapshot.data == "tourist") {
//     //         return HomePage();
//     //       }
//     //     }
//     //     return Login();
//     //   }
//     // );
//
//     if(getUserType().toString() == "local tour guide"){
//       return HomePageLTG();
//     }else if(getUserType().toString() == "tourist"){
//       return HomePage();
//     }else{
//       return Login();
//     }
//   }
//
//   Future<String> getUserType() async{
//     try {
//       String uid = FirebaseAuth.instance.currentUser!.uid;
//       final docRef = await FirebaseFirestore.instance.collection('Users')
//           .doc(uid);
//       final DocumentSnapshot docSnapshot = await docRef.get();
//       String userType = await docSnapshot.get("userType");
//       print("current user is: "+userType);
//       setState((){
//
//       })
//       return userType;
//     } catch (e) {
//       print(e.toString());
//       return "Error obtaining user Type.";
//     }
//   }
// }

class Wrapper2 extends StatefulWidget {
  const Wrapper2({Key? key}) : super(key: key);

  @override
  State<Wrapper2> createState() => _Wrapper2State();
}

class _Wrapper2State extends State<Wrapper2> {

  String user="";
  @override
  Widget build(BuildContext context) {
    getUserType();
    if(user == "local tour guide"){
      return HomePageLTG();
    }else if(user == "tourist"){
      return HomePage();
    }else{
      return Login();
    }
  }

  Future<void> getUserType() async{
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      final docRef = await FirebaseFirestore.instance.collection('Users')
          .doc(uid);
      final DocumentSnapshot docSnapshot = await docRef.get();
      String userType = await docSnapshot.get("userType");
      setState((){
        user = userType;
      });
      // return userType;
    } catch (e) {
      print(e.toString());
      // return "Error obtaining user Type.";
    }
  }
}

