// Simplified Home Page for Elderly Users
// This replaces the default RustDesk home page with a minimal, easy-to-use interface

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hbb/common.dart';
import 'package:flutter_hbb/models/platform_model.dart';
import 'package:flutter_hbb/models/server_model.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class SimpleHomePage extends StatefulWidget {
  const SimpleHomePage({Key? key}) : super(key: key);

  @override
  State<SimpleHomePage> createState() => _SimpleHomePageState();
}

class _SimpleHomePageState extends State<SimpleHomePage> {
  var _id = '';
  var _isServiceRunning = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateStatus();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateStatus());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateStatus() {
    final id = bind.mainGetMyId();
    final isRunning = gFFI.serverModel.isStart;
    if (mounted) {
      setState(() {
        _id = id;
        _isServiceRunning = isRunning;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: gFFI.serverModel,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  _buildLogo(),
                  const SizedBox(height: 48),

                  // Status indicator
                  _buildStatusIndicator(),
                  const SizedBox(height: 32),

                  // ID Display
                  _buildIdCard(),
                  const SizedBox(height: 48),

                  // Help Request Button
                  _buildHelpButton(),
                  const SizedBox(height: 24),

                  // Instructions
                  _buildInstructions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: const Color(0xFF4A90D9),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4A90D9).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(
            Icons.support_agent,
            size: 56,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          '원격도우미',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3748),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: _isServiceRunning ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: _isServiceRunning ? Colors.green : Colors.orange,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: _isServiceRunning ? Colors.green : Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            _isServiceRunning ? '연결 준비됨' : '연결 대기 중...',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: _isServiceRunning ? Colors.green.shade700 : Colors.orange.shade700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '내 연결 코드',
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF718096),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              if (_id.isNotEmpty) {
                Clipboard.setData(ClipboardData(text: _id));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('코드가 복사되었습니다', style: TextStyle(fontSize: 18)),
                    backgroundColor: Color(0xFF4A90D9),
                  ),
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFE2E8F0),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _id.isEmpty ? '로딩 중...' : _formatId(_id),
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3748),
                      letterSpacing: 4,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.copy,
                    color: Color(0xFF4A90D9),
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            '이 코드를 도우미에게 알려주세요',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF718096),
            ),
          ),
        ],
      ),
    );
  }

  String _formatId(String id) {
    // Format ID with spaces for readability (e.g., "123 456 789")
    if (id.length <= 3) return id;
    final buffer = StringBuffer();
    for (int i = 0; i < id.length; i++) {
      if (i > 0 && i % 3 == 0) buffer.write(' ');
      buffer.write(id[i]);
    }
    return buffer.toString();
  }

  Widget _buildHelpButton() {
    return SizedBox(
      width: double.infinity,
      height: 72,
      child: ElevatedButton(
        onPressed: _isServiceRunning ? _requestHelp : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A90D9),
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.phone_in_talk,
              size: 32,
              color: _isServiceRunning ? Colors.white : Colors.grey.shade500,
            ),
            const SizedBox(width: 16),
            Text(
              '도움 요청하기',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: _isServiceRunning ? Colors.white : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _requestHelp() {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Text(
          '도움을 요청하시겠습니까?',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '도우미에게 연결 코드를 알려주시면\n컴퓨터 화면을 보며 도움을 받을 수 있습니다.',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '코드: ${_formatId(_id)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A90D9),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '취소',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('코드가 복사되었습니다!', style: TextStyle(fontSize: 18)),
                  backgroundColor: Color(0xFF4A90D9),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A90D9),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              '코드 복사하기',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        children: const [
          Icon(Icons.info_outline, color: Color(0xFF4A90D9), size: 28),
          SizedBox(height: 12),
          Text(
            '사용 방법',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '1. 위의 연결 코드를 도우미에게 알려주세요\n'
            '2. 도우미가 연결하면 확인 창이 나타납니다\n'
            '3. "허용"을 누르면 도움을 받을 수 있습니다',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF4A5568),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
