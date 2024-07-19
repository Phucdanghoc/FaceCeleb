class ImageUploadResponse {
  final String label;
  final int index;
  final String url_image;
  final double confidence;
  final String url_npy;

  ImageUploadResponse({
    required this.url_image,
    required this.url_npy,
    required this.confidence,
    required this.index,
    required this.label,
  });

  factory ImageUploadResponse.fromJson(Map<String, dynamic> json) {
    return ImageUploadResponse(
      url_image: json['url_image'] as String,
      index: json['index'] ,
      confidence:  json['confidence'],
      url_npy: json['url_npy'] as String,
      label: json['label'] as String,
    );
  }

  
}
