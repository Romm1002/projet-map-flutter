import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../globale.dart';
import '../model/user.dart';

class ChatView extends StatefulWidget {
  final User otherUser;
  const ChatView({super.key, required this.otherUser});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    User otherUser = widget.otherUser;
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
        backgroundColor: mainColor,
      ),
      body: Placeholder()
    );
  }
}
