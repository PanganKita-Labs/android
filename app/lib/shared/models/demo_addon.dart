/// Reference add-ons; neither availability nor merchant pricing is verified.
enum DemoAddon {
  /// Reference seasoning option.
  chili('Chili powder', 7000),

  /// Reference cheese option.
  cheese('Keju ekstra', 10000),

  /// Reference sauce option.
  garlic('Saus garlic', 5000);

  /// Creates one example add-on with [label] and whole-rupiah [priceRupiah].
  ///
  /// Enum values are fixed fixtures, not real merchant menu options.
  new(this.label, this.priceRupiah);

  /// Display label from the supplied reference.
  final String label;

  /// Illustrative whole-rupiah price per item.
  final int priceRupiah;
}
