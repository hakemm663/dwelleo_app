import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/api_result.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/property_query.dart';
import '../../domain/usecases/get_properties.dart';
import 'properties_state.dart';

class PropertiesCubit extends Cubit<PropertiesState> {
  final GetProperties _getProperties;

  PropertiesCubit(this._getProperties) : super(const PropertiesInitial());

  // null = curated home set (no filters); preserved across refresh cycles.
  PropertyQuery? _query;
  PropertyQuery? get query => _query;

  Future<void> load({PropertyQuery? query}) async {
    _query = query;
    emit(const PropertiesLoading());
    final result = await _getProperties(query: _query);
    result.when(
      success: (data) => emit(PropertiesLoaded(data)),
      error: (failure) => emit(PropertiesError(_message(failure))),
    );
  }

  Future<void> refresh() => load(query: _query);

  String _message(Failure failure) => switch (failure) {
    NetworkFailure() => 'No internet connection.',
    UnauthorizedFailure() => 'Please log in to continue.',
    NotFoundFailure() => 'No properties found.',
    ServerFailure() => 'Server error. Please try again later.',
    _ => 'Something went wrong. Please try again.',
  };
}
