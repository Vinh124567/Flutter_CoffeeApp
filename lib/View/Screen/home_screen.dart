import 'package:coffee_shop/Model/category_dto.dart';
import 'package:coffee_shop/Model/Coffees/coffee_response.dart';
import 'package:coffee_shop/ViewModel/category_view_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../Data/Response/status.dart';
import '../../ViewModel/home_view_model.dart';
import '../../routes/route_name.dart';

class HomeFragment extends StatefulWidget {
  const HomeFragment({super.key});

  @override
  State<HomeFragment> createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  String categorySelected = 'All Coffee';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch Coffee List
      Provider.of<HomeViewModel>(context, listen: false).fetchCoffeeListApi();
      // Fetch Categories List
      Provider.of<CategoriesViewModel>(context, listen: false).fetchCategoriesListApi();
    });
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [
        Stack(
          children: [
            buildBackground(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Gap(68),
                  buildHeader(),
                  const Gap(30),
                  buildSearch(),
                  const Gap(24),
                  buildBannerPromo(),
                ],
              ),
            ),
          ],
        ),
        const Gap(24),
        buildCategories(),
        const Gap(16),
        buildGridCoffee(),
        const Gap(30),
      ],
    );
  }

  Widget buildBackground() {
    return Container(
      height: 280,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xff111111),
            Color(0xff313131),
          ],
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Location',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12,
            color: Color(0xffA2A2A2),
          ),
        ),
        Row(
          children: [
            const Text(
              'Bilzen, Tanjungbalai',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xffD8D8D8),
              ),
            ),
            const Gap(4),
            Image.asset(
              'assets/images/ic_arrow_down.png',
              height: 14,
              width: 14,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildSearch() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xff2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Row(
              children: [
                ImageIcon(
                  AssetImage('assets/images/ic_search.png'),
                  color: Colors.white,
                ),
                Gap(8),
                Expanded(
                  child: TextField(
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(0),
                      isDense: true,
                      border: InputBorder.none,
                      hintText: 'Seach coffee',
                      hintStyle: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        color: Color(0xffA2A2A2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Gap(16),
        Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: const Color(0xffC67C4E),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: const ImageIcon(
            AssetImage('assets/images/ic_filter.png'),
            size: 20,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget buildBannerPromo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(
        'assets/images/banner.png',
        width: double.infinity,
        height: 140,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildCategories() {
    return Consumer<CategoriesViewModel>(builder: (context, categoriesViewModel, child) {
      if (categoriesViewModel.listCategories.status == Status.LOADING) {
        return const Center(child: CircularProgressIndicator());
      } else if (categoriesViewModel.listCategories.status == Status.ERROR) {
        return Center(child: Text('Lỗi: ${categoriesViewModel.listCategories.message}'));
      } else if (categoriesViewModel.listCategories.status == Status.COMPLETED) {
        List<Categories> categoriesList = categoriesViewModel.listCategories.data?.data ?? [];
        return SizedBox(
          height: 29,
          child: ListView.builder(
            itemCount: categoriesList.length + 1, // +1 cho "All Coffee"
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              String category = index == 0 ? 'All Coffee' : categoriesList[index - 1].name.toString();
              bool isActive = categorySelected == category;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    categorySelected = category;
                    // Nếu cần, bạn có thể gọi fetchCoffeeListApi() với danh mục đã chọn
                    // Provider.of<HomeViewModel>(context, listen: false).fetchCoffeeListApiByCategory(category);
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(
                    left: index == 0 ? 24 : 8,
                    right: index == categoriesList.length ? 24 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? const Color(0xffC67C4E) : const Color(0xffEDEDED).withOpacity(0.35),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.center,
                  child: Text(
                    category,
                    style: TextStyle(
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 14,
                      color: isActive ? Colors.white : const Color(0xff313131),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }
      return Container(); // Trả về widget rỗng nếu không có dữ liệu.
    });
  }

  Widget buildGridCoffee() {
    return Consumer<HomeViewModel>(builder: (context, homeViewModel, child) {
      // Kiểm tra trạng thái của dữ liệu
      if (homeViewModel.coffeeList.status == Status.LOADING) {
        return const Center(child: CircularProgressIndicator());
      } else if (homeViewModel.coffeeList.status == Status.ERROR) {
        return Center(child: Text('Lỗi: ${homeViewModel.coffeeList.message}'));
      } else if (homeViewModel.coffeeList.status == Status.COMPLETED) {
        // Lấy danh sách coffee từ response
        List<CoffeeData> coffeeList = homeViewModel.coffeeList.data?.coffeesData?.where((coffee) {
          return categorySelected == 'All Coffee' || coffee.category == categorySelected;
        }).toList() ?? [];

        // Nếu danh sách coffee rỗng
        if (coffeeList.isEmpty) {
          return const Center(child: Text('Không có sản phẩm nào.'));
        }

        return GridView.builder(
          itemCount: coffeeList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 238,
            crossAxisSpacing: 15,
            mainAxisSpacing: 24,
          ),
          shrinkWrap: true,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            CoffeeData coffee = coffeeList[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, RouteName.detail, arguments: coffee);
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
                decoration: BoxDecoration(
                  color: const Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            coffee.coffeeImageUrl.toString(),
                            height: 128,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  const Color(0xff111111).withOpacity(0.3),
                                  const Color(0xff313131).withOpacity(0.3),
                                ],
                              ),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(24),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/ic_star_filled.png',
                                  height: 12,
                                  width: 12,
                                ),
                                const Gap(4),
                                Text(
                                  '${coffee.averageRating}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 8,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),
                    Text(
                      coffee.coffeeName.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xff242424),
                      ),
                    ),
                    const Gap(4),
                    Text(
                      coffee.category.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 12,
                        color: Color(0xffA2A2A2),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          NumberFormat.currency(
                            decimalDigits: 2,
                            locale: 'en_US',
                            symbol: '\$ ',
                          ).format(coffee.coffeePrice),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: Color(0xff050505),
                          ),
                        ),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xffC67C4E),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }

      return Container(); // Trả về widget rỗng nếu không có dữ liệu.
    });
  }

}
