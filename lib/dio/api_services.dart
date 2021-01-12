import 'package:dio/dio.dart';
import 'package:news_app/dio/dio_error_util.dart';

class ApiServices {
  // String url;
  ApiServices._() {
    dioOptions();
  }

  // ApiServices(this.url);
  static final ApiServices apiServices = ApiServices._();
  static Dio dio = Dio();

  dioOptions() {
    dio
      ..options.responseType = ResponseType.json
      ..options.headers = {'Content-Type': 'application/json; charset=utf-8'}
      ..interceptors.add(LogInterceptor(
        request: true,
        responseBody: true,
        requestBody: true,
        requestHeader: true,
      ));
  }

  provideGetRequest(String url) async {
    var errorMessage;
    Response res = await dio.get(url).catchError((error) {
      errorMessage = DioErrorUtil.handleError(error);
      print("ERROR in API RES : " + errorMessage);
      throw error;
    });
    return res.data;
  }
}
