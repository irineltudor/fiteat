class News{
  String? type;
  String? title;
  String? summary;
  String? information;
  String? image;

  News({this.type,this.title,this.summary,this.information,this.image});

  // data from server
  factory News.fromMap(map){
    return News(
      type: map['type'],
      title : map['title'],
      summary: map['summary'],
      information: map['information'],
      image: map['image']
    );
  }

  // sendig data to our server
  Map<String, dynamic> toMap(){
    return {
      'type': type,
      'title': title,
      'summary': summary,
      'information': information,
      'image': image
    };
  }
}