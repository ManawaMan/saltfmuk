import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'; 
import 'dart:async';
import 'dart:collection';

import 'package:flutter_radio/flutter_radio.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:convert';
import 'dart:typed_data';
import 'dart:io';

import 'package:intl/date_symbol_data_local.dart';

import 'package:path_provider/path_provider.dart';
import '../peices/homePageDialog.dart';
import '../peices/mailer.dart';
import '../data/titlefetch.dart';
//import '../data/database.dart';

final _homeKey = GlobalKey();



List<Widget> homePage = [HomeScreenTopPart(_homeKey), HomeScreenBottomPart(), SizedBox(height:50,) ];

class HomeScreenTopPart extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => HomeScreenTopPartState();
	
	HomeScreenTopPart(key) : super(key: key);

}

class HomeScreenTopPartState extends State<HomeScreenTopPart> with TickerProviderStateMixin {

	static const streamUrl = "http://eclipse.galaxywebsolutions.com:7410/SaltFM-128.mp3";
	bool isPlaying = false;
	var myFile;
	Widget playPauseButton;
	
	
	static const Widget unliked = Icon(Icons.favorite_border,color: Color(0xFFdd629e));
	static const Widget liked = Icon(Icons.favorite,color: Color(0xFFdd629e));
	Widget favButton = unliked;
	String title = "Loading...";
	String oldSong = ' ';
	//final databaseMethods = DatabaseMethods();
	SharedPreferences prefs; 
	
