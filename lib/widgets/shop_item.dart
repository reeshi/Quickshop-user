import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/shop.dart';
import '../screens/categoryScreen.dart';

class ShopItem extends StatelessWidget {
  final ShopModel shop;
  final String userId;
  ShopItem(
    this.shop,
    this.userId,
  );
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductScreen(
              products: shop.products,
              userId: userId,
              shopId: shop.id,
            ),
          ),
        )
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.all(width * 0.032),
        elevation: 4,
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  // child: Image.network(
                  //   shop.imageUrl,
                  //   height: 200,
                  //   width: double.infinity,
                  //   fit: BoxFit.cover,
                  // ),
                  child: FadeInImage(
                    image: NetworkImage(
                      shop.imageUrl,
                    ),
                    placeholder: AssetImage('assets/images/shop.jpg'),
                    height: width * 0.45,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    width: width * 0.5,
                    padding: EdgeInsets.all(width * 0.008),
                    color: Colors.black54,
                    child: Text(
                      '${shop.shopName}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                      ),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(width * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: width * 0.045),
                        child: SvgPicture.asset(
                          'assets/svgIcons/location.svg',
                          height: 20,
                          width: 20,
                        ),
                      ),
                      SizedBox(
                        width: 6,
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: width * 0.78),
                        child: Text(
                          shop.location.formattedAddress,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                    ],
                  ),
                  // Row(
                  //   children: <Widget>[
                  //     Icon(
                  //       Icons.offline_pin,
                  //     ),
                  //     SizedBox(
                  //       width: 6,
                  //     ),
                  //     Text(
                  //       shop.ownerName,
                  //       style: Theme.of(context).textTheme.headline6,
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
