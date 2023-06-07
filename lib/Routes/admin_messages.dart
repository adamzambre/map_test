import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_test/Routes/chat.dart';
import 'package:map_test/Services/user_info.dart';

void main()=>runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home : AdminMessages(),
    )
);

class AdminMessages extends StatefulWidget {

  @override
  _AdminMessagesState createState() => _AdminMessagesState();
}

class _AdminMessagesState extends State<AdminMessages> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: /*Padding(
          padding: EdgeInsets.symmetric(horizontal: 25,vertical: 30),
          child: */Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  flex:1,
                  child: Container(
                    child: IconButton(
                      icon: Icon(Icons.arrow_back,size: 30,color: Colors.black87,),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Expanded(
                  flex:9,
                  child: Container(
                      alignment: Alignment.center,
                      child: Text("Admins",
                        style:TextStyle(
                            fontSize:20,
                            fontWeight: FontWeight.w700),
                      )
                  ),
                ),
              ],
            ),
            Expanded(
                flex:10,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("Users").where('userType', isEqualTo:'admin').snapshots(),
                    builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                      print(FirebaseAuth.instance.currentUser!.uid);
                      print(snapshot.data?.docs.toString());

                      if(snapshot.hasError){
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }

                      if(snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return Container(
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: snapshot.data!.docs.map((document){
                            print("replyer document:"+document.toString());
                            return Container(
                                child: FutureBuilder<QuerySnapshot>(
                                    future:FirebaseFirestore.instance.collection('Users').where('uid', isEqualTo: document.id).get(),
                                    builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
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

                                      QueryDocumentSnapshot document = snapshot.data!.docs.first;
                                      var data = document.data() as Map<String, dynamic>;//BENDA NI YG BAGI ERROR "data!.data()"
                                      String userTypeFB = data["userType"];
                                      String nameFB = data["name"]!="" ? data['name'] : 'please insert name';
                                      String picUri = data["picUri"]!="" ? data['picUri'] : 'https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg';
                                      return Container(
                                          padding: EdgeInsets.all(8),
                                          child:InkWell(
                                            child: Material(
                                              elevation: 3,
                                              child: Container(
                                                margin: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      margin: EdgeInsets.only(right: 10),
                                                      height: 60,
                                                      width: 60,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.rectangle,
                                                          image:DecorationImage(
                                                            image:NetworkImage(picUri),
                                                          )
                                                      ),
                                                    ),
                                                    Container(
                                                        child: Text(nameFB,style: TextStyle(fontSize:12),maxLines: 2,overflow: TextOverflow.ellipsis,)
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ),
                                            onTap: (){
                                              Navigator.push(
                                                context, MaterialPageRoute(
                                                  builder: (context) => Chat(document:document)
                                              ),
                                              );
                                            },
                                          )
                                      );
                                    }
                                )
                            );
                          }).toList(),
                        ),
                      );
                    }
                )
            ),
          ],
        ),
        //),
      ),
    );
  }
}