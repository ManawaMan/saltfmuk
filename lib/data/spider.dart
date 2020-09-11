import 'package:html/parser.dart' as html;
import 'package:http/http.dart';
import 'package:scrapy/scrapy.dart';

import 'model.dart';

class BlogSpider extends Spider<Quote, Quotes> {
  @override
  Stream<String> parse(Response response) async* {
    final document = html.parse(response.body);
    final nodes = document.querySelectorAll("td");
		var title;
		
    for (var node in nodes) {
      if (node.className != 'tablelist-schedule__time')
			{
				title = node.innerHtml;
				
				if(title.indexOf('ajax') != -1)
				{
					node = node.querySelector("a.ajax");
					title = node.innerHtml;
				}
				yield title;
			}
    }
  }

  @override
  Stream<String> transform(Stream<String> stream) async* {
    await for (String parsed in stream) {
      final transformed = parsed;
      yield transformed;
    }
  }
	
	List getTitles() {
		return cache;
	}

  @override
  Stream<Quote> save(Stream<String> stream) async* {
    await for (String transformed in stream) {
      final quote = Quote(quote: transformed);
      yield quote;
    }
  }
}
