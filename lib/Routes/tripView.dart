import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_test/Routes/chat.dart';
import 'package:map_test/Routes/profileView.dart';
import 'package:textfield_tags/textfield_tags.dart';

class TripView extends StatefulWidget {
  final QueryDocumentSnapshot tripDocument;
  final QueryDocumentSnapshot userDocument;

  TripView({Key? key, required this.tripDocument,required this.userDocument}) : super(key: key);

  @override
  State<TripView> createState() => _TripViewState();
}

class _TripViewState extends State<TripView> {



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
              ],
            ),
          ),
        ),
      );
  }


}
