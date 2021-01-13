import 'package:dio/dio.dart';
import 'package:news_app/dio/api_services.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/secret.dart';

class HomePageApi {
  var _apiServices = ApiServices.apiServices;

  Future<NewsModel> getNews(int page) async {
    String url =
        "https://newsapi.org/v2/top-headlines?country=in&sortBy=publishedAt&language=en&pageSize=10&page=${page.toString()}&apiKey=${apiKey}";

    NewsModel _newsModel;
    try {
      final res = await _apiServices.provideGetRequest(url);
      _newsModel = NewsModel.fromMap(res);
    } on DioError catch (e) {
      print("Home Page Api Error" + e.toString());
      throw e;
    }
    return _newsModel;
  }
}
