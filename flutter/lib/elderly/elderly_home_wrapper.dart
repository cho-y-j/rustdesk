// Elderly-Friendly Home Page Wrapper
// This wraps the original RustDesk home page with elderly-friendly enhancements

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'elderly_ui_theme.dart';

/// A wrapper widget that adds elderly-friendly features to the home page
/// while preserving all original RustDesk functionality
class ElderlyHomeWrapper extends StatefulWidget {
  final Widget child;
  final String currentId;
  final bool isServiceRunning;
  final VoidCallback? onHelpRequested;

  const ElderlyHomeWrapper({
    Key? key,
    required this.child,
    required this.currentId,
    required this.isServiceRunning,
    this.onHelpRequested,
  }) : super(key: key);

  @override
  State<ElderlyHomeWrapper> createState() => _ElderlyHomeWrapperState();
}

class _ElderlyHomeWrapperState extends State<ElderlyHomeWrapper> {
  bool _showSimplifiedView = true;

  @override
  Widget build(BuildContext context) {
    if (!_showSimplifiedView) {
      // Show original RustDesk UI with a toggle button
      return Stack(
        children: [
          widget.child,
          Positioned(
            top: 16,
            right: 16,
            child: _buildViewToggle(),
          ),
        ],
      );
    }

    // Show simplified elderly-friendly view
    return Scaffold(
      backgroundColor: ElderlyTheme.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            SingleChildScrollView(
              padding: const EdgeInsets.all(ElderlyTheme.paddingLarge),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildStatusCard(),
                  const SizedBox(height: 24),
                  _buildIdCard(),
                  const SizedBox(height: 32),
                  _buildHelpButton(),
                  const SizedBox(height: 24),
                  _buildInstructions(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            // Toggle to advanced view
            Positioned(
              top: 16,
              right: 16,
              child: _buildViewToggle(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewToggle() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _showSimplifiedView = !_showSimplifiedView;
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _showSimplifiedView ? Icons.settings : Icons.home,
                size: 20,
                color: ElderlyTheme.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                _showSimplifiedView ? '고급' : '간편',
                style: TextStyle(
                  fontSize: 14,
                  color: ElderlyTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [ElderlyTheme.primaryColor, ElderlyTheme.primaryDark],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: ElderlyTheme.primaryColor.withOpacity(0.4),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: const Icon(
            Icons.support_agent,
            size: 56,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          ElderlyKoreanStrings.get('app_name'),
          style: const TextStyle(
            fontSize: ElderlyTheme.fontSizeTitle,
            fontWeight: FontWeight.bold,
            color: ElderlyTheme.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
    final isRunning = widget.isServiceRunning;
    final statusColor = isRunning ? ElderlyTheme.accentColor : ElderlyTheme.warningColor;
    final statusText = isRunning
        ? ElderlyKoreanStrings.get('connection_ready')
        : ElderlyKoreanStrings.get('connection_waiting');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ElderlyTheme.borderRadiusLarge),
        border: Border.all(color: statusColor, width: 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: statusColor.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            statusText,
            style: TextStyle(
              fontSize: ElderlyTheme.fontSizeLarge,
              fontWeight: FontWeight.w600,
              color: statusColor.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdCard() {
    final id = widget.currentId;
    final displayId = _formatId(id);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(ElderlyTheme.paddingLarge),
      decoration: BoxDecoration(
        color: ElderlyTheme.cardBackground,
        borderRadius: BorderRadius.circular(ElderlyTheme.borderRadiusLarge),
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
          Text(
            ElderlyKoreanStrings.get('my_code'),
            style: const TextStyle(
              fontSize: ElderlyTheme.fontSizeMedium,
              color: ElderlyTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          // ID display with copy button
          GestureDetector(
            onTap: () => _copyId(id),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              decoration: BoxDecoration(
                color: ElderlyTheme.background,
                borderRadius: BorderRadius.circular(ElderlyTheme.borderRadiusMedium),
                border: Border.all(
                  color: ElderlyTheme.borderColor,
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    id.isEmpty ? '로딩 중...' : displayId,
                    style: const TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.bold,
                      color: ElderlyTheme.textPrimary,
                      letterSpacing: 6,
                      fontFamily: 'monospace',
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ElderlyTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.copy_rounded,
                      color: ElderlyTheme.primaryColor,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            ElderlyKoreanStrings.get('code_explanation'),
            style: const TextStyle(
              fontSize: ElderlyTheme.fontSizeSmall,
              color: ElderlyTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatId(String id) {
    if (id.length <= 3) return id;
    final buffer = StringBuffer();
    for (int i = 0; i < id.length; i++) {
      if (i > 0 && i % 3 == 0) buffer.write(' ');
      buffer.write(id[i]);
    }
    return buffer.toString();
  }

  void _copyId(String id) {
    if (id.isEmpty) return;
    Clipboard.setData(ClipboardData(text: id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ElderlyKoreanStrings.get('code_copied'),
          style: const TextStyle(fontSize: ElderlyTheme.fontSizeMedium),
        ),
        backgroundColor: ElderlyTheme.primaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildHelpButton() {
    final isEnabled = widget.isServiceRunning && widget.currentId.isNotEmpty;

    return SizedBox(
      width: double.infinity,
      height: ElderlyTheme.buttonHeightLarge,
      child: ElevatedButton(
        onPressed: isEnabled ? _showHelpDialog : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: ElderlyTheme.primaryColor,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ElderlyTheme.borderRadiusMedium),
          ),
          elevation: isEnabled ? 6 : 0,
          shadowColor: ElderlyTheme.primaryColor.withOpacity(0.4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.phone_in_talk_rounded,
              size: 36,
              color: isEnabled ? Colors.white : Colors.grey.shade500,
            ),
            const SizedBox(width: 16),
            Text(
              ElderlyKoreanStrings.get('request_help'),
              style: TextStyle(
                fontSize: ElderlyTheme.fontSizeLarge,
                fontWeight: FontWeight.bold,
                color: isEnabled ? Colors.white : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelpDialog() {
    final id = widget.currentId;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ElderlyTheme.borderRadiusLarge),
        ),
        title: const Text(
          '도움을 요청하시겠습니까?',
          style: TextStyle(
            fontSize: ElderlyTheme.fontSizeLarge,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '도우미에게 아래 코드를 알려주시면\n컴퓨터 화면을 보며 도움을 받을 수 있습니다.',
              style: TextStyle(
                fontSize: ElderlyTheme.fontSizeMedium,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ElderlyTheme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(ElderlyTheme.borderRadiusMedium),
                border: Border.all(
                  color: ElderlyTheme.primaryColor,
                  width: 2,
                ),
              ),
              child: Text(
                '코드: ${_formatId(id)}',
                style: const TextStyle(
                  fontSize: ElderlyTheme.fontSizeXLarge,
                  fontWeight: FontWeight.bold,
                  color: ElderlyTheme.primaryColor,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              '취소',
              style: TextStyle(
                fontSize: ElderlyTheme.fontSizeMedium,
                color: ElderlyTheme.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              _copyId(id);
              Navigator.pop(context);
              widget.onHelpRequested?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ElderlyTheme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text(
              '코드 복사하기',
              style: TextStyle(
                fontSize: ElderlyTheme.fontSizeMedium,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(ElderlyTheme.paddingMedium),
      decoration: BoxDecoration(
        color: ElderlyTheme.primaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(ElderlyTheme.borderRadiusMedium),
        border: Border.all(
          color: ElderlyTheme.primaryColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: ElderlyTheme.primaryColor,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            ElderlyKoreanStrings.get('how_to_use'),
            style: const TextStyle(
              fontSize: ElderlyTheme.fontSizeMedium,
              fontWeight: FontWeight.bold,
              color: ElderlyTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${ElderlyKoreanStrings.get('step1')}\n'
            '${ElderlyKoreanStrings.get('step2')}\n'
            '${ElderlyKoreanStrings.get('step3')}',
            style: const TextStyle(
              fontSize: ElderlyTheme.fontSizeSmall,
              color: ElderlyTheme.textSecondary,
              height: 1.8,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
