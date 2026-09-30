import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mindly/core/theme/app_colors.dart';
import 'package:mindly/features/auth/screens/auth_wrapper.dart';
import '../../../models/user_model.dart';
import '../../../widgets/app_button.dart';
import '../controllers/auth_controller.dart';
import 'login_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UserRole _selectedRole = UserRole.teen;
  bool _isPasswordVisible = false;
  bool _isSignUpLoading = false;
  bool _isGuestLoading = false;
  bool _isRegularSignUp = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSignUpLoading = true;
        _isRegularSignUp = true;
      });
      try {
        await ref.read(authControllerProvider.notifier).signUp(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              displayName: _nameController.text.trim(),
              role: _selectedRole,
            );

        // Sign out immediately so they have to login
        await ref.read(authControllerProvider.notifier).signOut();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account created successfully! Please login.')),
          );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSignUpLoading = false;
            _isRegularSignUp = false;
          });
        }
      }
    }
  }

  void _signInAnonymously() async {
    setState(() => _isGuestLoading = true);
    try {
      await ref.read(authControllerProvider.notifier).signInAnonymously();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGuestLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authControllerProvider, (previous, next) {
      if (_isRegularSignUp) return; // Ignore state updates during regular sign up flow

      next.whenOrNull(
        data: (user) {
          if (user != null && mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const AuthWrapper()),
              (route) => false,
            );
          }
        },
        error: (error, stackTrace) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.toString()),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFFFDF5E6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 60),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Join Mindly',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: const Color(0xFF2D1B4D),
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Fraunces',
                            ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: IntrinsicWidth(
                            child: Row(
                              children: [
                                _buildRoleToggle(UserRole.teen, 'Teen'),
                                _buildRoleToggle(UserRole.parent, 'Parent'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildTextField(
                        controller: _nameController,
                        hintText: 'Your Name',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _emailController,
                        hintText: 'Email Address',
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        icon: Icons.lock_outline,
                        isPassword: true,
                        isPasswordVisible: _isPasswordVisible,
                        onTogglePassword: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                      ),
                      const SizedBox(height: 32),
                      AppButton(
                        text: 'Sign Up',
                        onPressed: _signUp,
                        isLoading: _isSignUpLoading,
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const LoginScreen()),
                            );
                          },
                          child: RichText(
                            text: const TextSpan(
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                              children: [
                                TextSpan(text: "Already have an account? "),
                                TextSpan(
                                  text: 'Login',
                                  style: TextStyle(
                                    color: Color(0xFF2D1B4D),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: _isGuestLoading
                            ? const CircularProgressIndicator(color: AppColors.amber)
                            : TextButton.icon(
                                onPressed: _signInAnonymously,
                                icon: const Icon(Icons.arrow_forward, color: AppColors.amber, size: 18),
                                label: const Text(
                                  'Quick Track as Guest',
                                  style: TextStyle(color: AppColors.amber, fontWeight: FontWeight.bold),
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
      ),
    );
  }

  Widget _buildRoleToggle(UserRole role, String label) {
    final isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.amber.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            if (isSelected) ...[
              const Icon(Icons.check, size: 16, color: Color(0xFF2D1B4D)),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF2D1B4D) : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onTogglePassword,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade400),
        prefixIcon: Icon(icon, color: Colors.grey.shade400),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: Colors.grey.shade400,
                ),
                onPressed: onTogglePassword,
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.amber),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
    );
  }
}
