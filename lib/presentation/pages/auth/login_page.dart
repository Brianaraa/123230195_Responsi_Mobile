// lib/presentation/pages/auth/login_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _usernameCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      _authController.login(_usernameCtrl.text, _passwordCtrl.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF000000),
                  Color(0xFF1A0000),
                  Color(0xFF000000),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Subtle red glow
          Positioned(
            top: -200,
            left: -100,
            right: -100,
            child: Container(
              height: 500,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(500),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 40, 49, 222).withOpacity(0.15),
                    blurRadius: 150,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 36),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 80),

                        // Logo
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'NARA',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                      color: const Color.fromARGB(255, 31, 143, 218),
                                      fontSize: 52,
                                      letterSpacing: 8,
                                    ),
                              ),
                              Text(
                                'GAMES',
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                      color: AppColors.textPrimary,
                                      fontSize: 52,
                                      letterSpacing: 8,
                                    ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 60),

                        Text(
                          'Masuk',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(fontSize: 32),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Selamat datang kembali',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),

                        const SizedBox(height: 36),

                        // Username field
                        TextFormField(
                          controller: _usernameCtrl,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            hintText: 'Masukan Email Anda ',
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: AppColors.textMuted,
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Email Tidak Boleh Kosong';
                            }
                            if (val.trim().length < 3) {
                              return 'Email minimal @gmail.com';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.next,
                        ),

                        const SizedBox(height: 16),

                        // Password field
                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Masukkan password',
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: AppColors.textMuted,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.textMuted,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Password tidak boleh kosong';
                            }
                            if (val.trim().length < 4) {
                              return 'Password minimal 4 karakter';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) => _handleLogin(),
                        ),

                        const SizedBox(height: 12),

                        // Error message
                        Obx(() {
                          if (_authController.errorMessage.value.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: AppColors.primary,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _authController.errorMessage.value,
                                    style:
                                        Theme.of(context).textTheme.bodySmall?.copyWith(
                                              color: AppColors.primary,
                                            ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),

                        const SizedBox(height: 28),

                        // Login button
                        Obx(() => ElevatedButton(
                              onPressed: _authController.isLoading.value
                                  ? null
                                  : _handleLogin,
                              child: _authController.isLoading.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                AppColors.textPrimary),
                                      ),
                                    )
                                  : const Text('MASUK'),
                            )),

                        const SizedBox(height: 40),

                        // Hint
                        Center(
                          child: Text(
                            'Gunakan email & password bebas\n(min. 3 & 4 karakter)',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),

                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
