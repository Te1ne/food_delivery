import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/popular_product_controller.dart';
import 'package:food_delivery/controllers/recommended_product_controller.dart';
import 'package:food_delivery/food/popular_food_detail.dart';
import 'package:food_delivery/models/products_model.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widgets/app_column.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/icon_and_text_widget.dart';
import 'package:food_delivery/widgets/small_text.dart';
import 'package:get/get.dart';

enum SortType { name, price, rating, popularity }

class FoodPageBody extends StatefulWidget {
  const FoodPageBody({super.key});

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  PageController pageController = PageController(viewportFraction: 0.85);
  var _currPageValue = 0.0;
  double _scaleFactor = 0.8;
  double _height = Dimensions.pageViewContainer;
  SortType _currentSortType = SortType.name;
  bool _isAscending = true;

  @override
  void initState(){
    super.initState();
    pageController.addListener((){
      setState(() {
        _currPageValue = pageController.page!;
      });
    });
  }

  @override
  void dispose(){
    pageController.dispose();
    super.dispose();
  }

  List<ProductModel> _sortProducts(List<ProductModel> products) {
    List<ProductModel> sortedList = List.from(products);

    switch (_currentSortType) {
      case SortType.name:
        sortedList.sort((a, b) => _isAscending
            ? a.name!.compareTo(b.name!)
            : b.name!.compareTo(a.name!));
        break;
      case SortType.price:
        sortedList.sort((a, b) => _isAscending
            ? a.price!.compareTo(b.price!)
            : b.price!.compareTo(a.price!));
        break;
      case SortType.rating:
        sortedList.sort((a, b) => _isAscending
            ? (a.stars ?? 0).compareTo(b.stars ?? 0)
            : (b.stars ?? 0).compareTo(a.stars ?? 0));
        break;
      case SortType.popularity:
      // Giả sử có trường popularity hoặc dùng id như độ phổ biến
        sortedList.sort((a, b) => _isAscending
            ? (a.id ?? 0).compareTo(b.id ?? 0)
            : (b.id ?? 0).compareTo(a.id ?? 0));
        break;
    }

    return sortedList;
  }

