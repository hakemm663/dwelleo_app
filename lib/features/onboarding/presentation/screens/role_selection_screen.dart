import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routing/route_paths.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Text(
                'I am looking to…',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              _RoleTile(
                icon: Icons.search,
                label: 'Buy a Property',
                onTap: () =>
                    context.go(RoutePaths.propertySearchPath('for-sale')),
              ),
              const SizedBox(height: 12),
              _RoleTile(
                icon: Icons.home_outlined,
                label: 'Rent a Property',
                onTap: () =>
                    context.go(RoutePaths.propertySearchPath('for-rent')),
              ),
              const SizedBox(height: 12),
              _RoleTile(
                icon: Icons.sell_outlined,
                label: 'Sell / List a Property',
                onTap: () => context.go(RoutePaths.propertySearchPath()),
              ),
              const SizedBox(height: 12),
              _RoleTile(
                icon: Icons.business_outlined,
                label: 'Developer / Broker',
                onTap: () => context.go(RoutePaths.propertySearchPath()),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => context.go(RoutePaths.propertySearchPath()),
                child: const Text('Skip for now'),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleTile extends StatelessWidget {
  const _RoleTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
