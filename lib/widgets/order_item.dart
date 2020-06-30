import '../provider/orders.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class OrderTile extends StatefulWidget {
  final OrderItem orderItem;

  OrderTile(this.orderItem);

  @override
  _OrderTileState createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.orderItem.amount.toStringAsFixed(3)}'),
            subtitle: Text(
              DateFormat('dd/MM/YYYY hh:mm').format(widget.orderItem.dateTime),
            ),
            trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                }),
          ),
          if (_expanded)
            Container(
              height: min(widget.orderItem.products.length * 20.0 + 10, 180),
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                children: widget.orderItem.products.map(
                  (e) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text('${e.quantity}x \$ ${e.price}', style: TextStyle(fontSize: 18),)
                    ],
                  ),
                ).toList(),
              ),
            )
        ],
      ),
    );
  }
}
