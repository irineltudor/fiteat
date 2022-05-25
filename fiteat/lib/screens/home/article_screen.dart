import 'package:flutter/material.dart';
import 'package:newsapi/newsapi.dart';

import '../../model/news.dart';
import '../../service/storage_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleScreen extends StatelessWidget {
  Article article;
  Storage storage = Storage();

  ArticleScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    var pos = article.description.indexOf('.');
    String summary = ( pos != -1 ) ? article.description.substring(0,pos) : article.description;

    final headings = article.title;
    final infoHeadings = article.author; 

    pos = article.content.lastIndexOf('[');
    final content = ( pos != -1 ) ? article.content.substring(0,pos) : article.content;

    final readMore = Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(30),
      color: Color.fromARGB(255, 19, 147, 221),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Colors.white)),
        minWidth: MediaQuery.of(context).size.width / 1.5,
        onPressed: () => _launchURL(article.url),
        child: const Text(
          "Read More...",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            snap: true,
            floating: true,
            backgroundColor: Color.fromARGB(255, 19, 147, 221),
            expandedHeight: 200,
            iconTheme: IconThemeData(color: Colors.redAccent,size: 25),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(40))),
            flexibleSpace: FlexibleSpaceBar(
              background: ClipRRect(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                        fit:FlexFit.tight,
                        child:  ClipRRect(
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                          child: Image.network(article.urlToImage,
                                width:300,
                                fit: BoxFit.fitWidth,
                                errorBuilder: (context,url,error){
                                  return Container(
                                    color: Color.fromARGB(255, 19, 147, 221) , 
                                  child: Center(
                                    child: Text('Health News',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900
                                    ),),
                                  ),);
                                },
                    ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
            [SizedBox(
                  height: 20,
                ),
                ListTile(
                  title: Text(
                   'Health',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  subtitle: Text(
                    article.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 26,
                      color: Colors.black,
                    ),
                  ),
                ),
            SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Summary",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
                  child: Text(
                    summary,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Content",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
                  child: Text(
                    content,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                 Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: readMore
                ),
                ]
          )
          ),
          // SliverList(
          //   delegate: SliverChildBuilderDelegate(
          //     (BuildContext context, int index) {
     
          //       if(index < headings!.length){
                  
          //       final title = headings[index];
          //       final info = infoHeadings?[index];

          //       return Column(
          //         mainAxisAlignment: MainAxisAlignment.start,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //       SizedBox(
          //         height: 20,
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
          //         child: Text(
          //           title,
          //           style: TextStyle(
          //             fontWeight: FontWeight.w800,
          //             fontSize: 18,
          //             color: Colors.blueGrey,
          //           ),
          //         ),
          //       ),
          //       Padding(
          //         padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
          //         child: Text(
          //           info,
          //           style: TextStyle(
          //             fontSize: 16,
          //             fontWeight: FontWeight.w500,
          //           ),
          //         ),
          //       ),
          //         ],
          //       );
          //       }
          //     }
          //   ),)
           
        ]
    ));
  }

  _launchURL(url) async {
    Uri _url = Uri.parse(url);
  if (!await launchUrl(_url)) throw 'Could not launch $_url';
}
}
