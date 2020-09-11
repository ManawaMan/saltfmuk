import 'package:flutter/material.dart'; 
import 'dart:async';
import 'dart:collection';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Mailer
{
	
	
	Future<void> sendMail(String msg) async 
	{
		String username = 'noreply.inapp.mailer@gmail.com';
		String password = 'flutterapp123';
		String dest = 'd.adeoshun51@gmail.com';
		
		final smtpServer = gmail(username, password);
		
		final message = Message()
			..from = Address(username, 'Ade Ade')
			..recipients.add(dest)
			..subject = '${DateTime.now()}'
			..text = msg;

		try {
			final sendReport = await send(message, smtpServer);
			print('Message sent: ' + sendReport.toString());
		} on MailerException catch (e) {
			print('Message not sent.');
			print(e);
			for (var p in e.problems) {
				print('Problem: ${p.code}: ${p.msg}');
			}
		}
		
	}
	
}