import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/shared/demo_notice.dart';

const _otpLength = 4;
const _digitGap = 12.0;
// An empty native input produces no edit event on backspace. This invisible
// placeholder makes deletion observable for both software and hardware keys.
const _emptyDigit = '\u200b';

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
    _otpLength,
    (_) => TextEditingController(text: _emptyDigit),
  );
  final List<FocusNode> _focus = List.generate(_otpLength, (_) => FocusNode());
  final List<String> _values = List.filled(_otpLength, '');
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
    if (_values.join() != '5102') {
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
      digit.text = _emptyDigit;
    }
    _values.fillRange(0, _otpLength, '');
    setState(() => _error = null);
    _focusDigit(0);
    DemoNotice.show(
      context,
      'Kode demo masih 5102. Tidak ada SMS atau email yang dikirim.',
    );
  }

  void _changeDigit(int index, String value) {
    final wasEmpty = _values[index].isEmpty;
    final digits = value.replaceAll(_emptyDigit, '').split('');
    final startIndex = digits.length >= _otpLength ? 0 : index;
    if (digits.isEmpty) {
      _values[index] = '';
      _digits[index].value = const TextEditingValue(
        text: _emptyDigit,
        selection: TextSelection.collapsed(offset: 1),
      );
      if (wasEmpty && index > 0) _focusDigit(index - 1);
    }
    for (
      var offset = 0;
      offset < digits.length && startIndex + offset < _otpLength;
      offset++
    ) {
      _values[startIndex + offset] = digits[offset];
      _digits[startIndex + offset].text = digits[offset];
    }
    if (digits.isNotEmpty) {
      _focusDigit((startIndex + digits.length).clamp(0, _otpLength - 1));
    }
    if (_error != null) setState(() => _error = null);
  }

  void _focusDigit(int index) {
    _focus[index].requestFocus();
    _selectDigit(index);
  }

  void _selectDigit(int index) {
    final text = _digits[index].text;
    _digits[index].selection = TextSelection(
      baseOffset: text == _emptyDigit ? text.length : 0,
      extentOffset: text.length,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(29, 16, 29, 28),
        children: [
          const _OtpHeader(),
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
                      FilteringTextInputFormatter.allow(
                        RegExp('[0-9$_emptyDigit]'),
                      ),
                      LengthLimitingTextInputFormatter(_otpLength + 1),
                    ],
                    autofillHints: const [AutofillHints.oneTimeCode],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: PanganKitaTheme.bodyFontFamily,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                      labelText: 'Digit ${index + 1}',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                    onChanged: (value) => _changeDigit(index, value),
                    onTap: () => _selectDigit(index),
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

class _OtpHeader extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Align(alignment: Alignment.centerLeft, child: BackButton()),
      SizedBox(height: 23),
      Text(
        'Verifikasi Kode OTP',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontFamily: PanganKitaTheme.emphasisFontFamily,
          fontSize: 32,
          fontWeight: FontWeight.w700,
        ),
      ),
      Text(
        'Daftar dan nikmati makanan lezat\ndengan harga lebih hemat.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 19.5),
      ),
      SizedBox(height: 30),
    ],
  );
}
