import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sp_frontend/components/custom_scackbar.dart';

import 'dart:io';

import 'package:sp_frontend/group/group_provider.dart';
import 'package:sp_frontend/theme/colors.dart';
import 'package:sp_frontend/user/user_provider.dart';

class JoinGroupScreen extends StatefulWidget {
  const JoinGroupScreen({super.key});

  @override
  State<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Map<String, dynamic>? result;
  QRViewController? controller;
  bool _isJoining = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  void _join(BuildContext context) async {
    final group = context.read<GroupProvider>();
    final user = context.read<UserProvider>();

    setState(() {
      _isJoining = true;
    });

    final response = await group.joinGroup(result!['id']);

    // Reload user if no error
    if (response == null) {
      await user.reload();
    }

    if (!mounted) return;

    // Pop if no error
    if (response == null) {
      Navigator.pop(context, response);
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(customSnackBar(context, response));
    setState(() {
      _isJoining = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // QR View
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          // Result
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? _isJoining
                      ? const SpinKitPulse(
                          color: Palette.alpha,
                          size: 50.0,
                        )
                      : Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(width: 10),
                              Text(
                                result!['name'],
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(),
                              ),
                              const SizedBox(width: 10),
                              TextButton(
                                  onPressed: () => _join(context),
                                  child: const Text('Join'))
                            ],
                          ))
                  : const Text('Scan a Joining code'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        try {
          final details = jsonDecode(scanData.code!);
          // Validate
          if (details['name'] == null ||
              details['id'] == null ||
              details['name'].runtimeType != String ||
              details['id'].runtimeType != String) return;

          result = details;
        } catch (e) {
          // Invalid QR code
          if (kDebugMode) print(e);
        }
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
