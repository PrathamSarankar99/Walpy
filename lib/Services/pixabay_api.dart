import 'dart:convert';
import 'dart:math';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:walpy/Modals/Categories.dart';
import 'package:walpy/Modals/pixabay_image.dart';

class PixabayApi {
  static Future<List<PixabayImage>> getBestOfMonthList() async {
    String category = CategoryName[Random().nextInt(CategoryName.length)];
    bool isSafeSearch = Hive.isBoxOpen("SETTINGS")
        ? Hive.box("SETTINGS").get("SAFE_SEARCH")
        : true;
    var url =
        'https://pixabay.com/api/?key=21504212-43b26d6818202098dc2c96c14&category=$category"';
    var response = await http.get(Uri.parse(url));
    if (isSafeSearch != null) {
      url += '&safesearch=$isSafeSearch';
    }
    var map = jsonDecode(response.body);
    List<PixabayImage> images = List.from(map["hits"])
        .map(
          (e) => PixabayImage(
            views: e["views"],
            comments: e["comments"],
            downloads: e["downloads"],
            favorites: e["favorites"],
            id: e["id"],
            imageURL: e["largeImageURL"],
            likes: e["likes"],
            tags: e["tags"],
            type: e["type"],
            uploaderImageURL: e["userImageURL"],
            uploaderName: e["user"],
            uploaderid: e["user_id"],
          ),
        )
        .toList();

    return images;
  }

  static Future<PixabayImage> getUrl(String categoryName) async {
    int randompage = Random().nextInt(5);
    var url =
        'https://pixabay.com/api/?key=21504212-43b26d6818202098dc2c96c14&category=$categoryName&&orientation="vertical"&editors_choice=true';
    if (Hive.box("SETTINGS").get("SAFE_SEARCH") != null) {
      url += '&safesearch=${Hive.box("SETTINGS").get("SAFE_SEARCH")}';
    }
    var response = await http.get(Uri.parse(url));
    var map = jsonDecode(response.body);
    var image = List.from(map["hits"])[randompage];
    return PixabayImage(
      views: image["views"],
      comments: image["comments"],
      downloads: image["downloads"],
      favorites: image["favorites"],
      id: image["id"],
      imageURL: image["largeImageURL"],
      likes: image["likes"],
      tags: image["tags"],
      type: image["type"],
      uploaderImageURL: image["userImageURL"],
      uploaderName: image["user"],
      uploaderid: image["user_id"],
    );
  }

  static Future<Map<String, dynamic>> queryResult(
      String category, double pageno, String query, String color) async {
    var url =
        'https://pixabay.com/api/?key=21504212-43b26d6818202098dc2c96c14&safesearch=true&order="latest"&image_type="photo"&perpage=20&page=${pageno.floor()}';
    if (category.isNotEmpty) {
      url += '&category=$category';
    }
    if (query.isNotEmpty) {
      url += '&q=$query';
    }
    if (color.isNotEmpty) {
      url += '&colors=$color';
    }
    if (Hive.box("SETTINGS").get("SAFE_SEARCH") != null) {
      url += '&safesearch=${Hive.box("SETTINGS").get("SAFE_SEARCH")}';
    }

    var response = await http.get(Uri.parse(url));
    var map = jsonDecode(response.body);
    var totalimages = map["totalHits"];
    var images = List.from(map["hits"])
        .map((e) => PixabayImage(
              views: e["views"],
              comments: e["comments"],
              downloads: e["downloads"],
              favorites: e["favorites"],
              id: e["id"],
              imageURL: e["largeImageURL"],
              likes: e["likes"],
              tags: e["tags"],
              type: e["type"],
              uploaderImageURL: e["userImageURL"],
              uploaderName: e["user"],
              uploaderid: e["user_id"],
            ))
        .toList();
    return {"images": images, "totalhits": totalimages};
  }
}
