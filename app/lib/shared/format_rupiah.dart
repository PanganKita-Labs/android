/// Formats a whole-rupiah [amount] as a display string.
///
/// Returns text prefixed with `Rp` and periods between thousands, such as
/// `Rp32.000`. It does not convert currencies or round fractional values.
String formatRupiah(int amount) {
  final grouped = amount.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => '.',
  );
  return 'Rp$grouped';
}
