// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  const CartItem({
    Key? key,
    required this.id,
    required this.productId,
    required this.price,
    required this.quantity,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      //CREATES A SWIPE EFFECT TO DISMISS THE CARD
      key: ValueKey(id),
      background: Container(
        //BACKGROUND FOR WHATS SHOWN BEHIND
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart, //DIRECTION OF DISMISSIBLE SWIPE
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to remove the item from the cart?'),
            actions: [
              TextButton(onPressed: () {
                Navigator.of(context).pop(false);
              }, child: const Text('No'),),
              TextButton(onPressed: () {
                Navigator.of(context).pop(true);
              }, child: const Text('Yes'),),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        //WHAT IT DOES WHEN ITS DISMISSED
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 15,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: FittedBox(
                  child: Text('€$price'),
                ),
              ),
            ),
            title: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text('Total: €${(price * quantity).toStringAsFixed(2)}'),
            trailing: Column(
              children: [
                GestureDetector(
                  //ADD A SINGLE ITEM TO CART
                  child: const Text(
                    '+',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Provider.of<Cart>(context, listen: false)
                        .addSingleItem(productId);
                  },
                ),
                Text('$quantity x'),
                GestureDetector(
                  //REMOVE SINGLE ITEM FROM CART
                  child: const Text(
                    '-',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onTap: () {
                    Provider.of<Cart>(context, listen: false)
                        .removeSingleItem(productId);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
