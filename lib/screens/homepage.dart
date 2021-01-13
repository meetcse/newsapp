import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:news_app/api/homepage_api.dart';
import 'package:news_app/constants/strings.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/screens/search_screen.dart';
import 'package:news_app/widgets/appbar.dart';
import 'package:news_app/widgets/custom_progress_indicator.dart';
import 'package:news_app/widgets/message_flushbar.dart';
import 'package:news_app/widgets/news_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<NewsModel> _getNews;
  int _pageCount = 1;
  bool _isError = false;
  List<Article> _showNewsList = List();

  int _totalResults;
  bool _isEnd = false;

  ScrollController _scrollController = ScrollController();

  Future<NewsModel> getNews(int page) async {
    HomePageApi _homePageApi = HomePageApi();

    NewsModel _apiRes = await _homePageApi.getNews(page).catchError((error) {
      print("ERROR : " + error.toString());
      _isError = true;
      MessageFlushbar.showMessageFlushbar(
          context, Strings.error, Strings.somethingWentWrong, true);
      setState(() {});
    });
    if (_apiRes.isError) {
      _isError = true;
      MessageFlushbar.showMessageFlushbar(
          context, Strings.error, _apiRes.errorModel.message, true);
      setState(() {});
    } else {
      if (_totalResults == null) {
        _totalResults = _apiRes.totalResults;
      }

      _apiRes.articles.forEach((element) {
        _showNewsList.add(element);
      });
      setState(() {});
    }
    return _apiRes;
  }

  @override
  void initState() {
    super.initState();
    _getNews = getNews(1);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_pageCount * 10 < _totalResults) {
          _pageCount++;
          _getNews = getNews(_pageCount);
        } else {
          _isEnd = true;
          setState(() {});
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.myAppBar(
        context,
        title: Strings.topHeadlines,
        actions: [
          //Search in news feed
          Container(
            padding: const EdgeInsets.only(right: 14),
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return SearchScreen();
                    }),
                  );
                },
                child: Icon(CupertinoIcons.search)),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: _getNews,
            builder: (context, AsyncSnapshot<NewsModel> _newsModel) {
              return _isError
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.exclamationmark_triangle_fill,
                            color: Colors.red,
                            size: 48,
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          Text(Strings.somethingWentWrong,
                              style: Theme.of(context).textTheme.bodyText1),
                          SizedBox(
                            height: 14,
                          ),
                          GestureDetector(
                              onTap: () {
                                _isError = false;
                                _showNewsList.clear();
                                setState(() {});
                                _getNews = getNews(1);
                              },
                              child: Icon(
                                CupertinoIcons.refresh,
                                size: 48,
                              ))
                        ],
                      ),
                    )
                  : !_newsModel.hasData || _showNewsList.isEmpty
                      ? Center(
                          child: CustomProgressIndicator(),
                        )
                      : LiquidPullToRefresh(
                          backgroundColor: Colors.white,
                          color: Theme.of(context).primaryColor,
                          showChildOpacityTransition: false,
                          animSpeedFactor: 2,
                          height: 50,
                          onRefresh: () async {
                            _showNewsList.clear();
                            setState(() {});
                            _getNews = getNews(1);
                          },
                          child: Container(
                            color: Colors.grey[50],
                            height: MediaQuery.of(context).size.height,
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              physics: BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Container(),

                                  /// News Article
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: Container(
                                      margin: EdgeInsets.only(top: 16),
                                      child: ListView.builder(
                                          itemCount: _showNewsList.length,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            return NewsCard(
                                              imgUrl: _showNewsList[index]
                                                      .urlToImage ??
                                                  "",
                                              title:
                                                  _showNewsList[index].title ??
                                                      "",
                                              desc: _showNewsList[index]
                                                      .description ??
                                                  "",
                                              content: _showNewsList[index]
                                                      .content ??
                                                  "",
                                              posturl: _showNewsList[index]
                                                      .articleUrl ??
                                                  "",
                                              isLoading: index ==
                                                          _showNewsList.length -
                                                              1 &&
                                                      _showNewsList.length > 1
                                                  ? !_isEnd
                                                      ? true
                                                      : false
                                                  : false,
                                            );
                                          }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
            }),
      ),
    );
  }
}
