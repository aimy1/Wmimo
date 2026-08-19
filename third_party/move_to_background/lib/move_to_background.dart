import 'dart:async';
import 'package:flutter/services.dart';

class MoveToBackground {
  static const MethodChannel _channel = MethodChannel('move_to_background');

  static Future<bool?> moveTaskToBack() async {
    return await _channel.invokeMethod<bool>('moveTaskToBack');
  }
}
