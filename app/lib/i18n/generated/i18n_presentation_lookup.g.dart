// GENERATED CODE - DO NOT MODIFY BY HAND.
// Source: app/lib/i18n/arb/*.arb.

import 'package:pangankita/i18n/generated/app_localizations.dart';

final _patternuiValueDistanceAndTimeUnavailable = RegExp(
  r'^(.+?)\ •\ jarak\ dan\ waktu\ belum\ tersedia$',
);
final _patternuiDemoPickupDeadlineValueValue = RegExp(
  r'^Batas\ pickup\ contoh:\ (.+?)\ ·\ (.+?)$',
);
final _patternuiRemoveValueFromDemoFavorites = RegExp(
  r'^Hapus\ (.+?)\ dari\ favorit\ contoh$',
);
final _patternuiValueSampleFoodItemsFound = RegExp(
  r'^(.+?)\ makanan\ contoh\ ditemukan$',
);
final _patternuiSampleProductPhotoFromValue = RegExp(
  r'^Foto\ produk\ contoh\ dari\ (.+?)$',
);
final _patternuiDemoPickupValueValue = RegExp(
  r'^Pickup\ contoh:\ (.+?)\ ·\ (.+?)$',
);
final _patternuiDemoPickupLocationValue = RegExp(
  r'^Lokasi\ pickup\ contoh:\ (.+?)$',
);
final _patternuiDemoPickupDeadlineValue = RegExp(
  r'^Batas\ pickup\ contoh:\ (.+?)$',
);
final _patternuiDemoPickupValueValue2 = RegExp(
  r'^Pickup\ contoh\ (.+?),\ (.+?)$',
);
final _patternuiGiveValueStars = RegExp(r'^Beri\ rating\ (.+?)\ bintang$');
final _patternuiSubtotalValueItems = RegExp(r'^Subtotal\ \((.+?)\ item\)$');
final _patternuiPickUpAtValueDemo = RegExp(r'^Ambil\ (.+?)\ \(contoh\)$');
final _patternuiContinueWithValue = RegExp(r'^Lanjutkan\ dengan\ (.+?)$');
final _patternuiValuePiecesLeft = RegExp(r'^Tersisa\ (.+?)\ potong$');
final _patternuiValueItemsValue = RegExp(r'^(.+?)\ item\ ·\ (.+?)$');
final _patternuiPickupUntilValue = RegExp(r'^Pickup\ hingga\ (.+?)$');
final _patternuiPickupDeadlineValue = RegExp(r'^Batas\ pickup:\ (.+?)$');
final _patternuiDemoQuantityValue = RegExp(r'^Jumlah\ contoh\ (.+?)$');
final _patternuiValueSampleReviews = RegExp(r'^(.+?)\ ulasan\ contoh$');
final _patternuiQuantityOfValueValue = RegExp(r'^Jumlah\ (.+?):\ (.+?)$');
final _patternuiValuePortionsLeft = RegExp(r'^Tersisa\ (.+?)\ porsi$');
final _patternuiValueBoxesLeft2 = RegExp(r'^Tersisa\ (.+?)\ kotak$');
final _patternuiValueBoxesLeft = RegExp(r'^Sisa\ (.+?)\ kotak$');
final _patternuiValueMinutesLeft = RegExp(r'^(.+?)\ menit\ lagi$');
final _patternuiCategoryValue = RegExp(r'^Kategori:\ (.+?)$');
final _patternuiDecreaseValue = RegExp(r'^Kurangi\ (.+?)$');
final _patternuiIncreaseValue = RegExp(r'^Tambah\ (.+?)$');
final _patternuiSaveValue = RegExp(r'^Hemat\ (.+?)%$');
final _patternuiRemoveValue = RegExp(r'^Hapus\ (.+?)$');
final _patternuiDigitValue = RegExp(r'^Digit\ (.+?)$');

