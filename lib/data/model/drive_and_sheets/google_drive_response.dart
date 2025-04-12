import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class GoogleDriveResponse {
  final List<GoogleDriveFile> files;

  GoogleDriveResponse({required this.files});

  // Factory method to create an instance from JSON
  factory GoogleDriveResponse.fromJson(Map<String, dynamic> json) {
    var list = json['files'] as List; // Extract 'files' as a List

    List<GoogleDriveFile> fileList =
        list
            .map((item) => GoogleDriveFile.fromJson(item))
            .toList(); // Map each item to GoogleDriveFile

    return GoogleDriveResponse(files: fileList);
  }
}

class GoogleDriveFile {
  final String id;
  final String name;
  final String mimeType;

  GoogleDriveFile({
    required this.id,
    required this.name,
    required this.mimeType,
  });

  // Factory method to create an instance from JSON
  factory GoogleDriveFile.fromJson(Map<String, dynamic> json) {
    return GoogleDriveFile(
      id: json['id'] as String, // Ensure the type is String
      name: json['name'] as String,
      mimeType: json['mimeType'] as String,
    );
  }
}

class DriveImageGallery extends StatefulWidget {
  @override
  _DriveImageGalleryState createState() => _DriveImageGalleryState();
}

class _DriveImageGalleryState extends State<DriveImageGallery> {
  List<String> imageUrls = [];

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  // Function to fetch images from Google Drive
  void fetchImages() async {
    final folderId =
        'YOUR_FOLDER_ID'; // Replace with your Google Drive Folder ID
    final apiKey = 'YOUR_GOOGLE_API_KEY'; // Replace with your API Key

    // Construct the API URL to fetch files in the folder
    final url =
        'https://www.googleapis.com/drive/v3/files?q=%27$folderId%27+in+parents+and+mimeType+contains+%27image%27&key=$apiKey';

    final response = await Dio().get(url);

    if (response.statusCode == 200) {
      // Parse the response body into GoogleDriveResponse
      final data = json.decode(response.data); // Decoding JSON

      // Ensure that the response is a map before passing it to the model
      if (data is Map<String, dynamic>) {
        final googleDriveResponse = GoogleDriveResponse.fromJson(data);

        List<String> imageUrlsList = [];

        // Loop through the files and create the image URLs
        for (var file in googleDriveResponse.files) {
          final imageUrl =
              'https://drive.google.com/uc?export=view&id=${file.id}';
          imageUrlsList.add(imageUrl);
        }

        setState(() {
          imageUrls = imageUrlsList;
        });
      } else {
        print('Error: Response data is not a Map');
      }
    } else {
      print('Failed to load images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Drive Gallery")),
      body:
          imageUrls.isEmpty
              ? Center(child: CircularProgressIndicator())
              : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: imageUrls.length,
                itemBuilder: (context, index) {
                  return Image.network(imageUrls[index]);
                },
              ),
    );
  }
}
