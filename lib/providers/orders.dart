import 'package:flutter/foundation.dart';
import 'package:flutter_tutorial_shop_app/providers/cart.dart';

class OrderItem{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({@required this.id, @required this.amount, @required this.products, @required this.dateTime});

}

class Orders with ChangeNotifier{
  List<OrderItem> _ordres = [];

  List<OrderItem> get orders {
    return [..._ordres];
  }

  void addOrder(List<CartItem> cartProducts, double total){
    _ordres.insert(0, OrderItem(id: DateTime.now().toString(), amount: total, products: cartProducts, dateTime: DateTime.now()));
    //Anywhere that depends on the orders is now updated.
    notifyListeners();
  }
}