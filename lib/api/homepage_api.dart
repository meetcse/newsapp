import 'package:dio/dio.dart';
import 'package:news_app/dio/api_services.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/secret.dart';

class HomePageApi {
  var _apiServices = ApiServices.apiServices;
  String url =
      "https://newsapi.org/v2/top-headlines?country=in&sortBy=publishedAt&language=en&apiKey=${apiKey}";

  Future<NewsModel> getNews() async {
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
