import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/property.dart';
import '../../domain/entities/property_query.dart';
import '../cubit/properties_cubit.dart';
import '../cubit/properties_state.dart';
import '../widgets/property_card.dart';

/// `for-sale` (Buy) or `for-rent` (Rent). Null = curated home set.
class PropertiesListScreen extends StatefulWidget {
  final String? listingType;

  const PropertiesListScreen({super.key, this.listingType});

  @override
  State<PropertiesListScreen> createState() => _PropertiesListScreenState();
}

class _PropertiesListScreenState extends State<PropertiesListScreen> {
  late final PropertiesCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<PropertiesCubit>()
      ..load(
        query: widget.listingType == null
            ? null
            : PropertyQuery(listingType: widget.listingType),
      );
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
      child: _PropertiesView(listingType: widget.listingType),
    );
  }
}

class _PropertiesView extends StatelessWidget {
  final String? listingType;
  const _PropertiesView({this.listingType});

  String get _title => switch (listingType) {
    'for-rent' => 'Properties for Rent',
    'for-sale' => 'Properties for Sale',
    _ => 'Properties',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_title)),
      body: BlocBuilder<PropertiesCubit, PropertiesState>(
        builder: (context, state) {
          return switch (state) {
            PropertiesInitial() || PropertiesLoading() => const _Loading(),
            PropertiesError(:final message) => _ErrorView(
              message: message,
              onRetry: () => context.read<PropertiesCubit>().refresh(),
            ),
            PropertiesLoaded(:final properties) =>
              properties.isEmpty
                  ? const _EmptyView()
                  : _PropertiesGrid(
                      onRefresh: () =>
                          context.read<PropertiesCubit>().refresh(),
                      properties: properties,
                    ),
          };
        },
      ),
    );
  }
}

class _PropertiesGrid extends StatelessWidget {
  final List<Property> properties;
  final Future<void> Function() onRefresh;
  const _PropertiesGrid({required this.properties, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: properties.length,
        separatorBuilder: (ctx, i) => const SizedBox(height: 14),
        itemBuilder: (context, i) {
          final property = properties[i];
          return PropertyCard(
            property: property,
            onTap: () =>
                context.push(RoutePaths.propertyDetailPath(property.slug)),
          );
        },
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading();
  @override
  Widget build(BuildContext context) =>
      const Center(child: CircularProgressIndicator(color: AppColors.primary));
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, size: 48, color: AppColors.textSecondary),
          SizedBox(height: 12),
          Text(
            'No properties found',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
