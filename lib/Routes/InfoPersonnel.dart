import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:map_test/Services/user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:map_test/Services/authententication.dart';
class InfoPersonnel extends StatefulWidget {
  @override
  _infoPersonnelState createState() => _infoPersonnelState();
}

class _infoPersonnelState extends State<InfoPersonnel> {
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  late String countryValue="";
  late String? stateValue="";
  late String? cityValue="";

  final UserInfos userInformation = new UserInfos();

  bool nameExist(){
    if(userInformation.nameExist()==true){
      return true;
    }else{
      return false;
    }
  }

  Future<String> name(){
    if(nameExist()==true){
      return userInformation.getName();
    }else{
      return userInformation.getName();
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
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

          // final name = data["name"]!="" ? data['name'] : 'please insert name';
          // final bio = data['biodata']!="" ? data['bio'] : 'please insert biodata';
          // final name = data["name"]!="" ? data['name'] : 'please insert name';
          // final bio = data['biodata']!="" ? data['bio'] : 'please insert biodata';
          // final name = data["name"]!="" ? data['name'] : 'please insert name';



          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal:13,vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_back,size: 19,color: Colors.black87,),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(vertical:8.0,horizontal: 10),
                    child: Text("Modify your personel information",style: TextStyle(color:Colors.black,fontSize: 30,fontWeight: FontWeight.w500),),
                  ),
                  SizedBox(height: 25,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:  EdgeInsets.fromLTRB(10,8,10,0),
                        child: Text("Name",style: TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w400),),
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.black87,),
                              hintText: "name",
                          ),
                          controller: TextEditingController(text: "name"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:  EdgeInsets.fromLTRB(10,8,10,0),
                        child: Text("Biodata",style: TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w400),),
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.black87),
                              hintText: "bio",
                          ),
                          minLines: 1,
                          maxLines: 100,
                          controller: TextEditingController(
                              text: "bio",
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 25,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding:  EdgeInsets.fromLTRB(10,8,10,0),
                        child: Text("Place of origin",style: TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w400),),
                      ),
                      Padding(
                        padding:  EdgeInsets.symmetric(horizontal: 10),
                        child: CSCPicker(
                          layout: Layout.vertical,
                          onCountryChanged: (value) {
                            setState(() {
                              countryValue = value;
                              print(countryValue);
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
                      ),
                    ],
                  ),
                  SizedBox(height: 25,),
                  InkWell(
                    onTap: (){

                    },
                    child: GestureDetector(
                      onTap: (){
                        _askedToLead();
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding:  EdgeInsets.fromLTRB(10,8,10,0),
                            child: Text("Le sexe",style: TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.w400),),
                          ),
                          Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 12,vertical: 2),
                            child: Text("Homme",style: TextStyle(color:Colors.black,fontSize: 17,fontWeight: FontWeight.w300),),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Future<void> _askedToLead() async {
    switch (await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Sexe'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () { Navigator.pop(context, "Homme"); },
                child: const Text('Homme'),
              ),
              SimpleDialogOption(
                onPressed: () { Navigator.pop(context, "Femme"); },
                child: const Text('Femme'),
              ),
            ],
          );
        }
    )) {
      case "Homme":
      // Let's go.
      // ...
        break;
      case "Femme":
      // ...
        break;
    }
  }
}