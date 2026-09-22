import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/common/zovio_badge.dart';
import '../../../widgets/common/zovio_service_card.dart';
import '../../../widgets/common/zovio_worker_card.dart';
import '../../../services/api_client.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchVisible = false;

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
          if (_isSearchVisible)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: _buildSearchBar(context),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 48.0),
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
      padding: const EdgeInsets.only(left: 24.0, right: 24.0, top: 40.0, bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo
          Row(
            children: [
              Image.asset('assets/images/zovio-logo.png', height: 28),
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
              IconButton(
                icon: Icon(
                  _isSearchVisible ? Icons.close : Icons.search,
                  color: AppColors.primaryAction,
                ),
                onPressed: () {
                  setState(() {
                    _isSearchVisible = !_isSearchVisible;
                  });
                },
              ),
              const SizedBox(width: 8),
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
          const SizedBox(width: 20),
          Expanded(
            flex: 5,
            child: _buildHeroImage(context),
          ),
        ],
      );
    } else {
      return Column(
        children: [
          _buildHeroContent(context),
          const SizedBox(height: 20),
          _buildHeroImage(context),
        ],
      );
    }
  }

  Widget _buildHeroContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      fontSize: 45,
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
          const SizedBox(width: 24),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                hintText: 'What do you need help with?',
                hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5), fontSize: 18),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
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
              padding: const EdgeInsets.all(16),
              shape: const CircleBorder(),
              elevation: 0,
            ),
            child: const Icon(Icons.arrow_forward),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width > 900;
    
    return Container(
      height: isDesktop ? 500 : 250,
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
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
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
              mainAxisExtent: 120,
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
            child: FutureBuilder<List<dynamic>>(
              future: apiClient.getServices(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final services = snapshot.data ?? [];
                if (services.isEmpty) {
                  return const Center(child: Text('No services found.'));
                }

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: services.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return SizedBox(
                      width: 240,
                      child: ZovioServiceCard(
                        serviceName: service['name'] ?? 'Service',
                        description: service['description'] ?? 'No description',
                        rating: 4.8,
                        reviewCount: 124,
                        price: 'From \$50', // Mock price since model doesn't have it
                        onTap: () {
                          context.push('${AppRoutes.customerWorkers}?filter=${service['name']}');
                        },
                      ),
                    );
                  },
                );
              }
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
          FutureBuilder<List<dynamic>>(
            future: apiClient.getWorkers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final workers = snapshot.data ?? [];
              if (workers.isEmpty) {
                return const Center(child: Text('No workers found in your area.'));
              }

              // Take only the first 8 for the home screen
              final displayWorkers = workers.take(8).toList();

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 900 ? 4 : (MediaQuery.of(context).size.width > 600 ? 3 : 1),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  mainAxisExtent: 180,
                ),
                itemCount: displayWorkers.length,
                itemBuilder: (context, index) {
                  final worker = displayWorkers[index];
                  return ZovioWorkerCard(
                    workerName: worker['name'] ?? 'Worker',
                    specialization: worker['role'] ?? 'Specialist',
                    rating: (worker['rating'] ?? 0.0).toDouble(),
                    reviewCount: 86, // Mock review count
                    location: 'Nearby', // Mock location since worker doesn't have exact dist
                    isAvailable: worker['status'] == 'Approved',
                    onTap: () {},
                    onContactPressed: () {},
                  );
                },
              );
            }
          ),
        ],
      ),
    );
  }
}
