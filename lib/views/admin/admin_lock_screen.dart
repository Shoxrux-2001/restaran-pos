import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/responsive_helper.dart';
import '../../viewmodels/auth_viewmodel.dart';
import 'admin_screen.dart';

class AdminLockScreen extends StatefulWidget {
  final String lang;
  const AdminLockScreen({super.key, required this.lang});
  @override
  State<AdminLockScreen> createState() => _AdminLockScreenState();
}

class _AdminLockScreenState extends State<AdminLockScreen> {
  final _passwordController = TextEditingController();
  bool _obscure = true;
  String? _error;
  bool _isLoading = false;

  String get lang => widget.lang;
  String s(String k) => AppStrings.get(k, lang);

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _check() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    final ok = await context.read<AuthViewModel>().checkAdminPassword(
      _passwordController.text,
    );
    if (ok && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => AdminScreen(lang: lang)),
      );
    } else {
      setState(() {
        _error = s('wrong_password');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    R.init(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(s('admin_panel'), style: TextStyle(fontSize: R.textLG)),
        backgroundColor: AppColors.surface,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          width: R.isLargeTablet ? 420 : 380,
          padding: EdgeInsets.all(R.spaceLG),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(R.radiusLG),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: R.isLargeTablet ? 72 : 64,
                height: R.isLargeTablet ? 72 : 64,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.admin_panel_settings_outlined,
                  color: AppColors.primary,
                  size: R.iconLG,
                ),
              ),
              SizedBox(height: R.spaceMD),
              Text(
                s('admin_password'),
                style: TextStyle(
                  fontSize: R.textLG,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: R.spaceXS),
              Text(
                s('enter_admin_password'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: R.textSM,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: R.spaceMD),
              TextField(
                controller: _passwordController,
                obscureText: _obscure,
                onSubmitted: (_) => _check(),
                autofocus: true,
                style: TextStyle(fontSize: R.textMD),
                decoration: InputDecoration(
                  hintText: s('enter_password'),
                  prefixIcon: Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.textHint,
                    size: R.iconSM,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: R.iconSM,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              if (_error != null) ...[
                SizedBox(height: R.spaceSM),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: R.spaceSM,
                    vertical: R.spaceXS,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(R.radiusSM),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: AppColors.error,
                        size: R.iconSM,
                      ),
                      SizedBox(width: R.spaceXS),
                      Text(
                        _error!,
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: R.textSM,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: R.spaceMD),
              SizedBox(
                width: double.infinity,
                height: R.buttonH,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _check,
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          s('confirm'),
                          style: TextStyle(fontSize: R.textMD),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
