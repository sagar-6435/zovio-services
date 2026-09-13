import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/common/zovio_badge.dart';
import '../../../widgets/common/zovio_service_card.dart';
import '../../../widgets/common/zovio_worker_card.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_names.dart';
import '../../../providers/auth_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildHeader(context, ref),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
              child: _buildHeroSection(context),
            ),
          ),
          SliverToBoxAdapter(
            child: _buildCategoriesSection(context),
          ),
          SliverToBoxAdapter(
            child: _buildPopularServicesSection(context),
          ),
          SliverToBoxAdapter(
            child: _buildNearbyWorkersSection(context),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 64),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Icon(Icons.handshake_rounded, color: AppColors.primaryAction, size: 28),
              const SizedBox(width: 8),
              Text(
                'Zovio',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
          
          // Navigation Links (Desktop only)
          if (MediaQuery.of(context).size.width > 800)
            Row(
              children: [
                _buildNavButton(context, 'Services', () => context.push(AppRoutes.customerCategories)),
                _buildNavButton(context, 'Properties', () => context.push(AppRoutes.customerProperties)),
                _buildNavButton(context, 'How it works', () {}),
              ],
            ),
            
          // Actions
          Row(
            children: [
              if (MediaQuery.of(context).size.width > 600) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.softOrange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_outlined, color: AppColors.primaryAction, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        'Kakinada',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: AppColors.primaryAction,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryAction, size: 18),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                _buildOutlinedPill(context, Icons.help_outline, 'Help', onTap: () {}),
                const SizedBox(width: 12),
                _buildOutlinedPill(context, Icons.person_outline, 'sagar', onTap: () => context.push(AppRoutes.customerProfile)),
                const SizedBox(width: 12),
              ],
              Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.logout_rounded, color: Colors.red),
                  onPressed: () {
                    ref.read(authProvider.notifier).logout();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: onTap,
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }

  Widget _buildOutlinedPill(BuildContext context, IconData icon, String text, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.secondaryAction, size: 18),
            const SizedBox(width: 8),
            Text(
              text,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 900;
    
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 5,
            child: _buildHeroContent(context),
          ),
          const SizedBox(width: 48),
          Expanded(
            flex: 5,
            child: _buildHeroImage(),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          _buildHeroContent(context),
          const SizedBox(height: 48),
          _buildHeroImage(),
        ],
      );
    }
  }

  Widget _buildHeroContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ZovioBadge(
          label: '✨ TRUSTED AROUND YOU',
          style: ZovioBadgeStyle.trust,
        ),
        const SizedBox(height: 24),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Connect.\n',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      fontSize: 64,
                      height: 1.1,
                    ),
              ),
              TextSpan(
                text: 'Get It Done.',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: AppColors.primaryAction,
                      fontWeight: FontWeight.w900,
                      fontSize: 64,
                      height: 1.1,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Your everyday needs, handled by trusted local\nprofessionals. From a quick repair to your next home,\nZovio is here.',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
        ),
        const SizedBox(height: 40),
        _buildSearchBar(context),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const Icon(Icons.search, color: AppColors.primaryAction),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'What do you need help with?',
                hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5)),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  context.push('${AppRoutes.customerWorkers}?filter=${value.trim()}');
                } else {
                  context.push(AppRoutes.customerWorkers);
                }
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final query = _searchController.text.trim();
              if (query.isNotEmpty) {
                context.push('${AppRoutes.customerWorkers}?filter=$query');
              } else {
                context.push(AppRoutes.customerWorkers);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryAction,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Search',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        color: AppColors.secondaryAction.withOpacity(0.1),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/hero-image.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, {VoidCallback? onViewAll}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
          ),
          if (onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              child: const Text('View All', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    final categories = [
      {'icon': Icons.electrical_services, 'name': 'Electrical'},
      {'icon': Icons.plumbing, 'name': 'Plumbing'},
      {'icon': Icons.cleaning_services, 'name': 'Cleaning'},
      {'icon': Icons.format_paint, 'name': 'Painting'},
      {'icon': Icons.ac_unit, 'name': 'AC Repair'},
      {'icon': Icons.carpenter, 'name': 'Carpentry'},
      {'icon': Icons.local_shipping, 'name': 'Movers'},
      {'icon': Icons.camera_alt, 'name': 'Photography'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Service Categories', onViewAll: () {
            context.push(AppRoutes.customerCategories);
          }),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 900 ? 8 : (MediaQuery.of(context).size.width > 600 ? 6 : 4),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  final catName = categories[index]['name'] as String;
                  context.push('${AppRoutes.customerWorkers}?filter=$catName');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.02),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        categories[index]['icon'] as IconData,
                        size: 32,
                        color: AppColors.primaryAction,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      categories[index]['name'] as String,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPopularServicesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Popular Services'),
          SizedBox(
            height: 280,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 240,
                  child: ZovioServiceCard(
                    serviceName: 'House Cleaning',
                    description: 'Professional deep cleaning service',
                    rating: 4.8,
                    reviewCount: 124,
                    price: 'From \$50',
                    onTap: () {
                      context.push('${AppRoutes.customerWorkers}?filter=House%20Cleaning');
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyWorkersSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(context, 'Nearby Trusted Workers', onViewAll: () {
            context.push(AppRoutes.customerWorkers);
          }),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : (MediaQuery.of(context).size.width > 600 ? 3 : 1),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 170, // Fixed height to prevent bottom overflow
            ),
            itemCount: 8,
            itemBuilder: (context, index) {
              return ZovioWorkerCard(
                workerName: 'John Doe',
                specialization: 'Expert Electrician',
                rating: 4.9,
                reviewCount: 86,
                location: '2.5 km away',
                isAvailable: true,
                onTap: () {},
                onContactPressed: () {},
              );
            },
          ),
        ],
      ),
    );
  }
}
