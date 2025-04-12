class DriveFolderModel {
  final String folderId;
  final String folderName;
  final String folderImage;

  DriveFolderModel({
    required this.folderId,
    required this.folderName,
    required this.folderImage,
  });

  static DriveFolderModel fromJson(Map<String, dynamic> json) {
    final rawUrl = json['cover_image'] as String;
    final fileId = _extractDriveFileId(rawUrl);
    final directImageUrl = 'https://drive.google.com/uc?export=view&id=$fileId';

    return DriveFolderModel(
      folderId: json['folder_id'] as String,
      folderName: json['folder_name'] as String,
      folderImage: directImageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'folder_id': folderId,
      'folder_name': folderName,
      'cover_image': folderImage,
    };
  }

  static String _extractDriveFileId(String url) {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    if (segments.length >= 3 && segments[0] == 'file' && segments[1] == 'd') {
      return segments[2];
    }
    return '';
  }
}

class DriveFolderList {
  final List<DriveFolderModel> driveFolders;

  DriveFolderList({required this.driveFolders});

  factory DriveFolderList.fromJson(Map<String, dynamic> json) {
    var foldersJson = json['drive_folders'] as List<dynamic>;
    List<DriveFolderModel> folders =
        foldersJson
            .map(
              (folder) =>
                  DriveFolderModel.fromJson(folder as Map<String, dynamic>),
            )
            .toList();

    return DriveFolderList(driveFolders: folders);
  }

  Map<String, dynamic> toJson() {
    return {
      'drive_folders': driveFolders.map((folder) => folder.toJson()).toList(),
    };
  }
}
