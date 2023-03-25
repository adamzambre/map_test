import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_test/Routes/InfoPersonnel2.dart';
import 'package:map_test/Services/user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:map_test/Services/authententication.dart';

class EditInfoPersonnel extends StatefulWidget {
  @override
  _editInfoPersonnelState createState() => _editInfoPersonnelState();
}

class _editInfoPersonnelState extends State<EditInfoPersonnel> {

  AuthService customAuth = new AuthService();
  UserInfos userInfos = new UserInfos();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String profilePicLink = "";
  late String sex="";
  late String countryValue="";
  late String? stateValue="";
  late String? cityValue="";

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future:FirebaseFirestore.instance.collection('Users').doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder:(BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
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

          final nameFB = data["name"];//!="" ? data['name'] : 'please insert name';
          final bioFB = data['biodata'];//!="" ? data['biodata'] : 'please insert biodata';
          final ageFB = data['age'];//!="" ? data['age'] : 'please insert age';
          final sexFB = data['sex'];//!="" ? data['sex'] : 'please insert sex';
          final countryFB = data["country"];//!="" ? data['country'] : 'please insert country';
          final stateFB = data['state'];//!="" ? data['state'] : 'please insert state';
          final cityFB = data["city"];//!="" ? data['city'] : 'please insert city';
          final picUri = data["picUri"];//!="" ? data['picUri'] : 'https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg';

          TextEditingController nameController = TextEditingController(text: nameFB);
          TextEditingController bioController = TextEditingController(text: bioFB);
          TextEditingController ageController = TextEditingController(text: ageFB);

          profilePicLink = picUri;

          countryValue=countryFB;
          stateValue=stateFB;
          cityValue=cityFB;

          String? sex;
          if (sexFB == "male") {
            sex = "male";
          } else if (sexFB == "female") {
            sex = "female";
          } else {
            sex = null;
          }

          return SingleChildScrollView(
                    child:Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.arrow_back,size: 50,color: Colors.black87,),
                              onPressed: (){
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                        SizedBox(height:25),
                        Container(
                          padding: EdgeInsets.symmetric(vertical:8.0,horizontal: 10),
                          child: Text("Your personel information",style: TextStyle(color:Colors.black,fontSize: 30,fontWeight: FontWeight.w500),),
                        ),
                        SizedBox(height:25),
                        uploadProfilePic(),
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
                              child: TextField(
                                  controller:nameController,
                                  decoration: InputDecoration(
                                      hintText:nameFB,
                                      hintStyle: TextStyle(color:Colors.grey),
                                  ),
                              ),
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
                                child: TextField(
                                  minLines: 1,
                                  maxLines: 100,
                                  controller:bioController,
                                  decoration: InputDecoration(
                                    hintText:bioFB,
                                    hintStyle: TextStyle(color:Colors.grey),
                                  ),
                                ),
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
                                child: TextField(
                                  controller:ageController,
                                  decoration: InputDecoration(
                                    hintText:ageFB,
                                    hintStyle: TextStyle(color:Colors.grey),
                                  ),
                                ),
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
                                child:  Column(
                                    children: <Widget>[
                                      RadioListTile(
                                        title: Text("Male"),
                                        value: "male",
                                        groupValue: sex,
                                        onChanged: (value){
                                          setState(() {
                                            sex = value.toString();
                                          });
                                        },
                                      ),

                                      RadioListTile(
                                        title: Text("Female"),
                                        value: "female",
                                        groupValue: sex,
                                        onChanged: (value){
                                          setState(() {
                                            sex = value.toString();
                                          });
                                        },
                                      ),
                                  ]
                                )
                              )
                            ]
                        ),
                        SizedBox(height:25),
                        Container(
                          alignment: Alignment.topLeft,
                          padding:  EdgeInsets.fromLTRB(10,8,10,10),
                          child: Text("Place of origin",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                        ),
                        CSCPicker(
                          countryDropdownLabel: countryFB=="" ? "country":countryFB,
                          stateDropdownLabel: stateFB=="" ? "state":stateFB,
                          cityDropdownLabel: cityFB=="" ? "city":cityFB,

                          onCountryChanged: (value) {
                            setState(() {
                              countryValue = value;
                            });
                          },
                          onStateChanged:(value) {
                            setState(() {
                              stateValue = value;
                            });
                          },
                          onCityChanged:(value) {
                            setState(() {
                              cityValue = value;
                            });
                          },
                        ),
                        SizedBox(height:25),
                        Container(
                            child:FloatingActionButton.extended(
                              label:Text("Update your profile",style:TextStyle(color:Colors.black,fontSize:14,fontWeight: FontWeight.w400)),
                              backgroundColor: Colors.teal,
                              onPressed: ()async {
                                print("button pressed");
                                bool result = await userInfos.addInfo(nameController.text,ageController.text,bioController.text,sex,countryValue,stateValue,cityValue);
                                //bool result1 = await userInfos.addCountryStateCity(countryValue,stateValue,cityValue);
                                print("result:"+result.toString());
                                //print("result1:"+result1.toString());
                                if(result==true){
                                  Navigator.pop(context);
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("make sure you fill in the correct details in each section")),
                                  );
                                }
                              },
                            )
                        ),
                        SizedBox(height:25),
                      ],
                    )
                );
        }
      )
      // body: SingleChildScrollView(
      //           child:Column(
      //             children: [
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: <Widget>[
      //                   IconButton(
      //                     icon: Icon(Icons.arrow_back,size: 50,color: Colors.black87,),
      //                     onPressed: (){
      //                       Navigator.pop(context);
      //                     },
      //                   ),
      //                 ],
      //               ),
      //               SizedBox(height:25),
      //               Container(
      //                 padding: EdgeInsets.symmetric(vertical:8.0,horizontal: 10),
      //                 child: Text("Your personel information",style: TextStyle(color:Colors.black,fontSize: 30,fontWeight: FontWeight.w500),),
      //               ),
      //               SizedBox(height:25),
      //               uploadProfilePic(),
      //               SizedBox(height:25),
      //               Column(
      //                 children:[
      //                   Container(
      //                     alignment: Alignment.topLeft,
      //                     padding:  EdgeInsets.fromLTRB(10,8,10,10),
      //                     child: Text("Name",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
      //                   ),
      //                   Container(
      //                     alignment: Alignment.topLeft,
      //                     padding:  EdgeInsets.symmetric(horizontal: 10),
      //                     child: TextField(
      //                         controller:nameController,
      //                         decoration: InputDecoration(
      //                             hintText:"Enter your name here",
      //                             hintStyle: TextStyle(color:Colors.grey),
      //                         ),
      //                     ),
      //                   )
      //                 ],
      //               ),
      //               SizedBox(height:25),
      //               Column(
      //                   children:[
      //                     Container(
      //                       alignment: Alignment.topLeft,
      //                       padding:  EdgeInsets.fromLTRB(10,8,10,10),
      //                       child: Text("Biodata",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
      //                     ),
      //                     Container(
      //                       alignment: Alignment.topLeft,
      //                       padding:  EdgeInsets.symmetric(horizontal: 10),
      //                       child: TextField(
      //                         minLines: 1,
      //                         maxLines: 100,
      //                         controller:bioController,
      //                         decoration: InputDecoration(
      //                           hintText:"Enter your name here",
      //                           hintStyle: TextStyle(color:Colors.grey),
      //                         ),
      //                       ),
      //                     )
      //                   ]
      //               ),
      //               SizedBox(height:25),
      //               Column(
      //                   children:[
      //                     Container(
      //                       alignment: Alignment.topLeft,
      //                       padding:  EdgeInsets.fromLTRB(10,8,10,10),
      //                       child: Text("Age",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
      //                     ),
      //                     Container(
      //                       alignment: Alignment.topLeft,
      //                       padding:  EdgeInsets.symmetric(horizontal: 10),
      //                       child: TextField(
      //                         controller:ageController,
      //                         decoration: InputDecoration(
      //                           hintText:"Enter your name here",
      //                           hintStyle: TextStyle(color:Colors.grey),
      //                         ),
      //                       ),
      //                     )
      //                   ]
      //               ),
      //               SizedBox(height:25),
      //               Column(
      //                   children:[
      //                     Container(
      //                       alignment: Alignment.topLeft,
      //                       padding:  EdgeInsets.fromLTRB(10,8,10,10),
      //                       child: Text("Sex",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
      //                     ),
      //                     Container(
      //                       alignment: Alignment.topLeft,
      //                       padding:  EdgeInsets.symmetric(horizontal: 10),
      //                       child:  Column(
      //                           children: <Widget>[
      //                             RadioListTile(
      //                               title: Text("Male"),
      //                               value: "male",
      //                               groupValue: sex,
      //                               onChanged: (value){
      //                                 setState(() {
      //                                   sex = value.toString();
      //                                 });
      //                               },
      //                             ),
      //
      //                             RadioListTile(
      //                               title: Text("Female"),
      //                               value: "female",
      //                               groupValue: sex,
      //                               onChanged: (value){
      //                                 setState(() {
      //                                   sex = value.toString();
      //                                 });
      //                               },
      //                             ),
      //                         ]
      //                       )
      //                     )
      //                   ]
      //               ),
      //               SizedBox(height:25),
      //               Container(
      //                 alignment: Alignment.topLeft,
      //                 padding:  EdgeInsets.fromLTRB(10,8,10,10),
      //                 child: Text("Place of origin",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
      //               ),
      //               CSCPicker(
      //                 onCountryChanged: (value) {
      //                   setState(() {
      //                     countryValue = value;
      //                   });
      //                 },
      //                 onStateChanged:(value) {
      //                   setState(() {
      //                     stateValue = value;
      //                   });
      //                 },
      //                 onCityChanged:(value) {
      //                   setState(() {
      //                     cityValue = value;
      //                   });
      //                 },
      //               ),
      //               SizedBox(height:25),
      //               Container(
      //                   child:FloatingActionButton.extended(
      //                     label:Text("Update your profile",style:TextStyle(color:Colors.black,fontSize:14,fontWeight: FontWeight.w400)),
      //                     backgroundColor: Colors.teal,
      //                     onPressed: ()async {
      //                       print("button pressed");
      //                       bool result = await userInfos.addNameAndAgeAndBiodataAndSex(nameController.text,ageController.text,bioController.text,sex);
      //                       bool result1 = await userInfos.addCountryStateCity(countryValue,stateValue,cityValue);
      //                       print("result:"+result.toString());
      //                       print("result1:"+result1.toString());
      //                       if(result==true&&result1==true){
      //                         Navigator.pop(context);
      //                       }else{
      //                         ScaffoldMessenger.of(context).showSnackBar(
      //                           SnackBar(content: Text("make sure you fill in the correct details in each section")),
      //                         );
      //                       }
      //                     },
      //                   )
      //               )
      //             ],
      //           )
      //       )
    );
  }

  void pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 512,
      maxWidth: 512,
      imageQuality: 90,
    );
    String userUid = customAuth.getUid().toString();

    Reference ref = FirebaseStorage.instance
        .ref("local/$uid").child("profilepic.jpg");

    await ref.putFile(File(image!.path));

    ref.getDownloadURL().then((value) async {
      setState(() {
        profilePicLink = value;
      });
      print(value.toString());
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('Users').doc(uid);
      FirebaseFirestore.instance.runTransaction((
          transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
        //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        documentReference.update({"picUri": value.toString()});
      });
    });
  }

  Widget uploadProfilePic()=>
      Container(
        child: InkWell(
          onTap:() async{
            pickUploadProfilePic();
            //UserInfos().createSubCollectionContacts();
            //UserInfos().createSubCollectionPlaceToGo();
          },
          child: Container(
            margin: const EdgeInsets.only(top: 80, bottom: 24),
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.white,
              child:Center(
                child: profilePicLink == "" ?
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                      child: Center(
                        child: Icon(Icons.add_a_photo, color: Colors.green, size: 80,),
                      ),
                    ),
                    SizedBox(height:2),
                    Container(
                      child: Text(
                        "Upload your main picture here",
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ) : ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: CircleAvatar(
                    radius: 100.0,
                    backgroundImage:
                    NetworkImage(profilePicLink),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}