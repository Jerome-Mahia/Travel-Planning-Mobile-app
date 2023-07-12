// To parse this JSON data, do
//
//     final mapBoxSuggest = mapBoxSuggestFromJson(jsonString);

import 'dart:convert';


MapBoxSuggest mapBoxSuggestFromJson(String str) =>
    MapBoxSuggest.fromJson(json.decode(str));

String mapBoxSuggestToJson(MapBoxSuggest data) => json.encode(data.toJson());

class MapBoxSuggest {
  List<Suggestion> suggestions;
  String attribution;
  String url;

  MapBoxSuggest({
    required this.suggestions,
    required this.attribution,
    required this.url,
  });

  factory MapBoxSuggest.fromJson(Map<String, dynamic> json) => MapBoxSuggest(
        suggestions: List<Suggestion>.from(
            json["suggestions"].map((x) => Suggestion.fromJson(x))),
        attribution: json["attribution"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "suggestions": List<dynamic>.from(suggestions.map((x) => x.toJson())),
        "attribution": attribution,
        "url": url,
      };
}

class Suggestion {
  String name;
  String mapboxId;
  String featureType;
  String placeFormatted;
  Context context;
  String language;
  String maki;
  ExternalIds externalIds;
  ExternalIds metadata;

  Suggestion({
    required this.name,
    required this.mapboxId,
    required this.featureType,
    required this.placeFormatted,
    required this.context,
    required this.language,
    required this.maki,
    required this.externalIds,
    required this.metadata,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) => Suggestion(
        name: json["name"],
        mapboxId: json["mapbox_id"],
        featureType: json["feature_type"],
        placeFormatted: json["place_formatted"],
        context: Context.fromJson(json["context"]),
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

class ExternalIds {
  ExternalIds();

  factory ExternalIds.fromJson(Map<String, dynamic> json) => ExternalIds();

  Map<String, dynamic> toJson() => {};
}


