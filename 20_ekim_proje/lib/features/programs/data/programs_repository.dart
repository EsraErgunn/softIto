import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/demo/demo_settings_provider.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/models/models.dart';
import '../../../core/utils/date_resolver.dart';

abstract class ProgramsRepository {
  Future<List<Program>> getPrograms();
  Future<Program> getProgramById(String id);
}

class MockProgramsRepository implements ProgramsRepository {
  MockProgramsRepository(this._ref);
  final Ref _ref;

  List<Program>? _programs;

  Future<void> _simulateNetwork() async {
    final demo = _ref.read(demoSettingsProvider);
    if (demo.latency > Duration.zero) {
      await Future.delayed(demo.latency);
    }
    if (demo.simulateErrors) {
      throw const AppException('Destek programları yüklenirken bağlantı hatası oluştu.');
    }
  }

  @override
  Future<List<Program>> getPrograms() async {
    await _simulateNetwork();
    if (_programs != null) return _programs!;

    final raw = await rootBundle.loadString('assets/mock/programs.json');
    final now = DateTime.now();
    final list = (jsonDecode(raw) as List)
        .cast<Map<String, dynamic>>()
        .map((j) => resolveRelativeDates(j, now))
        .map((j) => Program.fromJson(j))
        .toList();

    // Son başvuru tarihi en yakın olanlar önce
    list.sort((a, b) => a.deadline.compareTo(b.deadline));
    _programs = list;
    return _programs!;
  }

  @override
  Future<Program> getProgramById(String id) async {
    final programs = await getPrograms();
    return programs.firstWhere(
      (p) => p.id == id,
      orElse: () => throw AppException('Destek programı bulunamadı: $id'),
    );
  }
}
