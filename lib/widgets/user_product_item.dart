import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imgUrl;

  UserProductItem(this.id, this.title, this.imgUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: id),
            ),
            IconButton(
              color: Theme.of(context).errorColor,
                icon: Icon(Icons.delete),
                onPressed: () async {
                  try {
                    await Provider.of<ProductsProvider>(context, listen: false)
                        .deleteProduct(id);
                  } catch (e) {
                    scaffold.showSnackBar(SnackBar(
                        content: Text(
                      'Deleting Failed',
                      textAlign: TextAlign.center,
                    )));
                  }
                }),
          ],
        ),
      ),
    );
  }
}
