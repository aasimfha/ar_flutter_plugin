import 'package:ar_flutter_plugin/datatypes/anchor_types.dart';
// ignore: unused_import
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:ar_flutter_plugin/utils/json_converters.dart';
// ignore: unnecessary_import
import 'package:vector_math/vector_math_64.dart';
import 'package:flutter/widgets.dart';

/// Object attached to a tracked physical entity of the AR environment (can be initialized with a world transformation)
abstract class ARAnchor {
  ARAnchor({
    required this.type,
    required this.transformation,
    String? name,
  }) : name = name ?? UniqueKey().toString();

  /// Specifies the [AnchorType] of this [ARAnchor]
  final AnchorType type;

  /// Determines the name of the [ARAnchor]
  /// Will be autogenerated if not defined.
  final String name;

  /// Constructs an [ARAnchor] from a serialized anchor object
  factory ARAnchor.fromJson(Map<String, dynamic> arguments) {
    final type = arguments['type'];
    switch (type) {
      case 0: //(= AnchorType.plane)
        return ARPlaneAnchor.fromJson(arguments);
    }
    return ARUnkownAnchor.fromJson(arguments);
  }

  /// Defines the anchor’s rotation, translation and scale in world coordinates.
  final Matrix4 transformation;

  /// Serializes an [ARAnchor]
  Map<String, dynamic> toJson();
}

/// An [ARAnchor] fixed to a tracked plane
class ARPlaneAnchor extends ARAnchor {
  ARPlaneAnchor({
    required Matrix4 transformation,
    String? name,
    List<String>? childNodes,
    String? cloudanchorid,
    int? ttl,
  })  : childNodes = childNodes ?? [],
        // ignore: unnecessary_null_in_if_null_operators
        cloudanchorid = cloudanchorid ?? null,
        ttl = ttl ?? 1,
        super(
            type: AnchorType.plane, transformation: transformation, name: name);

  /// Names of ARNodes attached to this [APlaneRAnchor]
  List<String> childNodes;

  /// ID associated with the anchor after uploading it to the google cloud anchor API
  String? cloudanchorid;

  /// Time to live of the anchor: Determines how long the anchor is stored once it is uploaded to the google cloud anchor API (optional, defaults to 1 day (24hours))
  int? ttl;

  static ARPlaneAnchor fromJson(Map<String, dynamic> json) =>
      aRPlaneAnchorFromJson(json);

  @override
  Map<String, dynamic> toJson() => aRPlaneAnchorToJson(this);
}

/// Constructs an [ARPlaneAnchor] from a serialized PlaneAnchor object
ARPlaneAnchor aRPlaneAnchorFromJson(Map<String, dynamic> json) {
  return ARPlaneAnchor(
    transformation:
        const MatrixConverter().fromJson(json['transformation'] as List),
    name: json['name'] as String,
    childNodes: json['childNodes']
        ?.map((child) => child.toString())
        ?.toList()
        ?.cast<String>(),
    cloudanchorid: json['cloudanchorid'] as String?,
    ttl: json['ttl'] as int?,
  );
}

/// Serializes an [ARPlaneAnchor]
Map<String, dynamic> aRPlaneAnchorToJson(ARPlaneAnchor instance) {
  return <String, dynamic>{
    'type': instance.type.index,
    'transformation': MatrixConverter().toJson(instance.transformation),
    'name': instance.name,
    'childNodes': instance.childNodes,
    'cloudanchorid': instance.cloudanchorid,
    'ttl': instance.ttl,
  };
}

/// An [ARAnchor] type that is not supported yet
class ARUnkownAnchor extends ARAnchor {
  ARUnkownAnchor(
      {required AnchorType type, required Matrix4 transformation, String? name})
      : super(type: type, transformation: transformation, name: name);

  static ARUnkownAnchor fromJson(Map<String, dynamic> json) =>
      aRUnkownAnchorFromJson(json);

  @override
  Map<String, dynamic> toJson() => aRUnkownAnchorToJson(this);
}

ARUnkownAnchor aRUnkownAnchorFromJson(Map<String, dynamic> json) {
  return ARUnkownAnchor(
    type: json['type'],
    transformation:
        const MatrixConverter().fromJson(json['transformation'] as List),
    name: json['name'] as String,
  );
}

Map<String, dynamic> aRUnkownAnchorToJson(ARUnkownAnchor instance) {
  return <String, dynamic>{
    'type': instance.type.index,
    'transformation': MatrixConverter().toJson(instance.transformation),
    'name': instance.name,
  };
}
