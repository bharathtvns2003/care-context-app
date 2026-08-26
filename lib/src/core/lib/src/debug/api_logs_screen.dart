import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'api_log_store.dart';

class ApiLogsScreen extends StatefulWidget {
  const ApiLogsScreen({super.key});

  @override
  State<ApiLogsScreen> createState() => _ApiLogsScreenState();
}

class _ApiLogsScreenState extends State<ApiLogsScreen> {
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
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final logs = ApiLogStore.instance.logs;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: const Text('API Logs', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              ApiLogStore.instance.clear();
            },
          ),
        ],
      ),
      body: logs.isEmpty
          ? const Center(
              child: Text(
                'No API calls logged yet',
                style: TextStyle(color: Colors.white54),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(8),
              itemCount: logs.length,
              separatorBuilder: (_, _) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                final log = logs[index];
                return _ApiLogTile(log: log);
              },
            ),
    );
  }
}

class _ApiLogTile extends StatelessWidget {
  final ApiLogEntry log;

  const _ApiLogTile({required this.log});

  @override
  Widget build(BuildContext context) {
    final statusColor = log.isError
        ? Colors.redAccent
        : (log.statusCode != null && log.statusCode! < 300)
            ? Colors.greenAccent
            : Colors.orangeAccent;

    return Card(
      color: const Color(0xFF16213E),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: _methodColor(log.method).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            log.method,
            style: TextStyle(
              color: _methodColor(log.method),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          Uri.parse(log.url).path.isEmpty ? log.url : Uri.parse(log.url).path,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Row(
          children: [
            Text(
              log.statusCode?.toString() ?? (log.error != null ? 'ERR' : '...'),
              style: TextStyle(color: statusColor, fontSize: 12),
            ),
            if (log.duration != null) ...[
              const SizedBox(width: 8),
              Text(
                '${log.duration!.inMilliseconds}ms',
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
            const Spacer(),
            Text(
              '${log.timestamp.hour.toString().padLeft(2, '0')}:'
              '${log.timestamp.minute.toString().padLeft(2, '0')}:'
              '${log.timestamp.second.toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.white24, fontSize: 11),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.white38, size: 20),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => _ApiLogDetailScreen(log: log)),
          );
        },
      ),
    );
  }

  Color _methodColor(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return Colors.greenAccent;
      case 'POST':
        return Colors.blueAccent;
      case 'PUT':
        return Colors.orangeAccent;
      case 'DELETE':
        return Colors.redAccent;
      default:
        return Colors.white70;
    }
  }
}

class _ApiLogDetailScreen extends StatelessWidget {
  final ApiLogEntry log;

  const _ApiLogDetailScreen({required this.log});

  @override
  Widget build(BuildContext context) {
    final statusColor = log.isError
        ? Colors.redAccent
        : (log.statusCode != null && log.statusCode! < 300)
            ? Colors.greenAccent
            : Colors.orangeAccent;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        title: Text(
          '${log.method} ${Uri.parse(log.url).path}',
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              final full = _formatFullLog(log);
              Clipboard.setData(ClipboardData(text: full));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Full log copied'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('URL', log.url),
            _buildInfoRow('Method', log.method),
            _buildInfoRow('Status', log.statusCode?.toString() ?? 'N/A',
                valueColor: statusColor),
            if (log.duration != null)
              _buildInfoRow('Duration', '${log.duration!.inMilliseconds}ms'),
            _buildInfoRow(
              'Time',
              '${log.timestamp.hour.toString().padLeft(2, '0')}:'
              '${log.timestamp.minute.toString().padLeft(2, '0')}:'
              '${log.timestamp.second.toString().padLeft(2, '0')}',
            ),
            const SizedBox(height: 16),
            if (log.requestHeaders != null)
              _buildSection(context, 'Request Headers', log.requestHeaders),
            if (log.requestBody != null)
              _buildSection(context, 'Request Body', log.requestBody),
            if (log.responseHeaders != null)
              _buildSection(context, 'Response Headers', log.responseHeaders),
            if (log.responseBody != null)
              _buildSection(context, 'Response Body', log.responseBody),
            if (log.error != null)
              _buildSection(context, 'Error', log.error),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white38, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, dynamic data) {
    final content = _formatData(data);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: Colors.white12, height: 24),
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: content));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$title copied'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              child: const Icon(Icons.copy, size: 16, color: Colors.white38),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(8),
          ),
          child: SelectableText(
            content,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  String _formatData(dynamic data) {
    if (data == null) return 'null';
    if (data is String) return data;
    try {
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data.toString();
    }
  }

  String _formatFullLog(ApiLogEntry log) {
    final buffer = StringBuffer();
    buffer.writeln('${log.method} ${log.url}');
    buffer.writeln('Status: ${log.statusCode ?? 'N/A'}');
    if (log.duration != null) buffer.writeln('Duration: ${log.duration!.inMilliseconds}ms');
    if (log.requestHeaders != null) {
      buffer.writeln('\n--- Request Headers ---');
      buffer.writeln(_formatData(log.requestHeaders));
    }
    if (log.requestBody != null) {
      buffer.writeln('\n--- Request Body ---');
      buffer.writeln(_formatData(log.requestBody));
    }
    if (log.responseBody != null) {
      buffer.writeln('\n--- Response Body ---');
      buffer.writeln(_formatData(log.responseBody));
    }
    if (log.error != null) {
      buffer.writeln('\n--- Error ---');
      buffer.writeln(log.error);
    }
    return buffer.toString();
  }
}
