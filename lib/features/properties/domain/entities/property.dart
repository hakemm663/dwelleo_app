import 'package:equatable/equatable.dart';

/// A media object as returned by the API: `{id, path, path_thumbnail, mime_type}`.
/// `path`/`thumbnail` are absolute S3 URLs.
class MediaImage extends Equatable {
  final int id;
  final String path;
  final String? thumbnail;
  final String? mimeType;

  const MediaImage({
    required this.id,
    required this.path,
    this.thumbnail,
    this.mimeType,
  });

  /// Best URL for a small/list context, falling back to the full path.
  String get displayThumb => thumbnail?.isNotEmpty == true ? thumbnail! : path;

  @override
  List<Object?> get props => [id, path, thumbnail, mimeType];
}

/// `listing_type`: `{key, label}` — key is stable (`for-sale`/`for-rent`),
/// label is localized by `Accept-Language`.
class ListingType extends Equatable {
  final String key;
  final String label;

  const ListingType({required this.key, required this.label});

  bool get isForSale => key == 'for-sale';
  bool get isForRent => key == 'for-rent';

  @override
  List<Object?> get props => [key, label];
}

/// A localized reference object (property_type, region, city, area).
/// `name`/`title` come pre-resolved for the requested locale.
class NamedRef extends Equatable {
  final int id;
  final String name;

  const NamedRef({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

/// The listing owner (developer / broker / agent / individual_broker).
class PropertyOwner extends Equatable {
  final int id;
  final String name;
  final String? phone;
  final String? userType;
  final bool verified;
  final MediaImage? image;

  const PropertyOwner({
    required this.id,
    required this.name,
    this.phone,
    this.userType,
    this.verified = false,
    this.image,
  });

  @override
  List<Object?> get props => [id, name, phone, userType, verified, image];
}

class Amenity extends Equatable {
  final int id;
  final String title;
  final MediaImage? icon;

  const Amenity({required this.id, required this.title, this.icon});

  @override
  List<Object?> get props => [id, title, icon];
}

class PropertyTag extends Equatable {
  final int id;
  final String title;
  final String? color;

  const PropertyTag({required this.id, required this.title, this.color});

  @override
  List<Object?> get props => [id, title, color];
}

class GeoPoint extends Equatable {
  final double? lat;
  final double? lng;

  const GeoPoint({this.lat, this.lng});

  bool get isValid => lat != null && lng != null;

  @override
  List<Object?> get props => [lat, lng];
}

class PropertyLocation extends Equatable {
  final String? address;
  final GeoPoint? point;
  final String? adLicenseNumber;
  final String? direction;
  final String? buildingYear;

  const PropertyLocation({
    this.address,
    this.point,
    this.adLicenseNumber,
    this.direction,
    this.buildingYear,
  });

  @override
  List<Object?> get props => [
    address,
    point,
    adLicenseNumber,
    direction,
    buildingYear,
  ];
}

/// Core domain entity for a Dwelleo property listing.
/// Fields mirror the verified real API schema (see docs/api/REAL_API_SPEC.md).
class Property extends Equatable {
  final int id;
  final String slug;
  final String title;
  final String? description;
  final num? price;

  final ListingType? listingType;
  final NamedRef? propertyType;

  final int? bedrooms;
  final int? bathrooms;
  final num? areaSqm;
  final int? floorNumber;
  final int? maidRoom;
  final int? driverRoom;

  final String? furnishingStatus;
  final String? availabilityStatus;
  final String? landType;

  final bool isFeatured;
  final bool isFavorite;
  final bool isBoosted;

  final MediaImage? coverImage;
  final List<MediaImage> images;

  final NamedRef? region;
  final NamedRef? city;
  final NamedRef? area;

  final PropertyOwner? owner;
  final PropertyLocation? location;

  final List<Amenity> amenities;
  final List<PropertyTag> tags;

  final String? handoverDate;

  const Property({
    required this.id,
    required this.slug,
    required this.title,
    this.description,
    this.price,
    this.listingType,
    this.propertyType,
    this.bedrooms,
    this.bathrooms,
    this.areaSqm,
    this.floorNumber,
    this.maidRoom,
    this.driverRoom,
    this.furnishingStatus,
    this.availabilityStatus,
    this.landType,
    this.isFeatured = false,
    this.isFavorite = false,
    this.isBoosted = false,
    this.coverImage,
    this.images = const [],
    this.region,
    this.city,
    this.area,
    this.owner,
    this.location,
    this.amenities = const [],
    this.tags = const [],
    this.handoverDate,
  });

  String? get cityName => city?.name ?? region?.name;
  bool get hasMaidRoom => (maidRoom ?? 0) > 0;
  bool get hasDriverRoom => (driverRoom ?? 0) > 0;

  @override
  List<Object?> get props => [
    id,
    slug,
    title,
    description,
    price,
    listingType,
    propertyType,
    bedrooms,
    bathrooms,
    areaSqm,
    floorNumber,
    maidRoom,
    driverRoom,
    furnishingStatus,
    availabilityStatus,
    landType,
    isFeatured,
    isFavorite,
    isBoosted,
    coverImage,
    images,
    region,
    city,
    area,
    owner,
    location,
    amenities,
    tags,
    handoverDate,
  ];
}
