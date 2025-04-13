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
