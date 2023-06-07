import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:map_test/Routes/EditInfoPersonnel.dart';
import 'package:map_test/Services/user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:map_test/Services/authententication.dart';

class InfoPersonnel extends StatefulWidget {
  @override
  _infoPersonnelState createState() => _infoPersonnelState();
}

class _infoPersonnelState extends State<InfoPersonnel> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot>(
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
              final bioFB = data['biodata']!="" ? data['biodata'] : 'please insert biodata';
              final ageFB = data['age']!="" ? data['age'] : 'please insert age';
              final sexFB = data['sex']!="" ? data['sex'] : 'please insert sex';
              final countryFB = data["country"]!="" ? data['country'] : 'please insert country';
              final stateFB = data['state']!="" ? data['state'] : 'please insert state';
              final cityFB = data["city"]!="" ? data['city'] : 'please insert city';
              final picUri = data["picUri"]!="" ? data['picUri'] : 'https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg';
              return SingleChildScrollView(
                child:Column(

                  children:
                  [
                    SizedBox(height:25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios_sharp,size: 50,color: Colors.black87,),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical:8.0,horizontal: 10),
                            child: Text("Your personel informations",style: TextStyle(color:Colors.black,fontSize: 30,fontWeight: FontWeight.w500),),
                          ),
                        ],
                      ),
                      SizedBox(height:25),
                      Container(
                          padding: EdgeInsets.symmetric(vertical:8.0,horizontal: 10),
                        height:MediaQuery.of(context).size.height *0.3,
                          width:MediaQuery.of(context).size.width,
                          color: Colors.teal,
                          child:CircleAvatar(
                            radius: 80,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(picUri),
                          )
                      ),
                    SizedBox(height:25),
                      Column(
                        children:[
                          Container(
                            alignment: Alignment.topLeft,
                            padding:  EdgeInsets.fromLTRB(10,8,10,10),
                            child: Text("Name",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding:  EdgeInsets.symmetric(horizontal: 10),
                            child: Text(nameFB,style:TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w400)),
                          )
                        ],
                      ),
                    SizedBox(height:25),
                    Column(
                      children:[
                        Container(
                          alignment: Alignment.topLeft,
                          padding:  EdgeInsets.fromLTRB(10,8,10,10),
                          child: Text("Biodata",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding:  EdgeInsets.symmetric(horizontal: 10),
                          child: Text(bioFB,style:TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w400)),
                        )
                      ]
                    ),
                    SizedBox(height:25),
                    Column(
                        children:[
                          Container(
                            alignment: Alignment.topLeft,
                            padding:  EdgeInsets.fromLTRB(10,8,10,10),
                            child: Text("Age",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding:  EdgeInsets.symmetric(horizontal: 10),
                            child: Text(ageFB,style:TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w400)),
                          )
                        ]
                    ),
                    SizedBox(height:25),
                    Column(
                        children:[
                          Container(
                            alignment: Alignment.topLeft,
                            padding:  EdgeInsets.fromLTRB(10,8,10,10),
                            child: Text("Sex",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding:  EdgeInsets.symmetric(horizontal: 10),
                            child: Text(sexFB,style:TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w400)),
                          )
                        ]
                    ),
                    SizedBox(height:25),
                    Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          padding:  EdgeInsets.fromLTRB(10,8,10,10),
                          child: Text("Place of origin",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding:  EdgeInsets.symmetric(horizontal: 10),
                          child: Text("Country: "+ countryFB,style:TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w400)),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding:  EdgeInsets.symmetric(horizontal: 10),
                          child: Text("State: "+stateFB,style:TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w400)),
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding:  EdgeInsets.symmetric(horizontal: 10),
                          child: Text("City: "+cityFB,style:TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w400)),
                        )
                      ],
                    ),
                    SizedBox(height:25),
                    Container(
                        padding:  EdgeInsets.fromLTRB(10,8,10,10),
                      child:FloatingActionButton.extended(
                        label:Text("Edit your profile",style:TextStyle(color:Colors.black,fontSize:14,fontWeight: FontWeight.w400)),
                        backgroundColor: Colors.teal,
                        onPressed: (){
                          print("button pressed");
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => EditInfoPersonnel()),
                          );
                        },
                      )
                    )
                  ],
                )
              );
            }
        ),
      ),
    );
  }

}