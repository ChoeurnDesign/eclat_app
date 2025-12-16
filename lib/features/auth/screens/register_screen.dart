import 'package:flutter/cupertino.dart';
import '../../../data/services/auth_service.dart';
import '../../../core/routes/app_routes.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../widgets/auth_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showErrorDialog('Please fill in all fields');
      return;
    }
    if (password != confirmPassword) {
      _showErrorDialog('Passwords do not match');
      return;
    }
    if (password.length < 6) {
      _showErrorDialog('Password must be at least 6 characters');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _authService.signUp(
        email: email,
        password: password,
        displayName: name,
        role: 'user',
      );
      if (!mounted) return;

      if (result['success']) {
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Success'),
            content: const Text('Account created successfully!'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
              ),
            ],
          ),
        );
      } else {
        _showErrorDialog(result['message'] ?? 'Registration failed');
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('An error occurred: $e');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: const Color(0xFFF8F5F0),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header - UPDATED LIKE home_body
            SliverToBoxAdapter(
              child: Container(
                height: 300,
                child: Stack(
                  children: [
                    // Banner Image like home_body
                    Image.asset(
                      'assets/images/banner.jpg',
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 300,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF8A9A5B),
                                Color(0xFF2C3E50),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    // Dark Overlay like home_body
                    Container(
                      height: 300,
                      color: const Color(0xFF000000).withOpacity(0.2),
                    ),

                    // Back Icon - KEPT SIMPLE
                    Positioned(
                      top: 16,
                      left: 16,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.pop(context),
                        child: const Icon(
                          CupertinoIcons.chevron_left,
                          color: Color(0xFFF8F5F0),
                          size: 28,
                        ),
                      ),
                    ),

                    // Text Layout like home_body
                    const Positioned(
                      left: 24,
                      bottom: 80,
                      child: Text(
                        'Curated Luxury Collection',
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2,
                          color: Color(0xFFF8F5F0),
                        ),
                      ),
                    ),

                    const Positioned(
                      left: 24,
                      bottom: 120,
                      child: Text(
                        'JOIN ÉCLAT',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 6,
                          color: Color(0xFFF8F5F0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Register Form - NO CHANGES
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x1A000000),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CREATE ACCOUNT',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height: 24),
                    CustomTextField(
                      controller: _nameController,
                      placeholder: 'Full Name',
                      label: 'FULL NAME',
                      icon: CupertinoIcons.person,
                    ),
                    CustomTextField(
                      controller: _emailController,
                      placeholder: 'Email',
                      label: 'EMAIL',
                      icon: CupertinoIcons.mail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    CustomTextField(
                      controller: _passwordController,
                      placeholder: 'Password',
                      label: 'PASSWORD',
                      icon: CupertinoIcons.lock,
                      obscureText: true,
                    ),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      placeholder: 'Confirm Password',
                      label: 'CONFIRM PASSWORD',
                      icon: CupertinoIcons.lock_fill,
                      obscureText: true,
                    ),
                    const SizedBox(height: 8),
                    AuthButton(
                      text: 'CREATE ACCOUNT',
                      onPressed: _handleRegister,
                      isLoading: _isLoading,
                      isSecondary: true,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: CupertinoButton(
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, AppRoutes.login),
                        child: const Text(
                          'Already have an account? Sign In',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF8A9A5B),
                          ),
                        ),
                      ),
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
}