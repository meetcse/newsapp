import 'package:dio/dio.dart';
import 'package:news_app/dio/api_services.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/secret.dart';

class SearchFilterApi {
  var _apiServices = ApiServices.apiServices;

  Future<NewsModel> getSearchAndFilterNews(String search, int page,
      {String country, String category, String language}) async {
    NewsModel _newsModel;
    String url;
    //TODO: ADD PAGESIZE AND PAGE TO URL
    country ??= "in";
    category ??= "business";
    language ??= "en";

    if (search == null) {
      url =
          "https://newsapi.org/v2/top-headlines?country=$country&language=${language}&category=$category&apiKey=${apiKey}";
      print("URL IS : " + url);
      print("URL IS : " + country);
    } else {
      url =
          "https://newsapi.org/v2/top-headlines?q=${search}&country=${country}&language=${language}&category=${category}&apiKey=${apiKey}";
    }

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
