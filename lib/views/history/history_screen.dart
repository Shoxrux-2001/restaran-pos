import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/responsive_helper.dart';
import '../../core/constants/app_constants.dart';
import '../../models/order_model.dart';
import '../../viewmodels/order_viewmodel.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../main/main_screen.dart';

class HistoryScreen extends StatefulWidget {
  final String lang;
  const HistoryScreen({super.key, required this.lang});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _filter = 'all'; // all, today, week
  String _statusFilter = 'all'; // all, completed, cancelled

  String get lang => widget.lang;
  String s(String k) => AppStrings.get(k, lang);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrderViewModel>().loadHistory();
    });
  }

  List<OrderModel> _filtered(List<OrderModel> all) {
    final now = DateTime.now();
    return all.where((o) {
      // Vaqt filter
      if (_filter == 'today') {
        if (o.createdAt.day != now.day || o.createdAt.month != now.month)
          return false;
      } else if (_filter == 'week') {
        if (now.difference(o.createdAt).inDays > 7) return false;
      }
      // Status filter
      if (_statusFilter != 'all' && o.status != _statusFilter) return false;
      return true;
    }).toList();
  }

  Map<String, List<OrderModel>> _grouped(List<OrderModel> orders) {
    final map = <String, List<OrderModel>>{};
    for (final o in orders) {
      final key = DateFormatter.formatRelative(o.createdAt, lang: lang);
      map.putIfAbsent(key, () => []).add(o);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final allOrders = context.watch<OrderViewModel>().historyOrders;
    final filtered = _filtered(allOrders);
    final grouped = _grouped(filtered);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(s('order_history'), style: TextStyle(fontSize: R.textLG)),
        backgroundColor: AppColors.surface,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(R.isLargeTablet ? 100 : 88),
          child: _FilterBar(
            filter: _filter,
            statusFilter: _statusFilter,
            lang: lang,
            onFilterChange: (v) => setState(() => _filter = v),
            onStatusChange: (v) => setState(() => _statusFilter = v),
            totalCount: filtered.length,
            totalSum: filtered
                .where((o) => o.status == AppConstants.statusCompleted)
                .fold(0.0, (s, o) => s + o.total),
          ),
        ),
      ),
      body: filtered.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: R.iconXL + 8,
                    color: AppColors.textHint,
                  ),
                  SizedBox(height: R.spaceSM),
                  Text(
                    s('no_history'),
                    style: TextStyle(
                      fontSize: R.textMD,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : ListView(
              padding: EdgeInsets.all(R.spaceMD),
              children: grouped.entries.map((entry) {
                final dayOrders = entry.value;
                final dayTotal = dayOrders
                    .where((o) => o.status == AppConstants.statusCompleted)
                    .fold(0.0, (s, o) => s + o.total);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── Kun header ──────────────────────────
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: R.spaceSM),
                      child: Row(
                        children: [
                          Text(
                            entry.key,
                            style: TextStyle(
                              fontSize: R.textMD,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(width: R.spaceSM),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: R.spaceXS + 2,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(R.radiusSM),
                            ),
                            child: Text(
                              '${dayOrders.length} ta',
                              style: TextStyle(
                                fontSize: R.textXS,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const Spacer(),
                          if (dayTotal > 0)
                            Text(
                              CurrencyFormatter.format(dayTotal, lang: lang),
                              style: TextStyle(
                                fontSize: R.textSM,
                                fontWeight: FontWeight.w700,
                                color: AppColors.success,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // ─── Zakazlar ────────────────────────────
                    ...dayOrders.map(
                      (o) => Padding(
                        padding: EdgeInsets.only(bottom: R.spaceXS),
                        child: _HistoryCard(
                          order: o,
                          lang: lang,
                          onTap: () => _showDetail(o),
                          onReorder: () => _reorder(o),
                        ),
                      ),
                    ),
                    SizedBox(height: R.spaceXS),
                  ],
                );
              }).toList(),
            ),
    );
  }

  void _showDetail(OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DetailSheet(order: order, lang: lang),
    );
  }

  void _reorder(OrderModel order) {
    final cart = context.read<CartViewModel>();
    cart.loadFromOrder(order);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainScreen()),
      (_) => false,
    );
  }
}

