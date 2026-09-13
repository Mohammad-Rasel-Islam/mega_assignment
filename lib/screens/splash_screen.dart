import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/constants.dart';
import 'login_screen.dart';
import 'main_wrapper_screen.dart';

/// Splash screen shown while the app checks whether a valid token is stored.
///
/// Flow:
///   1. App starts → AuthProvider begins token validation in the background.
///   2. SplashScreen shows logo + spinner.
///   3. Once [AuthProvider.isLoading] becomes false we navigate accordingly.
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scaleAnim = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    // Listen for auth state changes and navigate when ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listenForAuthReady();
    });
  }

  void _listenForAuthReady() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // If already done (unlikely but possible) navigate immediately.
    if (!authProvider.isLoading) {
      _navigate(authProvider.isAuthenticated);
      return;
    }

    // Otherwise wait for the loading to complete.
    authProvider.addListener(() {
      if (!authProvider.isLoading && mounted) {
        _navigate(authProvider.isAuthenticated);
      }
    });
  }

  void _navigate(bool isAuthenticated) {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => isAuthenticated
            ? const MainWrapperScreen()
            : const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ── Animated Logo ──────────────────────────────────────────
            ScaleTransition(
              scale: _scaleAnim,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.35),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.shopping_bag_rounded,
                    size: 56,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // ── App Name ───────────────────────────────────────────────
            FadeTransition(
              opacity: _fadeAnim,
              child: const Column(
                children: [
                  Text(
                    'Shop App',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      letterSpacing: 1.4,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Online Shopping Made Simple',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),

            // ── Loading spinner ────────────────────────────────────────
            const CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.primary),
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}
