import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final int quantity;
  final double price;
  final String title;

  CartItem(this.id, this.productId, this.quantity, this.price, this.title);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        background: Container(
          color: Theme.of(context).errorColor,
          alignment: Alignment.centerRight,
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
          padding: EdgeInsets.only(right: 20),
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text('are you sure'),
                    content: Text('Do You Want To Remove Item From The Cart'),
                    actions: [
                      FlatButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('No')),
                      FlatButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('Yes')),
                    ],
                  ));
        },
        onDismissed: (direction){
          Provider.of<CartProvider>(context,listen: false).removeItem(productId);
        },
        key: ValueKey(id),
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FittedBox(
                    child: Text('\$$price'),
                  ),
                ),
              ),
              title: Text(title),
              subtitle: Text('Total \$${(price * quantity)}'),
              trailing: Text('$quantity x'),
            ),
          ),
        ));
  }
}
