import 'package:flutter/material.dart';
import 'package:flutter_hbb/models/my_computers_model.dart';
import 'package:get/get.dart';
import '../../common.dart';

/// 내 컴퓨터 탭 위젯
class MyComputersView extends StatefulWidget {
  final EdgeInsets? menuPadding;

  const MyComputersView({Key? key, this.menuPadding}) : super(key: key);

  @override
  State<MyComputersView> createState() => _MyComputersViewState();
}

class _MyComputersViewState extends State<MyComputersView> {
  final MyComputersModel _model = MyComputersModel();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _aliasController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (_model.isLoggedIn) {
      _model.loadComputers();
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _aliasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!_model.isLoggedIn) {
        return _buildLoginPrompt();
      }

      if (_model.loading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_model.error.value.isNotEmpty) {
        return _buildError();
      }

      if (_model.computers.isEmpty) {
        return _buildEmpty();
      }

      return _buildComputersList();
    });
  }

  /// 로그인 필요 화면
  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.computer, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            '내 컴퓨터',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text('로그인하여 등록된 컴퓨터를 관리하세요'),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showLoginDialog,
            icon: const Icon(Icons.login),
            label: const Text('로그인'),
          ),
        ],
      ),
    );
  }

  /// 에러 화면
  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(_model.error.value),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _model.loadComputers(),
            icon: const Icon(Icons.refresh),
            label: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  /// 비어있는 화면
  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.computer, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('등록된 컴퓨터가 없습니다'),
          const SizedBox(height: 8),
          const Text('아래 버튼을 눌러 컴퓨터를 등록하세요'),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _showAddComputerDialog,
            icon: const Icon(Icons.add),
            label: const Text('컴퓨터 등록'),
          ),
        ],
      ),
    );
  }

  /// 컴퓨터 목록
  Widget _buildComputersList() {
    return Column(
      children: [
        _buildToolbar(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _model.loadComputers(),
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 1.2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _model.computers.length,
              itemBuilder: (context, index) {
                final computer = _model.computers[index];
                return _buildComputerCard(computer);
              },
            ),
          ),
        ),
      ],
    );
  }

  /// 툴바
  Widget _buildToolbar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Text(
            '내 컴퓨터 (${_model.computers.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '컴퓨터 등록',
            onPressed: _showAddComputerDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '새로고침',
            onPressed: () => _model.loadComputers(),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'logout') {
                _model.logout();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text('로그아웃'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 컴퓨터 카드
  Widget _buildComputerCard(MyComputer computer) {
    return Card(
      child: InkWell(
        onTap: () => _connectToComputer(computer),
        onLongPress: () => _showComputerMenu(computer),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Icon(
                    _getPlatformIcon(computer.platform),
                    size: 48,
                    color: computer.isOnline ? Colors.green : Colors.grey,
                  ),
                  if (computer.isOnline)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                computer.displayName,
                style: Theme.of(context).textTheme.titleSmall,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                computer.rustdeskId,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              if (computer.hasPassword)
                const Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Icon(Icons.lock, size: 14, color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 플랫폼 아이콘
  IconData _getPlatformIcon(String? platform) {
    switch (platform?.toUpperCase()) {
      case 'WINDOWS':
        return Icons.desktop_windows;
      case 'MACOS':
        return Icons.laptop_mac;
      case 'LINUX':
        return Icons.computer;
      case 'ANDROID':
        return Icons.phone_android;
      case 'IOS':
        return Icons.phone_iphone;
      default:
        return Icons.computer;
    }
  }

  /// 컴퓨터에 연결
  void _connectToComputer(MyComputer computer) {
    _model.recordConnection(computer.id);
    connect(context, computer.rustdeskId);
  }

  /// 컴퓨터 메뉴
  void _showComputerMenu(MyComputer computer) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.link),
              title: const Text('연결'),
              onTap: () {
                Navigator.pop(context);
                _connectToComputer(computer);
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('이름 변경'),
              onTap: () {
                Navigator.pop(context);
                _showEditAliasDialog(computer);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('삭제', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(computer);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 로그인 다이얼로그
  void _showLoginDialog() {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('로그인'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: '이메일',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: '비밀번호',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await _model.login(
                emailController.text,
                passwordController.text,
              );
              if (context.mounted) {
                Navigator.pop(context);
                if (!success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('로그인 실패')),
                  );
                }
              }
            },
            child: const Text('로그인'),
          ),
        ],
      ),
    );
  }

  /// 컴퓨터 등록 다이얼로그
  void _showAddComputerDialog() {
    _idController.clear();
    _aliasController.clear();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('컴퓨터 등록'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'RustDesk ID',
                hintText: '예: 123456789',
                prefixIcon: Icon(Icons.computer),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _aliasController,
              decoration: const InputDecoration(
                labelText: '별칭 (선택)',
                hintText: '예: 집 PC',
                prefixIcon: Icon(Icons.label),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_idController.text.isEmpty) return;

              final success = await _model.registerComputer(
                rustdeskId: _idController.text,
                alias: _aliasController.text.isNotEmpty
                    ? _aliasController.text
                    : null,
              );

              if (context.mounted) {
                Navigator.pop(context);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('컴퓨터가 등록되었습니다')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('등록 실패')),
                  );
                }
              }
            },
            child: const Text('등록'),
          ),
        ],
      ),
    );
  }

  /// 별칭 수정 다이얼로그
  void _showEditAliasDialog(MyComputer computer) {
    final controller = TextEditingController(text: computer.alias);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('이름 변경'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: '별칭',
            prefixIcon: Icon(Icons.label),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _model.updateComputer(computer.id, alias: controller.text);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }

  /// 삭제 확인
  void _confirmDelete(MyComputer computer) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('컴퓨터 삭제'),
        content: Text('${computer.displayName}을(를) 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              await _model.removeComputer(computer.id);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }
}
