class PopupModel {
  final String imageUrl;
  final String title;
  final String subTitle;
  final String buttonText;
  final bool isVisible;

  PopupModel({
    required this.imageUrl,
    required this.title,
    required this.subTitle,
    required this.buttonText,
    this.isVisible = true,
  });

  factory PopupModel.fromJson(Map<String, dynamic> json) {
    return PopupModel(
      imageUrl: json['image_url'] ?? '',
      title: json['title'] ?? '',
      subTitle: json['sub_title'] ?? '',
      buttonText: json['button_text'] ?? '',
      isVisible: json['is_visible'] ?? false,
    );
  }
}
