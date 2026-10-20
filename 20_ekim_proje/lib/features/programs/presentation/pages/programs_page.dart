import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/models/models.dart';
import '../../../../core/widgets/widgets.dart';
import '../widgets/program_card.dart';
import '../../providers/programs_providers.dart';

class ProgramsPage extends ConsumerWidget {
  const ProgramsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredAsync = ref.watch(filteredProgramsProvider);
    final filter = ref.watch(programFilterProvider);
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
                  onChanged: (q) => ref.read(programFilterProvider.notifier).setSearchQuery(q),
                  decoration: InputDecoration(
                    hintText: 'Program, kurum veya etiket ara...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: filter.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => ref.read(programFilterProvider.notifier).setSearchQuery(''),
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
                        selected: filter.selectedType == null && filter.selectedScope == null && !filter.hideExpired,
                        onSelected: (_) => ref.read(programFilterProvider.notifier).reset(),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      FilterChip(
                        label: const Text('Aktif (Süresi Dolmamış)'),
                        selected: filter.hideExpired,
                        onSelected: (val) => ref.read(programFilterProvider.notifier).setHideExpired(val),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      ...ProgramType.values.map((type) {
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.xs),
                          child: FilterChip(
                            label: Text(type.label),
                            selected: filter.selectedType == type,
                            onSelected: (_) => ref.read(programFilterProvider.notifier).setSelectedType(type),
                          ),
                        );
                      }),
                      ...ProgramScope.values.map((scope) {
                        return Padding(
                          padding: const EdgeInsets.only(right: AppSpacing.xs),
                          child: FilterChip(
                            label: Text(scope.label),
                            selected: filter.selectedScope == scope,
                            onSelected: (_) => ref.read(programFilterProvider.notifier).setSelectedScope(scope),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => ref.invalidate(programsProvider),
              child: AsyncValueView(
                value: filteredAsync,
                loading: () => const SkeletonList(variant: SkeletonVariant.program, itemCount: 5),
                empty: (list) => list.isEmpty,
                emptyBuilder: () => EmptyState.programs(
                  onAction: () => ref.read(programFilterProvider.notifier).reset(),
                ),
                data: (list) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      final program = list[index];
                      return ProgramCard(
                        program: program,
                        onTap: () => context.push('/programs/${program.id}'),
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