// ─── Filter bar ──────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  final String filter, statusFilter, lang;
  final ValueChanged<String> onFilterChange, onStatusChange;
  final int totalCount;
  final double totalSum;
  const _FilterBar({
    required this.filter,
    required this.statusFilter,
    required this.lang,
    required this.onFilterChange,
    required this.onStatusChange,
    required this.totalCount,
    required this.totalSum,
  });

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final s = (String k) => AppStrings.get(k, lang);
    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.fromLTRB(R.spaceMD, 0, R.spaceMD, R.spaceSM),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Vaqt filterlari
              ...[
                ['all', s('all')],
                ['today', s('today')],
                ['week', s('this_week')],
              ].map(
                (item) => Padding(
                  padding: EdgeInsets.only(right: R.spaceXS),
                  child: _Chip(
                    label: item[1],
                    active: filter == item[0],
                    onTap: () => onFilterChange(item[0]),
                  ),
                ),
              ),
              const Spacer(),
              // Status filter
              ...[
                ['all', s('all')],
                ['completed', s('status_completed')],
                ['cancelled', s('status_cancelled')],
              ].map(
                (item) => Padding(
                  padding: EdgeInsets.only(left: R.spaceXS - 2),
                  child: _Chip(
                    label: item[1],
                    active: statusFilter == item[0],
                    onTap: () => onStatusChange(item[0]),
                    small: true,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: R.spaceXS),
          Row(
            children: [
              Text(
                '$totalCount ta zakaz',
                style: TextStyle(
                  fontSize: R.textXS,
                  color: AppColors.textSecondary,
                ),
              ),
              if (totalSum > 0) ...[
                SizedBox(width: R.spaceSM),
                Text('•', style: TextStyle(color: AppColors.textHint)),
                SizedBox(width: R.spaceSM),
                Text(
                  CurrencyFormatter.format(totalSum, lang: lang),
                  style: TextStyle(
                    fontSize: R.textXS,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool active, small;
  final VoidCallback onTap;
  const _Chip({
    required this.label,
    required this.active,
    required this.onTap,
    this.small = false,
  });
  @override
  Widget build(BuildContext context) {
    R.init(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(
          horizontal: small ? R.spaceXS + 2 : R.spaceSM + 2,
          vertical: small ? 4 : R.spaceXS - 1,
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : AppColors.surfaceSecondary,
          borderRadius: BorderRadius.circular(R.radiusXL),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: small ? R.textXS : R.textSM,
            fontWeight: FontWeight.w600,
            color: active ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ─── Tarix card ───────────────────────────────────────────────

class _HistoryCard extends StatelessWidget {
  final OrderModel order;
  final String lang;
  final VoidCallback onTap, onReorder;
  const _HistoryCard({
    required this.order,
    required this.lang,
    required this.onTap,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final s = (String k) => AppStrings.get(k, lang);

    Color statusColor;
    String statusLabel;
    switch (order.status) {
      case AppConstants.statusCompleted:
        statusColor = AppColors.success;
        statusLabel = s('status_completed');
        break;
      case AppConstants.statusCancelled:
        statusColor = AppColors.error;
        statusLabel = s('status_cancelled');
        break;
      default:
        statusColor = AppColors.warning;
        statusLabel = s('status_waiting');
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(R.spaceMD),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(R.radiusMD),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Stol icon
            Container(
              width: R.isLargeTablet ? 52 : 46,
              height: R.isLargeTablet ? 52 : 46,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(R.radiusSM),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.table_restaurant_rounded,
                    size: R.iconSM,
                    color: statusColor,
                  ),
                  Text(
                    '${order.tableNumber}',
                    style: TextStyle(
                      fontSize: R.textSM,
                      fontWeight: FontWeight.w800,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: R.spaceSM),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        order.waiterName,
                        style: TextStyle(
                          fontSize: R.textMD,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: R.spaceXS),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: R.spaceXS,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          statusLabel,
                          style: TextStyle(
                            fontSize: R.textXS,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3),
                  Text(
                    '${order.items.length} ${s('items')}  •  '
                    '${DateFormatter.formatTime(order.createdAt)}',
                    style: TextStyle(
                      fontSize: R.textXS,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Summa
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.formatNumber(order.total),
                  style: TextStyle(
                    fontSize: R.textMD,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: R.spaceXS / 2),
                // Reorder tugmasi
                if (order.status == AppConstants.statusCompleted)
                  GestureDetector(
                    onTap: onReorder,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: R.spaceXS + 2,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(R.radiusSM),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.replay_rounded,
                            size: R.textXS + 1,
                            color: AppColors.primary,
                          ),
                          SizedBox(width: 3),
                          Text(
                            lang == 'kr' ? 'Қайта' : 'Qayta',
                            style: TextStyle(
                              fontSize: R.textXS,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: R.spaceXS),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textHint,
              size: R.iconSM,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Detail sheet ─────────────────────────────────────────────

class _DetailSheet extends StatelessWidget {
  final OrderModel order;
  final String lang;
  const _DetailSheet({required this.order, required this.lang});

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final s = (String k) => AppStrings.get(k, lang);

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(R.spaceLG),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s('order_details'),
                        style: TextStyle(
                          fontSize: R.textLG,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        '${s('table')} ${order.tableNumber}  •  '
                        '${order.waiterName}  •  '
                        '${DateFormatter.formatDateTime(order.createdAt)}',
                        style: TextStyle(
                          fontSize: R.textXS,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                controller: ctrl,
                padding: EdgeInsets.all(R.spaceLG),
                children: [
                  ...order.items.map(
                    (item) => Padding(
                      padding: EdgeInsets.only(bottom: R.spaceSM),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${item.getName(lang)}  ×${item.quantity}',
                              style: TextStyle(
                                fontSize: R.textMD,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(item.total, lang: lang),
                            style: TextStyle(
                              fontSize: R.textMD,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  SizedBox(height: R.spaceXS),
                  _DRow(
                    s('subtotal'),
                    CurrencyFormatter.format(order.subtotal, lang: lang),
                  ),
                  SizedBox(height: R.spaceXS),
                  _DRow(
                    s('tax'),
                    CurrencyFormatter.format(order.tax, lang: lang),
                    muted: true,
                  ),
                  SizedBox(height: R.spaceSM),
                  _DRow(
                    s('total'),
                    CurrencyFormatter.format(order.total, lang: lang),
                    bold: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DRow extends StatelessWidget {
  final String label, value;
  final bool bold, muted;
  const _DRow(this.label, this.value, {this.bold = false, this.muted = false});
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
            color: bold ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
