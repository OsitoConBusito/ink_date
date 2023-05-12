import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../theme/app_colors.dart';
import '../../theme/spacing.dart';
import '../../widgets/ink_date_elevated_button.dart';

class DateItem extends StatelessWidget {
  const DateItem({
    Key? key,
    required this.dateTimeRange,
  }) : super(key: key);

  final DateTimeRange dateTimeRange;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.medium),
      child: InkDateElevatedButton(
        backgroundColor: Colors.white,
        text: _buildDate(),
        textColor: AppColors.darkGreen,
        onTap: () {},
      ),
    );
  }

  String _buildDate() {
    return toBeginningOfSentenceCase(DateFormat('EEEE d MMM / h a - ', 'es')
            .format(dateTimeRange.start))! +
        DateFormat('h a').format(dateTimeRange.end);
  }
}
