import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/currency_formatter.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/utils/responsive_helper.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/order_viewmodel.dart';
import '../../viewmodels/product_viewmodel.dart';
import '../../models/order_model.dart';
import '../../models/product_model.dart';
import 'package:uuid/uuid.dart';

class AdminScreen extends StatefulWidget {
  final String lang;
  const AdminScreen({super.key, required this.lang});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String get lang => widget.lang;
  String s(String key) => AppStrings.get(key, lang);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(text: s('statistics')),
            Tab(text: s('products')),
            Tab(text: s('daily_report')),
            Tab(text: lang == 'kr' ? 'Столлар' : 'Stollar'),
            Tab(text: lang == 'kr' ? 'Созламалар' : 'Sozlamalar'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.power_settings_new_rounded,
                    size: 16,
                    color: AppColors.error,
                  ),
                  SizedBox(width: 6),
                  Text(
                    lang == 'kr' ? 'Ishni tugatish' : 'Ishni tugatish',
                    style: TextStyle(color: AppColors.error),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _StatisticsTab(lang: lang),
          _ProductsTab(lang: lang),
          _ReportTab(lang: lang),
          _TablesTab(lang: lang),
          _SettingsTab(lang: lang),
          _CloseShiftTab(lang: lang),
        ],
      ),
    );
  }
}

// ─── Statistika ──────────────────────────────────────────────

class _StatisticsTab extends StatelessWidget {
  final String lang;
  const _StatisticsTab({required this.lang});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderViewModel>().historyOrders;
    final s = (String key) => AppStrings.get(key, lang);

    R.init(context);
    final completedOrders = orders
        .where((o) => o.status == 'completed')
        .toList();
    final totalRevenue = completedOrders.fold<double>(0, (s, o) => s + o.total);
    final totalItems = completedOrders.fold<int>(0, (s, o) => s + o.itemCount);

