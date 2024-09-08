import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String imagePath;

  const CustomImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15), // Thay đổi giá trị để điều chỉnh độ bo góc
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: 100, // Chiều rộng của ảnh, có thể điều chỉnh theo nhu cầu
        height: 100, // Chiều cao của ảnh, có thể điều chỉnh theo nhu cầu
      ),
    );
  }
}
