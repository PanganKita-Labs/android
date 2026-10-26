/// Formats whole rupiah without floating-point arithmetic.
String formatRupiah(int amount) {
  final grouped = amount.toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (match) => '.',
  );
  return 'Rp$grouped';
}
