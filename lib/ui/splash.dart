import 'dart:async';

import 'package:flutter/material.dart';
import 'app.dart';
//import './screens/theme.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5), () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => RadioApp())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Color(0xFF1f2128)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
											Text(
													'Matthew 6:13',
													style: TextStyle(
															color: Colors.white,
															fontFamily:'Oswald',
															//fontWeight: FontWeight.bold,
															fontSize: 18.0),
												),
                      Text(
                        'YOU ARE THE SALT OF THE EARTH',
                        style: TextStyle(
                            color: Colors.white,
														fontFamily:'Oswald',
                            //fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
											Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
											
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 60.0,
                        child: ClipOval(
																child: Image.asset(
																	"assets/photos/logo.jpg",
																	fit: BoxFit.cover,
																	width: 120.0,
																	height: 120.0,
																)
															),
                      ),
											
											
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
											
                      
                    ],
                  ),
                ),
              ),
          
            ],
          )
        ],
      ),
    );
  }
}