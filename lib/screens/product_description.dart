import 'package:flutter/material.dart';
import '../providers/product.dart';

class ProductDescriptionScreen extends StatelessWidget {
  static const routeName = '/description';
  @override
  Widget build(BuildContext context) {
    final product = ModalRoute.of(context).settings.arguments as ProductModel;
    return SafeArea(
          child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(product.productName),
                background: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(
                  height: 30,
                ),
                Text(
                  '\u20B9${product.price}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    '${product.description}',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(
                  height: 800,
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
