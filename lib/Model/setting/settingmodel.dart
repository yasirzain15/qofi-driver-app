class ImageModel {
  final String imageUrl;

  ImageModel({required this.imageUrl});

  Map<String, dynamic> toJson() {
    return {'imageUrl': imageUrl};
  }
}
