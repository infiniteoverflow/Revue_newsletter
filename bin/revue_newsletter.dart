import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:web_scraper/web_scraper.dart';

class RevueNewsletter {
  Handler get handler {
    var router = Router();

    router.post('/newsletter', (Request request) async {
      // Get details for the issue cover
      String getIdAddress =
          'div.container > section > div[id=issues-covers] > a > article > div > time > span > span';
      List<String> idAddressAttribute = [];

      String getTitleAddress =
          'div.container > section > div[id=issues-covers] > a > article > div > h1';
      List<String> titleAddressAttribute = [];

      String dateAddress =
          'div.container > section > div[id=issues-covers] > a > article > div > time';
      List<String> dateAddressAttribute = ['datetime'];

      String getCoverUrlAddress =
          'div.container > section > div[id=issues-covers] > a > article';
      List<String> coverUrlAddressAttribute = ['style'];

      String getArticleUrlAddress =
          'div.container > section > div[id=issues-covers] > a';
      List<String> articleUrlAddressAttribute = ['href'];

      // Get details about the issue list
      String getIssueListIdAddress =
          'div.container > section > div[id=issues-holder] > div[id=issues-list] > ul > li > article.issue > div.issue-nr';
      List<String> issueListIdAddressAttribute = [];

      String getIssueListTitleAddress =
          'div.container > section > div[id=issues-holder] > div[id=issues-list] > ul > li > article.issue > div.issue-title > h1 > a > span.subject';
      List<String> issueListTitleAddressAttribute = [];

      String getIssueListDateAddress =
          'div.container > section > div[id=issues-holder] > div[id=issues-list] > ul > li > article.issue > div.issue-date > time';
      List<String> issueListDateAddressAttribute = ['datetime'];

      String getIssueListArticleUrlAddress =
          'div.container > section > div[id=issues-holder] > div[id=issues-list] > ul > li > article.issue > div.issue-title > h1 > a';
      List<String> issueListArticleUrlAddressAttribute = ['href'];

      var payload = await request.readAsString();
      if (payload.isEmpty) {
        return Response.notFound(
            jsonEncode(
                {'success': false, 'error': 'Please pass the user profile'}),
            headers: {'Content-Type': 'application/json'});
      }

      Map<String, dynamic> result = {
        'issue-cover': [],
        'issue-list': [],
        'success': true
      };

      Map<String, dynamic> payloadMap = jsonDecode(payload);

      final webScraper = WebScraper('https://www.getrevue.co');
      List<Map<String, dynamic>> ids = [];
      List<Map<String, dynamic>> titles = [];
      List<Map<String, dynamic>> dates = [];
      List<Map<String, dynamic>> coverUrls = [];
      List<Map<String, dynamic>> articleUrls = [];

      List<Map<String, dynamic>> issueListIds = [];
      List<Map<String, dynamic>> issueListTitles = [];
      List<Map<String, dynamic>> issueListDates = [];
      List<Map<String, dynamic>> issueListArticleUrls = [];

      if (await webScraper.loadWebPage('/profile/${payloadMap["profile"]}')) {
        ids = webScraper.getElement(getIdAddress, idAddressAttribute);
        titles = webScraper.getElement(getTitleAddress, titleAddressAttribute);
        dates = webScraper.getElement(dateAddress, dateAddressAttribute);
        coverUrls =
            webScraper.getElement(getCoverUrlAddress, coverUrlAddressAttribute);
        articleUrls = webScraper.getElement(
            getArticleUrlAddress, articleUrlAddressAttribute);

        issueListIds = webScraper.getElement(
            getIssueListIdAddress, issueListIdAddressAttribute);
        issueListTitles = webScraper.getElement(
            getIssueListTitleAddress, issueListTitleAddressAttribute);
        issueListDates = webScraper.getElement(
            getIssueListDateAddress, issueListDateAddressAttribute);
        issueListArticleUrls = webScraper.getElement(
            getIssueListArticleUrlAddress, issueListArticleUrlAddressAttribute);
      }

      for (int i = 0; i < ids.length; i++) {
        Map<String, dynamic> issueCover = {
          'id': ids[i]['title'],
          'title': titles[i]['title'],
          'datetime': dates[i]['attributes']['datetime'],
          'coverUrl': getUrl(coverUrls[i]['attributes']['style']),
          'articleUrl':
              'https://www.getrevue.co' + articleUrls[i]['attributes']['href']
        };
        result['issue-cover'].add(issueCover);
      }

      for (int i = 0; i < issueListIds.length; i++) {
        Map<String, dynamic> issueList = {
          'id': issueListIds[i]['title'],
          'title': issueListTitles[i]['title'],
          'datetime': issueListDates[i]['attributes']['datetime'],
          'articleUrl': 'https://www.getrevue.co' + issueListArticleUrls[i]['attributes']['href']
        };
        result['issue-list'].add(issueList);
      }

      return Response.ok(jsonEncode(result),
          headers: {'Content-Type': 'application/json'});
    });

    return router;
  }

  String getUrl(String? url) {
    if (url == null) return '';
    return url.split("'")[1];
  }
}
