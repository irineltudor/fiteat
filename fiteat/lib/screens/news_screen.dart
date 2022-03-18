import 'package:flutter/material.dart';

import '../model/news.dart';
import '../service/storage_service.dart';

class NewsScreen extends StatelessWidget{

  final News news;
  final Storage storage;

  const NewsScreen({Key? key,required this.news, required this.storage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 197, 201, 207),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background:  FutureBuilder(
                      future: storage.downloadURL('${news.image}'),
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
                        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData)
                            {
                              return Image.network(snapshot.data!,
                              width:300,
                              fit: BoxFit.fitWidth);
                            }
                          if(snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData){
                            return Container(
                              width: 300,
                              child: CircularProgressIndicator());
                          }
                  
                          return Container();
                      },
                                
                  
                    ),),
            )
          ],
        ),
      );
  }

}