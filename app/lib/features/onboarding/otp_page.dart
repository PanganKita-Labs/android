import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/shared/demo_notice.dart';

const _otpLength = 4;
const _digitGap = 12.0;

/// Four-digit local demo verification; no email or SMS is sent.
class OtpPage extends StatefulWidget {
  /// Creates verification for registration or recovery.
  const new({this.recovery = false, super.key});

  /// Whether verification continues to password replacement.
  final bool recovery;

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _digits = List.generate(
    4,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focus = List.generate(4, (_) => FocusNode());
  String? _error;

  @override
  void dispose() {
    for (final digit in _digits) {
      digit.dispose();
    }
    for (final node in _focus) {
      node.dispose();
    }
    super.dispose();
  }

  void _verify() {
    if (_digits.map((digit) => digit.text).join() != '5102') {
      setState(() => _error = 'Kode demo tidak cocok. Gunakan 5102.');
      return;
    }
    Navigator.pushNamed<void>(
      context,
      widget.recovery ? AppRoutes.password : AppRoutes.home,
    ).ignore();
  }

  void _resend() {
    for (final digit in _digits) {
      digit.clear();
    }
    setState(() => _error = null);
    _focus.first.requestFocus();
    DemoNotice.show(
      context,
      'Kode demo masih 5102. Tidak ada SMS atau email yang dikirim.',
    );
  }

  void _changeDigit(int index, String value) {
    final digits = value.split('');
    for (
      var offset = 0;
      offset < digits.length && index + offset < _otpLength;
      offset++
    ) {
      _digits[index + offset].text = digits[offset];
    }
    if (value.isNotEmpty) {
      _focus[(index + value.length).clamp(0, _otpLength - 1)].requestFocus();
    }
    if (_error != null) setState(() => _error = null);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(29, 16, 29, 28),
        children: [
          const Align(alignment: Alignment.centerLeft, child: BackButton()),
          const SizedBox(height: 23),
          const Text(
            'Verifikasi Kode OTP',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
          ),
          const Text(
            'Daftar dan nikmati makanan lezat\ndengan harga lebih hemat.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 19.5),
          ),
          const SizedBox(height: 30),
          Row(
            spacing: _digitGap,
            children: [
              for (var index = 0; index < _digits.length; index++)
                Expanded(
                  child: TextField(
                    controller: _digits[index],
                    focusNode: _focus[index],
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(_otpLength),
                    ],
                    autofillHints: const [AutofillHints.oneTimeCode],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                      labelText: 'Digit ${index + 1}',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                    onChanged: (value) => _changeDigit(index, value),
                  ),
                ),
            ],
          ),
          if (_error case final String error)
            Text(
              error,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          const SizedBox(height: 26),
          FilledButton(onPressed: _verify, child: const Text('Verifikasi')),
          const SizedBox(height: 12),
          const Text(
            'Mode demo: gunakan kode 5102.\nTidak ada email atau SMS '
            'yang dikirim.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: Colors.blueGrey),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text('Belum menerima kode?'),
              TextButton(onPressed: _resend, child: const Text('Kirim Ulang')),
            ],
          ),
        ],
      ),
    ),
  );
}
