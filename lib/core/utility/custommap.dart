import 'package:flutter/foundation.dart';

class CustomMap {
  final Map<String, dynamic> data;

  CustomMap(this.data);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CustomMap && mapEquals(other.data, data);
  }

  @override
  int get hashCode => data.hashCode;
}