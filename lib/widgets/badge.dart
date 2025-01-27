import 'package:flutter/material.dart';
import 'package:shop/utils/app_routes.dart';

class Badge extends StatelessWidget {
  const Badge(
      {super.key, required this.child, required this.value, this.color});

  final Widget child;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.CART);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: color ?? Theme.of(context).colorScheme.secondary,
              ),
              constraints: const BoxConstraints(
                minHeight: 16,
                minWidth: 16,
              ),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10),
              ),
            ),
          )
        ],
      ),
    );
  }
}
