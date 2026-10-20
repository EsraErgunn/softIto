import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/models.dart';
import '../../../core/storage/prefs_provider.dart';
import '../data/programs_repository.dart';

const _kSavedProgramsKey = 'app_saved_programs';

final programsRepositoryProvider = Provider<ProgramsRepository>((ref) {
  return MockProgramsRepository(ref);
});

final programsProvider = FutureProvider<List<Program>>((ref) async {
  return ref.watch(programsRepositoryProvider).getPrograms();
});

class ProgramFilter {
  const ProgramFilter({
    this.searchQuery = '',
    this.selectedType,
    this.selectedScope,
    this.hideExpired = false,
  });

  final String searchQuery;
  final ProgramType? selectedType;
  final ProgramScope? selectedScope;
  final bool hideExpired;

  ProgramFilter copyWith({
    String? searchQuery,
    ProgramType? selectedType,
    ProgramScope? selectedScope,
    bool? hideExpired,
    bool clearType = false,
    bool clearScope = false,
  }) {
    return ProgramFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedType: clearType ? null : (selectedType ?? this.selectedType),
      selectedScope: clearScope ? null : (selectedScope ?? this.selectedScope),
      hideExpired: hideExpired ?? this.hideExpired,
    );
  }

  bool matches(Program program) {
    final now = DateTime.now();
    final isExpired = program.deadline.isBefore(now);
    if (hideExpired && isExpired) return false;

    if (selectedType != null && program.type != selectedType) return false;
    if (selectedScope != null && program.scope != selectedScope) return false;

    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      final matchTitle = program.title.toLowerCase().contains(q);
      final matchProvider = program.provider.toLowerCase().contains(q);
      final matchSummary = program.summary.toLowerCase().contains(q);
      final matchTags = program.tags.any((t) => t.toLowerCase().contains(q));
      if (!matchTitle && !matchProvider && !matchSummary && !matchTags) return false;
    }

    return true;
  }
}

class ProgramFilterNotifier extends Notifier<ProgramFilter> {
  @override
  ProgramFilter build() => const ProgramFilter();

  void setSearchQuery(String q) => state = state.copyWith(searchQuery: q);
  void setSelectedType(ProgramType? type) {
    if (state.selectedType == type) {
      state = state.copyWith(clearType: true);
    } else {
      state = state.copyWith(selectedType: type);
    }
  }
  void setSelectedScope(ProgramScope? scope) {
    if (state.selectedScope == scope) {
      state = state.copyWith(clearScope: true);
    } else {
      state = state.copyWith(selectedScope: scope);
    }
  }
  void setHideExpired(bool val) => state = state.copyWith(hideExpired: val);
  void reset() => state = const ProgramFilter();
}

final programFilterProvider = NotifierProvider<ProgramFilterNotifier, ProgramFilter>(
  ProgramFilterNotifier.new,
);

final filteredProgramsProvider = Provider<AsyncValue<List<Program>>>((ref) {
  final filter = ref.watch(programFilterProvider);
  return ref.watch(programsProvider).whenData((list) {
    return list.where(filter.matches).toList();
  });
});

final programProvider = FutureProvider.family<Program, String>((ref, id) async {
  return ref.watch(programsRepositoryProvider).getProgramById(id);
});

class SavedProgramIdsNotifier extends Notifier<Set<String>> {
  @override
  Set<String> build() {
    final prefs = ref.watch(prefsProvider);
    final list = prefs.getStringList(_kSavedProgramsKey) ?? [];
    return list.toSet();
  }

  Future<void> toggle(String programId) async {
    HapticFeedback.lightImpact();
    final current = {...state};
    if (current.contains(programId)) {
      current.remove(programId);
    } else {
      current.add(programId);
    }
    state = current;
    final prefs = ref.read(prefsProvider);
    await prefs.setStringList(_kSavedProgramsKey, current.toList());
  }
}

final savedProgramIdsProvider = NotifierProvider<SavedProgramIdsNotifier, Set<String>>(
  SavedProgramIdsNotifier.new,
);
