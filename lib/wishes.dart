import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Wishes extends StatefulWidget {
  @override
  _WishesState createState() => _WishesState();
}

class _WishesState extends State<Wishes> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(
            onTap: () async {
                await launch("https://wa.me/919740748428?text=Testing");
                print("hello?");
            },
            child: Container(

                color: Colors.green,
            ),
        ),
    );
  }
}