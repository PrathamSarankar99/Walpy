import 'package:flutter/cupertino.dart';

class PixabayImage {
  int id;
  String type;
  String tags;
  String imageURL;
  int views;
  int downloads;
  int favorites;
  int likes;
  int comments;
  int uploaderid;
  String uploaderName;
  String uploaderImageURL;

  PixabayImage({
    this.comments = 0,
    this.downloads = 0,
    this.favorites = 0,
    @required this.id,
    @required this.imageURL,
    this.likes = 0,
    this.tags = '',
    @required this.type,
    @required this.uploaderImageURL,
    this.uploaderName = '',
    @required this.uploaderid,
    this.views = 0,
  });

  static Map<String, dynamic> toMap(PixabayImage image) {
    return {
      "id": image.id,
      "type": image.type,
      "tags": image.tags,
      "imageURL": image.imageURL,
      "views": image.views,
      "downloads": image.downloads,
      "favorites": image.favorites,
      "likes": image.likes,
      "comments": image.comments,
      "uploaderid": image.uploaderid,
      "uploaderName": image.uploaderName,
      "uploaderImageURL": image.uploaderImageURL
    };
  }

  static PixabayImage fromMap(Map<String, dynamic> map) {
    return PixabayImage(
      comments: map["comments"],
      downloads: map["downloads"],
      favorites: map["favorites"],
      id: map["id"],
      imageURL: map["imageURL"],
      likes: map["likes"],
      tags: map["tags"],
      type: map["type"],
      uploaderImageURL: map["uploaderImageURL"],
      uploaderName: map["uploaderName"],
      uploaderid: map["uploaderid"],
      views: map["views"],
    );
  }
}