/// Translates display strings without changing their domain identifiers.
String translateI18nPresentation(AppLocalizations? strings, String value) {
  if (strings == null) return value;
  final literal = switch (value) {
    "Contoh pesanan tidak tersedia." => strings.uiExampleOrderUnavailable,
    "Contoh chat toko tidak tersedia." =>
      strings.uiExampleMerchantChatUnavailable,
    "Contoh pengambilan tidak tersedia." => strings.uiExamplePickupUnavailable,
    "Contoh ulasan tidak tersedia." => strings.uiExampleReviewUnavailable,
    "Mandala by Pass, Medan · contoh lokasi" =>
      strings.uiMandalaByPassMedanSampleLocation,
    "Filter" => strings.uiFilter,
    "Jarak belum tersedia" => strings.uiDistanceUnavailable,
    "Belum ketemu makananmu" => strings.uiCanTFindYourFood,
    "Coba kata kunci lain dari contoh makanan yang tersedia." =>
      strings.uiTryAnotherKeywordFromTheAvailableSampleFoods,
    "Ubah Pencarian" => strings.uiEditSearch,
    "Reset Filter" => strings.uiResetFilters,
    "Mungkin Kamu Suka" => strings.uiYouMayAlsoLike,
    "Filter Pencarian" => strings.uiSearchFilters,
    "Reset" => strings.uiReset,
    "Kategori" => strings.uiCategory,
    "Rentang harga (Rp)" => strings.uiPriceRangeRp,
    "Jarak" => strings.uiDistance,
    "Filter jarak belum tersedia pada data contoh." =>
      strings.uiDistanceFilteringIsUnavailableInTheDemoData,
    "Urutkan" => strings.uiSortBy,
    "Hanya toko buka" => strings.uiOpenStoresOnly,
    "Status buka belum tersedia pada data contoh." =>
      strings.uiStoreOpeningStatusIsUnavailableInTheDemoData,
    "Tampilkan Hasil" => strings.uiShowResults,
    "Urutan contoh" => strings.uiExampleSorting,
    "Harga terendah" => strings.uiLowestPrice,
    "FLASH SALE" => strings.uiFLASHSALE,
    "Croissant Favoritmu,\nDiskon Hingga 60%" =>
      strings.uiYourFavoriteCroissantsUpTo60Off,
    "Pesan Sekarang!" => strings.uiOrderNow,
    "Demo offline · Semua penawaran, lokasi, rating, dan stok adalah contoh." =>
      strings.uiOfflineDemoAllOffersLocationsRatingsAndStockAreSampleData,
    "Diurutkan dari jarak pickup terdekat" =>
      strings.uiSortedByNearestPickupDistance,
    "Lihat Semua" => strings.uiViewAll,
    "Tidak ada makanan yang cocok dengan pencarianmu." =>
      strings.uiNoFoodsMatchYourSearch,
    "Mau lihat berdasarkan toko?" => strings.uiWantToBrowseByStore,
    "Jelajahi semua merchant di dekatmu" => strings.uiExploreNearbyMerchants,
    "Pilih Lokasi" => strings.uiChooseLocation,
    "Gunakan lokasi saat ini" => strings.uiUseCurrentLocation,
    "Akses lokasi belum tersedia" => strings.uiLocationAccessIsUnavailable,
    "Lokasi pilihan" => strings.uiSelectedLocation,
    "Pencarian terakhir" => strings.uiRecentSearches,
    "Area contoh tidak ditemukan." => strings.uiSampleAreaNotFound,
    "Area ini hanya contoh tampilan; belum menentukan hasil berdasarkan jarak." =>
      strings.uiThisAreaIsForDisplayOnlyDistanceBasedResultsAreNotAvailable,
    "Gunakan Lokasi Ini" => strings.uiUseThisLocation,
    "Peta ilustrasi - bukan lokasi langsung" =>
      strings.uiIllustrativeMapNotALiveLocation,
    "Produk contoh" => strings.uiSampleProduct,
    "Pilih Tambahan" => strings.uiChooseAddOns,
    "Bikin rasanya makin nikmat! (contoh)" => strings.uiMakeItEvenTastierDemo,
    "Ulasan Pelanggan" => strings.uiCustomerReviews,
    "Pelanggan Demo" => strings.uiDemoCustomer,
    "Ulasan contoh" => strings.uiSampleReview,
    "Ini contoh tampilan ulasan pelanggan. Belum ada ulasan nyata untuk produk demo ini." =>
      strings
          .uiThisIsASampleCustomerReviewThereAreNoRealReviewsForThisDemoProduct,
    "Tambah ke Keranjang (Demo)" => strings.uiAddToCartDemo,
    "Demo offline · Favorit hanya berlaku selama halaman terbuka. Produk, lokasi, tambahan, dan ulasan adalah contoh. Jumlah 1-10 item tidak mengubah stok atau membuat pesanan." =>
      strings
          .uiOfflineDemoFavoritesLastOnlyWhileThisPageIsOpenProductsLocationsAd,
    "Syarat & Ketentuan" => strings.uiTermsConditions,
    "Informasi penggunaan versi contoh PanganKita" =>
      strings.uiInformationAboutUsingThePanganKitaDemo,
    "Kebijakan Privasi" => strings.uiPrivacyPolicy,
    "Kebijakan Privasi belum tersedia" => strings.uiPrivacyPolicyUnavailable,
    "Dokumen resmi belum tersedia dalam contoh aplikasi ini." =>
      strings.uiTheOfficialDocumentIsNotYetAvailableInThisDemo,
    "Kembali ke Pengaturan" => strings.uiBackToSettings,
    "Edit Profil" => strings.uiEditProfile,
    "Ubah Foto" => strings.uiChangePhoto,
    "Keamanan" => strings.uiSecurity,
    "Ubah Password" => strings.uiChangePassword,
    "Simpan Perubahan" => strings.uiSaveChanges,
    "Nama lengkap" => strings.uiFullName,
    "Email" => strings.uiEmail,
    "Nomor telepon" => strings.uiPhoneNumber,
    "Nomor telepon membantu toko menghubungimu." =>
      strings.uiAPhoneNumberHelpsMerchantsContactYou,
    "Profil Saya" => strings.uiMyProfile,
    "Terima kasih sudah ikut menyelamatkan makanan." =>
      strings.uiThankYouForHelpingSaveFood,
    "Favorit Saya" => strings.uiMyFavorites,
    "Simpan yang kamu suka, temukan lagi kapan saja." =>
      strings.uiSaveWhatYouLoveAndFindItAnytime,
    "Favorit contoh. Harga dan ketersediaan belum terhubung." =>
      strings.uiDemoFavoritesPricesAndAvailabilityAreNotConnected,
    "Toko favorit contoh" => strings.uiSampleFavoriteStore,
    "Contoh tampilan · belum ada pesanan selesai." =>
      strings.uiDemoViewNoCompletedOrdersYet,
    "Tidak ada pesanan contoh yang cocok." => strings.uiNoMatchingSampleOrders,
    "Total pembayaran contoh" => strings.uiSamplePaymentTotal,
    "Contoh" => strings.uiDemo,
    "Waktu diambil: Belum tersedia" => strings.uiPickupTimeUnavailable,
    "Lihat Detail" => strings.uiViewDetails,
    "Beri Ulasan" => strings.uiWriteReview,
    "Pesanan" => strings.uiOrders,
    "Makanan favoritmu, siap dinikmati." =>
      strings.uiYourFavoriteFoodReadyToEnjoy,
    "Contoh pesanan aktif" => strings.uiSampleActiveOrders,
    "Contoh tampilan · belum ada pesanan nyata." =>
      strings.uiDemoViewThereAreNoRealOrders,
    "Kode pengambilan" => strings.uiPickupCode,
    "Belum tersedia" => strings.uiUnavailable,
    "Chat Toko" => strings.uiMessageStore,
    "Detail Pesanan" => strings.uiOrderDetails,
    "Bantuan Pesanan" => strings.uiOrderHelp,
    "Ada yang bisa kami bantu?" => strings.uiHowCanWeHelp,
    "Hubungi Customer Service" => strings.uiContactCustomerSupport,
    "ID pesanan belum tersedia" => strings.uiOrderIDUnavailable,
    "Pengambilan" => strings.uiPickup,
    "Pesanan sudah diambil!" => strings.uiOrderPickedUp,
    "Contoh tampilan pengambilan selesai.\nBelum ada pengambilan nyata yang dikonfirmasi." =>
      strings.uiSampleCompletedPickupViewNoRealPickupHasBeenConfirmed,
    "Terima kasih telah memilih makanan surplus." =>
      strings.uiThankYouForChoosingSurplusFood,
    "Kembali ke Beranda" => strings.uiBackToHome,
    "Contoh tampilan · belum ada pesanan dibatalkan." =>
      strings.uiDemoViewNoCanceledOrdersYet,
    "Pesanan yang dibatalkan akan muncul di sini." =>
      strings.uiCanceledOrdersWillAppearHere,
    "Belum ada pembayaran" => strings.uiNoPaymentYet,
    "Alasan pembatalan: Belum tersedia" =>
      strings.uiCancellationReasonUnavailable,
    "Cari Menu Lain" => strings.uiBrowseOtherFood,
    "Belum ada pesanan atau kode yang dibuat." =>
      strings.uiNoOrderOrCodeHasBeenCreated,
    "Informasi pengambilan" => strings.uiPickupInformation,
    "Rincian pembayaran" => strings.uiPaymentDetails,
    "Contoh detail pesanan" => strings.uiSampleOrderDetails,
    "Status pesanan belum tersedia." => strings.uiOrderStatusUnavailable,
    "Bagaimana makananmu?" => strings.uiHowWasYourFood,
    "Ceritakan pengalamanmu" => strings.uiTellUsAboutYourExperience,
    "Tampilkan nama saya" => strings.uiDisplayMyName,
    "Pilihan ini hanya contoh dan tidak disimpan." =>
      strings.uiThisOptionIsADemoAndIsNotSaved,
    "Kirim Ulasan" => strings.uiSubmitReview,
    "Tambah foto (opsional)" => strings.uiAddPhotoOptional,
    "Tambah foto" => strings.uiAddPhoto,
    "Bantuan PanganKita" => strings.uiPanganKitaHelp,
    "Customer Service • contoh" => strings.uiCustomerSupportDemo,
    "Siap diambil • contoh" => strings.uiReadyForPickupDemo,
    "Percakapan contoh" => strings.uiSampleConversation,
    "Chat" => strings.uiChat,
    "Terhubung dengan toko favoritmu." =>
      strings.uiStayConnectedWithYourFavoriteStores,
    "Contoh tampilan · belum ada percakapan nyata." =>
      strings.uiDemoViewNoRealConversationsYet,
    "Tidak ada contoh yang cocok." => strings.uiNoMatchingExamples,
    "Belum dibaca" => strings.uiUnread,
    "Semua" => strings.uiAll,
    "Belum ada contoh pesan untuk toko ini." =>
      strings.uiNoSampleMessagesForThisStore,
    "Percakapan contoh. Pesan tidak dikirim atau disimpan." =>
      strings.uiSampleConversationMessagesAreNotSentOrSaved,
    "Toko di Sekitarmu" => strings.uiStoresNearYou,
    "Peta ilustrasi • posisi toko contoh" =>
      strings.uiIllustrativeMapSampleStoreLocations,
    "Lihat daftar" => strings.uiViewList,
    "Petunjuk Arah" => strings.uiDirections,
    "Lihat Toko" => strings.uiViewStore,
    "Contoh tampilan · belum memakai lokasi atau data toko nyata." =>
      strings.uiDemoViewNoLiveLocationOrStoreDataIsUsed,
    "Tidak ada toko contoh yang cocok." => strings.uiNoMatchingSampleStores,
    "Pilihan toko" => strings.uiFeaturedStores,
    "4 toko contoh untuk pratinjau" => strings.ui4SampleStoresToPreview,
    "Lihat Peta" => strings.uiViewMap,
    "Lokasi saya (contoh)" => strings.uiMyLocationDemo,
    "Rute ilustrasi" => strings.uiIllustrativeRoute,
    "Buka di Aplikasi Peta" => strings.uiOpenInMaps,
    "Nama toko contoh disalin." => strings.uiSampleStoreNameCopied,
    "Detail Toko" => strings.uiStoreDetails,
    "Lihat peta ›" => strings.uiViewMap2,
    "Isi 5 pcs" => strings.uiPackOf5,
    "Roti panggang dengan garlic butter dan keju · contoh" =>
      strings.uiGarlicButterAndCheeseToastDemo,
    "Ulasan toko" => strings.uiStoreReviews,
    "Rating contoh, belum diverifikasi." => strings.uiSampleRatingsNotVerified,
    "Belum ada ulasan toko dalam demo offline." =>
      strings.uiNoStoreReviewsInTheOfflineDemo,
    "Tentang toko" => strings.uiAboutStore,
    "Informasi toko ini berasal dari data contoh demo offline." =>
      strings.uiThisStoreInformationComesFromOfflineDemoData,
    "Lihat Keranjang" => strings.uiViewCart,
    "Pembayaran" => strings.uiPayment,
    "Pembayaran belum tersedia" => strings.uiPaymentUnavailable,
    "Layar ini hanya contoh. Tidak ada kode QR, tagihan, transaksi, atau pesanan yang dibuat." =>
      strings.uiThisIsADemoScreenNoQRCodeBillTransactionOrOrderIsCreated,
    "Tutup" => strings.uiClose,
    "Keranjang kosong. Belum ada status pembayaran." =>
      strings.uiCartIsEmptyNoPaymentStatusAvailable,
    "Belum ada tagihan yang perlu diselesaikan." =>
      strings.uiThereIsNoBillToPay,
    "Batas waktu pembayaran" => strings.uiPaymentDeadline,
    "Total pembayaran" => strings.uiTotalPayment,
    "Metode pembayaran" => strings.uiPaymentMethod,
    "Simpan QR" => strings.uiSaveQR,
    "Status pratinjau" => strings.uiPreviewStatus,
    "ID Pesanan" => strings.uiOrderID,
    "QR belum tersedia" => strings.uiQRUnavailable,
    "Lihat contoh pembayaran berhasil" =>
      strings.uiViewExampleSuccessfulPayment,
    "Kembali ke Checkout" => strings.uiBackToCheckout,
    "Lihat contoh pembayaran belum berhasil" =>
      strings.uiViewExampleUnsuccessfulPayment,
    "Checkout" => strings.uiCheckout,
    "Demo offline. Toko, jadwal, profil, harga, dan QRIS hanya contoh. Tidak ada pembayaran atau pesanan dibuat." =>
      strings
          .uiOfflineDemoStoresSchedulesProfilesPricesAndQRISAreExamplesNoPaymen,
    "Keranjang kosong. Tambahkan produk sebelum checkout." =>
      strings.uiYourCartIsEmptyAddProductsBeforeCheckout,
    "Pesanan diambil langsung di toko" => strings.uiPickUpYourOrderAtTheStore,
    "Tidak ada biaya antar, lebih hemat!" => strings.uiNoDeliveryFeeSaveMore,
    "Detail lokasi" => strings.uiLocationDetails,
    "Pengambil pesanan" => strings.uiOrderRecipient,
    "Ubah" => strings.uiChange,
    "Ringkasan pembayaran" => strings.uiPaymentSummary,
    "Ketentuan pengambilan (demo)" => strings.uiPickupTermsDemo,
    "Halaman ini hanya simulasi. Toko, lokasi, dan jadwal adalah contoh. Tidak ada pembayaran, pesanan, atau reservasi dibuat. Ketentuan layanan sebenarnya belum tersedia." =>
      strings
          .uiThisPageIsASimulationStoresLocationsAndSchedulesAreExamplesNoPayme,
    "Saya setuju dengan " => strings.uiIAgreeToThe,
    "ketentuan pengambilan." => strings.uiPickupTerms,
    "Bayar Sekarang" => strings.uiPayNow,
    "Keranjang" => strings.uiCart,
    "Hapus Semua" => strings.uiClearAll,
    "Demo offline. Harga, tambahan, lokasi, dan jadwal adalah contoh. Keranjang hilang saat aplikasi ditutup. Tidak ada stok yang dipesan atau pembayaran dibuat." =>
      strings
          .uiOfflineDemoPricesAddOnsLocationsAndSchedulesAreExamplesTheCartClea,
    "Keranjangmu masih kosong" => strings.uiYourCartIsEmpty,
    "Pilih makanan dari Beranda untuk melihat ringkasan di sini." =>
      strings.uiSelectFoodFromHomeToSeeItHere,
    "Kembali Belanja" => strings.uiContinueShopping,
    "Lokasi toko contoh" => strings.uiSampleStoreLocation,
    "Tambah menu lain" => strings.uiAddMoreFood,
    "Ambil di toko" => strings.uiPickupAtStore,
    "Catatan untuk toko" => strings.uiNotesForStore,
    "Ringkasan pesanan" => strings.uiOrderSummary,
    "Pastikan kamu bisa datang sesuai jadwal. Jadwal aktual belum tersedia dalam demo." =>
      strings
          .uiMakeSureYouCanArriveOnTimeTheActualScheduleIsUnavailableInTheDemo,
    "Lanjut Checkout" => strings.uiContinueToCheckout,
    "Keranjang kosong. Tidak ada contoh pembayaran." =>
      strings.uiCartIsEmptyNoDemoPaymentAvailable,
    "Contoh pembayaran belum berhasil" => strings.uiExampleUnsuccessfulPayment,
    "Belum ada pembayaran yang diproses atau dikonfirmasi. Ini hanya contoh tampilan." =>
      strings.uiNoPaymentHasBeenProcessedOrConfirmedThisIsJustASampleScreen,
    "Status" => strings.uiStatus,
    "Yang bisa kamu lakukan" => strings.uiWhatYouCanDo,
    "Coba Bayar Lagi" => strings.uiTryPayingAgain,
    "Ganti Metode Pembayaran" => strings.uiChangePaymentMethod,
    "Butuh bantuan?" => strings.uiNeedHelp,
    "Rincian pesanan" => strings.uiOrderDetails2,
    "Rincian pesanan contoh" => strings.uiSampleOrderDetails2,
    "Contoh pembayaran berhasil" => strings.uiExampleSuccessfulPayment,
    "Pratinjau tampilan setelah pembayaran.\nBelum ada transaksi atau pesanan yang dibuat." =>
      strings.uiPreviewOfThePostPaymentScreenNoTransactionOrOrderHasBeenCreated,
    "Merchant contoh" => strings.uiSampleMerchant,
    "Jadwal ini bukan konfirmasi pesanan." =>
      strings.uiThisScheduleIsNotAnOrderConfirmation,
    "Lihat contoh pesanan" => strings.uiViewSampleOrders,
    "Pilih metode pembayaran" => strings.uiChoosePaymentMethod,
    "Saat ini hanya QRIS sebagai contoh tampilan. Tidak ada pembayaran atau kode QR yang dibuat." =>
      strings.uiOnlyQRISIsShownAsAnExampleNoPaymentOrQRCodeIsGenerated,
    "Metode contoh yang ditampilkan" => strings.uiSamplePaymentMethod,
    "Gunakan QRIS (contoh)" => strings.uiUseQRISDemo,
    "Password Berhasil Diperbarui!" => strings.uiPasswordUpdated,
    "Silakan masuk kembali menggunakan\npassword baru." =>
      strings.uiPleaseSignInAgainUsingYourNewPassword,
    "Kembali ke Login" => strings.uiBackToLogin,
    "Simulasi lokal. Tidak ada password atau akun yang disimpan." =>
      strings.uiLocalSimulationNoPasswordsOrAccountsAreSaved,
    "Makanan Berkualitas,\nHarga Lebih Bersahabat." =>
      strings.uiQualityFoodFriendlierPrices,
    "Temukan makanan surplus berkualitas dari bisnis terpercaya di sekitarmu sebelum waktu pengambilannya berakhir." =>
      strings
          .uiDiscoverQualitySurplusFoodFromTrustedNearbyBusinessesBeforePickupT,
    "Daftar" => strings.uiSignUp,
    "Sudah punya akun?" => strings.uiAlreadyHaveAnAccount,
    "Login" => strings.uiLogIn,
    "Sudah ingat password?" => strings.uiRememberedYourPassword,
    "Mode demo: tidak ada email atau kode yang dikirim." =>
      strings.uiDemoModeNoEmailOrCodeIsSent,
    "Kirim Kode OTP" => strings.uiSendOTPCode,
    "Lupa Password?" => strings.uiForgotPassword,
    "Tenang, kami bantu pulihkan akunmu." =>
      strings.uiDonTWorryWeLlHelpRecoverYourAccount,
    "Verifikasi" => strings.uiVerify,
    "Mode demo: gunakan kode 5102.\nTidak ada email atau SMS yang dikirim." =>
      strings.uiDemoModeUseCode5102NoEmailOrSMSIsSent,
    "Belum menerima kode?" => strings.uiDidnTReceiveTheCode,
    "Kirim Ulang" => strings.uiResend,
    "Verifikasi Kode OTP" => strings.uiVerifyOTPCode,
    "Daftar dan nikmati makanan lezat\ndengan harga lebih hemat." =>
      strings.uiSignUpAndEnjoyDeliciousFoodAtLowerPrices,
    "Contoh tampilan · belum ada notifikasi nyata." =>
      strings.uiDemoViewNoRealNotificationsYet,
    "Notifikasi" => strings.uiNotifications,
    "Tandai dibaca" => strings.uiMarkAsRead,
    "Kabar terbaru untukmu." => strings.uiYourLatestUpdates,
    "Fitur ini belum tersedia dalam demo offline." =>
      strings.uiThisFeatureIsUnavailableInTheOfflineDemo,
    "Buka profil contoh" => strings.uiOpenDemoProfile,
    "Pilih lokasi" => strings.uiChooseLocation2,
    "Kembali" => strings.uiBack,
    "Cari makanan..." => strings.uiSearchForFood,
    "Hapus pencarian" => strings.uiClearSearch,
    "Filter pencarian" => strings.uiSearchFilters2,
    "Minimum" => strings.uiMinimum,
    "Maksimum" => strings.uiMaximum,
    "Badge contoh; merchant belum diverifikasi" =>
      strings.uiSampleBadgeMerchantNotVerified,
    "Promo QRIS" => strings.uiQRISPromotion,
    "Flash Sale" => strings.uiFlashSale,
    "Dekat dari Lokasimu" => strings.uiNearYourLocation,
    "Temukan makanan lezat di sekitarmu..." =>
      strings.uiFindDeliciousFoodNearYou,
    "Filter makanan" => strings.uiFilterFood,
    "Cari area contoh" => strings.uiSearchSampleAreas,
    "Salin informasi produk" => strings.uiCopyProductInformation,
    "Kurangi jumlah contoh" => strings.uiDecreaseDemoQuantity,
    "Tambah jumlah contoh" => strings.uiIncreaseDemoQuantity,
    "Akun" => strings.uiAccount,
    "Produk dan pesanan" => strings.uiProductsAndOrders,
    "Pembayaran dan pengambilan" => strings.uiPaymentAndPickup,
    "Kembali ke Profil Saya" => strings.uiBackToMyProfile,
    "Ubah foto belum tersedia" => strings.uiChangingPhotosIsUnavailable,
    "Email contoh" => strings.uiSampleEmail,
    "Tambahkan nomor telepon" => strings.uiAddPhoneNumber,
    "Buka Pengaturan" => strings.uiOpenSettings,
    "Makanan" => strings.uiFood,
    "Toko" => strings.uiStores,
    "Tidak ada toko favorit contoh." => strings.uiNoSampleFavoriteStores,
    "Tidak ada makanan favorit contoh." => strings.uiNoSampleFavoriteFoods,
    "Cari pesanan" => strings.uiSearchOrders,
    "Cari nama produk atau toko contoh" =>
      strings.uiSearchSampleProductOrStoreName,
    "Tutup Bantuan Pesanan" => strings.uiCloseOrderHelp,
    "Bagaimana cara mengambil pesanan?" => strings.uiHowDoIPickUpMyOrder,
    "Pesanan belum siap" => strings.uiOrderNotReady,
    "Toko tutup atau sulit ditemukan" => strings.uiStoreClosedOrHardToFind,
    "Pesanan tidak sesuai" => strings.uiIncorrectOrder,
    "Kendala pembayaran" => strings.uiPaymentIssue,
    "Waktu pengambilan" => strings.uiPickupTime,
    "Total contoh" => strings.uiDemoTotal,
    "Buka Bantuan Pesanan" => strings.uiOpenOrderHelp,
    "Lokasi toko" => strings.uiStoreLocation,
    "Batas pickup contoh" => strings.uiDemoPickupDeadline,
    "Subtotal contoh" => strings.uiDemoSubtotal,
    "Bagaimana rasa makanan dan pengalaman pengambilanmu?" =>
      strings.uiHowWasTheFoodAndPickupExperience,
    "Rasa enak" => strings.uiTastyFood,
    "Porsi pas" => strings.uiGoodPortion,
    "Kemasan rapi" => strings.uiNeatPackaging,
    "Toko ramah" => strings.uiFriendlyStore,
    "Opsi bantuan belum tersedia" => strings.uiHelpOptionsUnavailable,
    "Halo! Ada yang bisa kami bantu terkait pesanan contoh?" =>
      strings.uiHelloHowCanWeHelpWithYourSampleOrder,
    "Saya sudah di toko, tetapi pesanan belum tersedia." =>
      strings.uiIMAtTheStoreButMyOrderIsnTReady,
    "Baik, Kak. Bisa ceritakan kondisi di lokasi?" =>
      strings.uiOfCourseCouldYouDescribeWhatSHappeningAtTheStore,
    "Lampiran belum tersedia" => strings.uiAttachmentsUnavailable,
    "Tulis pesan..." => strings.uiWriteAMessage,
    "Emoji belum tersedia" => strings.uiEmojiUnavailable,
    "Kirim pesan contoh" => strings.uiSendSampleMessage,
    "Pesanan Kakak sudah siap diambil, ya" =>
      strings.uiYourOrderIsReadyForPickup,
    "Baik, kak. Pesanan sedang kami siapkan." =>
      strings.uiWeRePreparingYourOrderNow,
    "Terima kasih sudah berbelanja, kak!" =>
      strings.uiThankYouForShoppingWithUs,
    "Siap, kak. Terima kasih!" => strings.uiOkayThankYou,
    "Cari toko atau pesan..." => strings.uiSearchStoresOrMessages,
    "Tulis pesan contoh..." => strings.uiWriteASampleMessage,
    "Tambahkan pesan contoh" => strings.uiAddSampleMessage,
    "Kembali ke daftar toko" => strings.uiBackToStoreList,
    "Filter peta belum tersedia" => strings.uiMapFiltersUnavailable,
    "Lokasi perangkat belum tersedia" => strings.uiDeviceLocationUnavailable,
    "Cari nama toko atau kategori..." => strings.uiSearchStoreNameOrCategory,
    "Filter toko belum tersedia" => strings.uiStoreFiltersUnavailable,
    "jarak belum ada" => strings.uiDistanceUnavailable2,
    "produk contoh" => strings.uiSampleProducts,
    "Jalan kaki" => strings.uiWalking,
    "Motor" => strings.uiMotorcycle,
    "Mobil" => strings.uiCar,
    "Kembali ke peta toko" => strings.uiBackToStoreMap,
    "Salin nama toko" => strings.uiCopyStoreName,
    "Tambah produk contoh ke keranjang" => strings.uiAddSampleProductToCart,
    "Tentang pratinjau pembayaran" => strings.uiAboutThePaymentPreview,
    "Logo QRIS, metode pembayaran contoh" =>
      strings.uiQRISLogoSamplePaymentMethod,
    "Biaya layanan" => strings.uiServiceFee,
    "Saya setuju dengan ketentuan pengambilan demo" =>
      strings.uiIAgreeToTheDemoPickupTerms,
    "Contoh: kemasan dipisah, jangan terlalu manis, dll." =>
      strings.uiExampleSeparatePackagingLessSweetEtc,
    "Biaya layanan (demo)" => strings.uiServiceFeeDemo,
    "Periksa koneksi internet" => strings.uiCheckInternetConnection,
    "Pastikan koneksi stabil sebelum mencoba lagi." =>
      strings.uiMakeSureYourConnectionIsStableBeforeRetrying,
    "Cek riwayat transaksi" => strings.uiCheckTransactionHistory,
    "Periksa aplikasi pembayaranmu sebelum mencoba lagi." =>
      strings.uiCheckYourPaymentAppBeforeTryingAgain,
    "Status pembayaran" => strings.uiPaymentStatus,
    "Waktu pembayaran" => strings.uiPaymentTime,
    "ID pesanan" => strings.uiOrderID2,
    "Logo QRIS" => strings.uiQRISLogo,
    "Lanjut ke sambutan" => strings.uiContinueToWelcome,
    "Logo PanganKita" => strings.uiPanganKitaLogo,
    "Pesanan siap diambil!" => strings.uiOrderReadyForPickup,
    "Soto Kesawan sedang menyiapkan makanan favoritmu." =>
      strings.uiSotoKesawanIsPreparingYourFavoriteFood,
    "Favoritmu lagi diskon!" => strings.uiYourFavoritesAreOnSale,
    "Hemat hingga 60% untuk roti dan camilan pilihan hari ini." =>
      strings.uiSaveUpTo60OnSelectedBreadAndSnacksToday,
    "Pesanan selesai" => strings.uiOrderCompleted,
    "Ada yang enak di dekatmu" => strings.uiSomethingTastyNearYou,
    "Temukan makanan favorit dengan harga yang lebih hemat." =>
      strings.uiFindYourFavoriteFoodAtBetterPrices,
    "Aneka Nasi" => strings.uiRiceDishes,
    "Roti & Pastry" => strings.uiBreadPastries,
    "Kue & Dessert" => strings.uiCakesDesserts,
    "Stok contoh" => strings.uiSampleStock,
    "Aktif" => strings.uiActive,
    "Selesai" => strings.uiCompleted,
    "Dibatalkan" => strings.uiCanceled,
    "Buka Sekarang" => strings.uiOpenNow,
    "Diskon Terbesar" => strings.uiBiggestDiscount,
    "Terdekat" => strings.uiNearest,
    "Rating" => strings.uiRating,
    "Semua toko" => strings.uiAllStores,
    "Diskon" => strings.uiDiscount,
    "Promo" => strings.uiPromotions,
    "Hari ini" => strings.uiToday,
    "Kemarin" => strings.uiYesterday,
    "Selamat Pagi, " => strings.uiGoodMorning,
    "Hemat " => strings.uiSave,
    "vincent@example.com • contoh" => strings.uiVincentExampleComDemo,
    "(Isi 5 pcs)" => strings.uiPackOf52,
    "Selamat datang kembali!" => strings.uiWelcomeBack,
    "Buat Akun Baru" => strings.uiCreateAccount,
    "Buat Password Baru" => strings.uiCreateNewPassword,
    "Temukan makanan favorit dengan\nharga lebih hemat." =>
      strings.uiFindYourFavoriteFoodsAtBetterPrices,
    "Pastikan password mudah diingat\nnamun sulit ditebak." =>
      strings.uiChooseAPasswordThatSEasyToRememberButHardToGuess,
    "Password" => strings.uiPassword,
    "Buat password" => strings.uiCreatePassword,
    "Password baru" => strings.uiNewPassword,
    "Masuk" => strings.uiSignIn,
    "Simpan Password" => strings.uiSavePassword,
    "Belum punya akun?" => strings.uiDonTHaveAnAccount,
    "Konfirmasi password tidak cocok." => strings.uiPasswordsDoNotMatch,
    "Mode demo. Tidak ada autentikasi atau akun server." =>
      strings.uiDemoModeNoAuthenticationOrServerAccount,
    "Konfirmasi password baru" => strings.uiConfirmNewPassword,
    "Konfirmasi password" => strings.uiConfirmPassword,
    "Kolom wajib diisi." => strings.uiThisFieldIsRequired,
    "Masukkan format email yang valid." => strings.uiEnterAValidEmailAddress,
    "Gunakan minimal 8 karakter, termasuk huruf dan angka." =>
      strings.uiUseAtLeast8CharactersIncludingLettersAndNumbers,
    "Kode demo tidak cocok. Gunakan 5102." =>
      strings.uiIncorrectDemoCodeUse5102,
    "Kode demo masih 5102. Tidak ada SMS atau email yang dikirim." =>
      strings.uiTheDemoCodeRemains5102NoSMSOrEmailIsSent,
    "Tampilkan password" => strings.uiShowPassword,
    "Sembunyikan password" => strings.uiHidePassword,
    "Masukkan nama lengkap." => strings.uiEnterYourFullName,
    "Masukkan email yang valid." => strings.uiEnterAValidEmailAddress2,
    "Perubahan contoh belum dapat disimpan ke akun." =>
      strings.uiDemoChangesCannotBeSavedToAnAccount,
    "Produk contoh ditambahkan ke keranjang lokal." =>
      strings.uiSampleProductAddedToLocalCart,
    "Batas jumlah contoh dalam keranjang sudah tercapai." =>
      strings.uiDemoCartQuantityLimitReached,
    "Informasi produk demo disalin." => strings.uiDemoProductInformationCopied,
    "Batas pratinjau 10 item per pilihan. Ubah jumlah di keranjang." =>
      strings.uiDemoLimit10ItemsPerConfigurationChangeTheQuantityInYourCart,
    "Cari makanan atau toko" => strings.uiSearchFoodOrStores,
    "Hapus favorit sementara" => strings.uiRemoveTemporaryFavorite,
    "Favoritkan sementara" => strings.uiTemporarilyFavorite,
    "Tidak ada stok yang dipesan atau pembayaran dibuat." =>
      strings.uiNoInventoryIsReservedOrPaymentCreated,
    "Update pesanan" => strings.uiOrderUpdates,
    "Terima kasih sudah menyelamatkan makanan bersama Soto Kesawan." =>
      strings.uiThankYouForHelpingReduceFoodWasteWithSotoKesawan,
    "Mawar Bakery & Cake sudah menyiapkan pesananmu. Ambil sebelum 20.30, ya." =>
      strings.uiMawarBakeryCakeHasPreparedYourOrderPleaseCollectItBefore2030,
    "Selamat datang di PanganKita" => strings.uiWelcomeToPanganKita,
    "Data contoh" => strings.uiDemoData,
    "Pengaturan" => strings.uiSettings,
    "Tentang PanganKita" => strings.uiAboutPanganKita,
    "Pesan dari toko" => strings.uiMessagesFromStores,
    "Promo & penawaran" => strings.uiPromotionsOffers,
    "Riwayat Pesanan" => strings.uiOrderHistory,
    "Lokasi Saya" => strings.uiMyLocation,
    "Pusat Bantuan" => strings.uiHelpCenter,
    "Keluar" => strings.uiLogOut,
    "Coba kata kunci lain." => strings.uiTryAnotherSearchTerm,
    _ => null,
  };
  if (literal != null) return literal;
  return _translateInterpolated(strings, value);
}

