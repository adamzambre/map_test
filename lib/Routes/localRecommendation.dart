import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_test/Routes/chat.dart';
import 'package:map_test/Routes/profileView.dart';
import 'package:map_test/Routes/tripView.dart';
import 'package:map_test/Services/user_info.dart';
import 'package:readmore/readmore.dart';

void main()=>runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home : LocalRecommendation(),
    )
);

class LocalRecommendation extends StatefulWidget {

  @override
  _LocalRecommendationState createState() => _LocalRecommendationState();
}

class _LocalRecommendationState extends State<LocalRecommendation> {
  String? countryValue = "";
  String? stateValue = "";
  String? cityValue = "";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25,vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex:1,
              child: Container(
                  alignment: Alignment.center,
                  child: Text("See what locals are providing!",
                    style:TextStyle(
                        fontSize:20,
                        fontWeight: FontWeight.w700),
                  )
              ),
            ),
            SizedBox(height: 20),
            Container(
              child:CSCPicker(
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
            ),
            Expanded(
                flex:10,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("Users")
                      .where("country", isEqualTo: countryValue)
                      .where("state", isEqualTo: stateValue)
                      .where("city", isEqualTo: cityValue)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      // Iterate through the documents in the snapshot
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          // Access the document data for each user
                          var userDoc = snapshot.data!.docs[index];
                          var data1 = userDoc.data() as Map<String, dynamic>;
                          String nameFB = data1["name"]!="" ? data1['name'] : 'Anonymous';
                          String picUri = data1["picUri"]!="" ? data1['picUri'] : 'https://icon-library.com/images/default-profile-icon/default-profile-icon-24.jpg';
                          // Access the subcollection "trips" for the current user document
                          var tripsDocuments = userDoc.reference.collection("Trips").get();

                          // Return a stream builder for the "trips" subcollection
                          return FutureBuilder<QuerySnapshot>(
                              future:tripsDocuments,
                              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasData) {
                                  if (snapshot.data!.docs.isEmpty) {
                                    return SizedBox.shrink();
                                  } else {
                                    // Render UI for non-empty subcollection
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        // Access the document data for each trip
                                        var tripDoc = snapshot.data!.docs[index];
                                        var data = tripDoc.data() as Map<String, dynamic>;
                                        String title = data["name"];
                                        List<dynamic> picUris = data["picUri"];
                                        List<String> picUrisCasted = picUris.cast<String>().toList();//The cast() method converts the List<dynamic> to a List<String> by applying a type cast to each element of the list.
                                        List<dynamic> tags = data["tags"];
                                        List<String> tagsCasted = tags.cast<String>().toList();
                                        String about = data["description"];
                                        return InkWell(
                                          onTap:(){
                                            Navigator.push(
                                              context, MaterialPageRoute(
                                              builder: (context) => TripView(tripDocument: tripDoc,userDocument: userDoc),
                                            ),
                                            );
                                          },
                                          child:Container(
                                            margin:EdgeInsets.all(10),
                                            width:MediaQuery.of(context).size.width,
                                            height:MediaQuery.of(context).size.height *0.3,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Column(
                                              children:[
                                                Expanded(
                                                  flex:4,
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        width:MediaQuery.of(context).size.width,
                                                        height:MediaQuery.of(context).size.height *0.3,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(20.0),
                                                            topRight: Radius.circular(20.0),
                                                          ),
                                                        ),
                                                        child: ClipRRect(/////////////////sini
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
                                                        alignment: Alignment.topLeft,
                                                        child: Padding(
                                                          padding: const EdgeInsets.fromLTRB(15,15,0,0),
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(20),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                CircleAvatar(
                                                                    radius:15,
                                                                    backgroundImage: NetworkImage(
                                                                      picUri,
                                                                    )
                                                                ),
                                                                Expanded(
                                                                  child:Padding(
                                                                    padding: const EdgeInsets.fromLTRB(8.0,0,0,0),
                                                                    child: GestureDetector(
                                                                      onTap:() {
                                                                        Navigator.push(
                                                                          context, MaterialPageRoute(
                                                                            builder: (context) => ProfileView(document: userDoc),
                                                                          ),
                                                                        );
                                                                      },
                                                                      child: Text(
                                                                        nameFB,
                                                                        style: GoogleFonts.lato(
                                                                          textStyle: TextStyle(
                                                                            color: Colors.white,
                                                                            fontWeight: FontWeight.bold,
                                                                            fontSize: 15,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )

                                                              ],
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
                                                                style:GoogleFonts.lato(
                                                                  textStyle: TextStyle(
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 20,
                                                                  ),
                                                                )
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex:3,
                                                    child:Container(
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
                                                )
                                              ]
                                            ),
                                          ),
                                        );
                                        // Render UI for each trip document
                                        // ...
                                      },
                                    );
                                  }
                                } else if (snapshot.hasError) {
                                  // Render UI for error in fetching subcollection
                                  return Text("Error: ${snapshot.error}");
                                } else {
                                  // Render UI for no data
                                  return Text("No data");
                                }
                              }
                          );
                        },
                      );
                    } else {
                      return CircularProgressIndicator(); // Placeholder while loading data
                    }
                  },
                ),
            ),
          ],
        ),
      ),
    );
  }
}
//
// StreamBuilder(
// stream: tripsCollection.snapshots(),
// builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> tripsSnapshot) {
// if (tripsSnapshot.hasData) {
// if (tripsSnapshot.data!.docs.isNotEmpty) {
// // "trips" subcollection exists for current user document
// // Access the documents in the "trips" subcollection
// var tripsDocs = tripsSnapshot.data!.docs;
//
// return ListView(
// children: tripsDocs.map((document){
// var data = document.data()! as Map<String, dynamic>;//BENDA NI YG BAGI ERROR "data!.data()"
// print("DATA: "+data.toString());
// String title = data["name"];
// List<dynamic> picUris = data["picUri"];
// List<String> picUrisCasted = picUris.cast<String>().toList();//The cast() method converts the List<dynamic> to a List<String> by applying a type cast to each element of the list.
// List<dynamic> tags = data["tags"];
// List<String> tagsCasted = tags.cast<String>().toList();
// String about = data["description"];
//
// int index = 0;
// print("replyer document:"+document.toString());
// return InkWell(
// onTap:(){
// print("berjaya");
// },
// child: Container(
// margin:EdgeInsets.all(10),
// width:MediaQuery.of(context).size.width,
// height:MediaQuery.of(context).size.height *0.3,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(20),
// ),
// child:Column(
// children: [
// Expanded(
// flex:4,
// child: Stack(
// children:[
// Container(
// width:MediaQuery.of(context).size.width,
// height:MediaQuery.of(context).size.height *0.3,
// decoration: BoxDecoration(
// borderRadius: BorderRadius.only(
// topLeft: Radius.circular(20.0),
// topRight: Radius.circular(20.0),
// ),
// ),
// child: ClipRRect(/////////////////sini
// borderRadius: BorderRadius.only(
// topLeft: Radius.circular(20.0),
// topRight: Radius.circular(20.0),
// ),
// child: ShaderMask(
// shaderCallback: (bounds) => LinearGradient(
// begin: Alignment.topCenter,
// end: Alignment.bottomCenter,
// stops: [0.0, 0.5, 1.0],
// colors: [
// Colors.transparent,
// Colors.grey.withOpacity(0.5),
// Colors.black.withOpacity(0.7)
// ],
// ).createShader(bounds),
// blendMode: BlendMode.srcATop,
// child: Image.network(
// picUrisCasted[0],
// fit: BoxFit.cover,
// ),
// ),
// ),
// ),
// Align(
// alignment: Alignment.bottomLeft,
// child: Padding(
// padding: const EdgeInsets.fromLTRB(15,0,0,15),
// child: Container(
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(20),
// ),
// child: Text(
// title,
// style:GoogleFonts.lato(
// textStyle: TextStyle(
// color: Colors.white,
// fontWeight: FontWeight.bold,
// fontSize: 20,
// ),
// )
// ),
// ),
// ),
// )
// ]
// )
// ),
// Expanded(
// flex:3,
// child: Container(
// padding:EdgeInsets.all(10),
// width:MediaQuery.of(context).size.width,
// height:MediaQuery.of(context).size.height *0.3,
// decoration: BoxDecoration(
// borderRadius:BorderRadius.only(
// bottomLeft: Radius.circular(20.0),
// bottomRight: Radius.circular(20.0),
// ),
// color: Colors.grey,
// ),
// child: Column(
// children: [
// SingleChildScrollView(
// scrollDirection: Axis.horizontal,
// child: Row(
// children: tagsCasted.map((String tag) {
// return Container(
// decoration: const BoxDecoration(
// borderRadius: BorderRadius.all(
// Radius.circular(20.0),
// ),
// color: Color.fromARGB(255, 74, 137, 92),
// ),
// margin: const EdgeInsets.symmetric(
// horizontal: 5.0),
// padding: const EdgeInsets.symmetric(
// horizontal: 10.0, vertical: 5.0),
// child: Text(
// '#$tag',
// style: const TextStyle(
// color: Colors.white),
// ),
// );
// }).toList()),
// ),
// Expanded(
// child: SingleChildScrollView(
// scrollDirection: Axis.vertical,
// child: Container(
// margin: const EdgeInsets.symmetric(
// horizontal: 5.0),
// padding: const EdgeInsets.symmetric(
// horizontal: 10.0, vertical: 5.0),
// child:ReadMoreText(
// about,
// trimLines: 3,
// colorClickableText: Colors.pink,
// trimMode: TrimMode.Line,
// trimCollapsedText: 'Show more',
// trimExpandedText: 'Show less',
// moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
// ),
// ),
// ),
// ),
// ],
// ),
// )
// ),
// ],
// )
// ),
// );
// }).toList(),
// );
// } /*else {
//                                   // "trips" subcollection does not exist for current user document
//                                   return Text("No trips found");
//                                 }*/
// }
// return CircularProgressIndicator(); // Placeholder while loading data
// },
// )