import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/models/models.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../directory/presentation/widgets/person_card.dart';
import '../../../directory/providers/directory_providers.dart';

class InvestorsPage extends ConsumerWidget {
  const InvestorsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAsync = ref.watch(filteredInvestorsProvider);
    final filter = ref.watch(investorFilterProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          // Search & Filter Header
          Container(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xs),
            color: theme.colorScheme.surface,
            child: Column(
              children: [
                TextField(
                  onChanged: (q) => ref.read(investorFilterProvider.notifier).setSearchQuery(q),
                  decoration: InputDecoration(
                    hintText: 'Yatırımcı, fon veya portföy ara...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: filter.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => ref.read(investorFilterProvider.notifier).setSearchQuery(''),
                          )
                        : null,
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FilterChip(
                        label: const Text('Tümü'),
                        selected: filter.selectedType == null && !filter.verifiedOnly,
                        onSelected: (_) => ref.read(investorFilterProvider.notifier).reset(),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      FilterChip(
                        avatar: const Icon(Icons.verified, size: 16),
                        label: const Text('Doğrulanmış'),
                        selected: filter.verifiedOnly,
                        onSelected: (val) => ref.read(investorFilterProvider.notifier).setVerifiedOnly(val),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      ...InvestorType.values.map((type) {
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.xs),
                          child: FilterChip(
                            label: Text(type.label),
                            selected: filter.selectedType == type,
                            onSelected: (_) => ref.read(investorFilterProvider.notifier).setSelectedType(type),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Investor List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => ref.invalidate(investorsProvider),
              child: AsyncValueView(
                value: filteredAsync,
                loading: () => const SkeletonList(variant: SkeletonVariant.person, itemCount: 5),
                empty: (list) => list.isEmpty,
                emptyBuilder: () => EmptyState.investors(
                  onAction: () => ref.read(investorFilterProvider.notifier).reset(),
                ),
                data: (list) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final investor = list[index];
                      return PersonCard(
                        profile: investor,
                        onTap: () => context.push('/investors/${investor.id}'),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
