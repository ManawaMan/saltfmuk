import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'package:scrapy/scrapy.dart';

import 'model.dart';
import 'spider.dart';
import 'storage.dart';

class TitleFetcher 
{

	Future copTitles() async 
	{
		//WidgetsFlutterBinding.ensureInitialized();
		final spider = BlogSpider();
		spider.name = "myspider";
		spider.client = Client();
		spider.startUrls = [
			"https://onlineradiobox.com/uk/saltuk/playlist/?cs=uk.saltuk",
		];
		//final storage = QuoteStorage();
		//final path = await storage.localPath;
		//spider.path = "$path/data.json";
		spider.cache = [];
		await spider.startRequests();
		var cache = spider.getTitles();
		
		return cache[0];
	}
	
}