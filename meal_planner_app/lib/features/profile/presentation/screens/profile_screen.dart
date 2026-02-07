import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_planner_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:meal_planner_app/features/profile/presentation/providers/profile_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _foodPreferencesController = TextEditingController();
  final _mealsPerDayController = TextEditingController();
  final _snacksPerDayController = TextEditingController();
  final _apiKeyController = TextEditingController();

  bool _obscureApiKey = true;

  @override
  void dispose() {
    _foodPreferencesController.dispose();
    _mealsPerDayController.dispose();
    _snacksPerDayController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  void _loadProfile() {
    final profileState = ref.read(profileNotifierProvider);
    profileState.whenData((profile) {
      if (profile != null) {
        _foodPreferencesController.text = profile.foodPreferences ?? '';
        _mealsPerDayController.text = profile.mealsPerDay?.toString() ?? '3';
        _snacksPerDayController.text = profile.snacksPerDay?.toString() ?? '2';
      } else {
        _mealsPerDayController.text = '3';
        _snacksPerDayController.text = '2';
      }
    });
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final foodPreferences = _foodPreferencesController.text.trim().isNotEmpty
        ? _foodPreferencesController.text.trim()
        : null;
    final mealsPerDay = int.tryParse(_mealsPerDayController.text);
    final snacksPerDay = int.tryParse(_snacksPerDayController.text);

    final success = await ref.read(profileNotifierProvider.notifier).updateProfile(
          foodPreferences: foodPreferences,
          mealsPerDay: mealsPerDay,
          snacksPerDay: snacksPerDay,
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  void _setApiKey() async {
    if (_apiKeyController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an API key')),
      );
      return;
    }

    // TODO: Implement API key setting
    // This requires adding the setApiKey method to profile provider
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('API key management coming soon!')),
    );
  }

  void _deleteApiKey() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete API Key'),
        content: const Text(
          'Are you sure you want to remove your custom OpenAI API key? '
          'You will use the default app API key with limited usage.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: Implement API key deletion
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('API key management coming soon!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final authState = ref.watch(authNotifierProvider);

    // Load profile data when available
    profileState.whenData((profile) {
      if (profile != null && _foodPreferencesController.text.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _loadProfile());
      }
    });

    final userEmail = authState.maybeWhen(
      authenticated: (user) => user.email,
      orElse: () => 'user@example.com',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
      ),
      body: profileState.when(
        data: (profile) => Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // User Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Icon(
                          Icons.person,
                          size: 48,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        userEmail,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Preferences',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Food Preferences
              TextFormField(
                controller: _foodPreferencesController,
                decoration: const InputDecoration(
                  labelText: 'Food Preferences & Restrictions',
                  border: OutlineInputBorder(),
                  helperText: 'e.g., vegetarian, no nuts, low sodium',
                  prefixIcon: Icon(Icons.restaurant_menu),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Meals Per Day
              TextFormField(
                controller: _mealsPerDayController,
                decoration: const InputDecoration(
                  labelText: 'Meals Per Day',
                  border: OutlineInputBorder(),
                  helperText: 'Number of meals you eat daily',
                  prefixIcon: Icon(Icons.food_bank),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  final meals = int.tryParse(value);
                  if (meals == null || meals < 1 || meals > 10) {
                    return 'Enter valid number (1-10)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Snacks Per Day
              TextFormField(
                controller: _snacksPerDayController,
                decoration: const InputDecoration(
                  labelText: 'Snacks Per Day',
                  border: OutlineInputBorder(),
                  helperText: 'Number of snacks you eat daily',
                  prefixIcon: Icon(Icons.cookie),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  final snacks = int.tryParse(value);
                  if (snacks == null || snacks < 0 || snacks > 10) {
                    return 'Enter valid number (0-10)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Save Button
              FilledButton(
                onPressed: profileState.isLoading ? null : _saveProfile,
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: Text('Save Preferences'),
                ),
              ),

              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),

              // OpenAI API Key Section
              const Text(
                'OpenAI API Key (Optional)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Provide your own OpenAI API key for unlimited meal plan generations. '
                'Without this, you are limited to 10 generations per month using the default API key.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _apiKeyController,
                decoration: InputDecoration(
                  labelText: 'OpenAI API Key',
                  border: const OutlineInputBorder(),
                  hintText: 'sk-...',
                  helperText: 'Your key is encrypted and stored securely',
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureApiKey ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() => _obscureApiKey = !_obscureApiKey);
                    },
                  ),
                ),
                obscureText: _obscureApiKey,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _setApiKey,
                      icon: const Icon(Icons.save),
                      label: const Text('Save API Key'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: _deleteApiKey,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Remove'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),

              // Account Actions
              const Text(
                'Account',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Logout', style: TextStyle(color: Colors.red)),
                onTap: () {
                  ref.read(authNotifierProvider.notifier).logout();
                  context.go('/login');
                },
              ),

              // Error Display
              if (profileState.hasError) ...[
                const SizedBox(height: 16),
                Card(
                  color: Theme.of(context).colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      profileState.error.toString(),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => ref.invalidate(profileNotifierProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
