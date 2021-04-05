import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import './edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/userproducts';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProductScreen.routeName))
        ],
      ),
      body: FutureBuilder(
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    child: Consumer<ProductsProvider>(
                      builder: (ctx, productData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (ctx, index) => Column(
                            children: [
                              UserProductItem(
                                  productData.items[index].id,
                                  productData.items[index].title,
                                  productData.items[index].imgUrl),
                              Divider()
                            ],
                          ),
                          itemCount: productData.items.length,
                        ),
                      ),
                    ),
                    onRefresh: () => _refreshProducts(context)),
        future: _refreshProducts(context),
      ),
    );
  }
}
