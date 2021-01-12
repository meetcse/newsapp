import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/api/homepage_api.dart';
import 'package:news_app/constants/strings.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/widgets/appbar.dart';
import 'package:news_app/widgets/news_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<NewsModel> _getNews;

  Future<NewsModel> getNews() async {
    HomePageApi _homePageApi = HomePageApi();

    NewsModel _res = await _homePageApi.getNews().catchError((error) {
      //TODO: HANDLE ERROR IN UI
      print("ERROR : " + error.toString());
    });
    return _res;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getNews = getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: Strings.news, actions: [
        //Search in news feed
        GestureDetector(
            onTap: () {
              //TODO:
            },
            child: Icon(CupertinoIcons.search)),
        SizedBox(
          width: 8,
        ),
        // Apply filters
        GestureDetector(
            onTap: () {
              //TODO:
            },
            child: Icon(CupertinoIcons.slider_horizontal_3)),

        SizedBox(
          width: 8,
        ),
      ]),
      body: SafeArea(
        child: FutureBuilder(
            future: _getNews,
            builder: (context, AsyncSnapshot<NewsModel> _newsModel) {
              NewsModel _newsModelData = _newsModel.data;

              return !_newsModel.hasData
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: <Widget>[
                          /// News Article
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 16),
                              child: ListView.builder(
                                  itemCount: _newsModelData.articles.length,
                                  shrinkWrap: true,
                                  //TODO: ADD BOUNCING SCROLL PHYSICS on top
                                  physics: BouncingScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics()),
                                  itemBuilder: (context, index) {
                                    return NewsCard(
                                      imgUrl: _newsModelData
                                              .articles[index].urlToImage ??
                                          "",
                                      title: _newsModelData
                                              .articles[index].title ??
                                          "",
                                      desc: _newsModelData
                                              .articles[index].description ??
                                          "",
                                      content: _newsModelData
                                              .articles[index].content ??
                                          "",
                                      posturl: _newsModelData
                                              .articles[index].articleUrl ??
                                          "",
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                    );
            }),
      ),
    );
  }
}
