import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:map_test/Constants/Constants.dart';
//import 'package:airbnb_clone/Model/Property.dart';
//import 'package:airbnb_clone/Routes/AddProperty.dart';
import 'package:map_test/Routes/InfoPersonnel2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:map_test/Routes/admin_messages.dart';
import 'package:map_test/Routes/login.dart';

void main()=>runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home : Profile(),
    )
);

class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final textStyleState = TextStyle(
      fontSize: 11.0,
      color: Colors.white
  );

  final textStyleTop = TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.bold,
      color: Colors.white
  );

  final textStyle2 = TextStyle(
      color: Colors.white

  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:FutureBuilder<DocumentSnapshot>(
        future:FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder:(BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final data = snapshot.data!.data() as Map<String, dynamic>;

        final nameFB = data["name"]!="" ? data['name'] : 'please insert name';
        final picUri = data["picUri"]!="" ? data['picUri'] : 'https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg';
        return ListView(
          children: <Widget>[
            Container(

              child: Padding(
                padding: EdgeInsets.all(25),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(picUri),
                          fit: BoxFit.cover
                        ),
                        borderRadius: BorderRadius.circular(20)
                      ),
                    ),
                    SizedBox(width: 15,),
                    Flexible(
                      child: Container(
                        child: Text(nameFB,style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.black87
                        ),),
                      ),
                    )
                ],
                ),
              ),
            ),
            ClipRRect(
              child: Container(
                margin: const EdgeInsets.only(bottom: 5.0),
                  decoration: BoxDecoration(
                  color: Colors.black12,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black87,
                      offset: Offset(0.0, 1.0), //(x,y)
                      blurRadius: 5.0,
                    ),
                  ],
                ),
                width: 50,
                height: 1,
              ),
    ),
          Padding(
            padding: EdgeInsets.all(15),
            child: Text("Account Settings".toUpperCase(),style: TextStyle(color: Colors.grey,fontSize: 15,),),
          ),
          TextButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => InfoPersonnel()),
            );
          },
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Text("Profile Details",
                      style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.w300),
                      overflow: TextOverflow.ellipsis,),
                  ),
                  Icon(
                    Icons.person_outline,
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.black12,
            ),
            width: 50,
            height: 1,
          ),
          TextButton(
            onPressed: (){
              Navigator.push(
                context, MaterialPageRoute(
                  builder: (context) =>AdminMessages()
              ),
              );
            },
            child: Padding(
            padding: EdgeInsets.all(15),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Text("Admin",
                  style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w300),
                  overflow: TextOverflow.ellipsis,),
                ),
                Icon(
                  Icons.support_agent_sharp,
                ),
              ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.black12,
            ),
            width: 50,
            height: 1,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            decoration: BoxDecoration(
              color: Colors.black12,
            ),
            width: 50,
            height: 1,
          ),
          TextButton(
            onPressed: () async{
              await FirebaseAuth.instance.signOut();// do something
              Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Login())
              );
            },
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                Expanded(
                  child: Text("Log out",
                  style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.w300),
                  overflow: TextOverflow.ellipsis,),
                ),
                Icon(
                  Icons.exit_to_app,
                ),
                ],
              ),
            ),
          ),
        ],
        );
      }
      ),
    );
  }
}