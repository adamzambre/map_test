import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatefulWidget {

  late QueryDocumentSnapshot document;
  ProfileView({Key? key,required this.document}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
          future:FirebaseFirestore.instance.collection('Users').doc(widget.document.id).get(),
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
            final nameFB = widget.document.get('name');
            final bioFB = widget.document.get('biodata');
            final ageFB = widget.document.get('age');
            final sexFB = widget.document.get('sex');
            final countryFB = widget.document.get('country');
            final stateFB = widget.document.get('state');
            final cityFB = widget.document.get('city');
            final picUri = widget.document.get('picUri');

            return SingleChildScrollView(
                child:Column(

                  children:
                  [
                    SizedBox(height:25),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
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
                          flex:8,
                          child: Container(
                            //alignment: AlignmentDirectional.center,
                           //EdgeInsets.symmetric(vertical:8.0,horizontal: 10),
                            margin:EdgeInsets.all(10),
                            child: Text("User profile",style: TextStyle(color:Colors.black,fontSize: 30,fontWeight: FontWeight.w500,),textAlign: TextAlign.center,),
                          ),
                        ),
                        Expanded(flex: 1, child: Container()),
                      ],
                    ),

                    SizedBox(height:20),
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
                  ],
                )
            );
          }
      ),
    );;
  }
}
