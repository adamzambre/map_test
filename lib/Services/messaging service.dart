import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

import 'package:map_test/Services/authententication.dart';

class messagingService{

  int counter1=0;

  int counter2=0;

  void addUidToChat(String uidDiMesej) async{
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference documentReference1 = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('chat')
        .doc(uidDiMesej);
    FirebaseFirestore.instance.runTransaction((transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
      //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
      DocumentSnapshot snapshot = await transaction.get(documentReference1);
      documentReference1.set({"messageCounter":1});
      print("success addUidToChat documentReference1");
    });

    DocumentReference documentReference2 = FirebaseFirestore.instance
        .collection('Users')
        .doc(uidDiMesej)
        .collection('chat')
        .doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
      //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
      DocumentSnapshot snapshot = await transaction.get(documentReference2);
      documentReference2.set({"messageCounter":1});
      print("success addUidToChat documentReference2");
    });
  }

  void addMessageCounter(String uidDiMesej) async{
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DocumentReference documentReference1 = FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .collection('chat')
        .doc(uidDiMesej);
    FirebaseFirestore.instance.runTransaction((transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
      //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
      DocumentSnapshot snapshot = await transaction.get(documentReference1);
      print("counter doc1: "+counter1.toString());
      documentReference1.update({'messageCounter': FieldValue.increment(1)});
      counter1++;
      print("tambah 1 at:"+uidDiMesej);
      print("success addMessageCounter documentReference1");
    });

    DocumentReference documentReference2 = FirebaseFirestore.instance
        .collection('Users')
        .doc(uidDiMesej)
        .collection('chat')
        .doc(uid);
    FirebaseFirestore.instance.runTransaction((transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
      //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
      DocumentSnapshot snapshot = await transaction.get(documentReference2);
      print("counter doc2: "+counter2.toString());
      documentReference2.update({'messageCounter': FieldValue.increment(1)});
      counter2++;
      print("tambah 1 at:"+uid);
      print("success addMessageCounter documentReference2");
    });
  }

  Future<bool> addMessage(String uidDiMesej,String content, String date) async{
    try {

      String uid = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot documentSnapshot1 = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('chat')
          .doc(uidDiMesej)
          .get();
      DocumentSnapshot documentSnapshot2 = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uidDiMesej)
          .collection('chat')
          .doc(uid)
          .get();//run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
        //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
          if (!(documentSnapshot1.exists && documentSnapshot2.exists)) {
            addUidToChat(uidDiMesej);
          } else {
            addMessageCounter(uidDiMesej);
          }


      DocumentReference documentReference2A = FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .collection('chat')
          .doc(uidDiMesej)
          .collection('messages')
          .doc(date);
      FirebaseFirestore.instance.runTransaction((transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
        //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
        DocumentSnapshot snapshot = await transaction.get(documentReference2A);
        documentReference2A.set({"from": uid,"to": uidDiMesej, "content": content,"timeStamp":date});
        print("success addMessage documentReference2A");
      });

      DocumentReference documentReference2B = FirebaseFirestore.instance
          .collection('Users')
          .doc(uidDiMesej)
          .collection('chat')
          .doc(uid)
          .collection('messages')
          .doc(date);
      FirebaseFirestore.instance.runTransaction((transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
        //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
        DocumentSnapshot snapshot = await transaction.get(documentReference2B);
        documentReference2B.set({"from": uid,"to": uidDiMesej, "content": content,"timeStamp":date});
        print("success addMessage documentReference2B");
      });

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//   void addUidLocalToChat(String uidLocal) async{
//     String uid = FirebaseAuth.instance.currentUser!.uid;
//     DocumentReference documentReference1 = FirebaseFirestore.instance
//         .collection('Users')
//         .doc(uid)
//         .collection('chat')
//         .doc(uidLocal);
//     FirebaseFirestore.instance.runTransaction((transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
//       //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
//       DocumentSnapshot snapshot = await transaction.get(documentReference1);
//       documentReference1.set({"messageCounter":0});
//       print("success1");
//     });
//   }
//
//   void addMessageCounterTourists(String uidLocal) async{
//     String uid = FirebaseAuth.instance.currentUser!.uid;
//     DocumentReference documentReference1 = FirebaseFirestore.instance
//         .collection('Users')
//         .doc(uid)
//         .collection('chat')
//         .doc(uidLocal);
//     FirebaseFirestore.instance.runTransaction((transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
//       //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
//       DocumentSnapshot snapshot = await transaction.get(documentReference1);
//       documentReference1.update({'messageCounter': FieldValue.increment(1)});
//       print("success1");
//     });
// }
//
//   Future<bool> addMessageTourist(String uidLocal,String content, String date) async{
//     try {
//       String uid = FirebaseAuth.instance.currentUser!.uid;
//
//       DocumentReference documentReference1 = FirebaseFirestore.instance
//           .collection('Users')
//           .doc(uid)
//           .collection('chat')
//           .doc(uidLocal);
//       FirebaseFirestore.instance.runTransaction((transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
//         //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
//         DocumentSnapshot snapshot = await transaction.get(documentReference1);
//         if (!snapshot.exists) {
//           addUidLocalToChat(uidLocal);
//         } else {
//           addMessageCounterTourists(uidLocal);
//         }
//         print("success2");
//       });
//
//       DocumentReference documentReference2 = FirebaseFirestore.instance
//           .collection('Users')
//           .doc(uid)
//           .collection('chat')
//           .doc(uidLocal)
//           .collection('messages')
//           .doc(date);
//       FirebaseFirestore.instance.runTransaction((transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
//         //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
//         DocumentSnapshot snapshot = await transaction.get(documentReference2);
//         documentReference2.set({"from": uid,"to": uidLocal, "content": content,"timeStamp":date});
//         print("success2");
//       });
//       return true;
//     } catch (e) {
//       print(e.toString());
//       return false;
//     }
//   }
// ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//   void addUidTouristToChat(String uidLocal) async{
//     String uid = FirebaseAuth.instance.currentUser!.uid;
//     DocumentReference documentReference1 = FirebaseFirestore.instance
//         .collection('Users')
//         .doc(uidLocal)
//         .collection('chat')
//         .doc(uid);
//     FirebaseFirestore.instance.runTransaction((transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
//       //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
//       DocumentSnapshot snapshot = await transaction.get(documentReference1);
//       documentReference1.set({"messageCounter":0});
//       print("success1");
//     });
//   }
//
//   void addMessageCounterLocal(String uidLocal) async{
//     String uid = FirebaseAuth.instance.currentUser!.uid;
//     DocumentReference documentReference1 = FirebaseFirestore.instance
//         .collection('Users')
//         .doc(uidLocal)
//         .collection('chat')
//         .doc(uid);
//     FirebaseFirestore.instance.runTransaction((transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
//       //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
//       DocumentSnapshot snapshot = await transaction.get(documentReference1);
//       documentReference1.update({'messageCounter': FieldValue.increment(1)});
//       print("success1");
//     });
//   }
//
//   Future<bool> addMessageLocal(String uidLocal,String content,String date) async{
//     try {
//       String uid = FirebaseAuth.instance.currentUser!.uid;
//
//       DocumentReference documentReference1 = FirebaseFirestore.instance
//           .collection('Users')
//           .doc(uidLocal)
//           .collection('chat')
//           .doc(uid);
//       FirebaseFirestore.instance.runTransaction((transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
//         //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
//         DocumentSnapshot snapshot = await transaction.get(documentReference1);
//         if (!snapshot.exists) {
//           addUidTouristToChat(uidLocal);
//         } else {
//           addMessageCounterLocal(uidLocal);
//         }
//         print("success2");
//       });
//
//
//       DocumentReference documentReference2 = FirebaseFirestore.instance
//           .collection('Users')
//           .doc(uidLocal)
//           .collection('chat')
//           .doc(uid)
//           .collection('messages')
//           .doc(date);
//
//       FirebaseFirestore.instance.runTransaction((transaction) async { //run trasnactions is when u want to ubah documentSSSSS (banyak document sekali gus) so data will not be ubah by other people while requesting, gitu
//         //we read dulu the documetns from database to make sure we are working with the most uptodate data (beza dengan batched)
//         DocumentSnapshot snapshot = await transaction.get(documentReference2);
//         documentReference2.set({"from": uid,"to": uidLocal, "content": content,"timeStamp":date});
//         print("success");
//       });
//       return true;
//     } catch (e) {
//       print(e.toString());
//       return false;
//     }
//   }
}