	Widget playButton = Row(
                        children: <Widget>[
                          Text(
                            "  ",
                            style: TextStyle(
                                color: Color(0xFF2b2f37),
                                fontSize: 15.0,
                                fontFamily: "SF-Pro-Display-Bold"),
                          ),
												Text(
                            "Play Station",
                            style: TextStyle(
                            color: Colors.white,
                                fontSize: 15.0,
                                fontFamily: "SF-Pro-Display-Bold"),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Icon(Icons.play_circle_filled, color: Colors.white),
                        ],
                      );
	Widget pauseButton = Row(
                        children: <Widget>[
                          Text(
                            "Pause Station",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontFamily: "SF-Pro-Display-Bold"),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Icon(Icons.pause_circle_filled, color: Colors.white),
                        ],
                      );
	
	
	
	
	void initState()
	{
		playingStatus();
		audioStart();
		playPauseButton = playButton;
		_isLiked();
		const time = const Duration(seconds:5);
		new Timer.periodic(time, (Timer t) async {await updateTitle();});
	}
	
	Future<void> _isLiked() async {
		prefs = await SharedPreferences.getInstance();
		int bool = (prefs.getInt('counter'));
		if(bool == null) { bool = 0;}
		
		print(bool);
		
		setState(() {
			if (bool==1)
			{
				favButton = liked;
			} else {
				favButton = unliked;
			}
		});
	}
	
	
	Future playingStatus() async {
		bool isP = await FlutterRadio.isPlaying();
		print(isP);
		
		setState(() {
		  isPlaying = isP;
		  if(isP)
		  {
			  playPauseButton = pauseButton;
		  } else {
			  playPauseButton = playButton;
		  }
    });	
		
	}
	
	Future<void> audioStart() async 
	{
		await Future.delayed(Duration(milliseconds: 600));
		if(isPlaying){
			print('Audio Resume OK');
		} else {
			await FlutterRadio.audioStart();
			print('Audio Start OK');
		}
		await updateTitle();
	}
	
	
	Future<void> updateTitle() async 
	{	
		print('pop');
		TitleFetcher liveTitle = TitleFetcher();
		var hey = await liveTitle.copTitles();
		
		String playingNow = hey.toString().substring(18,hey.toString().length-2);
		String oldSong = (prefs.getString('song') ?? '');
		
		if (playingNow != oldSong)
		{			
			setState(() {
				title = playingNow;
				favButton = unliked;
			});
			await prefs.setInt('counter', 0);			
			await prefs.setString('song', playingNow);
		} else {
			setState(() {
				title = oldSong;
			});
		}
	}
	
	Future<void> loopOnSecondaryIsolate(int x) async 
	{
		print('we in');
		const time = const Duration(seconds:5);
		new Timer.periodic(time, (Timer t) async {await updateTitle();});
	}
	
  @override
  Widget build(BuildContext context) {
		
		
    return new Container(
      height: 420.0,
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: Mclipper(),
            child: Container(
              height: 370.0,
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0.0, 10.0),
                    blurRadius: 10.0)
              ]),
              child: Stack(
                children: <Widget>[
                  Image.asset("assets/photos/logo.jpg",
                      fit: BoxFit.fill, width: double.infinity, height:double.infinity),
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                          const Color(0x00000000),
                          const Color(0xD9333333)
                        ],
                            stops: [
                          0.0,
                          0.9
                        ],
                            begin: FractionalOffset(0.0, 0.0),
                            end: FractionalOffset(0.0, 1.0))),
                    child: Padding(
                      padding: EdgeInsets.only(top: 120.0, left: 95.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "-Live Now-",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontFamily: "SF-Pro-Display-Bold"),
                          ),
                          Text(
                            title,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontFamily: "SF-Pro-Display-Bold"),
														maxLines: 5,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 370.0,
            right: -20.0,
			width: MediaQuery.of(context).size.width,
            child: FractionalTranslation(
              translation: Offset(0.0, -0.5),
              child: Row(
				mainAxisAlignment:	MainAxisAlignment.spaceEvenly,	
				mainAxisSize: MainAxisSize.max,
                children: <Widget>[
										FloatingActionButton(
											backgroundColor: Color(0xFF2b2f37),
											onPressed: () async {
															  if(favButton !=  unliked)
															  {
																	await prefs.setInt('counter', 0);	
																	setState(() {
																		favButton = unliked;
																		Scaffold.of(context).showSnackBar(SnackBar(
																		content: Text("Song Unliked"),
																		duration:Duration(milliseconds:500),
																		elevation:4.0,));
																	});
															 } else {
																 await prefs.setInt('counter', 1);	
																 //await databaseMethods.likedSong(oldSong);
																 setState(() {
																  favButton = liked;
																	Scaffold.of(context).showSnackBar(SnackBar(
																		content: Text("Song Liked"),
																		duration:Duration(milliseconds:500),
																	elevation:4.0,));
																	});
															  }
															
															
															
														},
											child: favButton, 
											
										),
										
										SizedBox(width:10),
									
           
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: RaisedButton(
											elevation:4,
                      onPressed: () async {
											FlutterRadio.playOrPause(url: streamUrl);
											await Future.delayed(Duration(milliseconds: 500))
											.then((onValue) async { await playingStatus(); } );
											
										},
                      color: Color(0xFF2b2f37),
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: (MediaQuery.of(context).size.width/5) ),
                      child: playPauseButton,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HomeScreenBottomPart extends StatelessWidget {

	List<Widget> bottomBarIcons = [
																	Icon(Icons.share,color: Colors.white,size: 35.0,semanticLabel: 'Social Media Icon',),
																	Icon(Icons.send,color: Colors.white,size: 35.0,semanticLabel: 'Contact Station Icon',),
																	ImageIcon(AssetImage('assets/photos/donation.png'),color: Colors.white,size: 35.0,semanticLabel: 'Donations Icon',),		
																];
																
																
	

  @override
  Widget build(BuildContext context) {
    return Column(
		
			children: <Widget> [
				Container(
					
					height: MediaQuery.of(context).size.width >= 360 ? 250.0 : 300.0,
					width: 265,
					decoration: BoxDecoration(
						color: Color(0xFF2b2f37),
						borderRadius: BorderRadius.all(Radius.circular(20))
					),
					
					child: Column(
						children: <Widget>[
							Padding(
								padding: EdgeInsets.symmetric(horizontal: 50.0),
								child: Row(
									mainAxisAlignment: MainAxisAlignment.center,
									children: <Widget>[
										Text(
											"About Us",
											style: GoogleFonts.oswald(
								textStyle:TextStyle(fontSize: 22.0, color:Colors.white, letterSpacing: 3),
								),
							
										),
										
									],
								),
							),
							Container(
								width: 250,
								height: MediaQuery.of(context).size.width >= 360 ? 200.0 : 250,
								child: Center(
								 child: Text('Salt FM is a listener supported urban contemporary gospel radio station broadcasting 24 hours a day on the internet from 2 studios in the United Kingdom. The station is an arm of Verity Training and Consultancy Services which delivers access technology training to visually impaired clients.',
								
								style: GoogleFonts.oswald(
									textStyle:TextStyle(fontSize: 16.0, color:Colors.white, letterSpacing: 1.5),),
								textAlign: TextAlign.center,
													),
							)
					)
						],
					),
				),
				
				SizedBox(height: 20),
				
				Container(
					height: 55,
					width: 265,
					decoration: BoxDecoration(
						color: Color(0xFF2b2f37),
						borderRadius: BorderRadius.all(Radius.circular(20))
					),
					
					child: Row(
						mainAxisAlignment: MainAxisAlignment.spaceAround,
						children: <Widget>
						[
							Container(),
							Column(
								mainAxisAlignment: MainAxisAlignment.spaceEvenly,
								children: <Widget> [
									InkWell(
										child: bottomBarIcons[0],
										//tooltip: 'Click To Bring Up Social Media Popup',
										onTap: () async {
											await _showSocialDialog(context);
										},
									),
									Text('Connect', style:GoogleFonts.oswald(
									textStyle:TextStyle(fontSize: 10.0, color:Colors.white, letterSpacing: 1.5),),),
								],
							),
							VerticalDivider(),
							Column(
								mainAxisAlignment: MainAxisAlignment.spaceAround,
								children: <Widget> [
									InkWell(
										child: bottomBarIcons[1],
										//tooltip: 'Click To Bring Up Social Media Popup',
										onTap: () async {
											await _showContactDialog(context);
										},
									),
									Text('Contact', style:GoogleFonts.oswald(
									textStyle:TextStyle(fontSize: 10.0, color:Colors.white, letterSpacing: 1.5),),),
								],
							),
							VerticalDivider(),
							Column(
								mainAxisAlignment: MainAxisAlignment.spaceEvenly,
								children: <Widget> [
									InkWell(
										child: bottomBarIcons[2],
										//tooltip: 'Click To Bring Up Social Media Popup',
										onTap: () async {
											await _showDonateDialog(context);
										},
									),
									Text('Donate', style:GoogleFonts.oswald(
									textStyle:TextStyle(fontSize: 10.0, color:Colors.white, letterSpacing: 1.5),),),
								],
							),
							Container(),
						],
					),
				),
			]
		);
  }
	
	
	Future<void> _showSocialDialog(BuildContext context) async {
		List<Widget> socialIcons =  [
																ImageIcon(AssetImage('assets/photos/facebook.png'),color: Colors.white,size: 27.0,semanticLabel: 'Facebook Link',),	
																ImageIcon(AssetImage('assets/photos/twitter.png'),color: Colors.white,size: 27.0,semanticLabel: 'Twitter Link',),	
																ImageIcon(AssetImage('assets/photos/insta.png'),color: Colors.white,size: 27.0,semanticLabel: 'Instagram Link',),	
																ImageIcon(AssetImage('assets/photos/youtube.png'),color: Colors.white,size: 27.0,semanticLabel: 'YouTube Link',),	
																];
		
		return showDialog<void>(
			context: context,
			barrierDismissible: false, // user must tap button!
			builder: (BuildContext context) {
				return AlertDialog(
					title:
						Row(
							mainAxisAlignment: MainAxisAlignment.center,
							children:<Widget> [Text('Connect With Us On Social Media', style: GoogleFonts.oswald(
										textStyle:TextStyle(fontSize: 12.0, color:Colors.white, letterSpacing: 1.5),),),
										],),
					content: SingleChildScrollView(
						child: ListBody(
							children: <Widget>[
								SizedBox(height:20),
								Row(
									mainAxisAlignment: MainAxisAlignment.spaceAround,
									children: <Widget>
										[
											InkWell(child: socialIcons[0] , onTap: () => _launchURL('https://www.facebook.com/SaltFMUK/'), ),
											InkWell(child: socialIcons[1] , onTap: () => _launchURL('https://twitter.com/saltfm?lang=en'), ),
											InkWell(child: socialIcons[2] , onTap: () => _launchURL('https://www.instagram.com/saltfmuk/'), ),
											InkWell(child: socialIcons[3] , onTap: () => _launchURL('https://www.youtube.com/c/BIWSTBeInspiredWithShoggyTosh'), ),
										],
								),
							],
						),
					),
					actions: <Widget>[
						FlatButton(
							child: Text('Close', style: GoogleFonts.oswald(
										textStyle:TextStyle(fontSize: 10.0, color:Colors.white, letterSpacing: 1.5),),),
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

Future<void> _showContactDialog(BuildContext context) async {
	TextEditingController msg;
	Mailer mailer = Mailer();
	
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: 
				Row(
					mainAxisAlignment: MainAxisAlignment.center,
					children: <Widget>[Text('Message Us Directly With Our App', style: GoogleFonts.oswald(
									textStyle:TextStyle(fontSize: 12.0, color:Colors.white, letterSpacing: 1.5),),),
									]),
									
					
        content: SingleChildScrollView(
          child:Center(
						child:ListBody(
								children: <Widget>[
									Row(
										mainAxisAlignment: MainAxisAlignment.center,
										children: <Widget> [ Expanded( child:getMessageBarUI(msg),) ]
									),
									Column(
									crossAxisAlignment: CrossAxisAlignment.center,
									children: <Widget> [
									Text('Email Us At: studio@saltfm.com', style: GoogleFonts.oswald(
											textStyle:TextStyle(fontSize: 12.0, color:Colors.white, letterSpacing: 1.5),),),
									Text('Or Say Hello To Us On: +442071932560', style: GoogleFonts.oswald(
											textStyle:TextStyle(fontSize: 12.0, color:Colors.white, letterSpacing: 1.5),),),
									],
									)
								],
							),
						)
        ),
        actions: <Widget>[
					FlatButton(
            child: Text('Send', style: GoogleFonts.oswald(
									textStyle:TextStyle(fontSize: 10.0, color:Colors.white, letterSpacing: 1.5),),),
            onPressed: () async {
							//mailer
							await mailer.sendMail('he4yyyy');
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Close', style: GoogleFonts.oswald(
									textStyle:TextStyle(fontSize: 10.0, color:Colors.white, letterSpacing: 1.5),),),
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

Future<void> _showDonateDialog(BuildContext context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Support Us', style: GoogleFonts.oswald(
									textStyle:TextStyle(fontSize: 12.0, color:Colors.white, letterSpacing: 1.5),),),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
							
              Row(
								mainAxisAlignment: MainAxisAlignment.spaceAround,
								children: <Widget>[
								
								
																	Padding(
																		padding: const EdgeInsets.only(
																				left: 8, right: 8, bottom: 8, top: 8),
																		child: Container(
																			height: 38,
																			width: 100,
																			decoration: BoxDecoration(
																				color: Color(0xFF6471ed),
																				borderRadius: const BorderRadius.all(Radius.circular(24.0)),
																				boxShadow: <BoxShadow>[
																					BoxShadow(
																						color: Colors.grey.withOpacity(0.6),
																						blurRadius: 8,
																						offset: const Offset(4, 4),
																					),
																				],
																			),
																			child: Material(
																				color: Colors.transparent,
																				child: InkWell(
																					borderRadius: const BorderRadius.all(Radius.circular(24.0)),
																					highlightColor: Colors.transparent,
																					onTap: () {
																						_launchURL('https://www.paypal.com/paypalme/SaltFMUK');
																					},
																					child: Center(
																						child: Text(
																							'Donate',
																							style: TextStyle(
																									fontWeight: FontWeight.w500,
																									fontSize: 18,
																									color: Colors.white
																									),
																						),
																					),
																				),
																			),
																		),
																	),
																	
																	
																	
																	]
							),
							
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Close', style: GoogleFonts.oswald(
									textStyle:TextStyle(fontSize: 10.0, color:Colors.white, letterSpacing: 1.5),),),
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

	_launchURL(String url) async {
		
		if (await canLaunch(url)) {
			await launch(url);
		} else {
			throw 'Could not launch $url';
		}
	}
	
	  Widget getMessageBarUI(TextEditingController myController) {
			
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.white.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
										maxLines: 3,
										controller: myController,
                    onChanged: (String txt) { print(txt);},
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: Colors.white,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Send Message',
                    ),
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

class Mclipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 100.0);

    var controlpoint = Offset(35.0, size.height);
    var endpoint = Offset(size.width / 2, size.height);

    path.quadraticBezierTo(
        controlpoint.dx, controlpoint.dy, endpoint.dx, endpoint.dy);

    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
