import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/formatters.dart';
import '../../domain/entities/property.dart';

/// Compact property card used in the list. Mirrors the dwelleo.sa listing card.
/// Fully theme-aware (light + dark) and uses the brand vector spec icons.
class PropertyCard extends StatelessWidget {
  final Property property;
  final VoidCallback? onTap;

  const PropertyCard({super.key, required this.property, this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CardImage(property: property),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppSvg.sar,
                        width: 16,
                        height: 16,
                        colorFilter: ColorFilter.mode(
                          scheme.onSurface,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        Formatters.priceValue(property.price),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: scheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurface,
                    ),
                  ),
                  if (property.cityName != null) ...[
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: scheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            property.cityName!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 10),
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
              placeholder: (ctx, _) => const _ImageFallback(),
              errorWidget: (ctx, url, error) => const _ImageFallback(),
            )
          else
            const _ImageFallback(),
          if (property.isFeatured)
            const Positioned(
              top: 10,
              left: 10,
              child: _Badge(label: 'Featured', color: AppColors.accent),
            ),
          if (property.listingType != null)
            Positioned(
              top: 10,
              right: 10,
              child: _Badge(
                label: property.listingType!.isForRent ? 'Rent' : 'Sale',
                color: AppColors.accentFor(Theme.of(context).brightness),
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
    final scheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: scheme.surfaceContainerHighest,
      child: Icon(
        Icons.image_outlined,
        size: 40,
        color: scheme.onSurfaceVariant,
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
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          // Pick a readable foreground for whatever accent the theme uses.
          color: ThemeData.estimateBrightnessForColor(color) == Brightness.dark
              ? Colors.white
              : AppColors.ink,
          fontSize: 11,
          fontWeight: FontWeight.w700,
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
    final color = Theme.of(context).colorScheme.onSurfaceVariant;
    return Wrap(
      spacing: 14,
      runSpacing: 4,
      children: [
        if (property.bedrooms != null)
          _Spec(
            svg: AppSvg.bed,
            label: '${property.bedrooms} Beds',
            color: color,
          ),
        if (property.bathrooms != null)
          _Spec(
            svg: AppSvg.bath,
            label: '${property.bathrooms} Baths',
            color: color,
          ),
        if (property.areaSqm != null)
          _Spec(
            svg: AppSvg.sqf,
            label: Formatters.area(property.areaSqm),
            color: color,
          ),
      ],
    );
  }
}

class _Spec extends StatelessWidget {
  final String svg;
  final String label;
  final Color color;
  const _Spec({required this.svg, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          svg,
          width: 15,
          height: 15,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12, color: color)),
      ],
    );
  }
}
