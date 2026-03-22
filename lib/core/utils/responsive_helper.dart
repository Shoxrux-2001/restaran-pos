import 'package:flutter/material.dart';

/// Planshet va telefon uchun responsive o'lchamlar
class R {
  R._();

  static late MediaQueryData _mq;
  static late double _w;
  static late double _h;

  static void init(BuildContext context) {
    _mq = MediaQuery.of(context);
    _w = _mq.size.width;
    _h = _mq.size.height;
  }

  /// Ekran kengligi
  static double get screenW => _w;

  /// Ekran balandligi
  static double get screenH => _h;

  /// Planshetmi?
  static bool get isTablet => _w >= 768;

  /// Katta planshetmi? (1024+)
  static bool get isLargeTablet => _w >= 1024;

  /// Landscape rejimimi?
  static bool get isLandscape => _w > _h;

  // ─── Font o'lchamlari ─────────────────────────────────────

  /// Kichik matn: 11-12
  static double get textXS => isLargeTablet
      ? 14
      : isTablet
      ? 13
      : 12;

  /// Oddiy matn: 13-14
  static double get textSM => isLargeTablet
      ? 16
      : isTablet
      ? 15
      : 14;

  /// Asosiy matn: 14-16
  static double get textMD => isLargeTablet
      ? 18
      : isTablet
      ? 17
      : 16;

  /// Sarlavha: 16-18
  static double get textLG => isLargeTablet
      ? 21
      : isTablet
      ? 20
      : 18;

  /// Katta sarlavha: 20-24
  static double get textXL => isLargeTablet
      ? 28
      : isTablet
      ? 26
      : 24;

  /// Juda katta: 28-36
  static double get text2XL => isLargeTablet
      ? 36
      : isTablet
      ? 32
      : 28;

  // ─── Padding / Spacing ────────────────────────────────────

  /// Kichik: 8-10
  static double get spaceXS => isLargeTablet
      ? 10
      : isTablet
      ? 9
      : 8;

  /// O'rta: 12-16
  static double get spaceSM => isLargeTablet
      ? 16
      : isTablet
      ? 14
      : 12;

  /// Asosiy: 16-20
  static double get spaceMD => isLargeTablet
      ? 20
      : isTablet
      ? 18
      : 16;

  /// Katta: 20-28
  static double get spaceLG => isLargeTablet
      ? 28
      : isTablet
      ? 24
      : 20;

  /// Juda katta: 24-36
  static double get spaceXL => isLargeTablet
      ? 36
      : isTablet
      ? 30
      : 24;

  // ─── Border radius ────────────────────────────────────────

  static double get radiusSM => isLargeTablet ? 10 : 8;
  static double get radiusMD => isLargeTablet
      ? 14
      : isTablet
      ? 12
      : 10;
  static double get radiusLG => isLargeTablet
      ? 18
      : isTablet
      ? 16
      : 14;
  static double get radiusXL => isLargeTablet
      ? 22
      : isTablet
      ? 20
      : 16;

  // ─── Icon o'lchamlari ────────────────────────────────────

  static double get iconSM => isLargeTablet ? 22 : 20;
  static double get iconMD => isLargeTablet
      ? 26
      : isTablet
      ? 24
      : 22;
  static double get iconLG => isLargeTablet
      ? 28
      : isTablet
      ? 24
      : 22;
  static double get iconXL => isLargeTablet
      ? 36
      : isTablet
      ? 32
      : 28;

  // ─── Komponent o'lchamlari ───────────────────────────────

  /// Tugma balandligi
  static double get buttonH => isLargeTablet
      ? 58
      : isTablet
      ? 54
      : 50;

  /// TextField balandligi
  static double get inputH => isLargeTablet
      ? 52
      : isTablet
      ? 48
      : 44;

  /// AppBar balandligi
  static double get appBarH => isLargeTablet
      ? 64
      : isTablet
      ? 60
      : 56;

  /// O'ng panel kengligi (zakaz paneli)
  static double get orderPanelW => isLargeTablet
      ? 360
      : isTablet
      ? 320
      : 300;

  /// Product card aspect ratio
  static double get productCardRatio => isLargeTablet
      ? 0.78
      : isTablet
      ? 0.82
      : 0.88;

  /// Grid ustunlar soni
  static int get productGridCols => isLargeTablet
      ? 4
      : isTablet
      ? 3
      : 2;

  /// Stol tanlash grid ustunlar soni
  static int get tableGridCols => isLargeTablet
      ? 6
      : isTablet
      ? 5
      : 4;

  // ─── Qulay funksiyalar ───────────────────────────────────

  /// Foizda kenglik: R.pw(0.5) = ekranning 50%
  static double pw(double percent) => _w * percent;

  /// Foizda balandlik: R.ph(0.5) = ekranning 50%
  static double ph(double percent) => _h * percent;

  /// Adaptiv qiymat: katta planshet / planshet / telefon
  static T adaptive<T>(T large, T tablet, T phone) {
    if (isLargeTablet) return large;
    if (isTablet) return tablet;
    return phone;
  }
}

/// Responsive wrapper — faqat bitta joyda R.init() chaqirish uchun
class ResponsiveBuilder extends StatelessWidget {
  final Widget child;
  const ResponsiveBuilder({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    R.init(context);
    return child;
  }
}
