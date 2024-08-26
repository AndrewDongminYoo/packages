// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: avoid_classes_with_only_static_members
/// 소모품 저장소입니다.
///
/// 이것은 공유 환경설정에 소모품을 저장하는 개발 프로토타입입니다.
/// 실제 앱에서는 사용하지 마세요.
class ConsumableStore {
  static const String _kPrefKey = 'consumables';
  static Future<void> _writes = Future<void>.value();

  /// ID가 `id`인 소모품을 스토어에 추가합니다.
  ///
  /// 소모품은 반환된 퓨처가 완료된 후에만 추가됩니다.
  static Future<void> save(String id) {
    _writes = _writes.then((void _) => _doSave(id));
    return _writes;
  }

  /// 상점에서 ID가 `id`인 소모품을 소비합니다.
  ///
  /// 소모품은 반환된 미래가 완료된 후에만 소모됩니다.
  static Future<void> consume(String id) {
    _writes = _writes.then((void _) => _doConsume(id));
    return _writes;
  }

  /// 스토어에서 소모품 목록을 반환합니다.
  static Future<List<String>> load() async {
    return (await SharedPreferences.getInstance()).getStringList(_kPrefKey) ??
        <String>[];
  }

  static Future<void> _doSave(String id) async {
    final List<String> cached = await load();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.add(id);
    await prefs.setStringList(_kPrefKey, cached);
  }

  static Future<void> _doConsume(String id) async {
    final List<String> cached = await load();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    cached.remove(id);
    await prefs.setStringList(_kPrefKey, cached);
  }
}
