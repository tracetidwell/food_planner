import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_planner_app/features/meal_plans/presentation/providers/meal_plans_provider.dart';

/// Screen for displaying grocery list for an accepted meal plan
class GroceryListScreen extends ConsumerStatefulWidget {
  final String mealPlanId;

  const GroceryListScreen({
    super.key,
    required this.mealPlanId,
  });

  @override
  ConsumerState<GroceryListScreen> createState() => _GroceryListScreenState();
}

class _GroceryListScreenState extends ConsumerState<GroceryListScreen> {
  final Map<String, bool> _checkedItems = {};

  @override
  void initState() {
    super.initState();
    // Load grocery list on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGroceryList();
    });
  }

  Future<void> _loadGroceryList() async {
    await ref
        .read(groceryListStateProvider.notifier)
        .loadGroceryList(widget.mealPlanId);
  }

  @override
  Widget build(BuildContext context) {
    final groceryListState = ref.watch(groceryListStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Grocery List'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
        ),
      ),
      body: groceryListState.when(
        data: (groceryList) {
          if (groceryList == null) {
            return const Center(
              child: Text('Grocery list not found'),
            );
          }

          final itemsByCategory = groceryList.itemsByCategory;
          final categories = itemsByCategory.keys.toList()..sort();

          return Column(
            children: [
              // Info card
              Card(
                margin: const EdgeInsets.all(16),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Shopping List',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Check off items as you shop',
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer
                                    .withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Grocery list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final items = itemsByCategory[category]!;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        title: Text(
                          category,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text('${items.length} items'),
                        children: items.map((item) {
                          final key = '${item.name}_${item.quantity}';
                          final isChecked = _checkedItems[key] ?? false;

                          return CheckboxListTile(
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                _checkedItems[key] = value ?? false;
                              });
                            },
                            title: Text(
                              item.name,
                              style: TextStyle(
                                decoration: isChecked
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: isChecked ? Colors.grey : null,
                              ),
                            ),
                            subtitle: Text(
                              item.quantity == item.quantity.toInt()
                                  ? '${item.quantity.toInt()} ${item.unit}'
                                  : '${item.quantity.toStringAsFixed(1)} ${item.unit}',
                              style: TextStyle(
                                decoration: isChecked
                                    ? TextDecoration.lineThrough
                                    : null,
                                color: isChecked ? Colors.grey : null,
                              ),
                            ),
                            dense: true,
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading grocery list...'),
            ],
          ),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  error.toString(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  'The grocery list may still be generating. Please try again in a moment.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _loadGroceryList,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: () {
              ref.read(mealPlanGenerationProvider.notifier).reset();
              ref.read(groceryListStateProvider.notifier).reset();
              context.go('/');
            },
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Done',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
