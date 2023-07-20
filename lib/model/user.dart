

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../globale.dart';

class MyUser {
  late String id;
  late String mail;
  late String nom;
  late String prenom;
  String? avatar;

  String get fullName {
    return "$prenom $nom";
  }

  MyUser.empty(){
    id = "";
    mail = "";
    nom = "";
    prenom = "";
  }

  MyUser(DocumentSnapshot snapshot){
    id = snapshot.id;
    Map<String,dynamic> map = snapshot.data() as Map<String,dynamic>;
    mail = map["EMAIL"];
    nom = map["NOM"];
    prenom = map["PRENOM"];
    avatar = map["AVATAR"] ?? defaultImage;
  }


}