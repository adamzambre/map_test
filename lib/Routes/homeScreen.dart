import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:map_test/Constants/Constants.dart';
import 'package:map_test/Routes/Messages.dart';
import 'package:map_test/Routes/Profile.dart';
//import 'package:map_test/Routes/SearchScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_test/Routes/chat.dart';
import 'package:map_test/Routes/profileView.dart';

void main()=>runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home : HomeScreen(),
    )
);

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = PageController(
    initialPage: 1,
  );

  String? countryValue = "";
  String? stateValue = "";
  String? cityValue = "";

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.amber,
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Center(
                child:Text(
                  "Search locals based on location",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
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
          SizedBox(height:10),
            Center(
              child:Container(
                height:1.0,
                width: MediaQuery.of(context).size.width,
                color:Colors.black,),
            ),
          SizedBox(height:10),
            Container(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("Users")
                    .where("userType", isEqualTo: "local tour guide")
                    .where("country", isEqualTo: countryValue)
                    .where("state", isEqualTo: stateValue)
                    .where("city", isEqualTo: cityValue)
                    .snapshots(),

                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                  if(!snapshot.hasData){//kalau data takde
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Expanded(
                    child: ListView(
                      children: snapshot.data!.docs.map((document) {
                        return Card(
                          color: Colors.white54,
                          child: new InkWell(
                            onTap: () {
                              Navigator.push(
                                context, MaterialPageRoute(
                                  builder: (context) => ProfileView(document: document),
                                ),
                              );
                            },
    //borderOnForeground: true,
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              children:[
                                Container(
                                  child: Image.network(document.get('picUri')),
                                ),
                                ExpansionTile(
                                  title:Text(
                                    document.get('name'),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21,
                                    ),
                                  ),
                                children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${document.get('country')},${document.get('state')}, ${document.get('city')}",
                                        style:TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height:10),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "${document.get('biodata')}",
                                          style:TextStyle(
                                            fontSize: 15,
                                          )
                                        ),
                                    ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: FloatingActionButton.extended(
                                      label: Text("Contact me!"),
                                      onPressed: () {

                                        Navigator.push(
                                          context, MaterialPageRoute(
                                            builder: (context) => Chat(document:document)
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                                )
                            ]
                          )
                          )
                          )
                        );
                      }).toList(),
                    ),
                  );
              }
              ),
            ),
          ],
          ),
        ),
    );
}
}
  /*Widget build(BuildContext context) {
    return Scaffold(
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 50,),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  //Navigator.push(
                    //context,
                    //MaterialPageRoute(builder: (context) => SearchScreen()),
                  //);
                },
                splashColor: Colors.white,
                hoverColor: Constants.greenAirbnb,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black87),),
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Icon(Icons.search),
                        Text("Emplacement, site touristique",style:TextStyle(fontSize: 13,color: Colors.black54),
                          overflow: TextOverflow.ellipsis,

                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 80,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Image.asset("assets/images/landing_page_img.png",fit: BoxFit.scaleDown,),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 20,),
                        Center(child: Text("Explorez",style:TextStyle(fontSize: 25,fontWeight:FontWeight.bold,color: Colors.white))),
                        Center(child: Text("l'Algérie",style:TextStyle(fontSize: 20,color: Colors.white))),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,

                      child: MaterialButton(
                        onPressed: (){
                          /*  Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Photo()),
                              );*/
                        },
                        elevation: 3,
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15,horizontal: 40),
                            margin: EdgeInsets.symmetric(vertical: 15,horizontal: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                            ),
                            child: Text("Explorez",style: TextStyle(color: Colors.red),)),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                height: 400,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text("DARI DAREK",style: TextStyle(color:Color(0xfff35e0b)),)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10,right: 10,left: 10),
                      child: Text("Rencontrez des gens partout en Algérie et découverez les plus beaux endroits du pays. Avec DARI DAREK, trouvez les",style: TextStyle(fontSize: 13,color:Color(0xffd3d3d3)),),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: PageView(
                          scrollDirection: Axis.horizontal,
                          controller: controller,
                          children: <Widget>[
                            buildScrollActivities("les meilleures vacances", "assets/images/3.jpg"),
                            buildScrollActivities("Logement familial", "assets/images/4.jpg"),
                            buildScrollActivities("Endroits calmes", "assets/images/1.jpg"),
                            buildScrollActivities("Les meilleures appartements", "assets/images/2.jpg"),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Padding buildScrollActivities(String text,String imgUri){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: <Widget>[
          Container(
              color: Colors.white,
              height: 250,
              width: 350,
              child: Image.asset(imgUri,fit: BoxFit.fill,)
          ),
          Container(
              width: double.infinity,
              color: Colors.black,
              child: Text(text,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),
        ],
      ),
    );
  }
}*/