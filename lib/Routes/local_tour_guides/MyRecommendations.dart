import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_test/Routes/chat.dart';
import 'package:map_test/Routes/local_tour_guides/TripCreator.dart';
import 'package:map_test/Services/user_info.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:readmore/readmore.dart';
import 'EditTrip.dart';

void main()=>runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home : MyRecommendations(),
    )
);

class MyRecommendations extends StatefulWidget {

  @override
  _MyRecommendationsState createState() => _MyRecommendationsState();
}

class _MyRecommendationsState extends State<MyRecommendations> {
  late final Timer timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        children:[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25,vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex:1,
                child: Container(
                    alignment: Alignment.topCenter,
                    child: Text("Provide local insights to your tourists!!!",
                      style:TextStyle(
                          fontSize:20,
                          fontWeight: FontWeight.w700),
                    )
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                  flex:20,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("Users").doc(FirebaseAuth.instance.currentUser!.uid).collection("Trips").snapshots(),
                      builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                        print(snapshot.data?.docs.toString());

                        // QueryDocumentSnapshot document = snapshot.data!.docs;

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
                        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                          print(snapshot.data!.docs.toString());
                          // return the widget tree that shows the data
                          return Container(
                            child: ListView(
                              scrollDirection: Axis.vertical,
                              children: snapshot.data!.docs.map((document){
                                var data = document.data()! as Map<String, dynamic>;//BENDA NI YG BAGI ERROR "data!.data()"
                                print("DATA: "+data.toString());
                                String title = data["name"];
                                List<dynamic> picUris = data["picUri"];
                                List<String> picUrisCasted = picUris.cast<String>().toList();//The cast() method converts the List<dynamic> to a List<String> by applying a type cast to each element of the list.
                                List<dynamic> tags = data["tags"];
                                List<String> tagsCasted = tags.cast<String>().toList();
                                String about = data["description"];

                                int index = 0;
                                print("replyer document:"+document.toString());
                                return InkWell(
                                  onTap:(){
                                  Navigator.push(
                                    context, MaterialPageRoute(
                                      builder: (context) => EditTrip(document:document)
                                  ),
                                  );
                                },
                                  child: Container(
                                          margin:EdgeInsets.all(10),
                                          width:MediaQuery.of(context).size.width,
                                          height:MediaQuery.of(context).size.height *0.3,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child:Column(
                                            children: [
                                              Expanded(
                                                  flex:5,
                                                  child: Stack(
                                                      children:[
                                                        Container(
                                                          width:MediaQuery.of(context).size.width,
                                                          height:MediaQuery.of(context).size.height *0.3,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(20.0),
                                                              topRight: Radius.circular(20.0),
                                                            ),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(20.0),
                                                              topRight: Radius.circular(20.0),
                                                            ),
                                                            child: ShaderMask(
                                                              shaderCallback: (bounds) => LinearGradient(
                                                                begin: Alignment.topCenter,
                                                                end: Alignment.bottomCenter,
                                                                stops: [0.0, 0.5, 1.0],
                                                                colors: [
                                                                  Colors.transparent,
                                                                  Colors.grey.withOpacity(0.5),
                                                                  Colors.black.withOpacity(0.7)
                                                                ],
                                                              ).createShader(bounds),
                                                              blendMode: BlendMode.srcATop,
                                                              child: Image.network(
                                                                picUrisCasted[0],
                                                                fit: BoxFit.cover,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Align(
                                                          alignment: Alignment.bottomLeft,
                                                          child: Padding(
                                                            padding: const EdgeInsets.fromLTRB(15,0,0,15),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(20),
                                                              ),
                                                              child: Text(
                                                                title,
                                                                style: GoogleFonts.lato(
                                                                  textStyle: TextStyle(
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 20,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ]
                                                  )
                                              ),
                                              Expanded(
                                                flex:5,
                                                child: Container(
                                                  padding:EdgeInsets.all(10),
                                                  width:MediaQuery.of(context).size.width,
                                                  height:MediaQuery.of(context).size.height *0.3,
                                                  decoration: BoxDecoration(
                                                    borderRadius:BorderRadius.only(
                                                      bottomLeft: Radius.circular(20.0),
                                                      bottomRight: Radius.circular(20.0),
                                                    ),
                                                    color: Colors.grey,
                                                  ),
                                                  child: Column(
                                                      children: [
                                                        SingleChildScrollView(
                                                            scrollDirection: Axis.horizontal,
                                                            child: Row(
                                                                children: tagsCasted.map((String tag) {
                                                                  return Container(
                                                                    decoration: const BoxDecoration(
                                                                      borderRadius: BorderRadius.all(
                                                                        Radius.circular(20.0),
                                                                      ),
                                                                      color: Color.fromARGB(255, 74, 137, 92),
                                                                    ),
                                                                    margin: const EdgeInsets.symmetric(
                                                                        horizontal: 5.0),
                                                                    padding: const EdgeInsets.symmetric(
                                                                        horizontal: 10.0, vertical: 5.0),
                                                                    child: Text(
                                                                      '#$tag',
                                                                      style: const TextStyle(
                                                                          color: Colors.white),
                                                                    ),
                                                                  );
                                                                }).toList()),
                                                          ),
                                                        Expanded(
                                                          child: SingleChildScrollView(
                                                            scrollDirection: Axis.vertical,
                                                              child: Container(
                                                                margin: const EdgeInsets.symmetric(
                                                                    horizontal: 5.0),
                                                                padding: const EdgeInsets.symmetric(
                                                                    horizontal: 10.0, vertical: 5.0),
                                                                child:ReadMoreText(
                                                                    about,
                                                                  trimLines: 3,
                                                                  colorClickableText: Colors.pink,
                                                                  trimMode: TrimMode.Line,
                                                                  trimCollapsedText: 'Show more',
                                                                  trimExpandedText: 'Show less',
                                                                  moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                                ),
                                                              ),
                                                            ),
                                                        ),
                                                      ],
                                                    ),
                                                )
                                              ),
                                            ],
                                          )
                                        ),
                                );
                              }).toList(),
                            ),
                          );
                        }else{
                          return Container(
                              alignment: Alignment.center,
                              child:Text("You have not created any trips yet.",style:TextStyle(),)
                          );
                        }
                      }
                  )
              ),
              Container(
                  alignment: Alignment.bottomRight,
                  child:FloatingActionButton(
                    child: Icon(Icons.add),
                    backgroundColor: Colors.green,
                    onPressed: () {
                      Navigator.push(
                        context, MaterialPageRoute(
                        builder: (context) => TripCreator(),
                      ),
                      );
                    },
                  )
              ),
                ],
              ),
        )
            ],
          ),
    );
  }
}