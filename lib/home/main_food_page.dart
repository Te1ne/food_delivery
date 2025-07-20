import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/popular_product_controller.dart';
import 'package:food_delivery/controllers/recommended_product_controller.dart';
import 'package:food_delivery/home/food_page_body.dart';
import 'package:food_delivery/models/products_model.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/small_text.dart';
import 'package:get/get.dart';

class MainFoodPage extends StatefulWidget {
  const MainFoodPage({super.key});

  @override
  State<MainFoodPage> createState() => _MainFoodPageState();
}

class _MainFoodPageState extends State<MainFoodPage> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  List<ProductModel> _searchResults = [];
  FocusNode _searchFocusNode = FocusNode();

  Future<void> _loadResource() async {
    await Get.find<PopularProductController>().getPopularProductList();
    await Get.find<RecommendedProductController>().getRecommendedProductList();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (_isSearching) {
        _searchFocusNode.requestFocus();
      } else {
        _searchController.clear();
        _searchResults.clear();
        _searchFocusNode.unfocus();
      }
    });
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    List<ProductModel> allProducts = [];

    // Lấy data từ controllers
    var popularController = Get.find<PopularProductController>();
    var recommendedController = Get.find<RecommendedProductController>();

    if (popularController.isLoaded) {
      allProducts.addAll(popularController.popularProductList);
    }
    if (recommendedController.isLoaded) {
      allProducts.addAll(recommendedController.recommendedProductList);
    }

    // Filter products theo tên
    List<ProductModel> results = allProducts
        .where((product) =>
        product.name!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    setState(() {
      _searchResults = results;
    });
  }

  void _navigateToProductDetail(ProductModel product) {
    // Tìm index trong popular hoặc recommended list
    var popularController = Get.find<PopularProductController>();
    var recommendedController = Get.find<RecommendedProductController>();

    int popularIndex = popularController.popularProductList.indexOf(product);
    int recommendedIndex = recommendedController.recommendedProductList.indexOf(product);

    if (popularIndex != -1) {
      // Nếu là popular product
      Get.toNamed(RouteHelper.getPopularFood(popularIndex, "home"));
    } else if (recommendedIndex != -1) {
      // Nếu là recommended product
      Get.toNamed(RouteHelper.getRecommendedFood(recommendedIndex, "home"));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        child: Column(
          children: [
            // Header with search
            Container(
              child: Container(
                margin: EdgeInsets.only(top: Dimensions.height45, bottom: Dimensions.height15),
                padding: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20),
                child: Column(
                  children: [
                    // Original header row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            BigText(text: "Quan7", color: AppColors.mainColor),
                            Row(
                              children: [
                                SmallText(text: "TPHCM", color: Colors.black54),
                                Icon(Icons.arrow_drop_down_rounded)
                              ],
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: _toggleSearch,
                          child: Container(
                            width: Dimensions.height45,
                            height: Dimensions.height45,
                            child: Icon(
                              _isSearching ? Icons.close : Icons.search,
                              color: Colors.white,
                              size: Dimensions.iconSize24,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radius15),
                              color: AppColors.mainColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    // Search bar (hiện khi _isSearching = true)
                    if (_isSearching)
                      Container(
                        margin: EdgeInsets.only(top: Dimensions.height15),
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.width10),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(Dimensions.radius20),
                        ),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          onChanged: _performSearch,
                          decoration: InputDecoration(
                            hintText: "Tìm kiếm món ăn...",
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search, color: Colors.grey),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Body content
            Expanded(
              child: _isSearching && _searchController.text.isNotEmpty
                  ? _buildSearchResults()
                  : SingleChildScrollView(
                child: FoodPageBody(),
              ),
            ),
          ],
        ),
        onRefresh: _loadResource,
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: Dimensions.height20),
            BigText(text: "Không tìm thấy sản phẩm", color: Colors.grey),
            SizedBox(height: Dimensions.height10),
            SmallText(text: "Thử tìm kiếm với từ khóa khác", color: Colors.grey),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(Dimensions.width10),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        ProductModel product = _searchResults[index];
        return GestureDetector(
          onTap: () => _navigateToProductDetail(product),
          child: Container(
            margin: EdgeInsets.only(bottom: Dimensions.height10),
            padding: EdgeInsets.all(Dimensions.width10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Dimensions.radius20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Product image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        AppConstants.BASE_URL + AppConstants.UPLOAD_URL + product.img!,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.width15),
                // Product info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BigText(text: product.name!),
                      SizedBox(height: Dimensions.height10),
                      SmallText(
                        text: product.description ?? "Món ăn ngon",
                        color: Colors.grey,
                      ),
                      SizedBox(height: Dimensions.height10),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 4),
                          SmallText(text: product.stars?.toString() ?? "4.5"),
                          SizedBox(width: Dimensions.width10),
                          SmallText(text: "\$${product.price ?? 0}", color: AppColors.mainColor),
                        ],
                      ),
                    ],
                  ),
                ),
                // Arrow icon
                Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}