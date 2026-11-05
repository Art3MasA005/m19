import 'dart:ui';

import 'package:flutter/material.dart';

import 'food_item.dart';
import 'formatters.dart';

const foodAccentColors = [
  Color(0xFFDFF0B4),
  Color(0xFFC3ECF1),
  Color(0xFFF3D1C7),
];

class GlassFoodRow extends StatelessWidget {
  const GlassFoodRow({
    super.key,
    required this.food,
    required this.accent,
    required this.onDelete,
  });

  final FoodItem food;
  final Color accent;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(28),
      boxShadow: const [
        BoxShadow(
          color: Color(0x1B63725A),
          blurRadius: 18,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xF2FFFFFF), width: 1.5),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xF2FFFFFF), Color(0xBAFFFFFF), Color(0xA9E9F4E5)],
              stops: [0, 0.55, 1],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 1,
                left: 24,
                right: 24,
                child: Container(
                  height: 1.5,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0x00FFFFFF),
                        Colors.white,
                        Color(0x00FFFFFF),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xD9FFFFFF)),
                        gradient: RadialGradient(
                          center: const Alignment(-0.5, -0.6),
                          colors: [Colors.white, accent],
                        ),
                      ),
                      child: const Icon(
                        Icons.restaurant,
                        size: 20,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            food.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF151A13),
                            ),
                          ),
                          Text(
                            '${formatCalories(food.calories)} kcal',
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF697068),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Delete ${food.name}',
                      onPressed: onDelete,
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0x8CFFFFFF),
                        side: const BorderSide(color: Color(0xC9FFFFFF)),
                        minimumSize: const Size(44, 44),
                      ),
                      icon: const Icon(
                        Icons.close,
                        size: 20,
                        color: Color(0xFF242A22),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
