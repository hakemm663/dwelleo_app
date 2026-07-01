import 'package:dio/dio.dart';

import '../constants/api_endpoints.dart';

/// A city option for dropdowns (id + localized name), from /api/v1/lookup.
class CityOption {
  final String id;
  final String name;
  const CityOption({required this.id, required this.name});
}

/// Fetches filter lookups (cities, …) from the real backend and caches them
/// (the list rarely changes within a session).
class LookupService {
  final Dio _dio;
  LookupService(this._dio);

  List<CityOption>? _citiesCache;

  Future<List<CityOption>> cities() async {
    final cached = _citiesCache;
    if (cached != null) return cached;
    final res = await _dio.get<dynamic>(ApiEndpoints.lookup);
    final body = res.data;
    final data = body is Map ? body['data'] : null;
    final raw = data is Map ? data['cities'] : null;
    final list = raw is List
        ? raw
              .whereType<Map>()
              .map(
                (m) => CityOption(
                  id: '${m['id']}',
                  name: (m['name'] ?? m['title'] ?? '').toString(),
                ),
              )
              .where((c) => c.name.isNotEmpty)
              .toList(growable: false)
        : const <CityOption>[];
    _citiesCache = list;
    return list;
  }
}
