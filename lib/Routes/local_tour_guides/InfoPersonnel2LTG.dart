import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:map_test/Routes/EditInfoPersonnel.dart';
import 'package:map_test/Services/user_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:map_test/Services/authententication.dart';

class InfoPersonnelLTG extends StatefulWidget {
  @override
  _infoPersonnelLTGState createState() => _infoPersonnelLTGState();
}

class _infoPersonnelLTGState extends State<InfoPersonnelLTG> {

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
                    /*Row(
                        children:[
                          Container(
                            alignment: Alignment.topLeft,
                            padding:  EdgeInsets.fromLTRB(10,8,10,10),
                            child: Text("Rating:",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                          ),
                          Container(
                            child:FutureBuilder<Map<String,dynamic>>(
                                future:UserInfos().getRatingAverage(FirebaseAuth.instance.currentUser!.uid),
                                builder:(context, snapshot){
                                  final averageRating = snapshot.data?['averageRating'];
                                  final totalDocuments = snapshot.data?['totalDocuments'];
                                  if(averageRating.isNaN){
                                    return Text("0.0 ("+totalDocuments.toString()+")",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),);
                                  }else{
                                    return Text(averageRating.toString()+" ("+totalDocuments.toString()+")",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),);
                                  }
                                }
                            ),
                          ),
                        ]
                    ),*/
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
                    ),
                    SizedBox(height:10),
                    Container(
                      child:FutureBuilder<Map<String,dynamic>>(
                          future:UserInfos().getRatingAverage(FirebaseAuth.instance.currentUser!.uid),
                          builder:(context, snapshot){
                            final averageRating = snapshot.data?['averageRating'];
                            final totalDocuments = snapshot.data?['totalDocuments'];
                            if(averageRating ==0.0){
                              return Text("Rating: 0.0 ("+totalDocuments.toString()+")",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),);
                            }else{
                              return Text("Rating:"+averageRating.toString()+" ("+totalDocuments.toString()+")",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),);
                            }
                          }
                      ),
                    ),
                    SingleChildScrollView(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).collection("UserReviews").snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                            if (snapshot.data!.size == 0) { //kalau data takde
                              return Container(
                                alignment: Alignment.center,
                                padding:  EdgeInsets.all(10),
                                child: Text("No comments have been left for you yet",style:TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.normal, fontStyle: FontStyle.normal)),
                              );
                            }
                            return ListView(
                              shrinkWrap: true,//kalau buang ni listtile tak keluar
                              children: snapshot.data!.docs.map((document){
                                return ListTile(
                                  tileColor: Colors.white,
                                  leading:Container(
                                    child: CircleAvatar(
                                      radius:50,
                                      backgroundImage: NetworkImage(document.get("picUri")),
                                    ),
                                  ),
                                  title: Column(
                                    children: [
                                      Text(document.get("name")),
                                      Container(
                                        child: RatingBar.builder(
                                          initialRating: document.get("rating"),
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                            setState(() {});
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                  subtitle: Text(
                                      '${document.get("comment")}'
                                          '\n\n${document.get("date")}'
                                  ),
                                  isThreeLine: true,
                                );
                              }
                              ).toList(),
                            );
                          }
                      ),
                    ),
                  ],
                )
            );
          }
      ),
    );
  }

}