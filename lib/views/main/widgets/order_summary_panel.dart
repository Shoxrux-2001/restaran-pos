import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../viewmodels/auth_viewmodel.dart';
import '../../../viewmodels/cart_viewmodel.dart';
import '../../../viewmodels/order_viewmodel.dart';
import '../../../viewmodels/table_viewmodel.dart';
import '../../payment/payment_screen.dart';

class OrderSummaryPanel extends StatelessWidget {
  final String lang;
  final VoidCallback onTableTap;
  final List<Widget>? extraActions;
  final bool hideTableSelector;

  const OrderSummaryPanel({
    super.key,
    required this.lang,
    required this.onTableTap,
    this.extraActions,
    this.hideTableSelector = false,
  });

  String s(String k) => AppStrings.get(k, lang);

  // ─── Stol yoki Sayoq tanlash dialog ─────────────────────
  Future<int?> _showTableOrTakeout(BuildContext context) {
    return showDialog<int>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) => _TableOrTakeoutOverlay(lang: lang),
    );
  }

  Future<void> _handleProcessPayment(BuildContext context) async {
    final cart = context.read<CartViewModel>();
    final auth = context.read<AuthViewModel>();
    final tableVM = context.read<TableViewModel>();

    // Stol yoki Sayoq tanlanmagan → dialog
    if (!cart.isTakeout && cart.tableNumber == 0) {
      final result = await _showTableOrTakeout(context);
      if (result == null || !context.mounted) return;
      if (result == -1) {
        cart.setTakeout();
      } else {
        // Bo'sh stol tanlandi
        cart.setTable(result);
      }
    }

    if (!context.mounted) return;

    final order = await context.read<OrderViewModel>().createOrder(
      tableNumber: cart.isTakeout ? 0 : cart.tableNumber,
      waiterId: auth.currentUser.id,
      waiterName: auth.currentUser.name,
      items: cart.items.toList(),
      subtotal: cart.subtotal,
      tax: cart.tax,
      total: cart.total,
      note: cart.isTakeout ? 'SAYOQ' : null,
    );

    if (order != null && context.mounted) {
      if (!cart.isTakeout) {
        // Avvalgi zakaz O'ZGARMAYDI — yangi zakaz qo'shiladi
        tableVM.occupyTable(order);
      }
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PaymentScreen(order: order, lang: lang),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final cart = context.watch<CartViewModel>();

    return Container(
      decoration: const BoxDecoration(color: AppColors.surface),
      child: Column(
        children: [
          _PanelHeader(
            lang: lang,
            cart: cart,
            hideTableSelector: hideTableSelector,
            onTableTap: onTableTap,
          ),

          if (extraActions != null) ...extraActions!,

          Expanded(
            child: cart.isEmpty
                ? _EmptyCart(lang: lang)
                : ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: R.spaceXS),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, indent: 16, endIndent: 16),
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return _OrderItemRow(
                        name: item.getName(lang),
                        price: item.price,
                        quantity: item.quantity,
                        total: item.total,
                        onRemove: () {
                          final cartVM = context.read<CartViewModel>();
                          final name = item.getName(lang);
                          cartVM.removeItem(item.productId);
                          ScaffoldMessenger.of(context).clearSnackBars();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "$name o'chirildi",
                                style: TextStyle(fontSize: R.textSM),
                              ),
                              duration: const Duration(seconds: 4),
                              action: SnackBarAction(
                                label: 'Bekor',
                                onPressed: () => cartVM.undoRemove(),
                              ),
                            ),
                          );
                        },
                        onDecrease: () => context
                            .read<CartViewModel>()
                            .removeOne(item.productId),
                        onIncrease: () => context.read<CartViewModel>().addById(
                          item.productId,
                        ),
                      );
                    },
                  ),
          ),

          if (!cart.isEmpty) ...[
            const Divider(height: 1),
            _SummarySection(cart: cart, lang: lang),
            if (!cart.isTakeout && cart.tableNumber > 0)
              _SaveBtn(cart: cart, lang: lang),
            _ProcessBtn(
              cart: cart,
              lang: lang,
              onTap: () => _handleProcessPayment(context),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Header ──────────────────────────────────────────────────

class _PanelHeader extends StatelessWidget {
  final String lang;
  final CartViewModel cart;
  final bool hideTableSelector;
  final VoidCallback onTableTap;
  const _PanelHeader({
    required this.lang,
    required this.cart,
    required this.hideTableSelector,
    required this.onTableTap,
  });

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final s = (String k) => AppStrings.get(k, lang);

    String badgeText;
    Color badgeColor;
    IconData badgeIcon;

    if (cart.isTakeout) {
      badgeText = lang == 'kr' ? 'Сайёқ' : 'Sayoq';
      badgeColor = AppColors.success;
      badgeIcon = Icons.shopping_bag_outlined;
    } else if (cart.tableNumber > 0) {
      badgeText = "${s('table')} ${cart.tableNumber}";
      badgeColor = AppColors.primary;
      badgeIcon = Icons.table_restaurant_rounded;
    } else {
      badgeText = '';
      badgeColor = AppColors.warning;
      badgeIcon = Icons.touch_app_rounded;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: R.spaceMD,
        vertical: R.spaceSM + 2,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              s('order_details'),
              style: TextStyle(fontSize: R.textLG, fontWeight: FontWeight.w700),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          if (!hideTableSelector && badgeText.isNotEmpty)
            GestureDetector(
              onTap: onTableTap,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: R.spaceSM,
                  vertical: R.spaceXS - 2,
                ),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(R.radiusSM),
                  border: Border.all(color: badgeColor.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(badgeIcon, size: R.iconSM, color: badgeColor),
                    const SizedBox(width: 4),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 100),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          fontSize: R.textSM,
                          fontWeight: FontWeight.w600,
                          color: badgeColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Stol YOKI Sayoq overlay ─────────────────────────────────

class _TableOrTakeoutOverlay extends StatefulWidget {
  final String lang;
  const _TableOrTakeoutOverlay({required this.lang});
  @override
  State<_TableOrTakeoutOverlay> createState() => _TableOrTakeoutOverlayState();
}

class _TableOrTakeoutOverlayState extends State<_TableOrTakeoutOverlay> {
  bool _showTables = false;
  int? _hovered;

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final s = (String k) => AppStrings.get(k, widget.lang);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: R.isLargeTablet ? 580 : 480,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(R.radiusXL),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 40,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(R.spaceLG),
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  border: Border(bottom: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(R.radiusMD),
                      ),
                      child: Icon(
                        _showTables
                            ? Icons.table_restaurant_rounded
                            : Icons.restaurant_rounded,
                        color: AppColors.primary,
                        size: R.iconMD,
                      ),
                    ),
                    SizedBox(width: R.spaceSM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _showTables
                                ? s('select_table')
                                : (widget.lang == 'kr'
                                      ? "To'lov turini tanlang"
                                      : "To'lov turini tanlang"),
                            style: TextStyle(
                              fontSize: R.textLG,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            _showTables ? "Stolni tanlang" : "Stol yoki Sayoq",
                            style: TextStyle(
                              fontSize: R.textXS,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_showTables)
                      GestureDetector(
                        onTap: () => setState(() => _showTables = false),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: R.spaceSM,
                            vertical: R.spaceXS - 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(R.radiusSM),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.arrow_back_rounded,
                                size: R.iconSM,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Orqaga",
                                style: TextStyle(
                                  fontSize: R.textXS,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            color: AppColors.surfaceSecondary,
                            borderRadius: BorderRadius.circular(R.radiusSM),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: R.iconSM,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.all(R.spaceLG),
                child: _showTables
                    ? _TableGrid(
                        lang: widget.lang,
                        hovered: _hovered,
                        onHover: (n) => setState(() => _hovered = n),
                        onSelect: (n) => Navigator.pop(context, n),
                      )
                    : _TypeButtons(
                        lang: widget.lang,
                        onTableTap: () => setState(() => _showTables = true),
                        onTakeoutTap: () => Navigator.pop(context, -1),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Stol vs Sayoq tanlash tugmalari
class _TypeButtons extends StatelessWidget {
  final String lang;
  final VoidCallback onTableTap, onTakeoutTap;
  const _TypeButtons({
    required this.lang,
    required this.onTableTap,
    required this.onTakeoutTap,
  });
  @override
  Widget build(BuildContext context) {
    R.init(context);
    return Row(
      children: [
        Expanded(
          child: _TypeCard(
            icon: Icons.table_restaurant_rounded,
            label: lang == 'kr' ? 'Стол' : 'Stol',
            desc: "Restoran ichida",
            color: AppColors.primary,
            onTap: onTableTap,
          ),
        ),
        SizedBox(width: R.spaceMD),
        Expanded(
          child: _TypeCard(
            icon: Icons.shopping_bag_outlined,
            label: lang == 'kr' ? 'Сайёқ' : 'Sayoq',
            desc: "Olib ketish",
            color: AppColors.success,
            onTap: onTakeoutTap,
          ),
        ),
      ],
    );
  }
}

class _TypeCard extends StatelessWidget {
  final IconData icon;
  final String label, desc;
  final Color color;
  final VoidCallback onTap;
  const _TypeCard({
    required this.icon,
    required this.label,
    required this.desc,
    required this.color,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    R.init(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(R.spaceLG),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(R.radiusLG),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              width: R.isLargeTablet ? 64 : 56,
              height: R.isLargeTablet ? 64 : 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: R.iconXL),
            ),
            SizedBox(height: R.spaceSM),
            Text(
              label,
              style: TextStyle(
                fontSize: R.textLG,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            SizedBox(height: R.spaceXS / 2),
            Text(
              desc,
              style: TextStyle(
                fontSize: R.textXS,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Stol grid — band stollar qizil, bo'shlar tanlanadi
class _TableGrid extends StatelessWidget {
  final String lang;
  final int? hovered;
  final ValueChanged<int> onHover;
  final ValueChanged<int> onSelect;
  const _TableGrid({
    required this.lang,
    required this.hovered,
    required this.onHover,
    required this.onSelect,
  });
  @override
  Widget build(BuildContext context) {
    R.init(context);
    final tableVM = context.watch<TableViewModel>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Legend
        Padding(
          padding: EdgeInsets.only(bottom: R.spaceSM),
          child: Row(
            children: [
              _Dot(color: AppColors.success, label: "Bo'sh"),
              SizedBox(width: R.spaceMD),
              _Dot(color: AppColors.error, label: 'Band'),
            ],
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: R.isLargeTablet ? 6 : 5,
            mainAxisSpacing: R.spaceSM,
            crossAxisSpacing: R.spaceSM,
            childAspectRatio: 1,
          ),
          itemCount: AppConstants.defaultTableCount,
          itemBuilder: (ctx, i) {
            final num = i + 1;
            final isOccupied = tableVM.isOccupied(num);
            final isHover = hovered == num && !isOccupied;

            // Band stol — qizil, bosilmaydi (avvalgi zakaz o'zgarmasin)
            if (isOccupied) {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(R.radiusMD),
                  border: Border.all(
                    color: AppColors.error.withOpacity(0.35),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.table_restaurant_rounded,
                      size: R.isLargeTablet ? 22 : 18,
                      color: AppColors.error.withOpacity(0.5),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$num',
                      style: TextStyle(
                        fontSize: R.textSM,
                        fontWeight: FontWeight.w800,
                        color: AppColors.error.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              );
            }

            // Bo'sh stol — tanlanadi
            return MouseRegion(
              onEnter: (_) => onHover(num),
              onExit: (_) => onHover(-1),
              child: GestureDetector(
                onTap: () => onSelect(num),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  decoration: BoxDecoration(
                    color: isHover
                        ? AppColors.primary
                        : AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(R.radiusMD),
                    border: Border.all(
                      color: isHover ? AppColors.primary : AppColors.border,
                      width: isHover ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.table_restaurant_rounded,
                        size: R.isLargeTablet ? 24 : 20,
                        color: isHover ? Colors.white : AppColors.textSecondary,
                      ),
                      SizedBox(height: R.spaceXS / 2),
                      Text(
                        '$num',
                        style: TextStyle(
                          fontSize: R.textMD,
                          fontWeight: FontWeight.w800,
                          color: isHover ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  final String label;
  const _Dot({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    R.init(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: R.spaceXS - 2),
        Text(
          label,
          style: TextStyle(fontSize: R.textXS, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

// ─── Bo'sh savat ─────────────────────────────────────────────

class _EmptyCart extends StatelessWidget {
  final String lang;
  const _EmptyCart({required this.lang});
  @override
  Widget build(BuildContext context) {
    R.init(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: R.iconXL + 12,
            color: AppColors.textHint,
          ),
          SizedBox(height: R.spaceSM),
          Text(
            AppStrings.get('empty_cart', lang),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: R.textMD,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Zakaz qatori ────────────────────────────────────────────

class _OrderItemRow extends StatelessWidget {
  final String name;
  final double price, total;
  final int quantity;
  final VoidCallback onRemove, onIncrease, onDecrease;
  const _OrderItemRow({
    required this.name,
    required this.price,
    required this.quantity,
    required this.total,
    required this.onRemove,
    required this.onIncrease,
    required this.onDecrease,
  });
  @override
  Widget build(BuildContext context) {
    R.init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: R.spaceMD, vertical: R.spaceSM),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: R.textSM,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  CurrencyFormatter.format(price),
                  style: TextStyle(
                    fontSize: R.textXS,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _SmBtn(icon: Icons.remove, onTap: onDecrease),
              SizedBox(
                width: R.isLargeTablet ? 44 : 40,
                child: Center(
                  child: Text(
                    '$quantity',
                    style: TextStyle(
                      fontSize: R.isLargeTablet ? R.textLG : R.textMD,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              _SmBtn(icon: Icons.add, onTap: onIncrease),
            ],
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: R.isLargeTablet ? 88 : 76,
            child: Text(
              CurrencyFormatter.formatNumber(total),
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: R.textSM, fontWeight: FontWeight.w700),
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Icon(
                Icons.close_rounded,
                size: R.iconSM,
                color: AppColors.textHint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _SmBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    R.init(context);
    final sz = R.isLargeTablet ? 44.0 : 40.0;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: sz,
        height: sz,
        decoration: BoxDecoration(
          color: AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(R.radiusMD),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: sz * 0.45, color: AppColors.textPrimary),
      ),
    );
  }
}

// ─── Summary ─────────────────────────────────────────────────

class _SummarySection extends StatelessWidget {
  final CartViewModel cart;
  final String lang;
  const _SummarySection({required this.cart, required this.lang});
  @override
  Widget build(BuildContext context) {
    R.init(context);
    final s = (String k) => AppStrings.get(k, lang);
    return Container(
      padding: EdgeInsets.fromLTRB(
        R.spaceMD,
        R.spaceSM + 2,
        R.spaceMD,
        R.spaceXS,
      ),
      child: Column(
        children: [
          _SRow(
            label: s('subtotal'),
            value: CurrencyFormatter.format(cart.subtotal, lang: lang),
          ),
          SizedBox(height: R.spaceXS - 2),
          _SRow(
            label: s('tax'),
            value: CurrencyFormatter.format(cart.tax, lang: lang),
            secondary: true,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: R.spaceXS + 2),
            child: const Divider(height: 1),
          ),
          _SRow(
            label: s('total'),
            value: CurrencyFormatter.format(cart.total, lang: lang),
            bold: true,
          ),
        ],
      ),
    );
  }
}

class _SRow extends StatelessWidget {
  final String label, value;
  final bool bold, secondary;
  const _SRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.secondary = false,
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
            color: secondary ? AppColors.textSecondary : AppColors.textPrimary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? R.textLG : R.textSM,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            color: bold ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ─── Saqlash tugmasi ─────────────────────────────────────────

class _SaveBtn extends StatelessWidget {
  final CartViewModel cart;
  final String lang;
  const _SaveBtn({required this.cart, required this.lang});
  @override
  Widget build(BuildContext context) {
    R.init(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(R.spaceMD, 0, R.spaceMD, R.spaceXS),
      child: SizedBox(
        width: double.infinity,
        height: R.buttonH - 4,
        child: OutlinedButton(
          onPressed: cart.isEmpty ? null : () => _saveTable(context),
          style: OutlinedButton.styleFrom(
            side: BorderSide(
              color: cart.isEmpty ? AppColors.border : AppColors.primary,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(R.radiusMD),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.save_outlined,
                size: R.iconSM,
                color: cart.isEmpty ? AppColors.textHint : AppColors.primary,
              ),
              SizedBox(width: R.spaceXS),
              Text(
                "Saqlash va yopish",
                style: TextStyle(
                  fontSize: R.textSM,
                  fontWeight: FontWeight.w600,
                  color: cart.isEmpty ? AppColors.textHint : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveTable(BuildContext context) async {
    final cart = context.read<CartViewModel>();
    final tableVM = context.read<TableViewModel>();
    final auth = context.read<AuthViewModel>();
    final orderVM = context.read<OrderViewModel>();
    final order = await orderVM.createOrder(
      tableNumber: cart.tableNumber,
      waiterId: auth.currentUser.id,
      waiterName: auth.currentUser.name,
      items: cart.items.toList(),
      subtotal: cart.subtotal,
      tax: cart.tax,
      total: cart.total,
    );
    if (order != null) {
      tableVM.occupyTable(order);
      cart.clear();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppStrings.get("table", auth.language)} ${order.tableNumber} — saqlandi',
              style: TextStyle(fontSize: R.textSM),
            ),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }
}

// ─── To'lov tugmasi ──────────────────────────────────────────

class _ProcessBtn extends StatelessWidget {
  final CartViewModel cart;
  final String lang;
  final VoidCallback onTap;
  const _ProcessBtn({
    required this.cart,
    required this.lang,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    R.init(context);
    final s = (String k) => AppStrings.get(k, lang);
    return Padding(
      padding: EdgeInsets.fromLTRB(R.spaceMD, R.spaceXS, R.spaceMD, R.spaceMD),
      child: SizedBox(
        width: double.infinity,
        height: R.buttonH + 4,
        child: ElevatedButton(
          onPressed: cart.isEmpty ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: cart.isEmpty
                ? AppColors.textHint
                : AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(R.radiusMD),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.payment_rounded, size: R.iconMD),
              SizedBox(width: R.spaceXS),
              Text(
                s('process_payment'),
                style: TextStyle(
                  fontSize: R.textMD + 1,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
