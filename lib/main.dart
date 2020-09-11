import 'package:flutter/material.dart';
import './ui/splash.dart';
import './ui/theme.dart';

void main() => runApp(App());


class App extends StatelessWidget 
{
	@override
	Widget build(BuildContext context)
	{
	
		return MaterialApp(
			debugShowCheckedModeBanner:false,
			theme: theme,
			home: SplashScreen()
		);
		
	}
	
}