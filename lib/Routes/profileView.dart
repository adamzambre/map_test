import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:map_test/Services/user_info.dart';

class ProfileView extends StatefulWidget {

  late QueryDocumentSnapshot document;
  ProfileView({Key? key,required this.document}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {

  UserInfos commentFunction = new UserInfos();
  double Userrating = 3;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot>(
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
              //getAverage();
              final nameFB = widget.document.get('name');
              final bioFB = widget.document.get('biodata');
              final ageFB = widget.document.get('age');
              final sexFB = widget.document.get('sex');
              final countryFB = widget.document.get('country');
              final stateFB = widget.document.get('state');
              final cityFB = widget.document.get('city');
              final picUri = widget.document.get('picUri');
              final userType = widget.document.get("userType");
              TextEditingController comment = new TextEditingController();

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
                      userType == "local tour guide" ?
                      Row(
                        children:[
                          Container(
                            alignment: Alignment.topLeft,
                            padding:  EdgeInsets.fromLTRB(10,8,10,10),
                            child: Text("Rating:",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),),
                          ),
                          Container(
                            child:FutureBuilder<Map<String,dynamic>>(
                                future:UserInfos().getRatingAverage(widget.document.id.toString()),
                                builder:(context, snapshot){
                                  final averageRating = snapshot.data?['averageRating'];
                                  final totalDocuments = snapshot.data?['totalDocuments'];
                                  if(snapshot.hasData!){
                                    return Text("0.0 ("+totalDocuments.toString()+")",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),);
                                  }else{
                                    return Text(averageRating.toString()+" ("+totalDocuments.toString()+")",style: TextStyle(color:Colors.black,fontSize: 20,fontWeight: FontWeight.w700),);
                                  }
                                }
                            ),
                          ),
                        ]
                      ):
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
                      userType == "local tour guide" ?// the user of the profile
                      Container(
                        alignment: Alignment.topLeft,
                        padding:  EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Text("Comments",style:TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.bold)),
                            SizedBox(height:10),
                            userType == "local tour guide" ?
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
                                                  dynamic result = await commentFunction.addReview(widget.document,comment.text,Userrating);
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
                                                  }/*else if(result ?? true){
                                                    Fluttertoast.showToast(
                                                        msg: "Error publishing comment, you can only publish one comment",
                                                        toastLength: Toast.LENGTH_SHORT,
                                                        gravity: ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 1,
                                                        textColor: Colors.white,
                                                        fontSize: 16.0
                                                    );
                                                  }*/
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
                            ):
                            SizedBox(height:0),
                            SingleChildScrollView(
                              child: StreamBuilder(
                                    stream: FirebaseFirestore.instance.collection("Users").doc(widget.document.id).collection("UserReviews").snapshots(),
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
                                          child: Text("No comments have been left for this local guide yet",style:TextStyle(color:Colors.black,fontSize: 15,fontWeight: FontWeight.normal, fontStyle: FontStyle.normal)),
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
                      ):
                          SizedBox(height:0),
                    ],
                  )
              );
            }
        ),
      ),
    );;
  }
}
