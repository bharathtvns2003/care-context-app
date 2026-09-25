import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../styles/cc_border_radiuses.dart';
import '../../styles/cc_colors.dart';
import '../../styles/cc_text_styles.dart';

import 'cc_error_model.dart';
import 'cc_error_type.dart';


class CcErrorBottomSheet extends StatefulWidget {
  final CcErrorModel errorModel;

  const CcErrorBottomSheet({
    super.key,
    required this.errorModel,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required CcErrorModel errorModel,
    bool isDismissible = true,
    Color? barrierColor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: barrierColor ?? Colors.black54,
      builder: (ctx) => PopScope(
        canPop: isDismissible,
        child: CcErrorBottomSheet(errorModel: errorModel),
      ),
    );
  }

  @override
  State<CcErrorBottomSheet> createState() => _CcErrorBottomSheetState();
}

class _CcErrorBottomSheetState extends State<CcErrorBottomSheet> {
  bool _showDetails = false;
  bool _copied = false;

  @override
  Widget build(BuildContext context) {
    final model = widget.errorModel;
    final type = model.type;
    final accentColor = type.accentColor;

    return Container(
      decoration: const BoxDecoration(
        color: CcColors.surface,
        borderRadius: CCBorderRadiuses.vertical(
          top: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: CcColors.shadowStrong,
            blurRadius: 24,
            offset: Offset(0, -8),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: CcColors.gray200,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header Row with optional close button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 32), // spacer for balance
              Expanded(
                child: Center(
                  child: _buildErrorIconBadge(type, accentColor),
                ),
              ),
              if (model.showCloseButton)
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close_rounded,
                    color: CcColors.textTertiary,
                    size: 22,
                  ),
                  tooltip: 'Close',
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                )
              else
                const SizedBox(width: 32),
            ],
          ),
          const SizedBox(height: 16),

          // Error Code Pill (if present)
          if (model.errorCode != null && model.errorCode!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    model.errorCode!.toUpperCase(),
                    style: CCTextStyle.captionSmall.style.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          // Title
          Text(
            model.title,
            textAlign: TextAlign.center,
            style: CCTextStyle.headingMedium.style.copyWith(
              color: CcColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),

          // Message
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              model.message,
              textAlign: TextAlign.center,
              style: CCTextStyle.bodyMedium.style.copyWith(
                color: CcColors.textSecondary,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Technical Details Toggle (Accordion)
          if (model.technicalDetails != null &&
              model.technicalDetails!.isNotEmpty) ...[
            _buildTechnicalDetailsSection(accentColor),
            const SizedBox(height: 20),
          ],

          // Action Buttons
          Row(
            children: [
              if (model.secondaryButtonText != null &&
                  model.secondaryButtonText!.isNotEmpty) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      model.onSecondaryPressed?.call();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: CcColors.border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      model.secondaryButtonText!,
                      style: CCTextStyle.buttonMedium.style.copyWith(
                        color: CcColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              if (model.primaryButtonText != null &&
                  model.primaryButtonText!.isNotEmpty)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      model.onPrimaryPressed?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shadowColor: accentColor.withValues(alpha: 0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      model.primaryButtonText!,
                      style: CCTextStyle.buttonMedium.style.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorIconBadge(CcErrorType type, Color accentColor) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: type.backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.15),
            blurRadius: 16,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: CcColors.surface,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.12),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            type.icon,
            color: accentColor,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildTechnicalDetailsSection(Color accentColor) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _showDetails = !_showDetails;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: CcColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: CcColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.bug_report_outlined,
                  size: 16,
                  color: CcColors.textTertiary,
                ),
                const SizedBox(width: 6),
                Text(
                  _showDetails ? 'Hide Technical Details' : 'View Technical Details',
                  style: CCTextStyle.captionLarge.style.copyWith(
                    color: CcColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  _showDetails
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 18,
                  color: CcColors.textTertiary,
                ),
              ],
            ),
          ),
        ),
        if (_showDetails) ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxHeight: 140),

            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B), // Dark slate blue
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: SelectableText(
                    widget.errorModel.technicalDetails!,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Color(0xFFE2E8F0),
                      height: 1.4,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(text: widget.errorModel.technicalDetails!),
                      );
                      setState(() => _copied = true);
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) setState(() => _copied = false);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _copied ? Icons.check_rounded : Icons.copy_rounded,
                            size: 12,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _copied ? 'Copied' : 'Copy',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
