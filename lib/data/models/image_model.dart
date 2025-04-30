class ImageBB {
  final String url;
  final String deleteUrl;


  ImageBB({
    required this.url,
    required this.deleteUrl,
  });

  factory ImageBB.fromJson(Map<String, dynamic> json) {
    return ImageBB(
      url: json['url'],
      deleteUrl: json['delete_url'],
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'url': url,
      'delete_url': deleteUrl,
    };
  }
}
