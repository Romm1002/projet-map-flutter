import 'package:flutter/material.dart';

import '../model/user.dart';
import 'package:permission_handler/permission_handler.dart';

enum Gender {homme,femme,transgenre,indefini}

MyUser me = MyUser.empty();
MaterialColor mainColor = Colors.lightBlue;
String defaultImage = "https://tse1.mm.bing.net/th?id=OIP.zRmpjD_EOxCboGENHfjxHAHaEc&pid=Api";
