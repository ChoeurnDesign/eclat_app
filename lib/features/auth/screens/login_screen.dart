import 'package:flutter/cupertino.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/seeder_service.dart';
import '../../../core/routes/app_routes.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../widgets/auth_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final SeederService _seederService = SeederService();

  bool _isLoading = false;
  bool _hasSeeded = false;

  @override
  void initState() {
    super.initState();
    _seedUsersIfNeeded();
  }

  Future<void> _seedUsersIfNeeded() async {
    if (! _hasSeeded) {
      await _seederService.seedUsers();
      _hasSeeded = true;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text. trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Please fill in all fields');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await _authService.signIn(
        email: email,
        password: password,
      );

      if (! mounted) return;

      if (result['success']) {
        final isAdmin = await _authService.isAdmin();

        if (! mounted) return;

        if (isAdmin) {
          Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        }
      } else {
        _showErrorDialog(result['message'] ?? 'Login failed');
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('An error occurred:  $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
      backgroundColor:  const Color(0xFFF8F5F0),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: Container(
                height: 250,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF2C3E50),
                      Color(0xFF8A9A5B),
                    ],
                  ),
                ),
                child:  Center(
                  child: Column(
                    mainAxisAlignment:  MainAxisAlignment.center,
                    children: [
                      const Text(
                        'ÉCLAT',
                        style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 8,
                          color: Color(0xFFF8F5F0),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Curated Luxury Collection',
                        style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2,
                          color: const Color(0xFFF8F5F0).withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Login Form
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: CupertinoColors.white,
                  borderRadius: BorderRadius. circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment. start,
                  children: [
                    const Text(
                      'SIGN IN',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 3,
                        color: Color(0xFF2C3E50),
                      ),
                    ),
                    const SizedBox(height:  24),

                    CustomTextField(
                      controller: _emailController,
                      placeholder: 'Email',
                      label: 'EMAIL',
                      icon: CupertinoIcons.mail,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    CustomTextField(
                      controller: _passwordController,
                      placeholder:  'Password',
                      label: 'PASSWORD',
                      icon: CupertinoIcons.lock,
                      obscureText: true,
                    ),

                    const SizedBox(height: 8),

                    AuthButton(
                      text: 'SIGN IN',
                      onPressed:  _handleLogin,
                      isLoading: _isLoading,
                    ),

                    const SizedBox(height: 16),

                    Center(
                      child:  CupertinoButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes. register);
                        },
                        child: const Text(
                          'Don\'t have an account? Sign Up',
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