  String _getSortButtonText() {
    String sortName = "";
    switch (_currentSortType) {
      case SortType.name:
        sortName = "Tên";
        break;
      case SortType.price:
        sortName = "Giá";
        break;
      case SortType.rating:
        sortName = "Đánh giá";
        break;
      case SortType.popularity:
        sortName = "Phổ biến";
        break;
    }
    return "$sortName ${_isAscending ? '↑' : '↓'}";
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Dimensions.radius20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(Dimensions.width20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Sắp xếp theo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Dimensions.height20),
              _buildSortOption('Tên sản phẩm', SortType.name, Icons.sort_by_alpha),
              _buildSortOption('Giá cả', SortType.price, Icons.attach_money),
              _buildSortOption('Đánh giá', SortType.rating, Icons.star),
              _buildSortOption('Độ phổ biến', SortType.popularity, Icons.trending_up),
              SizedBox(height: Dimensions.height20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isAscending = true;
                        });
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_upward),
                      label: Text('Tăng dần'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isAscending ? AppColors.mainColor : Colors.grey[300],
                        foregroundColor: _isAscending ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.width10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _isAscending = false;
                        });
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_downward),
                      label: Text('Giảm dần'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: !_isAscending ? AppColors.mainColor : Colors.grey[300],
                        foregroundColor: !_isAscending ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String title, SortType sortType, IconData icon) {
    bool isSelected = _currentSortType == sortType;
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppColors.mainColor : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.mainColor : Colors.black,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected ? Icon(Icons.check, color: AppColors.mainColor) : null,
      onTap: () {
        setState(() {
          _currentSortType = sortType;
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //slider
        GetBuilder<PopularProductController>(builder: (popularProducts){
          return popularProducts.isLoaded?Container(
            //color: Colors.redAccent,
            height: Dimensions.pageView,
            child: PageView.builder(
                controller: pageController,
                itemCount: popularProducts.popularProductList.length,
                itemBuilder: (context, position){
                  return _buildPageItem(position, popularProducts.popularProductList[position]);
                }),

          ):CircularProgressIndicator(
            color: AppColors.mainColor,
          );
        }),
        //dots
        GetBuilder<PopularProductController>(builder: (popularProducts){
          return DotsIndicator(
            dotsCount: popularProducts.popularProductList.isEmpty?1:popularProducts.popularProductList.length,
            position: _currPageValue,
            decorator: DotsDecorator(
              activeColor: AppColors.mainColor,
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
          );
        }),
        //popular text with sort button
        SizedBox(height: Dimensions.height30,),
        Container(
          margin: EdgeInsets.only(left: Dimensions.width30, right: Dimensions.width30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  BigText(text: "Recommended"),
                  SizedBox(width: Dimensions.width10,),
                  Container(
                    margin: const EdgeInsets.only(bottom: 3),
                    child: BigText(text: ".", color: Colors.black26,),
                  ),
                  SizedBox(width: Dimensions.width10,),
                ],
              ),
              // Sort button
              GestureDetector(
                onTap: _showSortOptions,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width10,
                    vertical: Dimensions.height10/2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.mainColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    border: Border.all(color: AppColors.mainColor, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.sort,
                        color: AppColors.mainColor,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        _getSortButtonText(),
                        style: TextStyle(
                          color: AppColors.mainColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        //recommended food

        //list of food and images
        GetBuilder<RecommendedProductController>(builder: (recommendedProduct){
          return recommendedProduct.isLoaded?ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _sortProducts(recommendedProduct.recommendedProductList).length,
              itemBuilder: (context, index){
                List<ProductModel> sortedProducts = _sortProducts(recommendedProduct.recommendedProductList);
                return GestureDetector(
                  onTap: (){
                    // Tìm index gốc của sản phẩm trong danh sách ban đầu
                    int originalIndex = recommendedProduct.recommendedProductList.indexOf(sortedProducts[index]);
                    Get.toNamed(RouteHelper.getRecommendedFood(originalIndex, "home"));
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: Dimensions.width20, right: Dimensions.width20, bottom: Dimensions.height10),
                    child: Row(
                      children: [
                        //image section
                        Container(
                          width:Dimensions.listViewImgSize,
                          height: Dimensions.listViewImgSize,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radius20),
                              color: Colors.white38,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      AppConstants.BASE_URL+AppConstants.UPLOAD_URL+sortedProducts[index].img!
                                  )
                              )
                          ),
                        ),
                        //text container
                        Expanded(
                          child: Container(
                            height: Dimensions.listViewTextContSize,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(Dimensions.radius20),
                                  bottomRight: Radius.circular(Dimensions.radius20)
                              ),
                              color: Colors.white,

                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: BigText(text: sortedProducts[index].name!),
                                      ),
                                      if (sortedProducts[index].price != null)
                                        Text(
                                          '\$ ${sortedProducts[index].price}',
                                          style: TextStyle(
                                            color: AppColors.mainColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: Dimensions.height10,),
                                  Row(
                                    children: [
                                      if (sortedProducts[index].stars != null) ...[
                                        Icon(Icons.star, color: Colors.amber, size: 14),
                                        SizedBox(width: 2),
                                        Text(
                                          '${sortedProducts[index].stars}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 11,
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                      ],
                                      Expanded(
                                        child: SmallText(
                                          text: sortedProducts[index].description!.length > 30
                                              ? '${sortedProducts[index].description!.substring(0, 30)}...'
                                              : sortedProducts[index].description!,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: Dimensions.height10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: IconAndTextWidget(icon: Icons.circle_sharp,
                                            text: "Normal",
                                            iconColor: AppColors.iconColor1),
                                      ),
                                      Flexible(
                                        child: IconAndTextWidget(icon: Icons.location_on,
                                            text: "1.7km",
                                            iconColor: AppColors.mainColor),
                                      ),
                                      Flexible(
                                        child: IconAndTextWidget(icon: Icons.access_time_rounded,
                                            text: "32min",
                                            iconColor: AppColors.iconColor2),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }):CircularProgressIndicator(
            color: AppColors.mainColor,
          );
        })
      ],
    );
  }
  Widget _buildPageItem(int index, ProductModel popularProduct){
    Matrix4 matrix = new Matrix4.identity();
    if(index == _currPageValue.floor()){
      var currScale = 1 - (_currPageValue-index)*(1-_scaleFactor);
      var currTrans = _height*(1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    }else if(index == _currPageValue.floor()+1){
      var currScale = _scaleFactor+(_currPageValue-index+1)*(1-_scaleFactor);
      var currTrans = _height*(1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    }else if(index == _currPageValue.floor()-1){
      var currScale = 1 - (_currPageValue-index)*(1-_scaleFactor);
      var currTrans = _height*(1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1, currScale, 1);
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, currTrans, 0);
    }else{
      var currScale = 0.8;
      matrix = Matrix4.diagonal3Values(1, currScale, 1)..setTranslationRaw(0, _height*(1-_scaleFactor)/2, 1);
    }
    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          GestureDetector(
            onTap: (){

              Get.toNamed(RouteHelper.getPopularFood(index, "home"));
            },
            child: Container(
              height: Dimensions.pageViewContainer,
              margin: EdgeInsets.only(left: Dimensions.width10, right: Dimensions.width10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                  color: index.isEven?Color(0xFF69c5df):Color(0xFF9294cc),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          AppConstants.BASE_URL+AppConstants.UPLOAD_URL+popularProduct.img!
                      )
                  )
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: Dimensions.pageViewTextContainer,
              margin: EdgeInsets.only(left: Dimensions.width30, right: Dimensions.width30, bottom: Dimensions.height30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xFFe8e8e8),
                        blurRadius: 5.0,
                        offset: Offset(0, 5)
                    ),
                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(-5, 0)
                    ),
                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(5, 0)
                    ),
                  ]
              ),
              child: Container(
                padding: EdgeInsets.only(top: Dimensions.height10, left: Dimensions.width10, right: Dimensions.width10),
                child: AppColumn(text: popularProduct.name!,),
              ),

            ),
          )
        ],
      ),
    );
  }
}