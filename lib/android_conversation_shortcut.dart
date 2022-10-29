import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

class AndroidConversationShortcut {
  static const MethodChannel _channel =
      MethodChannel('android_conversation_shortcut');

  static Future<String?> createConversationShortcut(Person person,
      [bool rounded = true]) async {
    if (person.key == null || person.name == null) {
      throw ArgumentError.notNull('Person key and name must not be null');
    }
    try {
      Uint8List? _iconBytes = person.icon?.data as Uint8List?;

      String fileName = '${person.key}.png';

      final directory = await getApplicationDocumentsDirectory();
      String filePath = '${directory.path}/$fileName';

      File file = File(filePath);
      if (_iconBytes != null) {
        file.writeAsBytesSync(_iconBytes);
      }

      final String? shortcutID =
          await _channel.invokeMethod('createConversationShortcut', {
        'personName': person.name,
        'personKey': person.key,
        'personIcon': file.path,
        'personBot': person.bot,
        'personImportant': person.important,
        'personUri': person.uri,
        'roundedIcon': rounded
      });
      return shortcutID;
    } on PlatformException catch (_) {
      return null;
    }
  }
}
