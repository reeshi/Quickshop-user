import 'package:QuickShop/providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../widgets/product_item.dart';
import '../providers/product.dart';
import 'listOfProduct.dart';

class ProductScreen extends StatefulWidget {
  static const routeName = '/product';
  List<ProductModel> products;
  final String userId;
  final String shopId;
  ProductScreen({
    this.products,
    this.shopId,
    this.userId,
  });
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool _isLoading = true;
  List categoryList = [
    {
      'title': "Fruits & Vegetables",
      'icon': 'assets/svgIcons/fruits.svg',
    },
    {
      'title': "Foodgrains,Oil & Masala",
      'icon': 'assets/svgIcons/grains.svg',
    },
    {
      'title': "Bakery,Cakes & Dairy",
      'icon': 'assets/svgIcons/dairy.svg',
    },
    {
      'title': "Beverages",
      'icon': 'assets/svgIcons/drinks.svg',
    },
    {
      'title': "Snacks",
      'icon': 'assets/svgIcons/snacks.svg',
    },
    {
      'title': "Beauty & Hygiene",
      'icon': 'assets/svgIcons/shampoo.svg',
    },
    {
      'title': "Cleaning & Household",
      'icon': 'assets/svgIcons/household.svg',
    },
    {
      'title': "Baby Care",
      'icon': 'assets/svgIcons/baby.svg',
    },
  ];

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  fetchCart() async {
    await Provider.of<Cart>(context, listen: false)
        .fetchUserCart(widget.userId);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Product Categories',
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'DancingScript',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // body: Column(
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     Expanded(
        //       child: ListView.builder(
        //         itemBuilder: (ctx, i) => ProductItem(
        //           products[i],
        //         ),
        //         itemCount: products.length,
        //       ),
        //     ),
        //     SizedBox(
        //       height: 20,
        //     )
        //   ],
        // ),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: EdgeInsets.all(width * 0.03),
                margin: EdgeInsets.only(bottom: width * 0.05),
                height: height * 0.85,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      ...categoryList.map((list) {
                        final List<ProductModel> product = widget.products
                            .where(
                              (data) => data.category == list['title'],
                            )
                            .toList();
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ListOfProduct(
                                  products: product,
                                  userId: widget.userId,
                                  shopId: widget.shopId,
                                ),
                              ),
                            ).then((value) async {
                              await Provider.of<Cart>(context, listen: false)
                                  .fetchUserCart(widget.userId);
                           
                            });
                          },
                          child: Card(
                            child: Container(
                              margin: EdgeInsets.all(width * 0.02),
                              padding:
                                  EdgeInsets.symmetric(vertical: width * 0.03),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          list['icon'],
                                          height: 30,
                                          width: 30,
                                        ),
                                        SizedBox(
                                          width: width * 0.07,
                                        ),
                                        Text(
                                          list['title'],
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_sharp,
                                    color: Theme.of(context).primaryColor,
                                    size: 18,
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
