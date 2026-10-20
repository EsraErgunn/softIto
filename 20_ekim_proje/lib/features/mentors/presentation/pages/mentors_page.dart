import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/models/models.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../directory/presentation/widgets/person_card.dart';
import '../../../directory/providers/directory_providers.dart';

class MentorsPage extends ConsumerWidget {
  const MentorsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAsync = ref.watch(filteredMentorsProvider);
    final filter = ref.watch(mentorFilterProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          // Filter Header
          Container(
            padding: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.sm, AppSpacing.md, AppSpacing.xs),
            color: theme.colorScheme.surface,
            child: Column(
              children: [
                TextField(
                  onChanged: (q) => ref.read(mentorFilterProvider.notifier).setSearchQuery(q),
                  decoration: InputDecoration(
                    hintText: 'Mentör, unvan veya uzmanlık ara...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: filter.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => ref.read(mentorFilterProvider.notifier).setSearchQuery(''),
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
                        selected: filter.selectedSector == null && !filter.verifiedOnly,
                        onSelected: (_) => ref.read(mentorFilterProvider.notifier).reset(),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      FilterChip(
                        avatar: const Icon(Icons.verified, size: 16),
                        label: const Text('Doğrulanmış'),
                        selected: filter.verifiedOnly,
                        onSelected: (val) => ref.read(mentorFilterProvider.notifier).setVerifiedOnly(val),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      ...Sector.values.take(6).map((sector) {
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.xs),
                          child: FilterChip(
                            label: Text(sector.label),
                            selected: filter.selectedSector == sector,
                            onSelected: (_) => ref.read(mentorFilterProvider.notifier).setSelectedSector(sector),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Mentors List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => ref.invalidate(mentorsProvider),
              child: AsyncValueView(
                value: filteredAsync,
                loading: () => const SkeletonList(variant: SkeletonVariant.person, itemCount: 5),
                empty: (list) => list.isEmpty,
                emptyBuilder: () => EmptyState.mentors(
                  onAction: () => ref.read(mentorFilterProvider.notifier).reset(),
                ),
                data: (list) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final mentor = list[index];
                      return PersonCard(
                        profile: mentor,
                        onTap: () => context.push('/mentors/${mentor.id}'),
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
