import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../globale.dart';
import '../model/user.dart';

class ChatView extends StatefulWidget {
  final MyUser otherUser;
  const ChatView({super.key, required this.otherUser});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  //variable
  TextEditingController msg = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MyUser otherUser = widget.otherUser;
    List? conversation = [];

    if(otherUser.messages != null && otherUser.messages?[me.id] != null){
      conversation = List.from(conversation)..addAll(otherUser.messages![me.id]);
    }
    if(me.messages != null && me.messages?[otherUser.id] != null){
      conversation = List.from(conversation)..addAll(me.messages![otherUser.id]);
    }
    conversation.sort((m1, m2) {
      return m1["DATE"].compareTo(m2["DATE"]);
    });

    sendMsg(){
      if(msg.text.replaceAll(' ', '') != ""){
        if(me.messages?[otherUser.id] == null){
          me.messages?[otherUser.id] = [];
        }
        me.messages?[otherUser.id].add(
            {
              "CONTENU": msg.text,
              "DATE": Timestamp.fromDate(DateTime.now()),
              "FROM": me.id
            }
        );
        Map<String, dynamic> data = {
          "MESSAGES": me.messages
        };
        FirebaseFirestore.instance.collection("UTILISATEURS").doc(me.id).update(data);
        setState(() {
          msg.text = "";
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(otherUser.avatar ?? defaultImage),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                otherUser.fullName,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: conversation.length,
              itemBuilder: (context, index){
                Map message = conversation![index];
                if(message['FROM'] == me.id){
                  return  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    color: Colors.blue,
                    child: Text(message['CONTENU']),
                  );
                }else{
                  return  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    color: Colors.green,
                    child: Text(message['CONTENU']),
                  );
                }
              }
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: msg,
                decoration: InputDecoration(
                  hintText: "Message...",
                  suffixIcon: IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: (){
                        sendMsg();
                      },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
