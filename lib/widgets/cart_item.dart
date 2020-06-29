import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';

class CartTile extends StatefulWidget {
  final String title;
  final String id;
  final String productId;
  final int quantity;
  final double price;

  CartTile(this.id, this.price, this.quantity, this.title, this.productId);

  @override
  _CartTileState createState() => _CartTileState();
}

class _CartTileState extends State<CartTile> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Are you sure?'),
            content: Text(
                'Are you sure you want to remove this item from the cart?'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: Text('NO'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: Text('YES'),
              )
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(widget.productId);
      },
      background: Container(
        color: Colors.purpleAccent,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(child: Text('\$${widget.price}')),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            title: Text(widget.title),
            subtitle: Text('Total: \$${(widget.price * widget.quantity)}'),
            trailing: FittedBox(
              child: Row(
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.remove,
                        size: 20,
                      ),
                      onPressed: () {
                        Provider.of<Cart>(context).subQuantity(widget.id);
                      }),
                  Text('${widget.quantity}'),
                  IconButton(
                      icon: Icon(
                        Icons.add,
                        size: 20,
                      ),
                      onPressed: () {
                        Provider.of<Cart>(context).addQuantity(widget.id);
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
