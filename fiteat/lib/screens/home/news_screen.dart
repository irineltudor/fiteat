import 'package:flutter/material.dart';

import '../../model/news.dart';
import '../../service/storage_service.dart';

class NewsScreen extends StatelessWidget {
  News news;
  Storage storage = Storage();

  NewsScreen({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final headings = news.headings;
    final infoHeadings = news.infoHeadings; 
    return Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            snap: true,
            floating: true,
            backgroundColor: const Color(0xFFfc7b78),
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
                          child: FutureBuilder(
                            future: storage.downloadURL('${news.image}'),
                            builder: (BuildContext context, AsyncSnapshot<String> snapshot){
                              if(snapshot.connectionState == ConnectionState.done && snapshot.hasData)
                                  {
                                    return Image.network(snapshot.data!,
                                    width: width,
                                    fit: BoxFit.cover);
                                  }
                                if(snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData){
                                  return Center(
                                    child: Container(
                                      width: 150,
                                      height: 150,
                                      child: CircularProgressIndicator(color: Colors.white,),
                                      color: const Color(0xFFfc7b78),),
                                  );
                                }
                        
                                return Container();
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
                    '${news.type}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                  subtitle: Text(
                    '${news.title}',
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
                    "${news.summary}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ]
          )
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
     
                if(index < headings!.length){
                  
                final title = headings[index];
                final info = infoHeadings?[index];

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 10),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
                  child: Text(
                    info,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                  ],
                );
                }
              }
            ),)
           
        ]
    ));
  }
}
