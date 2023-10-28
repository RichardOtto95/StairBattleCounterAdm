import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

overlayProgressIndicator() => OverlayEntry(
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.black.withOpacity(.3),
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      ),
    );

Widget vSpace(double size) => SizedBox(height: size);

Widget hSpace(double size) => SizedBox(width: size);

double maxWidth(context) => MediaQuery.of(context).size.width;

double maxHeight(context) => MediaQuery.of(context).size.height;

Future<bool?> showToast(String msg) => Fluttertoast.showToast(
      msg: msg,
      webBgColor: "#116D6E",
      backgroundColor: const Color.fromRGBO(17, 109, 110, 1),
      webPosition: "center",
      timeInSecForIosWeb: 3,
      webShowClose: true,
    );
