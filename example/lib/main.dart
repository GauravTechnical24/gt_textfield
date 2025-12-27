import 'package:flutter/material.dart';
import 'package:gt_textfield/gt_textfield.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GT TextField Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TextFieldExampleScreen(),
    );
  }
}

class TextFieldExampleScreen extends StatefulWidget {
  const TextFieldExampleScreen({super.key});

  @override
  State<TextFieldExampleScreen> createState() => _TextFieldExampleScreenState();
}

class _TextFieldExampleScreenState extends State<TextFieldExampleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GT TextField Example'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // MasterTextField Example
              Text(
                'MasterTextField',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),

              MasterTextField(
                controller: _emailController,
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Email is required';
                  if (!value!.contains('@')) return 'Invalid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              MasterTextField(
                controller: _passwordController,
                labelText: 'Password',
                hintText: 'Enter your password',
                prefixIcon: Icons.lock,
                obscureText: _obscurePassword,
                suffixIconWidget: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
                validator: (value) {
                  if ((value?.length ?? 0) < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // SuggestionTextField Example
              Text(
                'SuggestionTextField',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),

              SuggestionTextField(
                fieldName: 'search_example',
                labelText: 'Search',
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                config: const SuggestionFieldConfig(
                  storageType: HistoryStorageType.temporary,
                  maxHistoryItems: 5,
                  showRemoveButton: true,
                ),
                onSubmit: (text) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Searching: $text')));
                },
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Form is valid!')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
