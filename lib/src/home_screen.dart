import 'package:flutter/material.dart';

import 'add_food_page.dart';
import 'daily_tracking_page.dart';
import 'food_log.dart';
import 'formatters.dart';
import 'glass_food_row.dart';

const _goal = 2000.0;
const _paleGreen = Color(0xFFDEEFBA);
const _lime = Color(0xFF9CD71B);
const _muted = Color(0xFF777A74);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final FoodLog _log = FoodLog();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _log.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _log.refreshDay();
  }

  Future<void> _addFood() async {
    _log.refreshDay();
    final input = await Navigator.of(
      context,
    ).push<FoodInput>(MaterialPageRoute(builder: (_) => const AddFoodPage()));
    if (!mounted || input == null) return;
    _log.addFood(input.name, input.calories);
  }

  void _openTracking() {
    _log.refreshDay();
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => DailyTrackingPage(log: _log)),
    );
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _log,
    builder: (context, _) {
      final foods = _log.foods;
      final total = _log.totalCalories;
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
                  padding: const EdgeInsets.fromLTRB(22, 24, 22, 24),
                  itemCount: foods.isEmpty ? 2 : foods.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _Dashboard(
                        today: _log.today,
                        total: total,
                        remaining: _goal - total,
                        onTracking: _openTracking,
                      );
                    }
                    if (foods.isEmpty) return const _EmptyFoodList();
                    final food = foods[index - 1];
                    return GlassFoodRow(
                      key: ValueKey(food.id),
                      food: food,
                      accent:
                          foodAccentColors[(index - 1) %
                              foodAccentColors.length],
                      onDelete: () => _log.deleteFood(food.id),
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
                  onPressed: _addFood,
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

class _Dashboard extends StatelessWidget {
  const _Dashboard({
    required this.today,
    required this.total,
    required this.remaining,
    required this.onTracking,
  });

  final DateTime today;
  final double total;
  final double remaining;
  final VoidCallback onTracking;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundColor: _paleGreen,
            child: Icon(Icons.person_outline, color: Colors.black87),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text('Welcome Back!', style: TextStyle(fontSize: 19)),
          ),
          IconButton(
            tooltip: 'Daily Tracking',
            onPressed: onTracking,
            icon: const Icon(Icons.calendar_today_outlined),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFFE5E7E4)),
              minimumSize: const Size(48, 48),
            ),
          ),
        ],
      ),
      const SizedBox(height: 30),
      const Text(
        'Calorie Tracker',
        style: TextStyle(fontSize: 36, fontWeight: FontWeight.w700),
      ),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFFE7E7E7)),
        ),
        child: Text(
          formatDate(today),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      const SizedBox(height: 12),
      _TotalCard(total: total),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: _SmallCard(
              label: 'Daily Goal',
              amount: _goal,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SmallCard(
              label: 'Remaining Calories',
              amount: remaining,
              color: _paleGreen,
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),
      const Text(
        'Food list',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      ),
      const SizedBox(height: 12),
    ],
  );
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    color: _paleGreen,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
    child: Padding(
      padding: const EdgeInsets.all(22),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Total Calories', style: TextStyle(fontSize: 22)),
                const SizedBox(height: 36),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: formatCalories(total),
                          style: const TextStyle(fontSize: 43),
                        ),
                        const TextSpan(
                          text: ' kcal',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 112,
            height: 112,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: (total / _goal).clamp(0.0, 1.0),
                    strokeWidth: 7,
                    strokeCap: StrokeCap.round,
                    color: _lime,
                    backgroundColor: Colors.white,
                  ),
                ),
                const Icon(
                  Icons.local_fire_department_rounded,
                  size: 50,
                  color: Color(0xFFFF6B2D),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _SmallCard extends StatelessWidget {
  const _SmallCard({
    required this.label,
    required this.amount,
    required this.color,
  });

  final String label;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    color: color,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(28),
      side: color == Colors.white
          ? const BorderSide(color: Color(0xFFE5E5E5))
          : BorderSide.none,
    ),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 12, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, maxLines: 2, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: formatCalories(amount),
                    style: const TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const TextSpan(
                    text: ' kcal',
                    style: TextStyle(fontSize: 14, color: _muted),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _EmptyFoodList extends StatelessWidget {
  const _EmptyFoodList();

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    elevation: 0,
    color: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
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
