import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../history/history_screen.dart';
import '../../admin/admin_lock_screen.dart';

class LeftMenuDrawer extends StatelessWidget {
  final String lang;
  const LeftMenuDrawer({super.key, required this.lang});

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final s = (String key) => AppStrings.get(key, lang);
    final auth = context.watch<AuthViewModel>();
    final user = auth.currentUser;

    return Drawer(
      width: R.isLargeTablet ? 280 : 260,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(16)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // ─── Header ───────────────────────────────────
            Container(
              padding: EdgeInsets.all(R.spaceLG),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: R.isLargeTablet ? 50 : 44,
                    height: R.isLargeTablet ? 50 : 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(R.radiusMD),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.restaurant_menu_rounded,
                        color: Colors.white,
                        size: R.iconLG,
                      ),
                    ),
                  ),
                  SizedBox(width: R.spaceSM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s('app_name'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: R.textMD,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          lang == 'kr'
                              ? 'Ресторан бошқарув тизими'
                              : 'Restoran boshqaruv tizimi',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: R.textXS,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: R.spaceXS),

            // ─── Menyu elementlari ─────────────────────────
            _MenuItem(
              icon: Icons.history_rounded,
              label: s('history'),
              subtitle: lang == 'kr'
                  ? 'Barcha zakazlar tarixi'
                  : 'Barcha zakazlar tarixi',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HistoryScreen(lang: lang)),
                );
              },
            ),

            _MenuItem(
              icon: Icons.admin_panel_settings_outlined,
              label: s('admin_panel'),
              subtitle: lang == 'kr'
                  ? 'Statistika, mahsulotlar, sozlamalar'
                  : 'Statistika, mahsulotlar, sozlamalar',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AdminLockScreen(lang: lang),
                  ),
                );
              },
            ),

            const Spacer(),

            // ─── Pastki info ──────────────────────────────
            const Divider(),
            Padding(
              padding: EdgeInsets.all(R.spaceMD),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: R.iconSM - 2,
                    color: AppColors.textHint,
                  ),
                  SizedBox(width: R.spaceXS),
                  Text(
                    'v1.0.0',
                    style: TextStyle(
                      fontSize: R.textXS,
                      color: AppColors.textHint,
                    ),
                  ),
                  const Spacer(),
                  // Til toggle
                  GestureDetector(
                    onTap: () => auth.toggleLanguage(),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: R.spaceXS + 2,
                        vertical: R.spaceXS - 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(R.radiusSM),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        lang == 'uz' ? 'UZ → КР' : 'КР → UZ',
                        style: TextStyle(
                          fontSize: R.textXS,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: R.spaceXS),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  final Color? color;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final c = color ?? AppColors.textPrimary;
    return ListTile(
      leading: Container(
        width: R.isLargeTablet ? 40 : 36,
        height: R.isLargeTablet ? 40 : 36,
        decoration: BoxDecoration(
          color: c.withOpacity(0.08),
          borderRadius: BorderRadius.circular(R.radiusSM),
        ),
        child: Icon(icon, color: c, size: R.iconSM),
      ),
      title: Text(
        label,
        style: TextStyle(
          fontSize: R.textSM,
          fontWeight: FontWeight.w600,
          color: c,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: TextStyle(
                fontSize: R.textXS,
                color: AppColors.textSecondary,
              ),
            )
          : null,
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(R.radiusSM),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: R.spaceMD,
        vertical: R.spaceXS / 2,
      ),
    );
  }
}
