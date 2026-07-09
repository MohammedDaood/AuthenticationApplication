import 'package:auth_app/core/helper/extensions.dart';
import 'package:auth_app/core/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:auth_app/core/theming/colors.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> with SingleTickerProviderStateMixin {
  late final MobileScannerController _controller;
  late AnimationController _animationController;
  late Animation<double> _animation;

  bool _isProcessing = false;
  bool _isReady = false;

  @override
  void initState() {
    super.initState();

    _controller = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      torchEnabled: false,
    );

    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0,
      end: 220,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.linear));

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isReady = true);
    });
  }

  bool _isBase64UrlSafe(String value) {
    final base64UrlRegex = RegExp(r'^[A-Za-z0-9\-_]+=*$');
    return base64UrlRegex.hasMatch(value);
  }

  Future<void> _handleBarcode(BarcodeCapture capture) async {
    if (_isProcessing || !_isReady) return;

    final Barcode barcode = capture.barcodes.first;
    final String? code = barcode.rawValue;

    if (code == null || code.isEmpty) return;

    if (!_isBase64UrlSafe(code)) {
      return;
    }

    _isProcessing = true;
    try {
      await _controller.stop();
      _animationController.stop();

      if (!mounted) return;

      context.pushReplacementNamed(Routes.usernamePasswordScreen, arguments: code);
    } catch (e) {
      debugPrint('Scanner Error: $e');
      _isProcessing = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.myBlack,
      appBar: AppBar(
        backgroundColor: ColorsManager.myBlack,
        iconTheme: const IconThemeData(color: ColorsManager.myWhite),
        title: const Text("مسح رمز QR", style: TextStyle(color: ColorsManager.myWhite)),
        actions: [
          IconButton(icon: const Icon(Icons.flash_on), onPressed: () => _controller.toggleTorch()),
          IconButton(icon: const Icon(Icons.flip_camera_ios), onPressed: () => _controller.switchCamera()),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(controller: _controller, onDetect: _handleBarcode, fit: BoxFit.cover),

          ColorFiltered(
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.55), BlendMode.srcOut),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(color: Colors.black, backgroundBlendMode: BlendMode.dstOut),
                ),
                Center(
                  child: Container(
                    width: 260,
                    height: 260,
                    decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: SizedBox(
              width: 260,
              height: 260,
              child: Stack(
                children: [
                  ..._buildCorners(),

                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Positioned(
                        top: _animation.value,
                        left: 10,
                        right: 10,
                        child: Container(
                          height: 2.5,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.transparent, ColorsManager.myBlue, Colors.transparent],
                            ),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  _isReady ? "ضع رمز QR داخل الإطار" : "جارٍ تجهيز الكاميرا...",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: ColorsManager.myWhite, fontSize: 16, fontWeight: FontWeight.w500),
                ),
                if (!_isReady) ...[
                  const SizedBox(height: 10),
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(color: ColorsManager.myBlue, strokeWidth: 2.5),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCorners() {
    const color = ColorsManager.myBlue;
    const size = 24.0;
    const thickness = 3.5;

    return [
      // أعلى يسار
      Positioned(top: 0, left: 0, child: _corner(color, size, thickness, top: true, left: true)),
      // أعلى يمين
      Positioned(top: 0, right: 0, child: _corner(color, size, thickness, top: true, left: false)),
      // أسفل يسار
      Positioned(bottom: 0, left: 0, child: _corner(color, size, thickness, top: false, left: true)),
      // أسفل يمين
      Positioned(bottom: 0, right: 0, child: _corner(color, size, thickness, top: false, left: false)),
    ];
  }

  Widget _corner(Color color, double size, double thickness, {required bool top, required bool left}) {
    return CustomPaint(
      size: Size(size, size),
      painter: _CornerPainter(color: color, thickness: thickness, top: top, left: left),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final bool top;
  final bool left;

  _CornerPainter({required this.color, required this.thickness, required this.top, required this.left});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();

    if (top && left) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else if (top && !left) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (!top && left) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      path.moveTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CornerPainter old) => false;
}
