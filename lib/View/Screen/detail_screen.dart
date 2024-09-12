

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import '../../Model/coffee_dto.dart';
import '../../routes/route_name.dart';
import '../Widget/button_primary.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.coffee});
  final Coffee coffee;



  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String sizeSelected = 'M';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const Gap(68),
          buildHeader(),
          const Gap(24),
          buildImage(),
          const Gap(20),
          buildMainInfo(),
          const Gap(20),
          buildDescription(),
          const Gap(30),
          buildSize(),
          const Gap(24),
        ],
      ),
      bottomNavigationBar: buildPrice(),
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const ImageIcon(
            AssetImage('assets/images/ic_arrow_left.png'),
          ),
        ),
        const Text(
          'Detail',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xff242424),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.pushNamed(context, RouteName.cart);
          },
          icon: const ImageIcon(
            AssetImage('assets/images/ic_heart_border.png'),
          ),
        ),
      ],
    );
  }

  Widget buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        widget.coffee.imgUrl.toString(),
        width: double.infinity,
        height: 202,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildMainInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.coffee.name.toString(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Color(0xff242424),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(4),
                Text(
                  widget.coffee.categoryName.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                    color: Color(0xffA2A2A2),
                  ),
                ),
                const Gap(16),
                Row(
                  children: [
                    Image.asset(
                      'assets/images/ic_star_filled.png',
                      width: 20,
                      height: 20,
                    ),
                    const Gap(4),
                    Text(
                      '${widget.coffee.ratingAverage} ',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xff2A2A2A),
                      ),
                    ),
                    Text(
                      '(${widget.coffee.ratingAverage})',
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        color: Color(0xffA2A2A2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                'assets/images/bike.png',
                'assets/images/bean.png',
                'assets/images/milk.png'
              ].map((e) {
                return Container(
                  margin: const EdgeInsets.only(left: 12),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xffEDEDED).withOpacity(0.35),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Image.asset(
                    e,
                    height: 24,
                    width: 24,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        const Gap(16),
        const Divider(
          indent: 16,
          endIndent: 16,
          color: Color(0xffE3E3E3),
          height: 1,
          thickness: 1,
        ),
      ],
    );
  }

  Widget buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xff242424),
          ),
        ),
        const Gap(8),
        ReadMoreText(
          widget.coffee.description.toString(),
          trimLength: 110,
          trimMode: TrimMode.Length,
          trimCollapsedText: ' Read More',
          trimExpandedText: ' Read Less',
          style: const TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 14,
            color: Color(0xffA2A2A2),
          ),
          moreStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xffC67C4E),
          ),
          lessStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Color(0xffC67C4E),
          ),
        ),
      ],
    );
  }

  Widget buildSize() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Size',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xff242424),
          ),
        ),
        const Gap(16),
        Row(
          children: ['S', '', 'M', '', 'L'].map((e) {
            if (e == '') return const Gap(16);

            bool isSelected = sizeSelected == e;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  sizeSelected = e;
                  setState(() {});
                },
                child: Container(
                  height: 41,
                  decoration: BoxDecoration(
                    color: Color(isSelected ? 0xffF9F2ED : 0xffFFFFFF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Color(isSelected ? 0xffC67C4E : 0xffE3E3E3),
                      width: 1,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    e,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Color(isSelected ? 0xffC67C4E : 0xff242424),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget buildPrice() {
    List<Coffee> selectedCoffees = [];
    selectedCoffees.add(widget.coffee);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Price',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Color(0xff909090),
                  ),
                ),
                const Gap(4),
                Text(
                  NumberFormat.currency(
                    decimalDigits: 2,
                    locale: 'en_US',
                    symbol: '\$ ',
                  ).format(widget.coffee.price),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Color(0xffC67C4E),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.add_shopping_cart, color: Color(0xffC67C4E), size: 30),
            onPressed: () {
              // Xử lý khi bấm vào biểu tượng thêm vào giỏ hàng
              // Ví dụ: Thêm sản phẩm vào danh sách giỏ hàng hoặc hiển thị thông báo
              print('Sản phẩm đã được thêm vào giỏ hàng');
            },
          ),
          SizedBox(width: 10),
          SizedBox(
            width: 127,
            child: ButtonPrimary(
              title: 'Buy Now',
              onTap: () {
                Navigator.pushNamed(context, RouteName.order, arguments: selectedCoffees);
              },
            ),
          ),
          // Thay đổi "Add to Cart" thành IconButton

        ],
      ),

    );
  }
}
