import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../utils/cc_error_handler.dart';


class ErrorSheetsShowcaseScreen extends StatelessWidget {
  const ErrorSheetsShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error BottomSheets Showcase'),
        backgroundColor: const Color(0xFF0D1F2D),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFF7FBFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Interactive Error Sheets',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A2B35),
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tap any button below to preview the corresponding error bottom sheet in action.',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF7A96A4),
              ),
            ),
            const SizedBox(height: 24),

            _buildShowcaseTile(
              context: context,
              title: '1. API Failure (404 / Bad Request)',
              subtitle: 'Triggered when API requests fail with status 400-499 or missing endpoints.',
              icon: Icons.cloud_off_rounded,
              color: const Color(0xFFE11D48),
              onTap: () {
                CcErrorHandler.showApiFailure(
                  context: context,
                  title: 'Prescription Fetch Failed',
                  message: 'The requested medical document could not be retrieved from the server. (HTTP 404)',
                  errorCode: 'HTTP_404_NOT_FOUND',
                  technicalDetails: 'GET /api/v1/prescriptions/9999\nStatus Code: 404\nBody: {"error": "Prescription ID not found"}',
                  onRetry: () => _showSnackBar(context, 'Retrying API call...'),
                );
              },
            ),

            _buildShowcaseTile(
              context: context,
              title: '2. Page / Connection Timeout',
              subtitle: 'Triggered when a page or server response takes longer than allowed threshold.',
              icon: Icons.timer_off_outlined,
              color: const Color(0xFFF59E0B),
              onTap: () {
                CcErrorHandler.showTimeout(
                  context: context,
                  title: 'Page Loading Timed Out',
                  message: 'The connection to our health data gateway timed out. Please check your signal strength.',
                  errorCode: 'GATEWAY_TIMEOUT_504',
                  technicalDetails: 'DioException: connectionTimeout [30000ms]\nURL: https://api.carecontext.in/v1/user/details',
                  onRetry: () => _showSnackBar(context, 'Retrying connection...'),
                );
              },
            ),

            _buildShowcaseTile(
              context: context,
              title: '3. Server Side Issue (500 Internal Error)',
              subtitle: 'Triggered when internal server errors or database failures occur (5xx).',
              icon: Icons.dns_rounded,
              color: const Color(0xFFDC2626),
              onTap: () {
                CcErrorHandler.showServerError(
                  context: context,
                  title: 'Server Under Maintenance',
                  message: 'Our backend system is currently undergoing scheduled maintenance or experiencing internal issues. Please try again shortly.',
                  errorCode: 'HTTP_500_INTERNAL_SERVER_ERROR',
                  technicalDetails: 'HTTP 500 Internal Server Error\nTrace ID: req-88f29c41-2a90\nService: MedicineScheduleMicroservice',
                  onRetry: () => _showSnackBar(context, 'Checking server status...'),
                );
              },
            ),

            _buildShowcaseTile(
              context: context,
              title: '4. Network Offline / No Connection',
              subtitle: 'Triggered when device loses connection to Wi-Fi or mobile data.',
              icon: Icons.wifi_off_rounded,
              color: const Color(0xFF6366F1),
              onTap: () {
                CcErrorHandler.showNoInternet(
                  context: context,
                  title: 'You Are Offline',
                  message: 'Internet connection is unavailable. Please check your mobile network or Wi-Fi settings.',
                  errorCode: 'NET_OFFLINE',
                  technicalDetails: 'SocketException: Failed host lookup: api.carecontext.in (OS Error: No address associated with hostname)',
                  onRetry: () => _showSnackBar(context, 'Testing network connectivity...'),
                );
              },
            ),

            _buildShowcaseTile(
              context: context,
              title: '5. Session Expired (401 Unauthorized)',
              subtitle: 'Triggered when JWT token expires or session becomes invalid.',
              icon: Icons.lock_clock_outlined,
              color: const Color(0xFF8B5CF6),
              onTap: () {
                CcErrorHandler.showUnauthorized(
                  context: context,
                  title: 'Security Session Expired',
                  message: 'Your authentication token has expired. Please log in again to securely access your health portal.',
                  errorCode: 'AUTH_401_UNAUTHORIZED',
                  technicalDetails: 'HTTP 401 Unauthorized\nHeader: Bearer eyJhbGci...\nReason: Token expired at 1718901234',
                  onLogIn: () => _showSnackBar(context, 'Redirecting to login...'),
                );
              },
            ),

            _buildShowcaseTile(
              context: context,
              title: '6. Dynamic DioException Auto-Parser',
              subtitle: 'Simulates automatic parsing of a DioException object into bottomSheet.',
              icon: Icons.auto_mode_rounded,
              color: const Color(0xFF0AB5A8),
              onTap: () {
                final dioErr = DioException(
                  requestOptions: RequestOptions(path: '/api/v1/appointments/book', method: 'POST'),
                  response: Response(
                    requestOptions: RequestOptions(path: '/api/v1/appointments/book'),
                    statusCode: 503,
                    data: {'message': 'Service temporarily unavailable due to capacity overflow.'},
                  ),
                  type: DioExceptionType.badResponse,
                );

                CcErrorHandler.showErrorBottomSheet(
                  dioErr,
                  context: context,
                  onRetry: () => _showSnackBar(context, 'Retrying booking request...'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShowcaseTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE4EEF2)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A2B35),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF3D5566),
              height: 1.3,
            ),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Color(0xFF7A96A4)),
        onTap: onTap,
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF0AB5A8),
      ),
    );
  }
}
