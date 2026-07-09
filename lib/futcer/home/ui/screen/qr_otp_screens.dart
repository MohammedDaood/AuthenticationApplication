import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:auth_app/core/theming/colors.dart';

class QrOtpScreen extends StatefulWidget {
  const QrOtpScreen({super.key});

  @override
  State<QrOtpScreen> createState() => _QrOtpScreenState();
}

class _QrOtpScreenState extends State<QrOtpScreen> with SingleTickerProviderStateMixin {
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
      autoStart: false,
    );

    _animationController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0,
      end: 220,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.linear));

    _controller.start().then((_) {
      if (mounted) setState(() => _isReady = true);
    });
  }

  Future<void> _handleBarcode(BarcodeCapture capture) async {
    if (_isProcessing || !_isReady) return;
    if (capture.barcodes.isEmpty) return;

    final Barcode barcode = capture.barcodes.first;
    final String? rawValue = barcode.rawValue;

    if (rawValue == null || rawValue.isEmpty) return;

    final String code = _extractSecret(rawValue);
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('رمز QR غير صالح، جرّب مرة أخرى')));
      return;
    }

    _isProcessing = true;
    try {
      await _controller.stop();
      _animationController.stop();

      if (!mounted) return;

      Navigator.of(context).pop(code);
    } catch (e) {
      debugPrint('Scanner Error: $e');
      _isProcessing = false;
    }
  }

  String _extractSecret(String rawValue) {
    final uri = Uri.tryParse(rawValue);
    if (uri != null && uri.scheme == 'otpauth') {
      return uri.queryParameters['secret'] ?? '';
    }
    return rawValue;
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
      Positioned(top: 0, left: 0, child: _corner(color, size, thickness, top: true, left: true)),
      Positioned(top: 0, right: 0, child: _corner(color, size, thickness, top: true, left: false)),
      Positioned(bottom: 0, left: 0, child: _corner(color, size, thickness, top: false, left: true)),
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
