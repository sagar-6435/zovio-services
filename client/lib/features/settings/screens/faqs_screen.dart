import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/common/zovio_app_bar.dart';

class FaqsScreen extends StatelessWidget {
  const FaqsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ZovioAppBar(
        title: 'FAQs',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Frequently Asked Questions',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 24),
            _buildFaqItem(
              context,
              'How do I book a service?',
              'To book a service, browse through the categories or search for specific workers. Once you find a professional, click "Book Now", select your preferred date and time, and confirm your booking.',
            ),
            _buildFaqItem(
              context,
              'Are the workers verified?',
              'Yes, all workers on the Zovio platform undergo a strict verification process including background checks and skill assessments to ensure quality and safety.',
            ),
            _buildFaqItem(
              context,
              'How do I pay for a service?',
              'You can pay securely through the app using credit/debit cards, UPI, or digital wallets once the service is completed.',
            ),
            _buildFaqItem(
              context,
              'Can I cancel a booking?',
              'Yes, you can cancel a booking up to 2 hours before the scheduled time without any cancellation fees. Late cancellations may incur a small fee.',
            ),
            _buildFaqItem(
              context,
              'What if I am not satisfied with the service?',
              'We offer a satisfaction guarantee. If you are not happy with the service provided, please contact our support team within 24 hours, and we will help resolve the issue.',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ExpansionTile(
        title: Text(
          question,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
        ),
        collapsedBackgroundColor: AppColors.white,
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        children: [
          Text(
            answer,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }
}
