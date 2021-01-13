import 'package:news_app/models/news_error_model.dart';

class NewsModel {
  String status;
  List<Article> articles;
  int totalResults;
  bool isError;
  NewsErrorModel errorModel;

  NewsModel.fromMap(Map<String, dynamic> json) {
    this.status = json['status'];

    if (status == "ok" && json['articles'] != null) {
      isError = false;
      this.totalResults = json['totalResults'];
      List<dynamic> _articles = json["articles"];
      this.articles = _articles.map((element) {
        return Article.fromMap(element);
      }).toList();
    } else {
      isError = true;
      errorModel = NewsErrorModel.fromMap(json);
    }
  }
}

class Article {
  String title;
  String author;
  String description;
  String urlToImage;
  DateTime publshedAt;
  String content;
  String articleUrl;

  Article.fromMap(Map<String, dynamic> json) {
    this.title = json['title'];
    this.author = json['author'];
    this.description = json['description'];
    this.urlToImage = json['urlToImage'];
    this.publshedAt = DateTime.parse(json['publishedAt']);
    this.content = json["content"];
    this.articleUrl = json["url"];
  }
}
