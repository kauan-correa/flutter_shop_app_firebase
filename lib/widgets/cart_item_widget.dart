import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';

class CartItemWidget extends StatefulWidget {
  const CartItemWidget({super.key, required this.cartItem});
  final CartItem cartItem;

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget> {
  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of<Cart>(context);

    return Dismissible(
      key: ValueKey(widget.cartItem.id),
      background: Container(
        padding: const EdgeInsets.only(right: 20),
        color: const Color.fromARGB(255, 255, 0, 0),
        alignment: Alignment.centerRight,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: const Icon(
          Icons.delete,
          size: 40,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text("Are you sure?"),
            content:
                const Text("Do you want to remove the item from the cart?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: const Text("Yes"),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false)
            .removeItem(widget.cartItem.productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FittedBox(
                    child: Text(
                      NumberFormat('0.00', 'en_US')
                          .format(widget.cartItem.price),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.cartItem.title,
                        style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      "Total: \$${NumberFormat('0.00', 'en_US').format(widget.cartItem.price * widget.cartItem.quantity)}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        cart.addQuantity(widget.cartItem.productId);
                      });
                    },
                    icon: Icon(
                      Icons.arrow_upward,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  Text(
                    "${widget.cartItem.quantity}x",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (widget.cartItem.quantity == 1) return;
                        cart.removeSingleItem(widget.cartItem.productId);
                      });
                    },
                    icon: Icon(
                      Icons.arrow_downward,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
