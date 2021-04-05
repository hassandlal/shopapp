import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';
import '../providers/orders.dart' show OrdersProvider;

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: Text('Your Order'),
      ),
      body: FutureBuilder(
        future: Provider.of<OrdersProvider>(context, listen: false)
            .fetchAndSetOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.error != null) {
              return Center(child: Text('an error ocured'),);
            }
            else {
             return Consumer<OrdersProvider>(builder: (ctx, orderData, child) =>
                  ListView.builder(
                    itemBuilder: (context, index) =>
                        OrderItem(orderData.orders[index]),
                    itemCount: orderData.orders.length,),);
            }
          }
        },
      ),
    );
  }
}
