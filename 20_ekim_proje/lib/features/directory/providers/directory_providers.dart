import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/models.dart';
import '../data/directory_repository.dart';

final directoryRepositoryProvider = Provider<DirectoryRepository>((ref) {
  return MockDirectoryRepository(ref);
});

// INVESTORS
final investorsProvider = FutureProvider<List<Investor>>((ref) async {
  return ref.watch(directoryRepositoryProvider).getInvestors();
});

class InvestorFilter {
  const InvestorFilter({
    this.searchQuery = '',
    this.selectedType,
    this.verifiedOnly = false,
  });

  final String searchQuery;
  final InvestorType? selectedType;
  final bool verifiedOnly;

  InvestorFilter copyWith({
    String? searchQuery,
    InvestorType? selectedType,
    bool? verifiedOnly,
    bool clearType = false,
  }) {
    return InvestorFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedType: clearType ? null : (selectedType ?? this.selectedType),
      verifiedOnly: verifiedOnly ?? this.verifiedOnly,
    );
  }

  bool matches(Investor investor) {
    if (verifiedOnly && !investor.isVerified) return false;
    if (selectedType != null && investor.investorType != selectedType) return false;
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      final matchName = investor.name.toLowerCase().contains(q);
      final matchFirm = investor.firm.toLowerCase().contains(q);
      final matchBio = investor.bio.toLowerCase().contains(q);
      final matchPortfolio = investor.portfolio.any((p) => p.toLowerCase().contains(q));
      if (!matchName && !matchFirm && !matchBio && !matchPortfolio) return false;
    }
    return true;
  }
}

class InvestorFilterNotifier extends Notifier<InvestorFilter> {
  @override
  InvestorFilter build() => const InvestorFilter();

  void setSearchQuery(String q) => state = state.copyWith(searchQuery: q);
  void setSelectedType(InvestorType? type) {
    if (state.selectedType == type) {
      state = state.copyWith(clearType: true);
    } else {
      state = state.copyWith(selectedType: type);
    }
  }
  void setVerifiedOnly(bool val) => state = state.copyWith(verifiedOnly: val);
  void reset() => state = const InvestorFilter();
}

final investorFilterProvider = NotifierProvider<InvestorFilterNotifier, InvestorFilter>(
  InvestorFilterNotifier.new,
);

final filteredInvestorsProvider = Provider<AsyncValue<List<Investor>>>((ref) {
  final filter = ref.watch(investorFilterProvider);
  return ref.watch(investorsProvider).whenData((list) {
    return list.where(filter.matches).toList();
  });
});

final investorProvider = FutureProvider.family<Investor, String>((ref, id) async {
  final profile = await ref.watch(directoryRepositoryProvider).getById(id);
  if (profile is Investor) return profile;
  throw Exception('Profil bir yatırımcı değil: $id');
});

// MENTORS
final mentorsProvider = FutureProvider<List<Mentor>>((ref) async {
  return ref.watch(directoryRepositoryProvider).getMentors();
});

class MentorFilter {
  const MentorFilter({
    this.searchQuery = '',
    this.selectedSector,
    this.verifiedOnly = false,
  });

  final String searchQuery;
  final Sector? selectedSector;
  final bool verifiedOnly;

  MentorFilter copyWith({
    String? searchQuery,
    Sector? selectedSector,
    bool? verifiedOnly,
    bool clearSector = false,
  }) {
    return MentorFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedSector: clearSector ? null : (selectedSector ?? this.selectedSector),
      verifiedOnly: verifiedOnly ?? this.verifiedOnly,
    );
  }

  bool matches(Mentor mentor) {
    if (verifiedOnly && !mentor.isVerified) return false;
    if (selectedSector != null && !mentor.expertise.contains(selectedSector)) return false;
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      final matchName = mentor.name.toLowerCase().contains(q);
      final matchTitle = mentor.title.toLowerCase().contains(q);
      final matchBio = mentor.bio.toLowerCase().contains(q);
      if (!matchName && !matchTitle && !matchBio) return false;
    }
    return true;
  }
}

class MentorFilterNotifier extends Notifier<MentorFilter> {
  @override
  MentorFilter build() => const MentorFilter();

  void setSearchQuery(String q) => state = state.copyWith(searchQuery: q);
  void setSelectedSector(Sector? sector) {
    if (state.selectedSector == sector) {
      state = state.copyWith(clearSector: true);
    } else {
      state = state.copyWith(selectedSector: sector);
    }
  }
  void setVerifiedOnly(bool val) => state = state.copyWith(verifiedOnly: val);
  void reset() => state = const MentorFilter();
}

final mentorFilterProvider = NotifierProvider<MentorFilterNotifier, MentorFilter>(
  MentorFilterNotifier.new,
);

final filteredMentorsProvider = Provider<AsyncValue<List<Mentor>>>((ref) {
  final filter = ref.watch(mentorFilterProvider);
  return ref.watch(mentorsProvider).whenData((list) {
    return list.where(filter.matches).toList();
  });
});

final mentorProvider = FutureProvider.family<Mentor, String>((ref, id) async {
  final profile = await ref.watch(directoryRepositoryProvider).getById(id);
  if (profile is Mentor) return profile;
  throw Exception('Profil bir mentör değil: $id');
});
