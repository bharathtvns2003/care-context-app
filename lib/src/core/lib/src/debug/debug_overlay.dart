import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../api/utils/token_manager.dart';

import 'api_log_store.dart';
import 'api_logs_screen.dart';

class DebugOverlay extends StatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState>? navigatorKey;

  const DebugOverlay({super.key, required this.child, this.navigatorKey});

  @override
  State<DebugOverlay> createState() => _DebugOverlayState();
}

class _DebugOverlayState extends State<DebugOverlay> {
  bool _menuOpen = false;
  int _logCount = 0;

  @override
  void initState() {
    super.initState();
    ApiLogStore.instance.addListener(_onLogsChanged);
  }

  @override
  void dispose() {
    ApiLogStore.instance.removeListener(_onLogsChanged);
    super.dispose();
  }

  void _onLogsChanged() {
    if (mounted) {
      setState(() {
        _logCount = ApiLogStore.instance.logs.length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return widget.child;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          widget.child,
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Center(
              child: _DebugBanner(
                logCount: _logCount,
                onTap: () => setState(() => _menuOpen = !_menuOpen),
              ),
            ),
          ),
          if (_menuOpen)
            Positioned(
              left: 28,
              top: 0,
              bottom: 0,
              child: Center(
                child: _DebugMenu(
                  onClose: () => setState(() => _menuOpen = false),
                  onApiLogs: () {
                    setState(() => _menuOpen = false);
                    _navigator.push(
                      MaterialPageRoute(builder: (_) => const ApiLogsScreen()),
                    );
                  },
                  onLogout: () {
                    setState(() => _menuOpen = false);
                    _handleLogout();
                  },
                  onRestart: () {
                    setState(() => _menuOpen = false);
                    _handleRestart();
                  },
                  onClearLogs: () {
                    ApiLogStore.instance.clear();
                    setState(() => _menuOpen = false);
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }

  NavigatorState get _navigator => widget.navigatorKey!.currentState!;

  void _handleLogout() async {
    await TokenManager.instance.clearAllOnLogout();
    _navigator.pushNamedAndRemoveUntil('/login/phone', (_) => false);
  }

  void _handleRestart() {
    _navigator.pushNamedAndRemoveUntil('/', (_) => false);
  }
}

class _DebugBanner extends StatelessWidget {
  final int logCount;
  final VoidCallback onTap;

  const _DebugBanner({required this.logCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: const Color(0xCC0AB5A8),
          borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(2, 0),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.bug_report, color: Colors.white, size: 16),
            if (logCount > 0) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  logCount > 99 ? '99+' : '$logCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DebugMenu extends StatelessWidget {
  final VoidCallback onClose;
  final VoidCallback onApiLogs;
  final VoidCallback onLogout;
  final VoidCallback onRestart;
  final VoidCallback onClearLogs;

  const _DebugMenu({
    required this.onClose,
    required this.onApiLogs,
    required this.onLogout,
    required this.onRestart,
    required this.onClearLogs,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 180,
        decoration: BoxDecoration(
          color: const Color(0xF016213E),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const Divider(color: Colors.white12, height: 1),
            _menuItem(Icons.list_alt, 'API Logs', onApiLogs),
            _menuItem(Icons.delete_sweep, 'Clear Logs', onClearLogs),
            const Divider(color: Colors.white12, height: 1),
            _menuItem(Icons.logout, 'Logout', onLogout, color: Colors.orangeAccent),
            _menuItem(Icons.refresh, 'Restart App', onRestart),
            const Divider(color: Colors.white12, height: 1),
            _menuItem(Icons.close, 'Close Menu', onClose, color: Colors.white38),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF0F3460),
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: const Row(
        children: [
          Icon(Icons.developer_mode, color: Colors.tealAccent, size: 16),
          SizedBox(width: 8),
          Text(
            'Debug Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, VoidCallback onTap, {Color? color}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: color ?? Colors.white70, size: 16),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: color ?? Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
