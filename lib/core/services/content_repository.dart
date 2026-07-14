import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/content_block.dart';
import '../models/faq_item.dart';
import '../models/industry.dart';
import '../models/process_step.dart';
import '../models/service_package.dart';
import '../models/service_type.dart';
import '../models/site_example.dart';

/// `assets/data/` JSON을 로드하고 첫 로드 이후 캐시한다.
class ContentRepository {
  ContentRepository({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;

  List<ServicePackage>? _packages;
  List<Industry>? _industries;
  List<FaqItem>? _faqs;
  List<ProcessStep>? _processSteps;
  ContentBlocksCatalog? _contentBlocks;
  List<ServiceType>? _serviceTypes;
  List<SiteExample>? _siteExamples;
  Map<String, dynamic>? _consultationOptions;
  Map<String, dynamic>? _utilizationMethods;
  Map<String, dynamic>? _preparationMaterials;

  Future<List<ServicePackage>> loadPackages() async {
    if (_packages != null) return _packages!;
    final raw = await _loadJson('assets/data/service_packages.json');
    _packages = _asList(raw)
        .map(
          (e) => ServicePackage.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList();
    return _packages!;
  }

  Future<List<Industry>> loadIndustries() async {
    if (_industries != null) return _industries!;
    final raw = await _loadJson('assets/data/industries.json');
    _industries = _asList(raw)
        .map((e) => Industry.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    return _industries!;
  }

  Future<List<FaqItem>> loadFaqs() async {
    if (_faqs != null) return _faqs!;
    final raw = await _loadJson('assets/data/faqs.json');
    _faqs = _asList(raw)
        .map((e) => FaqItem.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    return _faqs!;
  }

  Future<List<ProcessStep>> loadProcessSteps() async {
    if (_processSteps != null) return _processSteps!;
    final raw = await _loadJson('assets/data/process_steps.json');
    _processSteps = _asList(raw)
        .map((e) => ProcessStep.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    return _processSteps!;
  }

  Future<ContentBlocksCatalog> loadContentBlocks() async {
    if (_contentBlocks != null) return _contentBlocks!;
    final raw = await _loadJson('assets/data/content_blocks.json');
    final map = raw is Map
        ? Map<String, dynamic>.from(raw)
        : <String, dynamic>{'contentBlocks': raw};
    _contentBlocks = ContentBlocksCatalog.fromJson(map);
    return _contentBlocks!;
  }

  Future<List<ServiceType>> loadServiceTypes() async {
    if (_serviceTypes != null) return _serviceTypes!;
    final raw = await _loadJson('assets/data/service_types.json');
    _serviceTypes = _asList(raw)
        .map((e) => ServiceType.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    return _serviceTypes!;
  }

  Future<List<SiteExample>> loadSiteExamples() async {
    if (_siteExamples != null) return _siteExamples!;
    final raw = await _loadJson('assets/data/site_examples.json');
    _siteExamples = _asList(raw)
        .map((e) => SiteExample.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    return _siteExamples!;
  }

  Future<Map<String, dynamic>> loadConsultationOptions() async {
    if (_consultationOptions != null) return _consultationOptions!;
    final raw = await _loadJson('assets/data/consultation_options.json');
    _consultationOptions = Map<String, dynamic>.from(raw as Map);
    return _consultationOptions!;
  }

  Future<Map<String, dynamic>> loadUtilizationMethods() async {
    if (_utilizationMethods != null) return _utilizationMethods!;
    final raw = await _loadJson('assets/data/utilization_methods.json');
    _utilizationMethods = raw is Map
        ? Map<String, dynamic>.from(raw)
        : <String, dynamic>{'items': raw};
    return _utilizationMethods!;
  }

  Future<Map<String, dynamic>> loadPreparationMaterials() async {
    if (_preparationMaterials != null) return _preparationMaterials!;
    final raw = await _loadJson('assets/data/preparation_materials.json');
    _preparationMaterials = Map<String, dynamic>.from(raw as Map);
    return _preparationMaterials!;
  }

  /// 테스트·핫리로드용 캐시 초기화.
  void clearCache() {
    _packages = null;
    _industries = null;
    _faqs = null;
    _processSteps = null;
    _contentBlocks = null;
    _serviceTypes = null;
    _siteExamples = null;
    _consultationOptions = null;
    _utilizationMethods = null;
    _preparationMaterials = null;
  }

  Future<dynamic> _loadJson(String assetPath) async {
    final text = await _bundle.loadString(assetPath);
    return json.decode(text);
  }

  List<dynamic> _asList(dynamic raw) {
    if (raw is List) return raw;
    if (raw is Map) {
      for (final key in const [
        'items',
        'packages',
        'industries',
        'faqs',
        'steps',
        'serviceTypes',
        'examples',
      ]) {
        final v = raw[key];
        if (v is List) return v;
      }
      // 단일 키에 배열이 있으면 사용
      if (raw.length == 1 && raw.values.first is List) {
        return raw.values.first as List<dynamic>;
      }
    }
    return const [];
  }
}
