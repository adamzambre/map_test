//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:map_test/Model/user.dart';
class AuthService {

  MyUser? _userFromFirebaseUser(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  Stream<MyUser?> get user {
    return FirebaseAuth.instance.
    authStateChanges().map((User? user) => _userFromFirebaseUser(user));
    //authStateChanges().map(_userFromFirebaseUser(user) ); punboleh
  }

  Future getUid() async{
    try{
      String result = await FirebaseAuth.instance.currentUser!.uid.toString();
      return result;
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future<List> TouristSignUp(email, password) async {
    String error="Make sure you fill in correct credentials";
    try {
      UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      _userFromFirebaseUser(user); //returning the user with the uid
      print(email.toString());
      return [true,error];
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        error='The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        error = 'The account already exists for that email.';
      }
      print(email.toString());
      return [false,error];
    } catch (e) {
      print(e.toString());
      print(email.toString());
      return [false,e.toString()];
    }
  }

  Future<List> TouristLogIn(email, password) async{
    String error="Make sure you fill in the correct credentials";
    try {
      UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      _userFromFirebaseUser(user);
      print(email.toString());
      return [true,error];
    }on FirebaseAuthException catch(e){
      if (e.code == 'invalid-email') {
        error='email address is not valid.';
      } else if (e.code == 'user-disabled') {
        error='user corresponding to the given email has been disabled.';
      }else if (e.code == 'weak-password') {
        error='user-not-found';
      } else if (e.code == 'wrong-password') {
        error='The password is wrong for the current email.';
      }
      print(email.toString());
      return [false,error];
    }catch(e){
      print(email.toString());
      return [false,e.toString()];
    }
  }

  Future<List> LocalTourGuideSignUp(email, password) async {
    String error="Make sure you fill in correct credentials";
    try {
      UserCredential result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      _userFromFirebaseUser(user); //returning the user with the uid
      print(email.toString());
      return [true,error];
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        error='The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        error = 'The account already exists for that email.';
      }
      print(email.toString());
      return [false,error];
    } catch (e) {
      print(e.toString());
      print(email.toString());
      return [false,e.toString()];
    }
  }

  Future<List> LocalTourGuideLogIn(email, password) async{
    String error="Make sure you fill in the correct credentials";
    try {
      UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      _userFromFirebaseUser(user);
      print(email.toString());
      return [true,error];
    }on FirebaseAuthException catch(e){
      if (e.code == 'invalid-email') {
        error='email address is not valid.';
      } else if (e.code == 'user-disabled') {
        error='user corresponding to the given email has been disabled.';
      }else if (e.code == 'weak-password') {
        error='user-not-found';
      } else if (e.code == 'wrong-password') {
        error='The password is wrong for the current email.';
      }
      print(email.toString());
      return [false,error];
    }catch(e){
      print(email.toString());
      return [false,e.toString()];
    }
  }

  Future<List> addLocalTourGuideUid() async{//used when registering NOT loggin in
    String error="working fine like it should";
    String uid = FirebaseAuth.instance.currentUser!.uid;
    try{
      CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('Users');
      collectionReference.add({"uid":uid});
      collectionReference.add({"userType":"LocalTourGuide"});
      return [true,error];
    }catch(e){
      print(e.toString());
      error = e.toString();
      return [false,error];
    }
  }

  Future<List> addTouristUid() async{//used when registering NOT loggin in
    String error="working fine like it should";
    String uid = FirebaseAuth.instance.currentUser!.uid;
    try{
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(uid);
      print("UID of current user is: "+uid);
      docRef.set({
        "uid": uid,
        "name": "",
        "age":"",
        "sex":"",
        "biodata": "",
        "country":"",
        "state":"",
        "city":"",
        "picUri":"",
        "userType":"tourist",
      });
      return [true,error];
    }catch(e){
      print(e.toString());
      error = e.toString();
      return [false,error];
    }
  }
}