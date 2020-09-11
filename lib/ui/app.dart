import 'package:flutter/material.dart'; 
import 'dart:async';
import 'dart:collection';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'home.dart';

class RadioApp extends StatefulWidget {
	
	
  @override
  State<StatefulWidget> createState() => RadioAppState();
}

class RadioAppState extends State<RadioApp> with TickerProviderStateMixin{
	
	int currentPage;
	

	void initState()
	{
		
		currentPage = 0;
	}  
	
	void _onItemTapped(int index) async {
		setState(() {
			currentPage = index;
		});
}
	List pages = [homePage];

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: pages[currentPage],
        ),
      ),
			backgroundColor: Color(0xFF1f2128),
    );
  }

	
}

