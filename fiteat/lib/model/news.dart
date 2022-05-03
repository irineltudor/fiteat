class News{
  String? type;
  String? title;
  String? summary;
  String? image;
  List<dynamic>? headings;
  List<dynamic>? infoHeadings;

  News({this.type,this.title,this.summary,this.image,required this.headings,required this.infoHeadings});

  // data from server
  factory News.fromMap(map){
    return News(
      type: map['type'],
      title : map['title'],
      summary: map['summary'],
      image: map['image'],
      headings: map['headings'],
      infoHeadings: map['infoHeadings']
    );
  }

  // sendig data to our server
  Map<String, dynamic> toMap(){
    return {
      'type': type,
      'title': title,
      'summary': summary,
      'image': image,
      'headings' : headings,
      'infoHeadings' : infoHeadings
    };
  }
}