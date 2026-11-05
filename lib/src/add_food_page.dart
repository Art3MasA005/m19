import 'package:flutter/material.dart';

const _lime = Color(0xFF9CD71B);
const _muted = Color(0xFF797D76);

class FoodInput {
  const FoodInput(this.name, this.calories);

  final String name;
  final double calories;
}

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({super.key});

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _caloriesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      FoodInput(
        _nameController.text.trim(),
        double.parse(_caloriesController.text.trim()),
      ),
    );
  }

  void _cancel() => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF5F9E6), Color(0xFFF9FAF3)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _PageHeader(onBack: _cancel),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(38)),
                ),
                child: SafeArea(
                  top: false,
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final compact = constraints.maxHeight < 600;
                          return Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.fromLTRB(
                                    22,
                                    26,
                                    22,
                                    12,
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const Text(
                                          'Calorie Tracker',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        const Text(
                                          'Add a food item to your daily log',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: _muted,
                                          ),
                                        ),
                                        SizedBox(height: compact ? 44 : 62),
                                        TextFormField(
                                          controller: _nameController,
                                          textCapitalization:
                                              TextCapitalization.sentences,
                                          textInputAction: TextInputAction.next,
                                          maxLength: 80,
                                          style: const TextStyle(fontSize: 18),
                                          decoration: _fieldDecoration(
                                            'Food name',
                                          ).copyWith(counterText: ''),
                                          validator: (value) =>
                                              value == null ||
                                                  value.trim().isEmpty
                                              ? 'Enter a food name'
                                              : null,
                                        ),
                                        const SizedBox(height: 6),
                                        const Text(
                                          'Required field',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: _muted,
                                          ),
                                        ),
                                        const SizedBox(height: 28),
                                        TextFormField(
                                          controller: _caloriesController,
                                          keyboardType:
                                              const TextInputType.numberWithOptions(
                                                decimal: true,
                                              ),
                                          textInputAction: TextInputAction.done,
                                          style: const TextStyle(fontSize: 18),
                                          decoration:
                                              _fieldDecoration(
                                                'Calorie amount',
                                              ).copyWith(
                                                suffixText: 'kcal',
                                                suffixStyle: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'Enter a calorie amount';
                                            }
                                            final amount = double.tryParse(
                                              value.trim(),
                                            );
                                            return amount == null ||
                                                    !amount.isFinite ||
                                                    amount <= 0
                                                ? 'Enter a positive number'
                                                : null;
                                          },
                                          onFieldSubmitted: (_) => _save(),
                                        ),
                                        const SizedBox(height: 6),
                                        const Text(
                                          'Required · Enter a number greater than 0',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: _muted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  22,
                                  12,
                                  22,
                                  36,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: FilledButton(
                                        onPressed: _cancel,
                                        style: FilledButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFFF3F3F3,
                                          ),
                                          foregroundColor: Colors.black,
                                          minimumSize: const Size.fromHeight(
                                            54,
                                          ),
                                        ),
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: FilledButton(
                                        onPressed: _save,
                                        style: FilledButton.styleFrom(
                                          backgroundColor: _lime,
                                          foregroundColor: Colors.black,
                                          minimumSize: const Size.fromHeight(
                                            54,
                                          ),
                                        ),
                                        child: const Text(
                                          'Add Food',
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 48),
        child: Row(
          children: [
            _RoundIconButton(
              icon: Icons.arrow_back,
              tooltip: 'Back',
              onPressed: onBack,
            ),
            const Expanded(
              child: Text(
                'Add Food',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
            ),
            _RoundIconButton(
              icon: Icons.close,
              tooltip: 'Close',
              onPressed: onBack,
            ),
          ],
        ),
      ),
    ),
  );
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
    tooltip: tooltip,
    onPressed: onPressed,
    icon: Icon(icon, size: 26),
    style: IconButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      side: const BorderSide(color: Color(0xFFE5E7E4)),
      minimumSize: const Size(48, 48),
    ),
  );
}

InputDecoration _fieldDecoration(String hint) => InputDecoration(
  hintText: hint,
  hintStyle: const TextStyle(color: _muted),
  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(22),
    borderSide: const BorderSide(color: Color(0xFFE5E7E4), width: 1.5),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(22),
    borderSide: const BorderSide(color: Color(0xFFE5E7E4), width: 1.5),
  ),
);
