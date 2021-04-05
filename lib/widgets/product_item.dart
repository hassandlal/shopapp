import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductProvider>(context, listen: false);
    final cart = Provider.of<CartProvider>(context, listen: false);
    final authData = Provider.of<AuthProvider>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<ProductProvider>(
            builder: (ctx, productprovider, _) => IconButton(
                icon: Icon(productprovider.isFavourite
                    ? Icons.favorite
                    : Icons.favorite_outline),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  product.toggleFavoouiteStatues(
                      authData.token, authData.userId);
                }),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.addItem(product.id, product.price, product.id);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('added to cart'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'undo',
                  onPressed: () {
                    cart.removeItem(product.id);
                  },
                ),
              ));
            },
          ),
        ),
        child: GestureDetector(
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product-placeholder.png'),
              image: NetworkImage(product.imgUrl),
              fit: BoxFit.cover,
            ),
          ),
          onTap: () =>
              Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,arguments: product.id),
        ),
      ),
    );
  }
}
