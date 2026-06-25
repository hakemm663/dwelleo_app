import '../../domain/entities/property.dart';

sealed class PropertiesState {
  const PropertiesState();
}

class PropertiesInitial extends PropertiesState {
  const PropertiesInitial();
}

class PropertiesLoading extends PropertiesState {
  const PropertiesLoading();
}

class PropertiesLoaded extends PropertiesState {
  final List<Property> properties;
  const PropertiesLoaded(this.properties);

  bool get isEmpty => properties.isEmpty;
}

class PropertiesError extends PropertiesState {
  final String message;
  const PropertiesError(this.message);
}
