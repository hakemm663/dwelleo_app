import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/property.dart';
import '../cubit/property_detail_cubit.dart';
import '../cubit/property_detail_state.dart';

class PropertyDetailScreen extends StatefulWidget {
  final String slug;
  const PropertyDetailScreen({super.key, required this.slug});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  late final PropertyDetailCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<PropertyDetailCubit>()..load(widget.slug);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocBuilder<PropertyDetailCubit, PropertyDetailState>(
          builder: (context, state) {
            return switch (state) {
              PropertyDetailInitial() ||
              PropertyDetailLoading() => const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
              PropertyDetailError(:final message) => _DetailError(
                message: message,
                onRetry: () => context.read<PropertyDetailCubit>().load(widget.slug),
              ),
              PropertyDetailLoaded(:final property) => _DetailBody(
                property: property,
              ),
            };
          },
        ),
      ),
    );
  }
}

class _DetailBody extends StatefulWidget {
  final Property property;
  const _DetailBody({required this.property});

  @override
  State<_DetailBody> createState() => _DetailBodyState();
}

class _DetailBodyState extends State<_DetailBody> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final property = widget.property;
    final images = [
      if (property.coverImage != null) property.coverImage!,
      ...property.images,
    ];
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          backgroundColor: AppColors.surfaceDark,
          flexibleSpace: FlexibleSpaceBar(
            background: images.isEmpty
                ? const ColoredBox(color: AppColors.divider)
                : PageView.builder(
                    controller: _pageController,
                    itemCount: images.length,
                    itemBuilder: (_, i) => CachedNetworkImage(
                      imageUrl: images[i].path,
                      fit: BoxFit.cover,
                      placeholder: (ctx, url) =>
                          const ColoredBox(color: AppColors.divider),
                      errorWidget: (ctx, url, err) =>
                          const ColoredBox(color: AppColors.divider),
                    ),
                  ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Formatters.price(property.price),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  property.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (property.location?.address != null) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.location!.address!,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                _Specs(property: property),
                if (property.description?.isNotEmpty == true) ...[
                  const _SectionTitle('About this property'),
                  Text(
                    property.description!,
                    style: const TextStyle(
                      height: 1.5,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
                if (property.amenities.isNotEmpty) ...[
                  const _SectionTitle('Amenities'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final a in property.amenities)
                        Chip(
                          label: Text(a.title),
                          backgroundColor: AppColors.surface,
                          side: const BorderSide(color: AppColors.divider),
                        ),
                    ],
                  ),
                ],
                if (property.owner != null) ...[
                  const _SectionTitle('Listed by'),
                  _OwnerCard(owner: property.owner!),
                ],
                if (property.location?.adLicenseNumber != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Ad license: ${property.location!.adLicenseNumber}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Specs extends StatelessWidget {
  final Property property;
  const _Specs({required this.property});

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String)>[
      if (property.bedrooms != null)
        (Icons.bed_outlined, '${property.bedrooms} Beds'),
      if (property.bathrooms != null)
        (Icons.bathtub_outlined, '${property.bathrooms} Baths'),
      if (property.areaSqm != null)
        (Icons.square_foot_outlined, Formatters.area(property.areaSqm)),
      if (property.hasMaidRoom)
        (Icons.cleaning_services_outlined, '${property.maidRoom} Maid'),
      if (property.furnishingStatus != null)
        (Icons.chair_outlined, _pretty(property.furnishingStatus!)),
    ];
    return Wrap(
      spacing: 16,
      runSpacing: 10,
      children: [
        for (final (icon, label) in items)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: AppColors.primaryDark),
              const SizedBox(width: 4),
              Text(label,
                  style: const TextStyle(color: AppColors.textPrimary)),
            ],
          ),
      ],
    );
  }

  static String _pretty(String s) =>
      s.replaceAll('_', ' ').replaceAll('-', ' ');
}

class _OwnerCard extends StatelessWidget {
  final PropertyOwner owner;
  const _OwnerCard({required this.owner});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primaryLight,
            backgroundImage: owner.image?.path != null
                ? CachedNetworkImageProvider(owner.image!.path)
                : null,
            child: owner.image?.path == null
                ? const Icon(Icons.business, color: AppColors.surface)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        owner.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    if (owner.verified) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified,
                          size: 16, color: AppColors.info),
                    ],
                  ],
                ),
                if (owner.userType != null)
                  Text(
                    owner.userType!.replaceAll('_', ' '),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _DetailError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _DetailError({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(onPressed: onRetry, child: const Text('Retry')),
            ],
          ),
        ),
      ),
    );
  }
}
