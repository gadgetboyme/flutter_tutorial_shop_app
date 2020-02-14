import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key key}) : super(key: key);
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final ordereData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Your Orders'),),
      body: ListView.builder(
        itemBuilder: (ctx, i) => OrderItem(ordereData.orders[i]),
        itemCount: ordereData.orders.length),
        drawer: AppDrawer(),
    );
  }
}