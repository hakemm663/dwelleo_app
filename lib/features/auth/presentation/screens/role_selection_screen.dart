import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/localization/locale_cubit.dart';
import '../../../../core/routing/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/dwelleo_app_bar.dart';

/// Account-type selection — the first step of SIGN-UP (mirrors dwelleo.sa
/// /register "Join Dwelleo · I am a…"). Six real roles with the brand icons.
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<LocaleCubit>().state.languageCode == 'ar';
    final roles = _roles(isArabic);

    return Scaffold(
      appBar: const DwelleoAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isArabic ? 'انضم إلى دويليو' : 'Join Dwelleo',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                isArabic
                    ? 'اختر نوع حسابك للبدء'
                    : 'Choose your account type to get started',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  itemCount: roles.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.92,
                  ),
                  itemBuilder: (_, i) => _RoleCard(
                    index: i,
                    data: roles[i],
                    // Role key is forwarded as GoRouter extra so the auth flow
                    // can read it via GoRouterState.extra when wired up.
                    onTap: () =>
                        context.go(RoutePaths.login, extra: roles[i].key),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<_RoleData> _roles(bool ar) => [
    _RoleData(
      'buyer',
      AppSvg.roleBuyer,
      ar ? 'مشتري / مستأجر' : 'Buyer / Renter',
      ar
          ? 'ابحث عن عقارك المثالي وقم بشرائه'
          : 'Find and purchase your dream property',
    ),
    _RoleData(
      'seller',
      AppSvg.roleSeller,
      ar ? 'بائع / مؤجر' : 'Seller / Rental',
      ar
          ? 'أدرج وبع عقاراتك للمشترين'
          : 'List and sell your properties to buyers',
    ),
    _RoleData(
      'agent',
      AppSvg.roleAgent,
      ar ? 'وكيل' : 'Agent',
      ar ? 'وكيل عقاري يساعد العملاء' : 'Agent helping clients buy and sell',
    ),
    _RoleData(
      'broker',
      AppSvg.roleBroker,
      ar ? 'وسيط' : 'Broker',
      ar
          ? 'وسيط مرخّص يدير المعاملات'
          : 'Licensed broker managing transactions',
    ),
    _RoleData(
      'developer',
      AppSvg.roleDeveloper,
      ar ? 'مطوّر' : 'Developer',
      ar ? 'طوّر واعرض مشاريعك العقارية' : 'Develop and showcase your projects',
    ),
    _RoleData(
      'individual_broker',
      AppSvg.roleIndividualBroker,
      ar ? 'وسيط فردي' : 'Individual Broker',
      ar ? 'اعرض عقاراتك بشكل فردي' : 'Showcase your real estate individually',
    ),
  ];
}

class _RoleCard extends StatelessWidget {
  final int index;
  final _RoleData data;
  final VoidCallback onTap;
  const _RoleCard({
    required this.index,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Staggered fade + rise on first build.
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 380 + index * 70),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, 18 * (1 - t)),
          child: child,
        ),
      ),
      child: Card(
        // Clip prevents RenderFlex overflow stripes when OS text-scale is large.
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: SvgPicture.asset(data.svg, width: 26, height: 26),
                ),
                const Spacer(),
                Text(
                  data.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  data.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RoleData {
  final String key;
  final String svg;
  final String title;
  final String subtitle;
  const _RoleData(this.key, this.svg, this.title, this.subtitle);
}
