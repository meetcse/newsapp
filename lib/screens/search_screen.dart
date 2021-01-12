import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:news_app/api/search_filter_api.dart';
import 'package:news_app/constants/strings.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/widgets/appbar.dart';
import 'package:news_app/widgets/news_card.dart';
import 'package:news_app/widgets/radio_list_widget.dart';

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
      //TODO: HANDLE ERROR IN UI
      print("ERROR : " + error.toString());
    });

    return _res;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //TODO: ADD PAGE dynamically
    _getNews = _getSearchNews(1);
  }

  _showFilter() {
    String country;
    String category;
    String language;
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            elevation: 5.0,
            child: Container(
              padding: const EdgeInsets.all(14),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Add Filter
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "ADD FILTER",
                        ),
                      ],
                    ), //TODO: HARDCODED

                    //Country
                    Text("Country"), //TODO: hardcoded text
                    RadioListWidget(
                      list: _countryMap,
                      groupValue: _country,
                      onChanged: (value) {
                        country = value;
                      },
                    ),
//Category
                    Text("Category"), //TODO: hardcoded text
                    RadioListWidget(
                      list: _categoryMap,
                      groupValue: _category,
                      onChanged: (value) {
                        category = value;
                      },
                    ),
//Language
                    Text("Language"), //TODO: hardcoded text
                    RadioListWidget(
                      list: _languageMap,
                      groupValue: _language,
                      onChanged: (value) {
                        language = value;
                      },
                    ),

                    //Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Cancel Button
                        Container(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Row(
                              children: [
                                Text(
                                  Strings.cancel,
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
                            highlightColor: Colors.transparent,
                            onPressed: () {
                              //TODO:
                              _country = country ?? null;
                              _category = category ?? null;
                              _language = language ?? null;
                              Navigator.of(context).pop();
                              _getNews = _getSearchNews(1);
                              setState(() {});
                            },
                            child: Row(
                              children: [
                                Text(
                                  Strings.apply,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: Strings.news, actions: [
        // Apply filters
        GestureDetector(
          onTap: () {
            //TODO:
            _showFilter();
          },
          child: Icon(CupertinoIcons.slider_horizontal_3),
        ),

        SizedBox(
          width: 8,
        ),
      ]),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: FutureBuilder(
            future: _getNews,
            builder: (context, AsyncSnapshot<NewsModel> newsModel) {
              NewsModel _newsModelData = newsModel.data;
              return newsModel.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextField(
                          onSubmitted: (value) {
                            //TODO:
                            _searchKeyword = value;

                            _getNews = _getSearchNews(1);
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            prefixIcon: Icon(CupertinoIcons.search),
                            hintText: Strings.search,
                          ),
                        ),
                        Expanded(child: _buildNewsList(_newsModelData)),
                      ],
                    );
            }),
      ),
    );
  }

  Widget _buildNewsList(NewsModel _newsModelData) {
    return Container(
      margin: EdgeInsets.only(top: 16),
      child: ListView.builder(
          itemCount: _newsModelData.articles.length,
          shrinkWrap: true,
          //TODO: ADD BOUNCING SCROLL PHYSICS on top
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemBuilder: (context, index) {
            return NewsCard(
              imgUrl: _newsModelData.articles[index].urlToImage ?? "",
              title: _newsModelData.articles[index].title ?? "",
              desc: _newsModelData.articles[index].description ?? "",
              content: _newsModelData.articles[index].content ?? "",
              posturl: _newsModelData.articles[index].articleUrl ?? "",
            );
          }),
    );
  }
}
