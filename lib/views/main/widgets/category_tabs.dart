import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../../viewmodels/product_viewmodel.dart';

class CategoryTabs extends StatelessWidget {
  final String lang;
  const CategoryTabs({super.key, required this.lang});

  static const _categories = [
    'all',
    'appetizer',
    'main_course',
    'dessert',
    'beverage',
  ];

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final products = context.watch<ProductViewModel>();
    final selected = products.selectedCategory;

    // CategoryTabs va QuickOrderStrip bir xil surface rangda bo'lsin
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(bottom: BorderSide(color: AppColors.border)),
      ),
      padding: EdgeInsets.fromLTRB(R.spaceMD, R.spaceSM, R.spaceMD, R.spaceSM),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _categories.map((cat) {
            final isSelected = selected == cat;
            return Padding(
              padding: EdgeInsets.only(right: R.spaceXS),
              child: GestureDetector(
                onTap: () => products.selectCategory(cat),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: R.isLargeTablet ? 22 : 18,
                    vertical: R.isLargeTablet ? 11 : 9,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(R.radiusXL),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Text(
                    AppStrings.get(cat == 'all' ? 'all' : cat, lang),
                    style: TextStyle(
                      fontSize: R.textSM,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
