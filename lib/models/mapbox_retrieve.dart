// To parse this JSON data, do
//
//     final mapBoxRetrieve = mapBoxRetrieveFromJson(jsonString);

import 'dart:convert';

MapBoxRetrieve mapBoxRetrieveFromJson(String str) => MapBoxRetrieve.fromJson(json.decode(str));

String mapBoxRetrieveToJson(MapBoxRetrieve data) => json.encode(data.toJson());

class MapBoxRetrieve {
    String type;
    List<Feature> features;
    String attribution;
    String url;

    MapBoxRetrieve({
        required this.type,
        required this.features,
        required this.attribution,
        required this.url,
    });

    factory MapBoxRetrieve.fromJson(Map<String, dynamic> json) => MapBoxRetrieve(
        type: json["type"],
        features: List<Feature>.from(json["features"].map((x) => Feature.fromJson(x))),
        attribution: json["attribution"],
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "features": List<dynamic>.from(features.map((x) => x.toJson())),
        "attribution": attribution,
        "url": url,
    };
}

class Feature {
    String type;
    Geometry geometry;
    Properties properties;

    Feature({
        required this.type,
        required this.geometry,
        required this.properties,
    });

    factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        type: json["type"],
        geometry: Geometry.fromJson(json["geometry"]),
        properties: Properties.fromJson(json["properties"]),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "geometry": geometry.toJson(),
        "properties": properties.toJson(),
    };
}

class Geometry {
    List<double> coordinates;
    String type;

    Geometry({
        required this.coordinates,
        required this.type,
    });

    factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        coordinates: List<double>.from(json["coordinates"].map((x) => x?.toDouble())),
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
        "type": type,
    };
}

class Properties {
    String name;
    String mapboxId;
    String featureType;
    String placeFormatted;
    Context context;
    Coordinates coordinates;
    List<double> bbox;
    String language;
    String maki;
    ExternalIds externalIds;
    ExternalIds metadata;

    Properties({
        required this.name,
        required this.mapboxId,
        required this.featureType,
        required this.placeFormatted,
        required this.context,
        required this.coordinates,
        required this.bbox,
        required this.language,
        required this.maki,
        required this.externalIds,
        required this.metadata,
    });

    factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        name: json["name"],
        mapboxId: json["mapbox_id"],
        featureType: json["feature_type"],
        placeFormatted: json["place_formatted"],
        context: Context.fromJson(json["context"]),
        coordinates: Coordinates.fromJson(json["coordinates"]),
        bbox: List<double>.from(json["bbox"].map((x) => x?.toDouble())),
        language: json["language"],
        maki: json["maki"],
        externalIds: ExternalIds.fromJson(json["external_ids"]),
        metadata: ExternalIds.fromJson(json["metadata"]),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "mapbox_id": mapboxId,
        "feature_type": featureType,
        "place_formatted": placeFormatted,
        "context": context.toJson(),
        "coordinates": coordinates.toJson(),
        "bbox": List<dynamic>.from(bbox.map((x) => x)),
        "language": language,
        "maki": maki,
        "external_ids": externalIds.toJson(),
        "metadata": metadata.toJson(),
    };
}

class Context {
    Country country;

    Context({
        required this.country,
    });

    factory Context.fromJson(Map<String, dynamic> json) => Context(
        country: Country.fromJson(json["country"]),
    );

    Map<String, dynamic> toJson() => {
        "country": country.toJson(),
    };
}

class Country {
    String id;
    String name;
    String countryCode;
    String countryCodeAlpha3;

    Country({
        required this.id,
        required this.name,
        required this.countryCode,
        required this.countryCodeAlpha3,
    });

    factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        name: json["name"],
        countryCode: json["country_code"],
        countryCodeAlpha3: json["country_code_alpha_3"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "country_code": countryCode,
        "country_code_alpha_3": countryCodeAlpha3,
    };
}

class Coordinates {
    double latitude;
    double longitude;

    Coordinates({
        required this.latitude,
        required this.longitude,
    });

    factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
    };
}

class ExternalIds {
    ExternalIds();

    factory ExternalIds.fromJson(Map<String, dynamic> json) => ExternalIds(
    );

    Map<String, dynamic> toJson() => {
    };
}
