// File: coffee_list_section.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../Model/coffee_dto.dart';
import '../../StateDeliverScreen/CoffeeQuantityProvider.dart';

class CoffeeListSection extends StatelessWidget {
  final List<Coffee> coffees;

  const CoffeeListSection({Key? key, required this.coffees}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CoffeeQuantityProvider>(
      builder: (context, coffeeQuantityProvider, child) {
        return Column(
          children: coffees.map((coffee) {
            final quantity = coffeeQuantityProvider.getQuantity(coffee);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      coffee.imageUrl.toString(),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(coffee.name ?? "Unknown Coffee"),
                        const Text("Deep Foam"),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      coffeeQuantityProvider.increaseQuantity(coffee);
                    },
                    icon: const Icon(Icons.add),
                    label: const SizedBox.shrink(),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(8),
                      minimumSize: const Size(30, 30),
                    ),
                  ),
                  Text(quantity.toString()),
                  ElevatedButton.icon(
                    onPressed: () {
                      coffeeQuantityProvider.decreaseQuantity(coffee);
                    },
                    icon: const Icon(Icons.remove),
                    label: const SizedBox.shrink(),
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(8),
                      minimumSize: const Size(30, 30),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
