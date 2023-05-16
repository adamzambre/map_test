import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

import 'package:map_test/Services/authententication.dart';

class UserInfos {

  Future<bool> addInfo(String name, String age,
      String biodata, String? sex, String country, String? state, String? city) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('Users')
          .doc(uid);
      print("func is running");
      print("name:" + name);
      print("age:" + age);
      print("biodata:" + biodata);
      print("sex:" + sex.toString());
      print("country:" + country);
      print("state:" + state.toString());
      print("city:" + city.toString());
      if(sex==null){
        sex="";
      }
      FirebaseFirestore.instance.runTransaction((
          transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
        //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        documentReference.update(
            {"name": name, "age": age, "biodata": biodata, "sex": sex, "country":country, "state":state, "city":city});
        print("success");
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> addCountryStateCity(String? Country, String? State,
      String? City) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('Users')
          .doc(uid);
      FirebaseFirestore.instance.runTransaction((
          transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
        //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        documentReference.update(
            {"country": Country, "state": State, "city": City});
        print("success");
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future getImage(File? image) async {
    try {
      final images = await ImagePicker().pickImage(source: ImageSource.gallery);
      image = images as File;
      print('Image Path $image');
      return image;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future pickUploadImage(BuildContext context, File image) async {
    try {
      AuthService customAuth = new AuthService();
      String uid = await customAuth.getUid();
      String fileName = basename(image.path);
      Reference ref = FirebaseStorage.instance.ref("locals/$uid/$fileName")
          .child("$fileName");
      UploadTask uploadTask = ref.putFile(File("$image"));
      return uploadTask;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  void createSubCollectionContacts() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      CollectionReference collectionReference = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid).collection('Contacts');
      print("jadi");
    } catch (e) {
      print(e.toString());
    }
  }

  void createSubCollectionPlaceToGo() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      CollectionReference collectionReference = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('Places To Go');
      print("jadi");
    } catch (e) {
      print(e.toString());
    }
  }

  Future<bool?> addReview(QueryDocumentSnapshot<Object?> document, String comment,double rating) async {
    final now = new DateTime.now();
    String dateUid = DateTime.now().toString();
    String formatter = DateFormat('yMd').format(now);
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var Name = await FirebaseFirestore.instance.collection('Users')
        .doc(uid)
        .get()
        .then((value) {
      return value.data()?['name']; // Access your after your get the data
    });
    String PPUrl = await FirebaseFirestore.instance.collection('Users')
        .doc(uid)
        .get()
        .then((value) {
      return value.data()?['picUri']; // Access your after your get the data
    });

    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('Users')
          .doc(document.id)
          .collection('UserReviews')
          .doc(dateUid);
      FirebaseFirestore.instance.runTransaction((
          transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
        //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        if (!snapshot
            .exists) { //if there is no data (no document of that) (user tak buat lagi document tu)
          documentReference.set({
            "rating":rating,
            "uid":uid,
            "name": Name,
            "picUri": PPUrl,
            "comment": comment,
            "date": formatter
          });
          return true;
        }
      });
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<Map<String, dynamic>> getRatingAverage(QueryDocumentSnapshot<Object?> document) async{
    int totalDocuments = 0;
    double totalRating = 0;
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').doc(document.id).collection('UserReviews').get();
    final List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    totalDocuments = documents.length;
    print("TOTAL DOCUMENTS: "+totalDocuments.toString());
    totalRating = 0;
    for (var doc in documents) {
      final rating = doc['rating'] as double;
      totalRating += rating;
    }
    double averageRating = totalRating / (5 * totalDocuments);

    return {'averageRating': averageRating, 'totalDocuments': totalDocuments};
  }

  Future<bool?> addReviewTrip(QueryDocumentSnapshot<Object?> documentTrip,QueryDocumentSnapshot<Object?> documentLTG, String comment,double rating) async {
    final now = new DateTime.now();
    String dateUid = DateTime.now().toString();
    String formatter = DateFormat('yMd').format(now);
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var Name = await FirebaseFirestore.instance.collection('Users')
        .doc(uid)
        .get()
        .then((value) {
      return value.data()?['name']; // Access your after your get the data
    });
    String PPUrl = await FirebaseFirestore.instance.collection('Users')
        .doc(uid)
        .get()
        .then((value) {
      return value.data()?['picUri']; // Access your after your get the data
    });

    try {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('Users')
          .doc(documentLTG.id)
          .collection('Trips')
          .doc(documentTrip.id)
          .collection('TripReviews')
          .doc(dateUid);
      FirebaseFirestore.instance.runTransaction((
          transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
        //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
        DocumentSnapshot snapshot = await transaction.get(documentReference);
        if (!snapshot
            .exists) { //if there is no data (no document of that) (user tak buat lagi document tu)
          documentReference.set({
            "rating":rating,
            "uid":uid,
            "name": Name,
            "picUri": PPUrl,
            "comment": comment,
            "date": formatter
          });
          return true;
        }
      });
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<Map<String, dynamic>> getRatingAverageTrip(QueryDocumentSnapshot<Object?> documentTrip,QueryDocumentSnapshot<Object?> documentLTG) async{
    int totalDocuments = 0;
    double totalRating = 0;
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').doc(documentLTG.id).collection('Trips')
        .doc(documentTrip.id)
        .collection('TripReviews')
        .get();
    final List<QueryDocumentSnapshot> documents = querySnapshot.docs;
    totalDocuments = documents.length;
    print("TOTAL DOCUMENTS: "+totalDocuments.toString());
    totalRating = 0;
    for (var doc in documents) {
      final rating = doc['rating'] as double;
      totalRating += rating;
    }
    double averageRating = totalRating / (5 * totalDocuments);

    return {'averageRating': averageRating, 'totalDocuments': totalDocuments};
  }

//////////////////////////////////////////////////////////////////////////////////////////
  Future<bool> nameExist() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      final docRef = await FirebaseFirestore.instance.collection('Users').doc(
          uid);
      final DocumentSnapshot docSnapshot = await docRef.get();
      if (docSnapshot.exists && docSnapshot.data() != null) {
        final bool fieldExists = (docSnapshot.data() as Map<String, dynamic>)
            .containsKey('name');
        if (fieldExists) {
          print('The field exists.');
          return true;
        } else {
          print('The field does not exist.');
          return false;
        }
      } else {
        print('The document does not exist.');
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<String> getName(String Receiveruid) async {
    try {
      //String uid = FirebaseAuth.instance.currentUser!.uid;
      final docRef = await FirebaseFirestore.instance.collection('Users')
          .doc(Receiveruid);
      final DocumentSnapshot docSnapshot = await docRef.get();
      String name = docSnapshot.get("name");
      print(name);
      return name;
    } catch (e) {
      print(e.toString());
      return "no name";
    }
  }

  Future<String> getPicUri(String Receiveruid) async {
    try {
      //String uid = FirebaseAuth.instance.currentUser!.uid;
      final docRef = await FirebaseFirestore.instance.collection('Users').doc(
          Receiveruid);
      final DocumentSnapshot docSnapshot = await docRef.get();
      String picUri = docSnapshot.get("picUri");
      return picUri;
    } catch (e) {
      print(e.toString());
      return "no uriPic";
    }
  }

  Future<String> getLastMessage(String Receiveruid) async {
    String lastMessage = "";
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      final ColRef = await FirebaseFirestore.instance.collection('Users').doc(uid).collection('chat').doc(Receiveruid).collection('messsages');
      Query query = await ColRef.orderBy("createdAt", descending: true).limit(1);
      QuerySnapshot querySnapshot = await query.get();
      DocumentSnapshot lastDocSnapshot = querySnapshot.docs.last;
      print("lastDocSnapshot: "+lastDocSnapshot.id);
      lastMessage = lastDocSnapshot['content'];
      return lastMessage;
    } catch (e) {
      print(e.toString());
      return lastMessage;
    }
  }

}