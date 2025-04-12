class ImageModel {
  List<ImageItem>? images;

  ImageModel({this.images});

  ImageModel.fromJson(Map<String, dynamic> json) {
    if (json['images'] != null) {
      images = List<ImageItem>.from(
        json['images'].map((item) => ImageItem.fromJson(item)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      if (images != null)
        'images': images!.map((item) => item.toJson()).toList(),
    };
  }
}

class ImageItem {
  int? id;
  String? previewURL;
  String? largeImageURL;

  ImageItem({this.id, this.previewURL, this.largeImageURL});

  ImageItem.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id'].toString());
    previewURL = json['previewURL'].toString();

    final dynamic largeURL = json['largeImageURL'];
    if (largeURL is String) {
      largeImageURL = getDirectUrl(largeURL: largeURL);
    } else {
      largeImageURL = null;
    }
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'previewURL': previewURL, 'largeImageURL': largeImageURL};
  }

  String? getDirectUrl({required String largeURL}) {
    if (largeURL.contains('https://drive.google.com')) {
      final fileId = extractDriveFileId(largeURL);

      final directUrl = 'https://drive.google.com/uc?export=view&id=$fileId';

      return directUrl;
    } else {
      return largeURL;
    }
  }

  String extractDriveFileId(String url) {
    final regex = RegExp(r'd/([a-zA-Z0-9_-]+)');
    final match = regex.firstMatch(url);
    return match != null ? match.group(1)! : '';
  }
}
