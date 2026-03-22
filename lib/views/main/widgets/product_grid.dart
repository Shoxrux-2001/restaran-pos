import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../viewmodels/product_viewmodel.dart';
import '../../../viewmodels/cart_viewmodel.dart';
import '../../../models/product_model.dart';

class ProductGrid extends StatelessWidget {
  final String lang;
  const ProductGrid({super.key, required this.lang});

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final products = context.watch<ProductViewModel>().filteredProducts;
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(R.spaceMD, 0, R.spaceMD, R.spaceMD),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: R.productGridCols,
        mainAxisSpacing: R.spaceSM,
        crossAxisSpacing: R.spaceSM,
        childAspectRatio: R.productCardRatio,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) =>
          ProductCard(product: products[index], lang: lang),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final String lang;
  const ProductCard({super.key, required this.product, required this.lang});

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final cart = context.watch<CartViewModel>();
    final qty = cart.getQuantity(product.id);
    final hasItem = qty > 0;

    return GestureDetector(
      onTap: () => context.read<CartViewModel>().addProduct(product),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(R.radiusLG),
          border: Border.all(
            color: hasItem ? AppColors.primary : AppColors.border,
            width: hasItem ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: hasItem
                  ? AppColors.primary.withOpacity(0.08)
                  : AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 6,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(R.radiusLG - 1),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    product.imageUrl != null
                        ? Image.network(
                            product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _PlaceholderImage(),
                          )
                        : _PlaceholderImage(),
                    if (hasItem)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              '$qty',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  R.spaceSM,
                  R.spaceXS,
                  R.spaceSM,
                  R.spaceXS,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.getName(lang),
                      style: TextStyle(
                        fontSize: R.textSM,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            _formatPrice(product.price),
                            style: TextStyle(
                              fontSize: R.textSM,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (hasItem)
                          _QtyControl(product: product)
                        else
                          _AddBtn(product: product),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(double price) {
    final f = price
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]} ',
        );
    return "$f so'm";
  }
}

class _QtyControl extends StatelessWidget {
  final ProductModel product;
  const _QtyControl({required this.product});
  @override
  Widget build(BuildContext context) {
    R.init(context);
    final cart = context.watch<CartViewModel>();
    final qty = cart.getQuantity(product.id);
    final btnSize = R.isLargeTablet ? 30.0 : 26.0;
    return Container(
      height: btnSize,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(R.radiusSM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyBtn(
            icon: Icons.remove,
            size: btnSize,
            onTap: () => cart.removeOne(product.id),
          ),
          SizedBox(
            width: btnSize,
            child: Center(
              child: Text(
                '$qty',
                style: TextStyle(
                  fontSize: R.textSM,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          _QtyBtn(
            icon: Icons.add,
            size: btnSize,
            onTap: () => cart.addProduct(product),
          ),
        ],
      ),
    );
  }
}

class _AddBtn extends StatelessWidget {
  final ProductModel product;
  const _AddBtn({required this.product});
  @override
  Widget build(BuildContext context) {
    R.init(context);
    final size = R.isLargeTablet ? 32.0 : 28.0;
    return GestureDetector(
      onTap: () => context.read<CartViewModel>().addProduct(product),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(R.radiusSM),
        ),
        child: Icon(Icons.add, color: Colors.white, size: R.iconSM + 2),
      ),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback onTap;
  const _QtyBtn({required this.icon, required this.size, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: Icon(icon, size: size * 0.5, color: AppColors.primary),
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    R.init(context);
    return Container(
      decoration: const BoxDecoration(color: AppColors.surfaceSecondary),
      child: Center(
        child: Icon(
          Icons.fastfood_rounded,
          color: AppColors.textHint,
          size: R.iconXL,
        ),
      ),
    );
  }
}
