import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/responsive_helper.dart';

class TableSelectorDialog extends StatelessWidget {
  final int selectedTable;
  final String lang;
  final ValueChanged<int> onSelected;

  const TableSelectorDialog({
    super.key,
    required this.selectedTable,
    required this.lang,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    R.init(context);
    final s = (String key) => AppStrings.get(key, lang);
    final dialogW = R.isLargeTablet ? 480.0 : 420.0;
    final cellSize = R.isLargeTablet ? 72.0 : 64.0;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(R.radiusXL),
      ),
      child: Container(
        width: dialogW,
        padding: EdgeInsets.all(R.spaceLG),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              s('select_table'),
              style: TextStyle(
                fontSize: R.textLG,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: R.spaceMD),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: R.tableGridCols,
                mainAxisSpacing: R.spaceXS,
                crossAxisSpacing: R.spaceXS,
                childAspectRatio: 1,
              ),
              itemCount: AppConstants.defaultTableCount,
              itemBuilder: (context, index) {
                final tableNum = index + 1;
                final isSelected = tableNum == selectedTable;
                return GestureDetector(
                  onTap: () {
                    onSelected(tableNum);
                    Navigator.pop(context);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.surfaceSecondary,
                      borderRadius: BorderRadius.circular(R.radiusMD),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.table_restaurant_rounded,
                          size: R.iconMD,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                        SizedBox(height: R.spaceXS / 2),
                        Text(
                          '$tableNum',
                          style: TextStyle(
                            fontSize: R.textMD,
                            fontWeight: FontWeight.w700,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            SizedBox(height: R.spaceSM),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                s('cancel'),
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