    // Mahsulot sarfi hisobi
    final Map<String, int> productCount = {};
    for (final order in completedOrders) {
      for (final item in order.items) {
        final name = lang == 'kr' ? item.productNameKr : item.productName;
        productCount[name] = (productCount[name] ?? 0) + item.quantity;
      }
    }
    final sortedProducts = productCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stat kartalar
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.attach_money_rounded,
                  label: s('total_sales'),
                  value: CurrencyFormatter.format(totalRevenue, lang: lang),
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _StatCard(
                  icon: Icons.receipt_long_rounded,
                  label: s('total_orders'),
                  value: '${completedOrders.length}',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _StatCard(
                  icon: Icons.fastfood_rounded,
                  label: s('products_sold'),
                  value: '$totalItems ${s('items')}',
                  color: AppColors.warning,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Top mahsulotlar
          Text(
            lang == 'kr' ? 'Энг кўп сотилганлар' : 'Eng ko\'p sotilganlar',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),

          if (sortedProducts.isEmpty)
            Text(
              s('no_history'),
              style: const TextStyle(color: AppColors.textSecondary),
            )
          else
            ...sortedProducts
                .take(10)
                .map(
                  (entry) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${entry.value} ${s('items')}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
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

// ─── Mahsulotlar boshqaruvi ──────────────────────────────────

class _ProductsTab extends StatelessWidget {
  final String lang;
  const _ProductsTab({required this.lang});

  @override
  Widget build(BuildContext context) {
    final products = context.watch<ProductViewModel>().allProducts;
    final s = (String key) => AppStrings.get(key, lang);

    return Column(
      children: [
        // Qo'shish tugmasi
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                '${products.length} ${s('products')}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _showProductDialog(context, lang: lang),
                icon: const Icon(Icons.add, size: 18),
                label: Text(s('add_product')),
                style: ElevatedButton.styleFrom(minimumSize: const Size(0, 40)),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Ro'yxat
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final p = products[index];
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.fastfood_rounded,
                        color: AppColors.textHint,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            p.getName(lang),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${s(p.category)}  •  '
                            '${CurrencyFormatter.format(p.price, lang: lang)}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Tahrirlash
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      onPressed: () =>
                          _showProductDialog(context, lang: lang, product: p),
                    ),
                    // O'chirish
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.error,
                        size: 20,
                      ),
                      onPressed: () => _confirmDelete(context, p, lang),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, ProductModel p, String lang) {
    final s = (String key) => AppStrings.get(key, lang);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(s('delete_product')),
        content: Text(p.getName(lang)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(s('cancel')),
          ),
          TextButton(
            onPressed: () {
              context.read<ProductViewModel>().deleteProduct(p.id);
              Navigator.pop(context);
            },
            child: Text(
              s('delete'),
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

void _showProductDialog(
  BuildContext context, {
  required String lang,
  ProductModel? product,
}) {
  showDialog(
    context: context,
    builder: (_) => _ProductDialog(lang: lang, product: product),
  );
}

class _ProductDialog extends StatefulWidget {
  final String lang;
  final ProductModel? product;
  const _ProductDialog({required this.lang, this.product});

  @override
  State<_ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<_ProductDialog> {
  late final TextEditingController _nameUz;
  late final TextEditingController _nameKr;
  late final TextEditingController _price;
  String _category = 'main_course';

  String get lang => widget.lang;
  String s(String key) => AppStrings.get(key, lang);

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameUz = TextEditingController(text: p?.name ?? '');
    _nameKr = TextEditingController(text: p?.nameKr ?? '');
    _price = TextEditingController(
      text: p != null ? p.price.toStringAsFixed(0) : '',
    );
    _category = p?.category ?? 'main_course';
  }

  @override
  void dispose() {
    _nameUz.dispose();
    _nameKr.dispose();
    _price.dispose();
    super.dispose();
  }

  void _save() {
    final price = double.tryParse(_price.text) ?? 0;
    if (_nameUz.text.isEmpty || price <= 0) return;

    final now = DateTime.now();
    final p = widget.product;

    final product = ProductModel(
      id: p?.id ?? const Uuid().v4(),
      name: _nameUz.text.trim(),
      nameKr: _nameKr.text.trim().isEmpty
          ? _nameUz.text.trim()
          : _nameKr.text.trim(),
      price: price,
      category: _category,
      isAvailable: true,
      sortOrder: p?.sortOrder ?? 0,
      createdAt: p?.createdAt ?? now,
      updatedAt: now,
    );

    if (p != null) {
      context.read<ProductViewModel>().updateProduct(product);
    } else {
      context.read<ProductViewModel>().addProduct(product);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;
    return AlertDialog(
      title: Text(isEdit ? s('edit_product') : s('add_product')),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameUz,
              decoration: InputDecoration(
                labelText: '${s('product_name')} (UZ)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameKr,
              decoration: InputDecoration(
                labelText: '${s('product_name')} (КР)',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _price,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: s('product_price')),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: InputDecoration(labelText: s('product_category')),
              items: ['appetizer', 'main_course', 'dessert', 'beverage']
                  .map(
                    (cat) => DropdownMenuItem(value: cat, child: Text(s(cat))),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _category = v ?? _category),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(s('cancel')),
        ),
        ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(minimumSize: const Size(80, 40)),
          child: Text(s('save')),
        ),
      ],
    );
  }
}

// ─── Kunlik hisobot ──────────────────────────────────────────

class _ReportTab extends StatelessWidget {
  final String lang;
  const _ReportTab({required this.lang});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderViewModel>().historyOrders;
    final s = (String key) => AppStrings.get(key, lang);

    // Bugungi zakazlar
    final today = DateTime.now();
    final todayOrders = orders.where((o) {
      final d = o.createdAt;
      return d.year == today.year &&
          d.month == today.month &&
          d.day == today.day &&
          o.status == 'completed';
    }).toList();

    final todayRevenue = todayOrders.fold<double>(0, (s, o) => s + o.total);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            s('daily_report'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.today_rounded,
                  label: s('total_orders'),
                  value: '${todayOrders.length}',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _StatCard(
                  icon: Icons.attach_money_rounded,
                  label: s('total_sales'),
                  value: CurrencyFormatter.format(todayRevenue, lang: lang),
                  color: AppColors.success,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Text(
            lang == 'kr' ? 'Буgungi заказлар' : 'Bugungi zakazlar',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          if (todayOrders.isEmpty)
            Text(
              s('no_history'),
              style: const TextStyle(color: AppColors.textSecondary),
            )
          else
            ...todayOrders.map(
              (o) => _ReportOrderCard(
                order: o,
                lang: lang,
                onTap: () => _showReceiptSheet(context, o, lang),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Report order card ───────────────────────────────────────

class _ReportOrderCard extends StatelessWidget {
  final OrderModel order;
  final String lang;
  final VoidCallback onTap;
  const _ReportOrderCard({
    required this.order,
    required this.lang,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final s = (String k) => AppStrings.get(k, lang);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: R.spaceXS),
        padding: EdgeInsets.symmetric(
          horizontal: R.spaceMD,
          vertical: R.spaceSM + 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(R.radiusMD),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Vaqt
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormatter.formatTime(order.createdAt),
                  style: TextStyle(
                    fontSize: R.textMD,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  DateFormatter.formatDate(order.createdAt),
                  style: TextStyle(
                    fontSize: R.textXS,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(width: R.spaceMD),
            // Stol + ofitsiant
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${s("table")} ${order.tableNumber}  •  ${order.waiterName}',
                    style: TextStyle(
                      fontSize: R.textSM,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${order.items.length} ${s("items")}',
                    style: TextStyle(
                      fontSize: R.textXS,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            // Summa
            Text(
              CurrencyFormatter.format(order.total, lang: lang),
              style: TextStyle(fontSize: R.textMD, fontWeight: FontWeight.w700),
            ),
            SizedBox(width: R.spaceXS),
            Icon(
              Icons.receipt_long_outlined,
              size: R.iconSM,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}

void _showReceiptSheet(BuildContext context, OrderModel order, String lang) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _AdminReceiptSheet(order: order, lang: lang),
  );
}

class _AdminReceiptSheet extends StatelessWidget {
  final OrderModel order;
  final String lang;
  const _AdminReceiptSheet({required this.order, required this.lang});

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final s = (String k) => AppStrings.get(k, lang);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.92,
      minChildSize: 0.4,
      builder: (_, ctrl) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Chek header
            Padding(
              padding: EdgeInsets.all(R.spaceLG),
              child: Column(
                children: [
                  Text(
                    'Restoran POS',
                    style: TextStyle(
                      fontSize: R.textXL,
                      fontWeight: FontWeight.w800,
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
                      _InfoChip(
                        icon: Icons.table_restaurant_rounded,
                        text: '${s("table")} ${order.tableNumber}',
                      ),
                      SizedBox(width: R.spaceSM),
                      _InfoChip(
                        icon: Icons.person_outline_rounded,
                        text: order.waiterName,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Items
            Expanded(
              child: ListView(
                controller: ctrl,
                padding: EdgeInsets.symmetric(
                  horizontal: R.spaceLG,
                  vertical: R.spaceSM,
                ),
                children: [
                  ...order.items.map(
                    (item) => Padding(
                      padding: EdgeInsets.only(bottom: R.spaceSM),
                      child: Row(
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
                                  '${item.quantity} × '
                                  '${CurrencyFormatter.formatNumber(item.price)}',
                                  style: TextStyle(
                                    fontSize: R.textXS,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            CurrencyFormatter.format(item.total, lang: lang),
                            style: TextStyle(
                              fontSize: R.textMD,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  SizedBox(height: R.spaceXS),
                  _RRow(
                    s('subtotal'),
                    CurrencyFormatter.format(order.subtotal, lang: lang),
                  ),
                  SizedBox(height: R.spaceXS),
                  _RRow(
                    s('tax'),
                    CurrencyFormatter.format(order.tax, lang: lang),
                    muted: true,
                  ),
                  SizedBox(height: R.spaceSM),
                  _RRow(
                    s('total'),
                    CurrencyFormatter.format(order.total, lang: lang),
                    bold: true,
                  ),
                  SizedBox(height: R.spaceSM),
                  _RRow(
                    lang == 'kr' ? "To'lov usuli" : "To'lov usuli",
                    order.paymentMethod == 'cash' ? s('cash') : s('card'),
                  ),
                ],
              ),
            ),

            // Yopish tugmasi
            Padding(
              padding: EdgeInsets.all(R.spaceMD),
              child: SizedBox(
                width: double.infinity,
                height: R.buttonH,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    lang == 'kr' ? 'Yopish' : 'Yopish',
                    style: TextStyle(fontSize: R.textSM),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoChip({required this.icon, required this.text});
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

class _RRow extends StatelessWidget {
  final String label, value;
  final bool bold, muted;
  const _RRow(this.label, this.value, {this.bold = false, this.muted = false});
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

// ─── Stat karta ──────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(fontSize: R.textLG, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 2),
          Text(
            label,
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

// ─── Stollar boshqaruvi ──────────────────────────────────────

class _TablesTab extends StatefulWidget {
  final String lang;
  const _TablesTab({required this.lang});
  @override
  State<_TablesTab> createState() => _TablesTabState();
}

class _TablesTabState extends State<_TablesTab> {
  final List<_TableEntry> _tables = List.generate(
    20,
    (i) => _TableEntry(number: i + 1, name: 'Stol ${i + 1}'),
  );

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final lang = widget.lang;
    final s = (String k) => AppStrings.get(k, lang);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(R.spaceMD),
          child: Row(
            children: [
              Text(
                '${_tables.length} ${s("table")}',
                style: TextStyle(
                  fontSize: R.textMD,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () => _addTable(),
                icon: Icon(Icons.add, size: R.iconSM),
                label: Text(
                  lang == 'kr' ? 'Qo\'shish' : 'Qo\'shish',
                  style: TextStyle(fontSize: R.textSM),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(0, R.isLargeTablet ? 44 : 40),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(R.spaceMD),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: R.isLargeTablet ? 6 : 5,
              mainAxisSpacing: R.spaceSM,
              crossAxisSpacing: R.spaceSM,
              childAspectRatio: 1.1,
            ),
            itemCount: _tables.length,
            itemBuilder: (ctx, i) {
              final t = _tables[i];
              return GestureDetector(
                onLongPress: () => _editTable(i),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(R.radiusMD),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.table_restaurant_rounded,
                        size: R.iconMD,
                        color: AppColors.primary,
                      ),
                      SizedBox(height: R.spaceXS / 2),
                      Text(
                        '${t.number}',
                        style: TextStyle(
                          fontSize: R.textMD,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (t.name != 'Stol ${t.number}')
                        Text(
                          t.name,
                          style: TextStyle(
                            fontSize: R.textXS,
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _addTable() {
    setState(() {
      final num = _tables.length + 1;
      _tables.add(_TableEntry(number: num, name: 'Stol $num'));
    });
  }

  void _editTable(int index) {
    final ctrl = TextEditingController(text: _tables[index].name);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Stol ${_tables[index].number}'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Nom (masalan: VIP)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _tables[index].name = ctrl.text);
              Navigator.pop(context);
            },
            child: const Text('Saqlash'),
          ),
          TextButton(
            onPressed: () {
              setState(() => _tables.removeAt(index));
              Navigator.pop(context);
            },
            child: const Text(
              'O\'chirish',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _TableEntry {
  final int number;
  String name;
  _TableEntry({required this.number, required this.name});
}

// ─── Sozlamalar ──────────────────────────────────────────────

class _SettingsTab extends StatefulWidget {
  final String lang;
  const _SettingsTab({required this.lang});
  @override
  State<_SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<_SettingsTab> {
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  double _taxRate = 10.0;
  final _oldPassCtrl = TextEditingController();
  final _newPassCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameCtrl.text = prefs.getString('rest_name') ?? 'Restoran POS';
      _addressCtrl.text = prefs.getString('rest_address') ?? 'Toshkent sh.';
      _phoneCtrl.text = prefs.getString('rest_phone') ?? '+998 90 123 45 67';
      _taxRate = prefs.getDouble('tax_rate') ?? 10.0;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('rest_name', _nameCtrl.text.trim());
    await prefs.setString('rest_address', _addressCtrl.text.trim());
    await prefs.setString('rest_phone', _phoneCtrl.text.trim());
    await prefs.setDouble('tax_rate', _taxRate);

    // Parolni o'zgartirish
    if (_newPassCtrl.text.isNotEmpty) {
      if (_newPassCtrl.text != _confirmCtrl.text) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.lang == 'kr'
                    ? 'Parollar mos kelmadi'
                    : 'Parollar mos kelmadi',
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }
      final ok = await context.read<AuthViewModel>().checkAdminPassword(
        _oldPassCtrl.text,
      );
      if (!ok) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.lang == 'kr'
                    ? 'Eski parol noto\'g\'ri'
                    : 'Eski parol noto\'g\'ri',
              ),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }
      await context.read<AuthViewModel>().updateAdminPassword(
        _newPassCtrl.text,
      );
      _oldPassCtrl.clear();
      _newPassCtrl.clear();
      _confirmCtrl.clear();
    }

    setState(() => _saved = true);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(widget.lang == 'kr' ? 'Сақланди!' : 'Saqlandi!'),
            ],
          ),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 2),
        ),
      );
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _saved = false);
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    _phoneCtrl.dispose();
    _oldPassCtrl.dispose();
    _newPassCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final lang = widget.lang;

    return SingleChildScrollView(
      padding: EdgeInsets.all(R.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Restoran ma'lumotlari ──────────────────────
          _SectionTitle(
            lang == 'kr' ? 'Ресторан маълумотлари' : 'Restoran ma\'lumotlari',
          ),
          SizedBox(height: R.spaceSM),
          Container(
            padding: EdgeInsets.all(R.spaceMD),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(R.radiusMD),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _SettingField(label: 'Restoran nomi', controller: _nameCtrl),
                SizedBox(height: R.spaceSM),
                _SettingField(label: 'Manzil', controller: _addressCtrl),
                SizedBox(height: R.spaceSM),
                _SettingField(label: 'Telefon', controller: _phoneCtrl),
              ],
            ),
          ),

          SizedBox(height: R.spaceLG),

          // ─── Soliq ─────────────────────────────────────
          _SectionTitle(lang == 'kr' ? 'Солиқ фоизи' : 'Soliq foizi'),
          SizedBox(height: R.spaceSM),
          Container(
            padding: EdgeInsets.all(R.spaceMD),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(R.radiusMD),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _taxRate,
                    min: 0,
                    max: 25,
                    divisions: 25,
                    activeColor: AppColors.primary,
                    onChanged: (v) => setState(() => _taxRate = v),
                  ),
                ),
                SizedBox(width: R.spaceSM),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: R.spaceSM,
                    vertical: R.spaceXS,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(R.radiusSM),
                  ),
                  child: Text(
                    '${_taxRate.toInt()}%',
                    style: TextStyle(
                      fontSize: R.textLG,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: R.spaceLG),

          // ─── Parolni o'zgartirish ───────────────────────
          _SectionTitle(
            lang == 'kr'
                ? 'Admin parolini o\'zgartirish'
                : 'Admin parolini o\'zgartirish',
          ),
          SizedBox(height: R.spaceSM),
          Container(
            padding: EdgeInsets.all(R.spaceMD),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(R.radiusMD),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _SettingField(
                  label: 'Eski parol',
                  controller: _oldPassCtrl,
                  obscure: true,
                ),
                SizedBox(height: R.spaceSM),
                _SettingField(
                  label: 'Yangi parol',
                  controller: _newPassCtrl,
                  obscure: true,
                ),
                SizedBox(height: R.spaceSM),
                _SettingField(
                  label: 'Yangi parolni tasdiqlang',
                  controller: _confirmCtrl,
                  obscure: true,
                ),
              ],
            ),
          ),

          SizedBox(height: R.spaceLG),

          // ─── Saqlash ───────────────────────────────────
          SizedBox(
            width: double.infinity,
            height: R.buttonH,
            child: ElevatedButton(
              onPressed: _saveSettings,
              style: ElevatedButton.styleFrom(
                backgroundColor: _saved ? AppColors.success : AppColors.primary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _saved ? Icons.check_rounded : Icons.save_outlined,
                    size: R.iconSM,
                    color: Colors.white,
                  ),
                  SizedBox(width: R.spaceXS),
                  Text(
                    _saved
                        ? (lang == 'kr' ? 'Сақланди!' : 'Saqlandi!')
                        : AppStrings.get('save', lang),
                    style: TextStyle(fontSize: R.textMD, color: Colors.white),
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

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);
  @override
  Widget build(BuildContext context) {
    R.init(context);
    return Text(
      title,
      style: TextStyle(
        fontSize: R.textMD,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }
}

class _SettingField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscure;
  const _SettingField({
    required this.label,
    required this.controller,
    this.obscure = false,
  });
  @override
  Widget build(BuildContext context) {
    R.init(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: R.textXS,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: R.spaceXS / 2),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: TextStyle(fontSize: R.textSM),
          decoration: const InputDecoration(),
        ),
      ],
    );
  }
}

// ─── Ishni tugatish ──────────────────────────────────────────

class _CloseShiftTab extends StatefulWidget {
  final String lang;
  const _CloseShiftTab({required this.lang});
  @override
  State<_CloseShiftTab> createState() => _CloseShiftTabState();
}

class _CloseShiftTabState extends State<_CloseShiftTab> {
  bool _confirmed = false;
  bool _closed = false;

  String get lang => widget.lang;
  String s(String k) => AppStrings.get(k, lang);

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final orders = context.watch<OrderViewModel>().historyOrders;
    final now = DateTime.now();

    final todayOrders = orders.where((o) {
      final d = o.createdAt;
      return d.year == now.year &&
          d.month == now.month &&
          d.day == now.day &&
          o.status == 'completed';
    }).toList();

    final todayRevenue = todayOrders.fold<double>(0, (s, o) => s + o.total);

    final Map<String, int> productCount = {};
    for (final o in todayOrders) {
      for (final item in o.items) {
        final name = item.getName(lang);
        productCount[name] = (productCount[name] ?? 0) + item.quantity;
      }
    }
    final sortedProducts = productCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    if (_closed) {
      return _ShiftClosedView(lang: lang);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(R.spaceLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Sarlavha ────────────────────────────────────
          Row(
            children: [
              Container(
                width: R.isLargeTablet ? 52 : 44,
                height: R.isLargeTablet ? 52 : 44,
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(R.radiusMD),
                ),
                child: Icon(
                  Icons.power_settings_new_rounded,
                  color: AppColors.error,
                  size: R.iconLG,
                ),
              ),
              SizedBox(width: R.spaceSM),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang == 'kr' ? 'Ishni tugatish' : 'Ishni tugatish',
                    style: TextStyle(
                      fontSize: R.textLG,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    DateFormatter.formatDate(now, lang: lang),
                    style: TextStyle(
                      fontSize: R.textSM,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: R.spaceLG),

          // ─── Bugungi yakuniy hisobot ──────────────────────
          Text(
            lang == 'kr'
                ? 'Bugungi yakuniy hisobot'
                : 'Bugungi yakuniy hisobot',
            style: TextStyle(fontSize: R.textMD, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: R.spaceSM),

          Row(
            children: [
              Expanded(
                child: _StatCard(
                  icon: Icons.receipt_long_rounded,
                  label: s('total_orders'),
                  value: '${todayOrders.length}',
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: R.spaceSM),
              Expanded(
                child: _StatCard(
                  icon: Icons.attach_money_rounded,
                  label: s('total_sales'),
                  value: CurrencyFormatter.format(todayRevenue, lang: lang),
                  color: AppColors.success,
                ),
              ),
            ],
          ),

          SizedBox(height: R.spaceMD),

          // ─── Top mahsulotlar ─────────────────────────────
          if (sortedProducts.isNotEmpty) ...[
            Text(
              lang == 'kr' ? 'Sotilgan mahsulotlar' : 'Sotilgan mahsulotlar',
              style: TextStyle(fontSize: R.textMD, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: R.spaceSM),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(R.radiusMD),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: sortedProducts.take(10).toList().asMap().entries.map((
                  entry,
                ) {
                  final i = entry.key;
                  final prod = entry.value;
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: R.spaceMD,
                      vertical: R.spaceSM,
                    ),
                    decoration: BoxDecoration(
                      border: i > 0
                          ? const Border(
                              top: BorderSide(color: AppColors.border),
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(R.radiusSM),
                          ),
                          child: Center(
                            child: Text(
                              '${i + 1}',
                              style: TextStyle(
                                fontSize: R.textXS,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: R.spaceSM),
                        Expanded(
                          child: Text(
                            prod.key,
                            style: TextStyle(
                              fontSize: R.textSM,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: R.spaceXS + 2,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(R.radiusSM),
                          ),
                          child: Text(
                            '${prod.value} ${s("items")}',
                            style: TextStyle(
                              fontSize: R.textXS,
                              fontWeight: FontWeight.w600,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],

          SizedBox(height: R.spaceLG),

          // ─── Tasdiqlash va yopish ─────────────────────────
          Container(
            padding: EdgeInsets.all(R.spaceMD),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.04),
              borderRadius: BorderRadius.circular(R.radiusMD),
              border: Border.all(color: AppColors.error.withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.warning,
                      size: R.iconSM,
                    ),
                    SizedBox(width: R.spaceXS),
                    Text(
                      lang == 'kr'
                          ? 'Diqqat! Bu amalni orqaga qaytarib bo\'lmaydi'
                          : 'Diqqat! Bu amalni orqaga qaytarib bo\'lmaydi',
                      style: TextStyle(
                        fontSize: R.textSM,
                        fontWeight: FontWeight.w600,
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: R.spaceSM),
                Text(
                  lang == 'kr'
                      ? 'Ertaga dastur qaytadan ochilganda bugungi zakazlar tarixda saqlanadi'
                      : 'Ertaga dastur qaytadan ochilganda bugungi zakazlar tarixda saqlanadi',
                  style: TextStyle(
                    fontSize: R.textXS,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: R.spaceMD),
                Row(
                  children: [
                    Checkbox(
                      value: _confirmed,
                      onChanged: (v) => setState(() => _confirmed = v ?? false),
                      activeColor: AppColors.error,
                    ),
                    SizedBox(width: R.spaceXS),
                    Expanded(
                      child: Text(
                        lang == 'kr'
                            ? 'Ishni tugatishni tasdiqlayman'
                            : 'Ishni tugatishni tasdiqlayman',
                        style: TextStyle(fontSize: R.textSM),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: R.spaceMD),

          SizedBox(
            width: double.infinity,
            height: R.buttonH,
            child: ElevatedButton(
              onPressed: _confirmed ? () => _closeShift(context) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _confirmed
                    ? AppColors.error
                    : AppColors.textHint,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(R.radiusMD),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.power_settings_new_rounded,
                    size: R.iconSM,
                    color: Colors.white,
                  ),
                  SizedBox(width: R.spaceXS),
                  Text(
                    lang == 'kr' ? 'Ishni tugatish' : 'Ishni tugatish',
                    style: TextStyle(
                      fontSize: R.textMD,
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
    );
  }

  Future<void> _closeShift(BuildContext context) async {
    // Barcha active zakazlarni yopamiz
    // (haqiqiy loyihada Firebase ga shift_closed yoziladi)
    setState(() => _closed = true);

    // SnackBar
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            lang == 'kr'
                ? 'Ish muvaffaqiyatli tugatildi!'
                : 'Ish muvaffaqiyatli tugatildi!',
          ),
          backgroundColor: AppColors.success,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

// ─── Smena yopildi ekrani ────────────────────────────────────

class _ShiftClosedView extends StatelessWidget {
  final String lang;
  const _ShiftClosedView({required this.lang});

  @override
  Widget build(BuildContext context) {
    R.init(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.success.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.check_circle_outline_rounded,
              color: AppColors.success,
              size: R.iconXL + 4,
            ),
          ),
          SizedBox(height: R.spaceLG),
          Text(
            lang == 'kr' ? 'Ish tugatildi!' : 'Ish tugatildi!',
            style: TextStyle(fontSize: R.textXL, fontWeight: FontWeight.w800),
          ),
          SizedBox(height: R.spaceSM),
          Text(
            DateFormatter.formatDate(DateTime.now(), lang: lang),
            style: TextStyle(
              fontSize: R.textMD,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: R.spaceXS),
          Text(
            lang == 'kr'
                ? 'Barcha ma\'lumotlar saqlandi.\nErtaga qaytadan ochiladi.'
                : 'Barcha ma\'lumotlar saqlandi.\nErtaga qaytadan ochiladi.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: R.textSM,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
