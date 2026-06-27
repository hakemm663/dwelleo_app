import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/locale_cubit.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../core/widgets/dwelleo_app_bar.dart';

/// Login (Welcome Back). UI STUB ONLY — the real authentication is Nafath-based
/// (see docs/api/REAL_API_SPEC.md). The email/password form mirrors dwelleo.sa's
/// login page; wiring it to real endpoints is pending a captured auth flow.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _todo(String label) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$label — coming soon')));
  }

  Widget _fieldIcon(BuildContext context, String asset) => Padding(
    padding: const EdgeInsets.all(14),
    child: SvgPicture.asset(
      asset,
      width: 18,
      height: 18,
      colorFilter: ColorFilter.mode(
        Theme.of(context).colorScheme.onSurfaceVariant,
        BlendMode.srcIn,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final ar = context.watch<LocaleCubit>().state.languageCode == 'ar';
    return Scaffold(
      appBar: const DwelleoAppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            const SizedBox(height: 24),
            Text(
              ar ? 'مرحبًا بعودتك' : 'Welcome Back',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              ar
                  ? 'سجّل الدخول للمتابعة إلى دويليو'
                  : 'Sign in to continue to Dwelleo',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 28),
            Text(ar ? 'البريد الإلكتروني' : 'Email Address'),
            const SizedBox(height: 6),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: _fieldIcon(context, AppSvg.inputEmail),
                hintText: 'your.email@example.com',
              ),
            ),
            const SizedBox(height: 16),
            Text(ar ? 'كلمة المرور' : 'Password'),
            const SizedBox(height: 6),
            TextField(
              controller: _password,
              obscureText: _obscure,
              decoration: InputDecoration(
                prefixIcon: _fieldIcon(context, AppSvg.inputPassword),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscure ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => setState(() => _obscure = !_obscure),
                ),
                hintText: '••••••••',
              ),
            ),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: () =>
                    _todo(ar ? 'استعادة كلمة المرور' : 'Forgot password'),
                child: Text(ar ? 'نسيت كلمة المرور؟' : 'Forgot password?'),
              ),
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () => _todo(ar ? 'تسجيل الدخول' : 'Sign in'),
              child: Text(ar ? 'تسجيل الدخول' : 'Sign In'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(ar ? 'أو' : 'OR'),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () => _todo('Google'),
              icon: SvgPicture.asset(AppSvg.google, width: 20, height: 20),
              label: Text(ar ? 'المتابعة عبر Google' : 'Continue with Google'),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(ar ? 'ليس لديك حساب؟' : "Don't have an account?"),
                TextButton(
                  onPressed: () => context.go(RoutePaths.signupRole),
                  child: Text(ar ? 'إنشاء حساب' : 'Sign Up'),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
