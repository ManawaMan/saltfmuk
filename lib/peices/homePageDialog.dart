import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> _showSocialDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Password'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Connect With Us On Social Media', style: GoogleFonts.oswald(
									textStyle:TextStyle(fontSize: 16.0, color:Colors.white, letterSpacing: 1.5),),),
              Row(),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
				semanticLabel:"Social Media Links Popup",
				backgroundColor: Color(0xFF2b2f37),
						
      );
    },
  );
}