String _translateInterpolated(AppLocalizations strings, String value) {
  final matchuiValueDistanceAndTimeUnavailable =
      _patternuiValueDistanceAndTimeUnavailable.firstMatch(value);
  if (matchuiValueDistanceAndTimeUnavailable != null) {
    final match = matchuiValueDistanceAndTimeUnavailable;
    return strings.uiValueDistanceAndTimeUnavailable(match.group(1) ?? '');
  }
  final matchuiDemoPickupDeadlineValueValue =
      _patternuiDemoPickupDeadlineValueValue.firstMatch(value);
  if (matchuiDemoPickupDeadlineValueValue != null) {
    final match = matchuiDemoPickupDeadlineValueValue;
    return strings.uiDemoPickupDeadlineValueValue(
      match.group(1) ?? '',
      match.group(2) ?? '',
    );
  }
  final matchuiRemoveValueFromDemoFavorites =
      _patternuiRemoveValueFromDemoFavorites.firstMatch(value);
  if (matchuiRemoveValueFromDemoFavorites != null) {
    final match = matchuiRemoveValueFromDemoFavorites;
    return strings.uiRemoveValueFromDemoFavorites(match.group(1) ?? '');
  }
  final matchuiValueSampleFoodItemsFound = _patternuiValueSampleFoodItemsFound
      .firstMatch(value);
  if (matchuiValueSampleFoodItemsFound != null) {
    final match = matchuiValueSampleFoodItemsFound;
    return strings.uiValueSampleFoodItemsFound(match.group(1) ?? '');
  }
  final matchuiSampleProductPhotoFromValue =
      _patternuiSampleProductPhotoFromValue.firstMatch(value);
  if (matchuiSampleProductPhotoFromValue != null) {
    final match = matchuiSampleProductPhotoFromValue;
    return strings.uiSampleProductPhotoFromValue(match.group(1) ?? '');
  }
  final matchuiDemoPickupValueValue = _patternuiDemoPickupValueValue.firstMatch(
    value,
  );
  if (matchuiDemoPickupValueValue != null) {
    final match = matchuiDemoPickupValueValue;
    return strings.uiDemoPickupValueValue(
      match.group(1) ?? '',
      match.group(2) ?? '',
    );
  }
  final matchuiDemoPickupLocationValue = _patternuiDemoPickupLocationValue
      .firstMatch(value);
  if (matchuiDemoPickupLocationValue != null) {
    final match = matchuiDemoPickupLocationValue;
    return strings.uiDemoPickupLocationValue(match.group(1) ?? '');
  }
  final matchuiDemoPickupDeadlineValue = _patternuiDemoPickupDeadlineValue
      .firstMatch(value);
  if (matchuiDemoPickupDeadlineValue != null) {
    final match = matchuiDemoPickupDeadlineValue;
    return strings.uiDemoPickupDeadlineValue(match.group(1) ?? '');
  }
  final matchuiDemoPickupValueValue2 = _patternuiDemoPickupValueValue2
      .firstMatch(value);
  if (matchuiDemoPickupValueValue2 != null) {
    final match = matchuiDemoPickupValueValue2;
    return strings.uiDemoPickupValueValue2(
      match.group(1) ?? '',
      match.group(2) ?? '',
    );
  }
  final matchuiGiveValueStars = _patternuiGiveValueStars.firstMatch(value);
  if (matchuiGiveValueStars != null) {
    final match = matchuiGiveValueStars;
    return strings.uiGiveValueStars(match.group(1) ?? '');
  }
  final matchuiSubtotalValueItems = _patternuiSubtotalValueItems.firstMatch(
    value,
  );
  if (matchuiSubtotalValueItems != null) {
    final match = matchuiSubtotalValueItems;
    return strings.uiSubtotalValueItems(match.group(1) ?? '');
  }
  final matchuiPickUpAtValueDemo = _patternuiPickUpAtValueDemo.firstMatch(
    value,
  );
  if (matchuiPickUpAtValueDemo != null) {
    final match = matchuiPickUpAtValueDemo;
    return strings.uiPickUpAtValueDemo(match.group(1) ?? '');
  }
  final matchuiContinueWithValue = _patternuiContinueWithValue.firstMatch(
    value,
  );
  if (matchuiContinueWithValue != null) {
    final match = matchuiContinueWithValue;
    return strings.uiContinueWithValue(match.group(1) ?? '');
  }
  final matchuiValuePiecesLeft = _patternuiValuePiecesLeft.firstMatch(value);
  if (matchuiValuePiecesLeft != null) {
    final match = matchuiValuePiecesLeft;
    return strings.uiValuePiecesLeft(match.group(1) ?? '');
  }
  final matchuiValueItemsValue = _patternuiValueItemsValue.firstMatch(value);
  if (matchuiValueItemsValue != null) {
    final match = matchuiValueItemsValue;
    return strings.uiValueItemsValue(
      match.group(1) ?? '',
      match.group(2) ?? '',
    );
  }
  final matchuiPickupUntilValue = _patternuiPickupUntilValue.firstMatch(value);
  if (matchuiPickupUntilValue != null) {
    final match = matchuiPickupUntilValue;
    return strings.uiPickupUntilValue(match.group(1) ?? '');
  }
  final matchuiPickupDeadlineValue = _patternuiPickupDeadlineValue.firstMatch(
    value,
  );
  if (matchuiPickupDeadlineValue != null) {
    final match = matchuiPickupDeadlineValue;
    return strings.uiPickupDeadlineValue(match.group(1) ?? '');
  }
  final matchuiDemoQuantityValue = _patternuiDemoQuantityValue.firstMatch(
    value,
  );
  if (matchuiDemoQuantityValue != null) {
    final match = matchuiDemoQuantityValue;
    return strings.uiDemoQuantityValue(match.group(1) ?? '');
  }
  final matchuiValueSampleReviews = _patternuiValueSampleReviews.firstMatch(
    value,
  );
  if (matchuiValueSampleReviews != null) {
    final match = matchuiValueSampleReviews;
    return strings.uiValueSampleReviews(match.group(1) ?? '');
  }
  final matchuiQuantityOfValueValue = _patternuiQuantityOfValueValue.firstMatch(
    value,
  );
  if (matchuiQuantityOfValueValue != null) {
    final match = matchuiQuantityOfValueValue;
    return strings.uiQuantityOfValueValue(
      match.group(1) ?? '',
      match.group(2) ?? '',
    );
  }
  final matchuiValuePortionsLeft = _patternuiValuePortionsLeft.firstMatch(
    value,
  );
  if (matchuiValuePortionsLeft != null) {
    final match = matchuiValuePortionsLeft;
    return strings.uiValuePortionsLeft(match.group(1) ?? '');
  }
  final matchuiValueBoxesLeft2 = _patternuiValueBoxesLeft2.firstMatch(value);
  if (matchuiValueBoxesLeft2 != null) {
    final match = matchuiValueBoxesLeft2;
    return strings.uiValueBoxesLeft2(match.group(1) ?? '');
  }
  final matchuiValueBoxesLeft = _patternuiValueBoxesLeft.firstMatch(value);
  if (matchuiValueBoxesLeft != null) {
    final match = matchuiValueBoxesLeft;
    return strings.uiValueBoxesLeft(match.group(1) ?? '');
  }
  final matchuiValueMinutesLeft = _patternuiValueMinutesLeft.firstMatch(value);
  if (matchuiValueMinutesLeft != null) {
    final match = matchuiValueMinutesLeft;
    return strings.uiValueMinutesLeft(match.group(1) ?? '');
  }
  final matchuiCategoryValue = _patternuiCategoryValue.firstMatch(value);
  if (matchuiCategoryValue != null) {
    final match = matchuiCategoryValue;
    return strings.uiCategoryValue(match.group(1) ?? '');
  }
  final matchuiDecreaseValue = _patternuiDecreaseValue.firstMatch(value);
  if (matchuiDecreaseValue != null) {
    final match = matchuiDecreaseValue;
    return strings.uiDecreaseValue(match.group(1) ?? '');
  }
  final matchuiIncreaseValue = _patternuiIncreaseValue.firstMatch(value);
  if (matchuiIncreaseValue != null) {
    final match = matchuiIncreaseValue;
    return strings.uiIncreaseValue(match.group(1) ?? '');
  }
  final matchuiSaveValue = _patternuiSaveValue.firstMatch(value);
  if (matchuiSaveValue != null) {
    final match = matchuiSaveValue;
    return strings.uiSaveValue(match.group(1) ?? '');
  }
  final matchuiRemoveValue = _patternuiRemoveValue.firstMatch(value);
  if (matchuiRemoveValue != null) {
    final match = matchuiRemoveValue;
    return strings.uiRemoveValue(match.group(1) ?? '');
  }
  final matchuiDigitValue = _patternuiDigitValue.firstMatch(value);
  if (matchuiDigitValue != null) {
    final match = matchuiDigitValue;
    return strings.uiDigitValue(match.group(1) ?? '');
  }
  return value;
}
