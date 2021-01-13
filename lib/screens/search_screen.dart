import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:news_app/api/search_filter_api.dart';
import 'package:news_app/constants/strings.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/widgets/appbar.dart';
import 'package:news_app/widgets/custom_progress_indicator.dart';
import 'package:news_app/widgets/message_flushbar.dart';
import 'package:news_app/widgets/news_card.dart';
import 'package:news_app/widgets/chip_option_list_widget.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchKeyword;
  String _country;
  String _category;
  String _language;
  Future<NewsModel> _getNews;
  int _pageCount = 1;
  bool _isError = false;
  List<Article> _showNewsList = List();

  String _sort;
  bool _isSort = false;

  int _totalResults;
  bool _isEnd = false;

  ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _sortMap = [
    {
      "id": "recent",
      "value": "Recent First",
    }
  ];

  List<Map<String, dynamic>> _countryMap = [
    {
      "id": "in",
      "value": "India",
    },
    {
      "id": "ae",
      "value": "United Arab Emirates",
    },
    {
      "id": "de",
      "value": "Germany",
    },
    {
      "id": "ro",
      "value": "Romania",
    },
    {
      "id": "us",
      "value": "United States of America",
    },
  ];

  List<Map<String, dynamic>> _categoryMap = [
    {
      "id": "business",
      "value": "Business",
    },
    {
      "id": "entertainment",
      "value": "Entertainment",
    },
    {
      "id": "general",
      "value": "General",
    },
    {
      "id": "health",
      "value": "Health",
    },
    {
      "id": "science",
      "value": "Science",
    },
    {
      "id": "sports",
      "value": "Sports",
    },
    {
      "id": "technology",
      "value": "Technology",
    },
  ];

  List<Map<String, dynamic>> _languageMap = [
    {
      "id": "de",
      "value": "German",
    },
    {
      "id": "en",
      "value": "English",
    },
    {
      "id": "fr",
      "value": "French",
    },
    {
      "id": "it",
      "value": "Italian",
    },
    {
      "id": "ru",
      "value": "Russian",
    },
  ];

  Future<NewsModel> _getSearchNews(int page) async {
    SearchFilterApi _searchApi = SearchFilterApi();

    NewsModel _res = await _searchApi
        .getSearchAndFilterNews(_searchKeyword, page,
            category: _category, country: _country, language: _language)
        .catchError((error) {
      print("ERROR : " + error.toString());
      _isError = true;
      MessageFlushbar.showMessageFlushbar(
          context, Strings.error, Strings.somethingWentWrong, true);
      setState(() {});
    });
    if (_res.isError) {
      _isError = true;
      MessageFlushbar.showMessageFlushbar(
          context, Strings.error, _res.errorModel.message, true);
      setState(() {});
    } else {
      _totalResults = _res.totalResults;

      _res.articles.forEach((element) {
        _showNewsList.add(element);
      });
      setState(() {});
    }

    return _res;
  }

  @override
  void initState() {
    super.initState();
    _getNews = _getSearchNews(1);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_pageCount * 10 < _totalResults) {
          _pageCount++;
          _getNews = _getSearchNews(_pageCount);
        } else {
          _isEnd = true;
          setState(() {});
        }
      }
    });
  }

  _showFilter() {
    String country;
    String category;
    String language;
    String sort;
    bool isSort;
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 22, vertical: 44),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            elevation: 5.0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: const EdgeInsets.only(left: 8, right: 8),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    //Add Filter
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: 12,
                            bottom: 12,
                          ),
                          child: Text(Strings.addFilter,
                              style: Theme.of(context).textTheme.headline1),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    //Country
                    Row(
                      children: [
                        Expanded(
                            child: Divider(
                          indent: 5,
                          endIndent: 5,
                        )),
                        Text(
                          Strings.country,
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        Expanded(
                            child: Divider(
                          indent: 5,
                          endIndent: 5,
                        )),
                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    ChipOptionListWidget(
                      list: _countryMap,
                      groupValue: _country,
                      onChanged: (value) {
                        country = value;
                      },
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    //Category
                    Row(
                      children: [
                        Expanded(
                            child: Divider(
                          indent: 5,
                          endIndent: 5,
                        )),
                        Text(
                          Strings.category,
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        Expanded(
                            child: Divider(
                          indent: 5,
                          endIndent: 5,
                        )),
                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    ChipOptionListWidget(
                      list: _categoryMap,
                      groupValue: _category,
                      onChanged: (value) {
                        category = value;
                      },
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    //Language
                    Row(
                      children: [
                        Expanded(
                            child: Divider(
                          indent: 5,
                          endIndent: 5,
                        )),
                        Text(
                          Strings.language,
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        Expanded(
                            child: Divider(
                          indent: 5,
                          endIndent: 5,
                        )),
                      ],
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    ChipOptionListWidget(
                      list: _languageMap,
                      groupValue: _language,
                      onChanged: (value) {
                        language = value;
                      },
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    //Sort By
                    Row(
                      children: [
                        Expanded(
                            child: Divider(
                          indent: 5,
                          endIndent: 5,
                        )),
                        Text(
                          Strings.sortBy,
                          style: Theme.of(context).textTheme.headline2,
                        ),
                        Expanded(
                            child: Divider(
                          indent: 5,
                          endIndent: 5,
                        )),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ChipOptionListWidget(
                      list: _sortMap,
                      groupValue: _sort,
                      onChanged: (value) {
                        sort = value;
                        isSort = true;
                      },
                    ),

                    SizedBox(
                      height: 10,
                    ),
                    //Buttons
                    Container(
                      margin: const EdgeInsets.only(left: 12, right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //Cancel Button
                          Container(
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              splashColor: Colors.transparent,
                              // highlightColor: Colors.transparent,
                              color: Theme.of(context).buttonColor,
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                children: [
                                  Text(
                                    Strings.cancel,
                                    style: Theme.of(context).textTheme.button,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          //Apply button
                          Container(
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              splashColor: Colors.transparent,
                              // highlightColor: Colors.transparent,
                              onPressed: () {
                                _country = country ?? _country ?? null;
                                _category = category ?? _category ?? null;
                                _language = language ?? _language ?? null;
                                _sort = sort ?? _sort ?? null;
                                _isSort = isSort ?? _isSort ?? false;
                                Navigator.of(context).pop();
                                _showNewsList.clear();
                                _totalResults = 0;
                                _getNews = _getSearchNews(1);
                                _getNews.then((value) {
                                  if (_isSort) {
                                    sortByRecent();
                                  }
                                });
                                setState(() {});
                              },
                              child: Row(
                                children: [
                                  Text(
                                    Strings.apply,
                                    style: Theme.of(context).textTheme.button,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  sortByRecent() {
    var sortList = _showNewsList;
    sortList.sort((a, b) {
      return a.publshedAt.compareTo(b.publshedAt);
    });
    _showNewsList = sortList.reversed.toList();
    _showNewsList.forEach((element) {
      print("PUBLISH : " + element.publshedAt.toString());
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.myAppBar(context, title: Strings.discover, actions: [
        // Apply filters
        Container(
          padding: const EdgeInsets.only(right: 14),
          child: GestureDetector(
            onTap: () {
              _showFilter();
            },
            child: Icon(CupertinoIcons.slider_horizontal_3),
          ),
        ),

        SizedBox(
          width: 8,
        ),
      ]),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder(
            future: _getNews,
            builder: (context, AsyncSnapshot<NewsModel> newsModel) {
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
                                _getNews = _getSearchNews(1);
                              },
                              child: Icon(
                                CupertinoIcons.refresh,
                                size: 48,
                              ))
                        ],
                      ),
                    )
                  : !newsModel.hasData || _showNewsList.isEmpty
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
                            _getNews = _getSearchNews(1);
                          },
                          child: Container(
                            color: Colors.grey[50],
                            child: SingleChildScrollView(
                              controller: _scrollController,
                              physics: BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics()),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.all(12),
                                    child: TextField(
                                      onSubmitted: (value) {
                                        _searchKeyword = value;
                                        _showNewsList.clear();
                                        setState(() {});
                                        _getNews = _getSearchNews(1);
                                      },
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(28),
                                        ),
                                        prefixIcon: Icon(CupertinoIcons.search),
                                        hintText: Strings.search,
                                        hintStyle: Theme.of(context)
                                            .textTheme
                                            .subtitle1,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                      fit: FlexFit.loose,
                                      child: _buildNewsList()),
                                ],
                              ),
                            ),
                          ),
                        );
            }),
      ),
    );
  }

  Widget _buildNewsList() {
    return Container(
      margin: EdgeInsets.only(top: 8),
      child: ListView.builder(
          itemCount: _showNewsList.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return NewsCard(
              imgUrl: _showNewsList[index].urlToImage ?? "",
              title: _showNewsList[index].title ?? "",
              desc: _showNewsList[index].description ?? "",
              content: _showNewsList[index].content ?? "",
              posturl: _showNewsList[index].articleUrl ?? "",
              isLoading:
                  index == _showNewsList.length - 1 && _showNewsList.length > 1
                      ? !_isEnd
                          ? true
                          : false
                      : false,
            );
          }),
    );
  }
}
