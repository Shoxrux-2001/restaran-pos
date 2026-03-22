import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/responsive_helper.dart';
import '../../models/order_model.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../../viewmodels/order_viewmodel.dart';
import '../../viewmodels/table_viewmodel.dart';
import '../main/main_screen.dart';

class PaymentScreen extends StatefulWidget {
  final OrderModel order;
  final String lang;
  const PaymentScreen({super.key, required this.order, required this.lang});
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _paymentMethod = AppConstants.paymentCash;
  bool _splitMode = false;
  bool _isProcessing = false;
  bool _isSuccess = false;

  final _cashController = TextEditingController();
  final _cardController = TextEditingController();
  double _cashGiven = 0;
  double _cardGiven = 0;

  String get lang => widget.lang;
  String s(String k) => AppStrings.get(k, lang);

  double get _change => _cashGiven - widget.order.total;
  bool get _cashEnough => _cashGiven >= widget.order.total;
  double get _splitRemaining => widget.order.total - _cashGiven - _cardGiven;
  bool get _splitReady => _splitRemaining <= 0;

  bool get _canPay {
    if (_splitMode) return _splitReady;
    // Naqd yoki karta — berilgan summa kiritish shart emas
    return true;
  }

  @override
  void dispose() {
    _cashController.dispose();
    _cardController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    setState(() => _isProcessing = true);
    final success = await context.read<OrderViewModel>().completeOrder(
      widget.order.id,
      _paymentMethod,
    );
    if (success && mounted) {
      context.read<TableViewModel>().freeTable(widget.order.tableNumber);
      setState(() {
        _isProcessing = false;
        _isSuccess = true;
      });
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) _goToMain();
      });
    }
  }

  void _goToMain() {
    context.read<CartViewModel>().clear();
    Navigator.of(context).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MainScreen(),
        transitionsBuilder: (_, a, __, c) =>
            FadeTransition(opacity: a, child: c),
        transitionDuration: const Duration(milliseconds: 400),
      ),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    R.init(context);
    if (_isSuccess)
      return _SuccessView(order: widget.order, lang: lang, onDone: _goToMain);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(s('payment'), style: TextStyle(fontSize: R.textLG)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Row(
        children: [
          // ─── CHAP: Chek ──────────────────────────────────
          Expanded(
            flex: 55,
            child: Container(
              decoration: const BoxDecoration(color: AppColors.surface),
              child: Column(
                children: [
                  _ReceiptHeader(order: widget.order, lang: lang),
                  Expanded(
                    child: _ReceiptItems(order: widget.order, lang: lang),
                  ),
                  _ReceiptTotals(order: widget.order, lang: lang),
                ],
              ),
            ),
          ),

          Container(width: 1, color: AppColors.border),

          // ─── O'NG: To'lov ────────────────────────────────
          Expanded(
            flex: 45,
            child: Container(
              decoration: const BoxDecoration(color: AppColors.background),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(R.spaceLG),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Jami katta ko'rsatkich
                    _TotalCard(total: widget.order.total, lang: lang),
                    SizedBox(height: R.spaceMD),

                    // Split mode toggle
                    _SplitToggle(
                      splitMode: _splitMode,
                      lang: lang,
                      onToggle: (v) => setState(() {
                        _splitMode = v;
                        _cashController.clear();
                        _cardController.clear();
                        _cashGiven = 0;
                        _cardGiven = 0;
                      }),
                    ),
                    SizedBox(height: R.spaceMD),

                    if (!_splitMode) ...[
                      // ─── Oddiy to'lov ─────────────────────
                      _PayMethodRow(
                        selected: _paymentMethod,
                        lang: lang,
                        onChanged: (v) => setState(() {
                          _paymentMethod = v;
                          _cashController.clear();
                          _cashGiven = 0;
                        }),
                      ),
                      SizedBox(height: R.spaceMD),
                      // Berilgan summa maydoni olib tashlandi
                    ] else ...[
                      // ─── Qisman to'lov ────────────────────
                      _SplitInput(
                        cashController: _cashController,
                        cardController: _cardController,
                        lang: lang,
                        total: widget.order.total,
                        cashGiven: _cashGiven,
                        cardGiven: _cardGiven,
                        remaining: _splitRemaining,
                        onCashChanged: (v) => setState(
                          () => _cashGiven = CurrencyFormatter.parse(v),
                        ),
                        onCardChanged: (v) => setState(
                          () => _cardGiven = CurrencyFormatter.parse(v),
                        ),
                      ),
                    ],

                    SizedBox(height: R.spaceLG),

                    // To'lov tugmasi
                    SizedBox(
                      width: double.infinity,
                      height: R.buttonH + 6,
                      child: ElevatedButton(
                        onPressed: (_canPay && !_isProcessing)
                            ? _processPayment
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _canPay
                              ? AppColors.success
                              : AppColors.textHint,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(R.radiusMD),
                          ),
                        ),
                        child: _isProcessing
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    size: R.iconMD,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: R.spaceXS),
                                  Text(
                                    s('process_payment'),
                                    style: TextStyle(
                                      fontSize: R.textMD + 1,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
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
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CHEK WIDGETLARI
// ═══════════════════════════════════════════════════════════════

class _ReceiptHeader extends StatelessWidget {
  final OrderModel order;
  final String lang;
  const _ReceiptHeader({required this.order, required this.lang});
  @override
  Widget build(BuildContext context) {
    R.init(context);
    final s = (String k) => AppStrings.get(k, lang);
    return Container(
      padding: EdgeInsets.all(R.spaceLG),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          Text(
            'Restoran POS',
            style: TextStyle(
              fontSize: R.textXL,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: R.spaceXS / 2),
          Text(
            DateFormatter.formatDateTime(order.createdAt),
            style: TextStyle(
              fontSize: R.textSM,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: R.spaceXS),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ChipInfo(
                icon: Icons.table_restaurant_rounded,
                text: '${s('table')} ${order.tableNumber}',
              ),
              SizedBox(width: R.spaceSM),
              _ChipInfo(
                icon: Icons.person_outline_rounded,
                text: order.waiterName,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChipInfo extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ChipInfo({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) {
    R.init(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: R.spaceSM,
        vertical: R.spaceXS / 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(R.radiusSM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: R.iconSM - 2, color: AppColors.textSecondary),
          SizedBox(width: R.spaceXS / 2),
          Text(
            text,
            style: TextStyle(
              fontSize: R.textXS,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptItems extends StatelessWidget {
  final OrderModel order;
  final String lang;
  const _ReceiptItems({required this.order, required this.lang});
  @override
  Widget build(BuildContext context) {
    R.init(context);
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: R.spaceLG, vertical: R.spaceSM),
      itemCount: order.items.length,
      separatorBuilder: (_, __) =>
          Divider(height: R.spaceMD, color: AppColors.borderLight),
      itemBuilder: (ctx, i) {
        final item = order.items[i];
        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.getName(lang),
                    style: TextStyle(
                      fontSize: R.textMD,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${item.quantity} × ${CurrencyFormatter.formatNumber(item.price)}',
                    style: TextStyle(
                      fontSize: R.textSM,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              CurrencyFormatter.formatNumber(item.total),
              style: TextStyle(fontSize: R.textMD, fontWeight: FontWeight.w700),
            ),
          ],
        );
      },
    );
  }
}

class _ReceiptTotals extends StatelessWidget {
  final OrderModel order;
  final String lang;
  const _ReceiptTotals({required this.order, required this.lang});
  @override
  Widget build(BuildContext context) {
    R.init(context);
    final s = (String k) => AppStrings.get(k, lang);
    return Container(
      padding: EdgeInsets.all(R.spaceLG),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          _TRow(
            s('subtotal'),
            CurrencyFormatter.format(order.subtotal, lang: lang),
          ),
          SizedBox(height: R.spaceXS),
          _TRow(
            s('tax'),
            CurrencyFormatter.format(order.tax, lang: lang),
            muted: true,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: R.spaceXS + 2),
            child: const Divider(),
          ),
          _TRow(
            s('total'),
            CurrencyFormatter.format(order.total, lang: lang),
            bold: true,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _TRow extends StatelessWidget {
  final String label, value;
  final bool bold, muted;
  final Color? color;
  const _TRow(
    this.label,
    this.value, {
    this.bold = false,
    this.muted = false,
    this.color,
  });
  @override
  Widget build(BuildContext context) {
    R.init(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: bold ? R.textMD : R.textSM,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            color: muted ? AppColors.textSecondary : AppColors.textPrimary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? R.textLG : R.textSM,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TO'LOV WIDGETLARI
// ═══════════════════════════════════════════════════════════════

class _TotalCard extends StatelessWidget {
  final double total;
  final String lang;
  const _TotalCard({required this.total, required this.lang});
  @override
  Widget build(BuildContext context) {
    R.init(context);
    final s = (String k) => AppStrings.get(k, lang);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(R.spaceMD),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(R.radiusLG),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            s('total'),
            style: TextStyle(
              fontSize: R.textSM,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: R.spaceXS / 2),
          Text(
            CurrencyFormatter.format(total, lang: lang),
            style: TextStyle(
              fontSize: R.text2XL,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SplitToggle extends StatelessWidget {
  final bool splitMode;
  final String lang;
  final ValueChanged<bool> onToggle;
  const _SplitToggle({
    required this.splitMode,
    required this.lang,
    required this.onToggle,
  });
  @override
  Widget build(BuildContext context) {
    R.init(context);
    return Row(
      children: [
        Text(
          lang == 'kr'
              ? 'Қисман тўлов (нақд + карта)'
              : 'Qisman to\'lov (naqd + karta)',
          style: TextStyle(
            fontSize: R.textSM,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const Spacer(),
        Switch.adaptive(
          value: splitMode,
          onChanged: onToggle,
          activeColor: AppColors.primary,
        ),
      ],
    );
  }
}

class _PayMethodRow extends StatelessWidget {
  final String selected;
  final String lang;
  final ValueChanged<String> onChanged;
  const _PayMethodRow({
    required this.selected,
    required this.lang,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    R.init(context);
    final s = (String k) => AppStrings.get(k, lang);
    return Row(
      children: [
        Expanded(
          child: _PayCard(
            icon: Icons.payments_outlined,
            label: s('cash'),
            selected: selected == AppConstants.paymentCash,
            onTap: () => onChanged(AppConstants.paymentCash),
          ),
        ),
        SizedBox(width: R.spaceSM),
        Expanded(
          child: _PayCard(
            icon: Icons.credit_card_rounded,
            label: s('card'),
            selected: selected == AppConstants.paymentCard,
            onTap: () => onChanged(AppConstants.paymentCard),
          ),
        ),
      ],
    );
  }
}

class _PayCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _PayCard({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    R.init(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(vertical: R.spaceMD),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(R.radiusMD),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: R.iconLG,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
            SizedBox(height: R.spaceXS),
            Text(
              label,
              style: TextStyle(
                fontSize: R.textSM,
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.primary : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CashInput extends StatelessWidget {
  final TextEditingController controller;
  final String lang;
  final double total, cashGiven, change;
  final ValueChanged<String> onChanged;
  const _CashInput({
    required this.controller,
    required this.lang,
    required this.total,
    required this.cashGiven,
    required this.change,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    R.init(context);
    final s = (String k) => AppStrings.get(k, lang);
    final hasEnough = cashGiven >= total;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          s('amount_given'),
          style: TextStyle(
            fontSize: R.textSM,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: R.spaceXS),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: R.textLG, fontWeight: FontWeight.w700),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: '0',
            suffixText: lang == 'kr' ? 'сўм' : 'so\'m',
            suffixStyle: TextStyle(
              fontSize: R.textSM,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        if (cashGiven > 0) ...[
          SizedBox(height: R.spaceSM),
          Container(
            padding: EdgeInsets.all(R.spaceSM),
            decoration: BoxDecoration(
              color: hasEnough
                  ? AppColors.success.withOpacity(0.08)
                  : AppColors.error.withOpacity(0.08),
              borderRadius: BorderRadius.circular(R.radiusMD),
              border: Border.all(
                color: hasEnough
                    ? AppColors.success.withOpacity(0.3)
                    : AppColors.error.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hasEnough ? s('change') : 'Yetarli emas',
                  style: TextStyle(
                    fontSize: R.textSM,
                    fontWeight: FontWeight.w600,
                    color: hasEnough ? AppColors.success : AppColors.error,
                  ),
                ),
                Text(
                  hasEnough
                      ? CurrencyFormatter.format(change, lang: lang)
                      : CurrencyFormatter.format(total - cashGiven, lang: lang),
                  style: TextStyle(
                    fontSize: R.textMD,
                    fontWeight: FontWeight.w800,
                    color: hasEnough ? AppColors.success : AppColors.error,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _SplitInput extends StatelessWidget {
  final TextEditingController cashController, cardController;
  final String lang;
  final double total, cashGiven, cardGiven, remaining;
  final ValueChanged<String> onCashChanged, onCardChanged;
  const _SplitInput({
    required this.cashController,
    required this.cardController,
    required this.lang,
    required this.total,
    required this.cashGiven,
    required this.cardGiven,
    required this.remaining,
    required this.onCashChanged,
    required this.onCardChanged,
  });
  @override
  Widget build(BuildContext context) {
    R.init(context);
    final s = (String k) => AppStrings.get(k, lang);
    final done = remaining <= 0;
    return Column(
      children: [
        _SplitField(
          icon: Icons.payments_outlined,
          label: s('cash'),
          controller: cashController,
          lang: lang,
          onChanged: onCashChanged,
        ),
        SizedBox(height: R.spaceSM),
        _SplitField(
          icon: Icons.credit_card_rounded,
          label: s('card'),
          controller: cardController,
          lang: lang,
          onChanged: onCardChanged,
        ),
        SizedBox(height: R.spaceSM),
        Container(
          padding: EdgeInsets.all(R.spaceSM),
          decoration: BoxDecoration(
            color: done
                ? AppColors.success.withOpacity(0.08)
                : AppColors.surfaceSecondary,
            borderRadius: BorderRadius.circular(R.radiusMD),
            border: Border.all(
              color: done
                  ? AppColors.success.withOpacity(0.3)
                  : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                done
                    ? (lang == 'kr' ? 'Тўланди ✓' : 'To\'landi ✓')
                    : (lang == 'kr' ? 'Қолди' : 'Qoldi'),
                style: TextStyle(
                  fontSize: R.textSM,
                  fontWeight: FontWeight.w600,
                  color: done ? AppColors.success : AppColors.textPrimary,
                ),
              ),
              Text(
                CurrencyFormatter.format(remaining.abs(), lang: lang),
                style: TextStyle(
                  fontSize: R.textMD,
                  fontWeight: FontWeight.w800,
                  color: done ? AppColors.success : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SplitField extends StatelessWidget {
  final IconData icon;
  final String label, lang;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const _SplitField({
    required this.icon,
    required this.label,
    required this.lang,
    required this.controller,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    R.init(context);
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.surfaceSecondary,
            borderRadius: BorderRadius.circular(R.radiusSM),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, size: R.iconSM, color: AppColors.textSecondary),
        ),
        SizedBox(width: R.spaceSM),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: TextStyle(fontSize: R.textMD, fontWeight: FontWeight.w600),
            onChanged: onChanged,
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(fontSize: R.textSM),
              suffixText: lang == 'kr' ? 'сўм' : 'so\'m',
              suffixStyle: TextStyle(
                fontSize: R.textXS,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// MUVAFFAQIYAT EKRANI
// ═══════════════════════════════════════════════════════════════

class _SuccessView extends StatefulWidget {
  final OrderModel order;
  final String lang;
  final VoidCallback onDone;
  const _SuccessView({
    required this.order,
    required this.lang,
    required this.onDone,
  });
  @override
  State<_SuccessView> createState() => _SuccessViewState();
}

class _SuccessViewState extends State<_SuccessView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    duration: const Duration(milliseconds: 700),
    vsync: this,
  )..forward();
  late final Animation<double> _scale = Tween(
    begin: 0.4,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut));
  late final Animation<double> _fade = CurvedAnimation(
    parent: _ctrl,
    curve: Curves.easeIn,
  );

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final s = (String k) => AppStrings.get(k, widget.lang);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: _scale,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.success.withOpacity(0.3),
                      width: 2.5,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check_rounded,
                      size: R.iconXL + 8,
                      color: AppColors.success,
                    ),
                  ),
                ),
              ),

              SizedBox(height: R.spaceLG),

              Text(
                s("payment_success"),
                style: TextStyle(
                  fontSize: R.textXL,
                  fontWeight: FontWeight.w800,
                ),
              ),

              SizedBox(height: R.spaceSM),

              Text(
                "${s("table")} ${widget.order.tableNumber}",
                style: TextStyle(
                  fontSize: R.textMD,
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: R.spaceXS),

              Text(
                CurrencyFormatter.format(widget.order.total, lang: widget.lang),
                style: TextStyle(
                  fontSize: R.text2XL,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),

              SizedBox(height: R.spaceLG),

              Text(
                widget.lang == "kr"
                    ? "Асосий экранга қайтилмоқда..."
                    : "Asosiy ekranga qaytilmoqda...",
                style: TextStyle(
                  fontSize: R.textSM,
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: R.spaceMD),

              SizedBox(
                width: 200,
                child: OutlinedButton(
                  onPressed: widget.onDone,
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(0, R.buttonH),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(R.radiusMD),
                    ),
                  ),
                  child: Text(
                    s("new_sale"),
                    style: TextStyle(fontSize: R.textSM),
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
