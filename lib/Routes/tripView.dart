import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_test/Routes/chat.dart';
import 'package:map_test/Routes/profileView.dart';
import 'package:map_test/Services/user_info.dart';
import 'package:textfield_tags/textfield_tags.dart';

class TripView extends StatefulWidget {
  final QueryDocumentSnapshot tripDocument;
  final QueryDocumentSnapshot userDocument;

  UserInfos commentFunction = new UserInfos();

  TripView({Key? key, required this.tripDocument,required this.userDocument}) : super(key: key);

  @override
  State<TripView> createState() => _TripViewState();
}

class _TripViewState extends State<TripView> {

  double Userrating = 3;

  @override
  Widget build(BuildContext context) {
    final title = widget.tripDocument.get('name');
    final about = widget.tripDocument.get('description');
    final tags = widget.tripDocument.get('tags');
    List<String> tagsCasted = tags.cast<String>().toList();
    final picUri = widget.tripDocument.get('picUri');
    List<String> picUrisCasted = picUri.cast<String>().toList();
    final creatorId = widget.tripDocument.get('uid');
    final ScreenHeight = MediaQuery.of(context).size.height;
    final ScreenWidth = MediaQuery.of(context).size.width;
    TextEditingController comment = new TextEditingController();

    Future<String> fetchCreatorName() async{
      final docSnapshot = await FirebaseFirestore.instance.collection("Users").doc(creatorId).get();
      final creatorName = docSnapshot.get('name');
      return creatorName;
    }


    final List<Widget> imageSliders = picUrisCasted
        .map((item) => Container(
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Stack(
              children: <Widget>[
                Image.network(item, fit: BoxFit.cover, width: 1000.0),
                Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(200, 0, 0, 0),
                          Color.fromARGB(0, 0, 0, 0)
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                  ),
                ),
              ],
            )),
      ),
    ))
        .toList();

    return Scaffold(
      body: SafeArea(
        child:SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.arrow_back,color: Colors.black87,size: 20,),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child:Text("Trip Details",
                          style:TextStyle(
                              fontSize:18,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  margin:EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green,width:2)
                    ),
                    child: CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.vertical,
                        autoPlay: true,
                      ),
                      items: imageSliders,
                    )),
                SizedBox(height:25),
                Container(
                    margin:EdgeInsets.fromLTRB(10,0,0,0),
                    padding:EdgeInsets.fromLTRB(10,0,0,0),
                    alignment: Alignment.centerLeft,
                    child:Text(title,
                      style:TextStyle(
                          fontSize:25,
                          fontWeight: FontWeight.w500),)
                ),
                SizedBox(height:10),
                Container(
                    margin:EdgeInsets.fromLTRB(10,0,0,0),
                    padding:EdgeInsets.fromLTRB(10,0,0,0),
                    alignment: Alignment.centerLeft,
                    child:FutureBuilder<DocumentSnapshot>(
                      future:FirebaseFirestore.instance.collection("Users").doc(creatorId).get(),
                      builder:(context, AsyncSnapshot<DocumentSnapshot> snapshot){
                        String creatorName = snapshot.data!['name'];
                        String picUri = snapshot.data!["picUri"];
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: 1,
                            itemBuilder: (BuildContext context, int index) {
                              return  Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      child: Text(
                                        "by: ",
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                  ),
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
                                            builder: (context) => ProfileView(document: widget.userDocument),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          creatorName,
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )

                                ],
                              );//       fontWeight: FontWeight.w500),);
                            });
                      }
                    )
                ),
                SizedBox(height:25),
                Row(
                    children:[
                      Container(
                        alignment: Alignment.topLeft,
                        padding:  EdgeInsets.fromLTRB(10,8,10,10),
                        child: Text("Rating:",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                      ),
                      Container(
                        child:FutureBuilder<Map<String,dynamic>>(
                            future:UserInfos().getRatingAverageTrip(widget.tripDocument,widget.userDocument),
                            builder:(context, snapshot){
                              final averageRating = snapshot.data?['averageRating'];
                              final totalDocuments = snapshot.data?['totalDocuments'];
                              return Text(averageRating.toString()+" ("+totalDocuments.toString()+")",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),);
                            }
                        ),
                      ),
                    ]
                ),
                Container(
                    margin:EdgeInsets.fromLTRB(10,0,0,0),
                    padding:EdgeInsets.fromLTRB(10,0,0,0),
                    alignment: Alignment.centerLeft,
                    child:Text("Tags:",
                      style:TextStyle(
                          fontSize:15,
                          fontWeight: FontWeight.w500),)
                ),
                SizedBox(height:10),
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
                SizedBox(height:25),
                Container(
                  height: MediaQuery.of(context).size.height*0.3,
                    margin:EdgeInsets.fromLTRB(10,0,0,0),
                    padding:EdgeInsets.fromLTRB(10,0,0,0),
                    alignment: Alignment.centerLeft,
                    child:Text(about,
                      style:TextStyle(
                          fontSize:15,
                          fontWeight: FontWeight.w500),)
                ),
                SizedBox(height:25),
                Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00AA6D), // Use the TripAdvisor green color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0), // Rounded corners
                        ),
                      ),
                      onPressed: () async{
                        Navigator.push(
                          context, MaterialPageRoute(
                          builder: (context) => Chat(document: widget.userDocument),
                        ),
                        );
                      },
                      child: Text(
                        'Contact the local tour guide',
                        style: GoogleFonts.lato(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    )
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding:  EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Text("Comments",style:TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.bold)),
                      SizedBox(height:10),
                      GestureDetector(
                        child:Container(
                            alignment:Alignment.topLeft,
                            child: Text(
                                "Publish a comment",style:TextStyle(color:Colors.blue,fontSize: 10,fontWeight: FontWeight.bold)
                            )
                        ),
                        onTap: (){
                          showModalBottomSheet<dynamic>(
                              isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context){
                                return Padding(
                                  //height: MediaQuery.of(context).size.height *0.35,
                                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          padding:EdgeInsets.all(10),
                                          child: Text("Your Rating: ",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),)
                                      ),
                                      Container(
                                        child: RatingBar.builder(
                                          initialRating: 3,
                                          minRating: 0.5,
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
                                            setState(() {
                                              Userrating=rating;
                                            });
                                          },
                                        ),
                                      ),
                                      SizedBox(height:25),
                                      Container(
                                          padding:EdgeInsets.all(10),
                                          child: Text("Your Comment: ",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),)
                                      ),
                                      TextFormField(//name
                                        controller: comment,
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          hintText: "Write your comment here",
                                          fillColor: Colors.white,
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.white, width:2),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: Colors.blue, width: 2),
                                          ),
                                        ),
                                        minLines: 1,
                                        maxLines: 100,
                                      ),
                                      SizedBox(height:15),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextButton(
                                          onPressed: ()async{
                                            dynamic result = await UserInfos().addReviewTrip(widget.tripDocument,widget.userDocument,comment.text,Userrating);
                                            if(result==false){
                                              Fluttertoast.showToast(
                                                  msg: "Error publishing comment",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0
                                              );
                                              print(result.toString());
                                            }
                                            else{
                                              Fluttertoast.showToast(
                                                  msg: "Review successfully uploaded",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  timeInSecForIosWeb: 1,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0
                                              );
                                              print(result.toString());
                                            }
                                            Navigator.pop(context);
                                          },
                                          child:Text(
                                            'Submit my review',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                            padding: MaterialStateProperty.all<EdgeInsets>(
                                              EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                                            ),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(30),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                          );
                        },
                      ),
                      SingleChildScrollView(
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance.collection("Users").doc(widget.userDocument.id).collection("Trip").doc(widget.tripDocument.id).collection('TripReviews').snapshots(),
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
                                  child: Text("No comments have been left for this trip yet",style:TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.normal, fontStyle: FontStyle.normal)),
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
                  ),
                )
              ],
            ),
          ),
        ),
      );
  }


}
