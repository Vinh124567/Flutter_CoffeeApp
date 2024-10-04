import 'package:coffee_shop/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../../ViewModel/auth_view_model.dart';
import '../../ViewModel/coffee_view_model.dart';

class StarRatingScreen extends StatefulWidget {
  final int coffeeId; // Thêm coffeeId vào đây

  const StarRatingScreen({Key? key, required this.coffeeId}) : super(key: key);

  @override
  _StarRatingScreenState createState() => _StarRatingScreenState();
}

class _StarRatingScreenState extends State<StarRatingScreen> {
  double _rating = 0; // Số sao được chọn
  final TextEditingController _reviewController =
      TextEditingController(); // Điều khiển ô văn bản

  @override
  void dispose() {
    _reviewController.dispose(); // Giải phóng điều khiển ô văn bản
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final coffeeViewModel =
        Provider.of<CoffeeViewModel>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Chọn số sao"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Chọn số sao:",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              RatingBar.builder(
                initialRating: _rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating; // Cập nhật số sao
                  });
                },
              ),
              const SizedBox(height: 20),
              Text(
                "Bạn đã chọn: ${_rating.toStringAsFixed(1)} sao",
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _reviewController,
                maxLines: 3, // Số dòng tối đa của ô văn bản
                decoration: const InputDecoration(
                  labelText: 'Nhập đánh giá của bạn',
                  border: OutlineInputBorder(),
                  hintText: 'Hãy chia sẻ cảm nhận của bạn...',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Xử lý khi người dùng nhấn nút
                  String review = _reviewController.text;
                  await coffeeViewModel.addReview(
                    widget.coffeeId,
                    authViewModel.user!.uid.toString(),
                    _rating.toInt(),
                    review,
                  );
                  print("Số sao đã chọn: ${_rating.toStringAsFixed(1)}");
                  print("Đánh giá: $review");
                  print(widget.coffeeId);
                  print(authViewModel.user?.uid.toString());
                  Navigator.pushNamed(context,RouteName.my_order); // Có thể điều hướng về màn hình trước
                },
                child: const Text("Xác nhận"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
