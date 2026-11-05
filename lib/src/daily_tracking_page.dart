import 'package:flutter/material.dart';

import 'add_food_page.dart';
import 'food_log.dart';
import 'formatters.dart';
import 'glass_food_row.dart';

const _goal = 2000.0;
const _lime = Color(0xFF9CD71B);
const _paleGreen = Color(0xFFDEEFBA);
const _muted = Color(0xFF777A74);

class DailyTrackingPage extends StatelessWidget {
  const DailyTrackingPage({super.key, required this.log});

  final FoodLog log;

  Future<void> _addFood(BuildContext context) async {
    log.refreshDay();
    final input = await Navigator.of(
      context,
    ).push<FoodInput>(MaterialPageRoute(builder: (_) => const AddFoodPage()));
    if (input != null) log.addFood(input.name, input.calories);
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: log,
    builder: (context, _) {
      final foods = log.foods;
      final total = log.totalCalories;
      return Scaffold(
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF5F9E6), Color(0xFFF7F8F5)],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
                  itemCount: foods.isEmpty ? 2 : foods.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _TrackingHeader(
                        date: log.today,
                        total: total,
                        onBack: () => Navigator.of(context).pop(),
                      );
                    }
                    if (foods.isEmpty) return const _EmptyTrackingList();
                    final food = foods[index - 1];
                    return GlassFoodRow(
                      key: ValueKey(food.id),
                      food: food,
                      accent:
                          foodAccentColors[(index - 1) %
                              foodAccentColors.length],
                      onDelete: () => log.deleteFood(food.id),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(22, 8, 22, 16),
          child: Center(
            heightFactor: 1,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 556),
              child: SizedBox(
                width: double.infinity,
                height: 58,
                child: FilledButton(
                  onPressed: () => _addFood(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: _lime,
                    foregroundColor: Colors.black,
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Add Food', style: TextStyle(fontSize: 22)),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class _TrackingHeader extends StatelessWidget {
  const _TrackingHeader({
    required this.date,
    required this.total,
    required this.onBack,
  });

  final DateTime date;
  final double total;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          IconButton(
            tooltip: 'Back to Home',
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, size: 21),
            style: IconButton.styleFrom(minimumSize: const Size(42, 42)),
          ),
          const Expanded(
            child: Text(
              'Calorie Tracker',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14, color: _muted),
            ),
          ),
          Container(
            constraints: const BoxConstraints(maxWidth: 120),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFFE7E7E7)),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                formatDate(date),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      const SizedBox(height: 2),
      const Text(
        'Daily Tracking',
        style: TextStyle(fontSize: 31, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 22),
      Row(
        children: [
          Expanded(
            child: _TrackingSummaryCard(label: 'Total Calories', amount: total),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: _TrackingSummaryCard(label: 'Daily Goal', amount: _goal),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _TrackingSummaryCard(
              label: 'Remaining Calories',
              amount: _goal - total,
              color: _paleGreen,
            ),
          ),
        ],
      ),
      const SizedBox(height: 22),
      const Text(
        'Food list',
        style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
    ],
  );
}

class _TrackingSummaryCard extends StatelessWidget {
  const _TrackingSummaryCard({
    required this.label,
    required this.amount,
    this.color = Colors.white,
  });

  final String label;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    color: color,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    child: SizedBox(
      height: 120,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, height: 1.1),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                formatCalories(amount),
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const Text('kcal', style: TextStyle(fontSize: 13, color: _muted)),
          ],
        ),
      ),
    ),
  );
}

class _EmptyTrackingList extends StatelessWidget {
  const _EmptyTrackingList();

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    color: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(27)),
    child: const Padding(
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 32),
      child: Column(
        children: [
          Icon(Icons.restaurant_outlined, size: 32, color: _muted),
          SizedBox(height: 10),
          Text(
            'No food added today',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 4),
          Text(
            'Tap Add Food to start tracking.',
            style: TextStyle(color: _muted),
          ),
        ],
      ),
    ),
  );
}
