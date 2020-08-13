import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  var _isLoading = false;

  // @override
  // void initState() {
    ////Below code works, however if listen:false is used, the future delayed is not necessary
    // Future.delayed(Duration.zero).then((_) async {
    //   setState(() {
    //     _isLoading = true;
    //   });
    //   await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
    //   setState(() {
    //     _isLoading = false;
    //   });
    // });

    ////The below code will also work in the init state.
    // setState(() {
    //   _isLoading = true;
    // });
    // Provider.of<Orders>(context, listen: false)
    //     .fetchAndSetOrders()
    //     .then((_) => {
    //           setState(() {
    //             _isLoading = false;
    //           })
    //         });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    print('Fetching Orders');
    // final ordereData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: FutureBuilder(future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(), builder: (ctx, asyncSnapshot) {
        if(asyncSnapshot.connectionState == ConnectionState.waiting){
          return Center( child: CircularProgressIndicator(),);
        }
        else{
          if(asyncSnapshot.error != null){
            //...
            //DO error handling stuff here
            return Center(child: Text('An error had occurred!'),);
          }
          else{
            return Consumer<Orders> (builder: (ctx, orderData, child) => ListView.builder(
              itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
              itemCount: orderData.orders.length)); 
          }
        }
      },),
      drawer: AppDrawer(),
    );
  }
}
