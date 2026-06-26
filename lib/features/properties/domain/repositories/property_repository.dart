import '../../../../core/errors/api_result.dart';
import '../entities/property.dart';
import '../entities/property_query.dart';

abstract interface class PropertyRepository {
  /// List/search properties. With no [query], returns the curated home set.
  Future<ApiResult<List<Property>>> getProperties({PropertyQuery? query});

  /// Full detail for a single property by its `slug`.
  Future<ApiResult<Property>> getPropertyBySlug(String slug);
}
