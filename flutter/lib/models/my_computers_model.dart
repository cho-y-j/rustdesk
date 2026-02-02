import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_hbb/models/peer_model.dart';
import 'package:flutter_hbb/models/platform_model.dart';
import '../common.dart';

/// 내 컴퓨터 모델 - 백엔드 API와 통신하여 등록된 컴퓨터 목록 관리
class MyComputersModel with ChangeNotifier {
  final RxList<MyComputer> computers = RxList<MyComputer>();
  final RxBool loading = false.obs;
  final RxString error = ''.obs;

  // 백엔드 서버 URL (설정에서 가져오거나 하드코딩)
  String get backendUrl {
    final url = bind.mainGetLocalOption(key: 'my-computers-backend-url');
    return url.isNotEmpty ? url : 'http://localhost:8081';
  }

  // 저장된 토큰
  String get authToken {
    return bind.mainGetLocalOption(key: 'my-computers-auth-token');
  }

  set authToken(String token) {
    bind.mainSetLocalOption(key: 'my-computers-auth-token', value: token);
  }

  /// 컴퓨터 목록 로드
  Future<void> loadComputers() async {
    if (authToken.isEmpty) {
      error.value = '로그인이 필요합니다';
      return;
    }

    loading.value = true;
    error.value = '';

    try {
      final response = await http.get(
        Uri.parse('$backendUrl/api/v1/my-computers'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        computers.value = data.map((e) => MyComputer.fromJson(e)).toList();
      } else if (response.statusCode == 401) {
        error.value = '인증이 만료되었습니다';
        authToken = '';
      } else {
        error.value = '데이터를 불러오지 못했습니다';
      }
    } catch (e) {
      error.value = '서버에 연결할 수 없습니다';
      debugPrint('MyComputersModel.loadComputers error: $e');
    } finally {
      loading.value = false;
      notifyListeners();
    }
  }

  /// 새 컴퓨터 등록
  Future<bool> registerComputer({
    required String rustdeskId,
    String? alias,
    String? platform,
    String? permanentPassword,
  }) async {
    if (authToken.isEmpty) return false;

    try {
      final response = await http.post(
        Uri.parse('$backendUrl/api/v1/my-computers'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'rustdeskId': rustdeskId,
          'alias': alias,
          'platform': platform,
          'permanentPassword': permanentPassword,
        }),
      );

      if (response.statusCode == 200) {
        await loadComputers();
        return true;
      }
    } catch (e) {
      debugPrint('MyComputersModel.registerComputer error: $e');
    }
    return false;
  }

  /// 컴퓨터 정보 수정
  Future<bool> updateComputer(String id, {String? alias, String? note}) async {
    if (authToken.isEmpty) return false;

    try {
      final response = await http.put(
        Uri.parse('$backendUrl/api/v1/my-computers/$id'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          if (alias != null) 'alias': alias,
          if (note != null) 'note': note,
        }),
      );

      if (response.statusCode == 200) {
        await loadComputers();
        return true;
      }
    } catch (e) {
      debugPrint('MyComputersModel.updateComputer error: $e');
    }
    return false;
  }

  /// 컴퓨터 삭제
  Future<bool> removeComputer(String id) async {
    if (authToken.isEmpty) return false;

    try {
      final response = await http.delete(
        Uri.parse('$backendUrl/api/v1/my-computers/$id'),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 204) {
        computers.removeWhere((c) => c.id == id);
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint('MyComputersModel.removeComputer error: $e');
    }
    return false;
  }

  /// 연결 기록
  Future<void> recordConnection(String id) async {
    if (authToken.isEmpty) return;

    try {
      await http.post(
        Uri.parse('$backendUrl/api/v1/my-computers/$id/connect'),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );
    } catch (e) {
      debugPrint('MyComputersModel.recordConnection error: $e');
    }
  }

  /// 로그인
  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$backendUrl/api/v1/auth/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        authToken = data['accessToken'];
        await loadComputers();
        return true;
      }
    } catch (e) {
      debugPrint('MyComputersModel.login error: $e');
    }
    return false;
  }

  /// 로그아웃
  void logout() {
    authToken = '';
    computers.clear();
    notifyListeners();
  }

  /// Peer 객체로 변환 (기존 연결 로직과 호환)
  List<Peer> toPeers() {
    return computers.map((c) => c.toPeer()).toList();
  }

  /// 로그인 여부
  bool get isLoggedIn => authToken.isNotEmpty;
}

/// 내 컴퓨터 데이터 모델
class MyComputer {
  final String id;
  final String rustdeskId;
  final String? alias;
  final String trustLevel;
  final bool requireApproval;
  final String? platform;
  final String? hostname;
  final String? note;
  final bool isOnline;
  final bool hasPassword;
  final int connectionCount;
  final DateTime? lastConnectedAt;
  final DateTime? createdAt;

  MyComputer({
    required this.id,
    required this.rustdeskId,
    this.alias,
    required this.trustLevel,
    required this.requireApproval,
    this.platform,
    this.hostname,
    this.note,
    required this.isOnline,
    required this.hasPassword,
    required this.connectionCount,
    this.lastConnectedAt,
    this.createdAt,
  });

  factory MyComputer.fromJson(Map<String, dynamic> json) {
    return MyComputer(
      id: json['id'],
      rustdeskId: json['rustdeskId'],
      alias: json['alias'],
      trustLevel: json['trustLevel'] ?? 'FULL_ACCESS',
      requireApproval: json['requireApproval'] ?? false,
      platform: json['platform'],
      hostname: json['hostname'],
      note: json['note'],
      isOnline: json['isOnline'] ?? false,
      hasPassword: json['hasPassword'] ?? false,
      connectionCount: json['connectionCount'] ?? 0,
      lastConnectedAt: json['lastConnectedAt'] != null
          ? DateTime.parse(json['lastConnectedAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
    );
  }

  /// 표시 이름 (별칭 우선, 없으면 RustDesk ID)
  String get displayName => alias?.isNotEmpty == true ? alias! : rustdeskId;

  /// Peer 객체로 변환
  Peer toPeer() {
    return Peer.fromJson({
      'id': rustdeskId,
      'alias': alias ?? '',
      'platform': platform ?? '',
      'hostname': hostname ?? '',
      'online': isOnline,
      'tags': [],
    });
  }
}
