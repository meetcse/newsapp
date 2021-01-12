class NewsErrorModel {
  String status;
  String code;
  String message;

  NewsErrorModel.fromMap(Map<String, dynamic> json) {
    this.status = json['status'];
    this.code = json['code'];
    this.message = json['message'];
  }
}
