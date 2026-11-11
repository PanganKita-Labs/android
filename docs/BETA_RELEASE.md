# PanganKita v0.1.0 beta release preparation

This release is a **testing prerelease**, not a production service.
Authentication, merchant inventories, reservations, payments, location tracking
and messaging are demonstrations backed by fixtures, not live integrations.

## Proposed identity and distribution

- GitHub prerelease tag: `v0.1.0-beta.1`
- Flutter version: `0.1.0-beta.1+2` (Android version code `2`)
- Toolchain: Flutter 3.47.4, Dart 3.13.3, Java 17
- Distribution: a **draft GitHub prerelease** with a signed Android APK,
  SHA-256 checksums, LICENSE, and NOTICE; a maintainer publishes it manually
- Never automatically publish an APK on a PR merge

## Mandatory maintainer decisions before publication

1. **Android identity:** Choose a unique, lasting application ID.
   `com.example.pangankita` is a template value and must be replaced.
   Changing the application ID later creates a different Android application.
2. **Signing:** Create and safely back up a dedicated release keystore.
   Configure the four GitHub secrets below and record the signing certificate
   fingerprint privately. Never sign a distributed beta using debug keys.
3. **Copyright:** Confirm the contributors can license all included source
   under Apache-2.0 and approve the project attribution in NOTICE. The initial
   text names the `PanganKita-Labs contributors`; named individual owners
   must be reviewed before claiming their rights or identity.
4. **Assets:** Audit the original creator and distribution rights for logos,
   screenshots, prototype photographs and embedded Geist/Satoshi fonts.
   Their licenses or trademark rights do not automatically become Apache-2.0.
5. **Compatibility:** Confirm Quality, Android Build, and API 24/29/35/36
   smoke coverage. Test the actual release APK on physical Android devices,
   including Indonesian, English, Simplified Chinese, navigation and startup.
6. **User expectations:** State clearly that no authentication, order,
   inventory, merchant verification or payment operation is live.

## GitHub Actions signing secrets

| Secret | Value |
| --- | --- |
| `ANDROID_RELEASE_KEYSTORE_BASE64` | Base64-encoded release keystore |
| `ANDROID_RELEASE_STORE_PASSWORD` | Keystore password |
| `ANDROID_RELEASE_KEY_ALIAS` | Key alias |
| `ANDROID_RELEASE_KEY_PASSWORD` | Key password |

Do not commit the keystore, keys or passwords. Losing the keystore can make
future APK updates incompatible with an earlier installation.

## Manual draft release

After merging this preparation PR and completing all above decisions:

1. Select **Actions → Android beta release (manual)**, on branch **main**,
   with tag `v0.1.0-beta.1`.
2. The workflow verifies tag/version consistency, rejects the example Android
   application ID, checks required signing secrets, builds a release APK,
   verifies its signature, and creates a **draft** GitHub prerelease.
3. Inspect the APK checksum, signing certificate and LICENSE/NOTICE, validate
   installation and application behavior on Android, then explicitly publish
   the draft prerelease.

Future betas must increment both beta number and Android version code.
Do not reuse Git tags or downgrade version codes.

## Verification boundary

CI does not certify copyright ownership, asset redistribution rights, legal
food-safety compliance, or production behavior. Those require maintainer
review. Signing must also be tested for upgrades from the previous beta.
