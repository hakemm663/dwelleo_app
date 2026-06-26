import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/property.dart';

/// Compact property card used in the list. Mirrors the dwelleo.sa listing card.
class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback? onTap;

  const PropertyCard({super.key, required this.property, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1.5,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardImage(property: property),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    Formatters.price(property.price),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (property.cityName != null) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            property.cityName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  _SpecRow(property: property),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardImage extends StatelessWidget {
  final Property property;
  const _CardImage({required this.property});

  @override
  Widget build(BuildContext context) {
    final url = property.coverImage?.displayThumb;
    return AspectRatio(
      aspectRatio: 16 / 10,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (url != null)
            CachedNetworkImage(
              imageUrl: url,
              fit: BoxFit.cover,
              placeholder: (ctx, url) =>
                  const ColoredBox(color: AppColors.divider),
              errorWidget: (ctx, url, err) => const _ImageFallback(),
            )
          else
            const _ImageFallback(),
          if (property.isFeatured)
            Positioned(
              top: 8,
              left: 8,
              child: _Badge(
                label: 'Featured',
                color: AppColors.accent,
              ),
            ),
          if (property.listingType != null)
            Positioned(
              top: 8,
              right: 8,
              child: _Badge(
                label: property.listingType!.isForRent ? 'Rent' : 'Sale',
                color: AppColors.primaryDark,
              ),
            ),
        ],
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.divider,
      child: Center(
        child: Icon(Icons.home_outlined, size: 40, color: AppColors.textSecondary),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.textOnPrimary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _SpecRow extends StatelessWidget {
  final Property property;
  const _SpecRow({required this.property});

  @override
  Widget build(BuildContext context) {
    final specs = <Widget>[
      if (property.bedrooms != null)
        _Spec(icon: Icons.bed_outlined, label: '${property.bedrooms} Beds'),
      if (property.bathrooms != null)
        _Spec(icon: Icons.bathtub_outlined, label: '${property.bathrooms} Baths'),
      if (property.areaSqm != null)
        _Spec(
          icon: Icons.square_foot_outlined,
          label: Formatters.area(property.areaSqm),
        ),
    ];
    return Wrap(spacing: 12, runSpacing: 4, children: specs);
  }
}

class _Spec extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Spec({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: AppColors.textSecondary),
        const SizedBox(width: 3),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
