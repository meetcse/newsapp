import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/widgets/custom_progress_indicator.dart';
import 'package:news_app/widgets/detail_news_screen.dart';

class NewsCard extends StatelessWidget {
  final String imgUrl, title, desc, content, posturl;
  final bool isLoading;

  NewsCard(
      {this.imgUrl,
      this.desc,
      this.title,
      this.content,
      this.isLoading = false,
      @required this.posturl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailNewsScreen(
                      postUrl: posturl,
                      title: title,
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 18),
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(14),
                  ),
                ),
                color: Colors.white,
                elevation: 5,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  // decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.only(
                  //         bottomRight: Radius.circular(6),
                  //         bottomLeft: Radius.circular(6))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: imgUrl,
                          placeholder: (context, url) {
                            return Center(child: CustomProgressIndicator());
                          },
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          left: 8,
                          right: 8,
                          top: 12,
                        ),
                        child: Text(
                          title,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.headline4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          right: 8,
                          left: 8,
                          top: 8,
                          bottom: 12,
                        ),
                        child: Text(
                          desc,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              isLoading
                  ? Container(
                      margin: const EdgeInsets.only(top: 14, bottom: 8),
                      child: Center(child: CustomProgressIndicator()))
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
