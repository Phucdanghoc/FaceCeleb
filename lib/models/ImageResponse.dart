class ImageUploadResponse {
  final String imageUrl;
  final String name;

  ImageUploadResponse({
    required this.imageUrl,
    required this.name,
  });

  factory ImageUploadResponse.fromJson(Map<String, dynamic> json) {
    return ImageUploadResponse(
      imageUrl: json['image_url'] as String,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'image_url': imageUrl,
      'name': name,
    };
  }
}
