import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/responsive_helper.dart';
import '../../core/utils/currency_formatter.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/cart_viewmodel.dart';
import '../../viewmodels/product_viewmodel.dart';
import '../../viewmodels/table_viewmodel.dart';
import '../../viewmodels/order_viewmodel.dart';
import 'widgets/category_tabs.dart';
import 'widgets/product_grid.dart';
import 'widgets/order_summary_panel.dart';
import 'widgets/left_menu_drawer.dart';

enum PosMode { tableFirst, productFirst }

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  PosMode _mode = PosMode.tableFirst;
  bool _searchOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductViewModel>().loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final auth = context.watch<AuthViewModel>();
    final lang = auth.language;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: LeftMenuDrawer(lang: lang),
      body: SafeArea(
        child: _mode == PosMode.tableFirst
            ? _TableFirstLayout(
                lang: lang,
                scaffoldKey: _scaffoldKey,
                searchOpen: _searchOpen,
                onToggleSearch: () => setState(() {
                  _searchOpen = !_searchOpen;
                  if (!_searchOpen) context.read<ProductViewModel>().search('');
                }),
                onModeChange: (m) => setState(() => _mode = m),
                onLangToggle: () => auth.toggleLanguage(),
              )
            : _ProductFirstLayout(
                lang: lang,
                scaffoldKey: _scaffoldKey,
                searchOpen: _searchOpen,
                onToggleSearch: () => setState(() {
                  _searchOpen = !_searchOpen;
                  if (!_searchOpen) context.read<ProductViewModel>().search('');
                }),
                onModeChange: (m) => setState(() => _mode = m),
                onLangToggle: () => auth.toggleLanguage(),
              ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// 1-REJIM: Avval stol → keyin mahsulot
// ═══════════════════════════════════════════════════════

class _TableFirstLayout extends StatefulWidget {
  final String lang;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool searchOpen;
  final VoidCallback onToggleSearch;
  final ValueChanged<PosMode> onModeChange;
  final VoidCallback onLangToggle;
  const _TableFirstLayout({
    required this.lang,
    required this.scaffoldKey,
    required this.searchOpen,
    required this.onToggleSearch,
    required this.onModeChange,
    required this.onLangToggle,
  });
  @override
  State<_TableFirstLayout> createState() => _TableFirstLayoutState();
}

class _TableFirstLayoutState extends State<_TableFirstLayout> {
  int? _selectedTable;
  String get lang => widget.lang;

  void _onTableTap(int num) {
    final cart = context.read<CartViewModel>();
    // Band yoki bo'sh — har doim faqat stol raqamini set qilamiz
    // Avvalgi zakaz O'ZGARMAYDI — TableViewModel da shundayligicha qoladi
    cart.clear();
    cart.setTable(num);
    setState(() => _selectedTable = num);
  }

  void _backToTables() {
    context.read<CartViewModel>().clear();
    setState(() => _selectedTable = null);
  }

  @override
  Widget build(BuildContext context) {
    R.init(context);

    // ─── STOLLAR EKRANI ──────────────────────────────────
    if (_selectedTable == null) {
      return Column(
        children: [
          _TopBar(
            lang: lang,
            mode: PosMode.tableFirst,
            tableNumber: 0,
            searchOpen: false,
            showSearch: false,
            showModeToggle: true,
            onMenuTap: () => widget.scaffoldKey.currentState?.openDrawer(),
            onToggleSearch: () {},
            onModeChange: widget.onModeChange,
            onLangToggle: widget.onLangToggle,
          ),
          Expanded(
            child: _TableGrid(lang: lang, onTableTap: _onTableTap),
          ),
        ],
      );
    }

    // ─── MAHSULOT + O'NG PANEL ───────────────────────────
    return Row(
      children: [
        Expanded(
          flex: 62,
          child: DecoratedBox(
            decoration: const BoxDecoration(color: AppColors.surface),
            child: Column(
              children: [
                _TopBar(
                  lang: lang,
                  mode: PosMode.tableFirst,
                  tableNumber: _selectedTable!,
                  searchOpen: widget.searchOpen,
                  showSearch: true,
                  showModeToggle: false,
                  onMenuTap: _backToTables,
                  onToggleSearch: widget.onToggleSearch,
                  onModeChange: widget.onModeChange,
                  onLangToggle: widget.onLangToggle,
                  backIcon: Icons.arrow_back_rounded,
                ),
                _QuickOrderStrip(lang: lang),
                CategoryTabs(lang: lang),
                Expanded(
                  child: context.watch<ProductViewModel>().isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ProductGrid(lang: lang),
                ),
              ],
            ),
          ),
        ),
        Container(width: 1, color: AppColors.border),
        SizedBox(
          width: R.orderPanelW,
          child: OrderSummaryPanel(
            lang: lang,
            onTableTap: () {},
            hideTableSelector: true,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════
// 2-REJIM: Avval mahsulot → keyin stol
// ═══════════════════════════════════════════════════════

class _ProductFirstLayout extends StatelessWidget {
  final String lang;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool searchOpen;
  final VoidCallback onToggleSearch;
  final ValueChanged<PosMode> onModeChange;
  final VoidCallback onLangToggle;
  const _ProductFirstLayout({
    required this.lang,
    required this.scaffoldKey,
    required this.searchOpen,
    required this.onToggleSearch,
    required this.onModeChange,
    required this.onLangToggle,
  });

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final cart = context.watch<CartViewModel>();
    return Row(
      children: [
        Expanded(
          flex: 62,
          child: DecoratedBox(
            decoration: const BoxDecoration(color: AppColors.surface),
            child: Column(
              children: [
                _TopBar(
                  lang: lang,
                  mode: PosMode.productFirst,
                  tableNumber: cart.tableNumber,
                  searchOpen: searchOpen,
                  showSearch: true,
                  showModeToggle: true,
                  onMenuTap: () => scaffoldKey.currentState?.openDrawer(),
                  onToggleSearch: onToggleSearch,
                  onModeChange: onModeChange,
                  onLangToggle: onLangToggle,
                ),
                _QuickOrderStrip(lang: lang),
                CategoryTabs(lang: lang),
                Expanded(
                  child: context.watch<ProductViewModel>().isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ProductGrid(lang: lang),
                ),
              ],
            ),
          ),
        ),
        Container(width: 1, color: AppColors.border),
        SizedBox(
          width: R.orderPanelW,
          child: OrderSummaryPanel(lang: lang, onTableTap: () {}),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════
// STOL GRID
// ═══════════════════════════════════════════════════════

class _TableGrid extends StatefulWidget {
  final String lang;
  final ValueChanged<int> onTableTap;
  const _TableGrid({required this.lang, required this.onTableTap});
  @override
  State<_TableGrid> createState() => _TableGridState();
}

class _TableGridState extends State<_TableGrid> {
  late final _ticker = Stream.periodic(const Duration(seconds: 30), (_) => 0)
      .listen((_) {
        if (mounted) setState(() {});
      });

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final tableVM = context.watch<TableViewModel>();
    final cols = R.isLargeTablet ? 6 : 5;
    final total = tableVM.totalTables;
    final occupied = tableVM.activeByTable.length;
    final free = total - occupied;

    return Column(
      children: [
        // Stat bar
        Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: R.spaceMD,
            vertical: R.spaceSM,
          ),
          child: Row(
            children: [
              _Dot(color: AppColors.success, label: "Bo'sh: $free"),
              SizedBox(width: R.spaceMD),
              _Dot(color: AppColors.error, label: 'Band: $occupied'),
              SizedBox(width: R.spaceMD),
              _Dot(color: AppColors.warning, label: '30+ min'),
              const Spacer(),
              Text(
                'Jami: $total stol',
                style: TextStyle(
                  fontSize: R.textSM,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        // Grid
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(R.spaceLG),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              mainAxisSpacing: R.spaceMD,
              crossAxisSpacing: R.spaceMD,
              childAspectRatio: R.isLargeTablet ? 1.05 : 0.95,
            ),
            itemCount: total,
            itemBuilder: (ctx, i) => _TableCell(
              number: i + 1,
              lang: widget.lang,
              onTap: () => widget.onTableTap(i + 1),
            ),
          ),
        ),
      ],
    );
  }
}

class _TableCell extends StatelessWidget {
  final int number;
  final String lang;
  final VoidCallback onTap;
  const _TableCell({
    required this.number,
    required this.lang,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final tableVM = context.watch<TableViewModel>();
    final isOcc = tableVM.isOccupied(number);
    final dur = isOcc ? tableVM.getTableDuration(number) : null;
    final isLate = dur != null && dur.inMinutes >= 30;
    final total = isOcc ? tableVM.getTableTotal(number) : 0.0;
    final cnt = isOcc ? tableVM.getTableItemCount(number) : 0;
    final orderCount = isOcc ? tableVM.getOrders(number).length : 0;
    final Color accent = isOcc
        ? (isLate ? AppColors.warning : AppColors.error)
        : AppColors.success;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: accent.withOpacity(0.06),
          borderRadius: BorderRadius.circular(R.radiusLG),
          border: Border.all(color: accent.withOpacity(0.35), width: 1.5),
          boxShadow: isOcc
              ? [
                  BoxShadow(
                    color: accent.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        padding: EdgeInsets.all(R.spaceSM),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.table_restaurant_rounded,
              size: R.isLargeTablet ? 30 : 26,
              color: accent,
            ),
            SizedBox(height: R.spaceXS / 2),
            Text(
              '$number',
              style: TextStyle(
                fontSize: R.isLargeTablet ? 24 : 20,
                fontWeight: FontWeight.w800,
                color: accent,
              ),
            ),
            SizedBox(height: R.spaceXS / 2),
            if (isOcc) ...[
              Text(
                CurrencyFormatter.formatNumber(total),
                style: TextStyle(
                  fontSize: R.textSM,
                  fontWeight: FontWeight.w700,
                  color: accent,
                ),
              ),
              Text(
                orderCount > 1
                    ? '$orderCount zakaz  •  ${dur!.inMinutes} min'
                    : '$cnt ta  •  ${dur!.inMinutes} min',
                style: TextStyle(
                  fontSize: R.textXS,
                  color: accent.withOpacity(0.75),
                ),
              ),
            ] else
              Text(
                "Bo'sh",
                style: TextStyle(
                  fontSize: R.textSM,
                  color: accent.withOpacity(0.8),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// TEZ BUYURTMA STRIP
// ═══════════════════════════════════════════════════════

class _QuickOrderStrip extends StatelessWidget {
  final String lang;
  const _QuickOrderStrip({required this.lang});

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final top = context
        .watch<ProductViewModel>()
        .allProducts
        .where((p) => p.isAvailable)
        .take(6)
        .toList();
    if (top.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.fromLTRB(R.spaceMD, R.spaceSM, R.spaceMD, R.spaceSM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            lang == 'kr' ? 'Тез буюртма' : 'Tez buyurtma',
            style: TextStyle(
              fontSize: R.textXS,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: R.spaceXS),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: top.map((p) {
                final qty = context.watch<CartViewModel>().getQuantity(p.id);
                final active = qty > 0;
                return Padding(
                  padding: EdgeInsets.only(right: R.spaceXS),
                  child: GestureDetector(
                    onTap: () => context.read<CartViewModel>().addProduct(p),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: EdgeInsets.symmetric(
                        horizontal: R.spaceMD,
                        vertical: R.spaceXS + 2,
                      ),
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.primary
                            : AppColors.surfaceSecondary,
                        borderRadius: BorderRadius.circular(R.radiusXL),
                        border: Border.all(
                          color: active ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (active) ...[
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '$qty',
                                  style: TextStyle(
                                    fontSize: R.textXS,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: R.spaceXS - 2),
                          ],
                          Text(
                            p.getName(lang),
                            style: TextStyle(
                              fontSize: R.textSM,
                              fontWeight: FontWeight.w600,
                              color: active
                                  ? Colors.white
                                  : AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(width: R.spaceXS),
                          Text(
                            CurrencyFormatter.formatNumber(p.price),
                            style: TextStyle(
                              fontSize: R.textXS,
                              color: active
                                  ? Colors.white.withOpacity(0.85)
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// TOPBAR
// ═══════════════════════════════════════════════════════

class _TopBar extends StatelessWidget {
  final String lang;
  final PosMode mode;
  final int tableNumber;
  final bool searchOpen, showSearch, showModeToggle;
  final VoidCallback onMenuTap, onToggleSearch, onLangToggle;
  final ValueChanged<PosMode> onModeChange;
  final IconData backIcon;
  final String? backTooltip;

  const _TopBar({
    required this.lang,
    required this.mode,
    required this.tableNumber,
    required this.searchOpen,
    required this.showSearch,
    required this.showModeToggle,
    required this.onMenuTap,
    required this.onToggleSearch,
    required this.onModeChange,
    required this.onLangToggle,
    this.backIcon = Icons.menu_rounded,
    this.backTooltip,
  });

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final s = (String k) => AppStrings.get(k, lang);
    final products = context.read<ProductViewModel>();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: R.spaceMD,
        vertical: R.isLargeTablet ? 14.0 : 11.0,
      ),
      child: Row(
        children: [
          _IBtn(icon: backIcon, onTap: onMenuTap),
          SizedBox(width: R.spaceSM),

          // Sarlavha
          if (tableNumber > 0)
            _TableBadge(num: tableNumber, lang: lang)
          else
            Text(
              s('app_name'),
              style: TextStyle(
                fontSize: R.textLG,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),

          const Spacer(),

          // Qidiruv
          if (showSearch) ...[
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: searchOpen ? (R.isLargeTablet ? 240 : 180) : 0,
              child: searchOpen
                  ? TextField(
                      autofocus: true,
                      onChanged: (v) => products.search(v),
                      style: TextStyle(fontSize: R.textSM),
                      decoration: InputDecoration(
                        hintText: s('search'),
                        prefixIcon: Icon(Icons.search, size: R.iconSM),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: R.spaceXS,
                        ),
                        filled: true,
                        fillColor: AppColors.surfaceSecondary,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(R.radiusMD),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
            _IBtn(
              icon: searchOpen ? Icons.close_rounded : Icons.search_rounded,
              onTap: onToggleSearch,
            ),
            SizedBox(width: R.spaceXS),
          ],

          // Rejim toggle
          if (showModeToggle) ...[
            _ModeToggle(mode: mode, onChanged: onModeChange, lang: lang),
            SizedBox(width: R.spaceXS),
          ],

          // Til
          _LangBtn(lang: lang, onTap: onLangToggle),
          SizedBox(width: R.spaceXS),

          // Avatar
          _Avatar(),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════
// KICHIK WIDGETLAR
// ═══════════════════════════════════════════════════════

class _TableBadge extends StatelessWidget {
  final int num;
  final String lang;
  const _TableBadge({required this.num, required this.lang});
  @override
  Widget build(BuildContext context) {
    R.init(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: R.spaceSM,
        vertical: R.spaceXS - 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(R.radiusMD),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.table_restaurant_rounded,
            size: R.iconSM,
            color: AppColors.primary,
          ),
          SizedBox(width: R.spaceXS - 2),
          Text(
            '${AppStrings.get('table', lang)} $num',
            style: TextStyle(
              fontSize: R.textMD,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeToggle extends StatelessWidget {
  final PosMode mode;
  final ValueChanged<PosMode> onChanged;
  final String lang;
  const _ModeToggle({
    required this.mode,
    required this.onChanged,
    required this.lang,
  });
  @override
  Widget build(BuildContext context) {
    R.init(context);
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(R.radiusMD),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MBtn(
            icon: Icons.table_restaurant_rounded,
            label: lang == 'kr' ? 'Стол' : 'Stol',
            active: mode == PosMode.tableFirst,
            onTap: () => onChanged(PosMode.tableFirst),
          ),
          const SizedBox(width: 2),
          _MBtn(
            icon: Icons.fastfood_rounded,
            label: lang == 'kr' ? 'Маҳсулот' : 'Mahsulot',
            active: mode == PosMode.productFirst,
            onTap: () => onChanged(PosMode.productFirst),
          ),
        ],
      ),
    );
  }
}

class _MBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _MBtn({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    R.init(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(
          horizontal: R.spaceSM,
          vertical: R.spaceXS - 2,
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(R.radiusSM),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: R.iconSM,
              color: active ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: R.textXS,
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IBtn({required this.icon, required this.onTap});
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
        child: Icon(icon, size: R.iconMD, color: AppColors.textPrimary),
      ),
    );
  }
}

class _LangBtn extends StatelessWidget {
  final String lang;
  final VoidCallback onTap;
  const _LangBtn({required this.lang, required this.onTap});
  @override
  Widget build(BuildContext context) {
    R.init(context);
    return GestureDetector(
      onTap: onTap,
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'UZ',
              style: TextStyle(
                fontSize: R.textXS,
                fontWeight: FontWeight.w600,
                color: lang == 'uz'
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 4),
            Container(width: 1, height: 13, color: AppColors.border),
            const SizedBox(width: 4),
            Text(
              'КР',
              style: TextStyle(
                fontSize: R.textXS,
                fontWeight: FontWeight.w600,
                color: lang == 'kr'
                    ? AppColors.primary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    R.init(context);
    final name = context.watch<AuthViewModel>().currentUser.name;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
    final sz = R.isLargeTablet ? 44.0 : 40.0;
    return Container(
      width: sz,
      height: sz,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(R.radiusMD),
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: Colors.white,
            fontSize: R.textMD,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
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
          style: TextStyle(fontSize: R.textSM, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
