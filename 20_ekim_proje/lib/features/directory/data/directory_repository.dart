import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/demo/demo_settings_provider.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/models/models.dart';

abstract class DirectoryRepository {
  Future<List<Mentor>> getMentors();
  Future<List<Investor>> getInvestors();
  Future<DirectoryProfile> getById(String id);
}

class MockDirectoryRepository implements DirectoryRepository {
  MockDirectoryRepository(this._ref);
  final Ref _ref;

  List<Mentor>? _mentors;
  List<Investor>? _investors;

  Future<void> _simulateNetwork() async {
    final demo = _ref.read(demoSettingsProvider);
    if (demo.latency > Duration.zero) {
      await Future.delayed(demo.latency);
    }
    if (demo.simulateErrors) {
      throw const AppException('Dizin verileri yüklenirken bir bağlantı hatası oluştu.');
    }
  }

  @override
  Future<List<Mentor>> getMentors() async {
    await _simulateNetwork();
    if (_mentors != null) return _mentors!;

    final raw = await rootBundle.loadString('assets/mock/mentors.json');
    final list = (jsonDecode(raw) as List)
        .cast<Map<String, dynamic>>()
        .map((j) => DirectoryProfile.fromJson(j) as Mentor)
        .toList();

    _mentors = list;
    return _mentors!;
  }

  @override
  Future<List<Investor>> getInvestors() async {
    await _simulateNetwork();
    if (_investors != null) return _investors!;

    final raw = await rootBundle.loadString('assets/mock/investors.json');
    final list = (jsonDecode(raw) as List)
        .cast<Map<String, dynamic>>()
        .map((j) => DirectoryProfile.fromJson(j) as Investor)
        .toList();

    _investors = list;
    return _investors!;
  }

  @override
  Future<DirectoryProfile> getById(String id) async {
    if (id.startsWith('mnt_')) {
      final mentors = await getMentors();
      return mentors.firstWhere(
        (m) => m.id == id,
        orElse: () => throw AppException('Mentör bulunamadı: $id'),
      );
    } else {
      final investors = await getInvestors();
      return investors.firstWhere(
        (i) => i.id == id,
        orElse: () => throw AppException('Yatırımcı bulunamadı: $id'),
      );
    }
  }
}
