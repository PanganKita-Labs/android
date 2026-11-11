# Releasing PanganKita Android

This is the maintained release checklist, not a version history.
Use [CHANGELOG.md](../CHANGELOG.md) to record noteworthy changes and
[version-specific notes](releases/0.1.0-beta.1.md) to describe a particular APK.
Update this guide when release controls change.

**Current distribution:** The repository has a manual Android **beta**
workflow at `.github/workflows/release-android-beta.yml`. It prepares a
**draft** GitHub prerelease; publication requires a separate maintainer action.
No PR merge automatically publishes an APK. The app is currently an
educational and research prototype, not a live food-ordering service.

## Mandatory release checks

1. **Code rights and attribution:** Verify that each contributor can license
   their contribution under [Apache-2.0](../LICENSE) and that
   [NOTICE](../NOTICE) preserves applicable contributor and maintainer credit.
2. **Assets:** Complete the [asset-provenance review](#asset-provenance-and-redistribution).
   Do not distribute a release APK with material lacking verified rights.
3. **Android identity:** The chosen application ID is
   `com.pangankitalabs.pangankita`. Confirm it does not conflict with an
   existing distribution, and keep it unchanged after the first public APK.
   Changing it later makes Android treat the result as another application.
4. **Signing:** Create and securely back up a dedicated release keystore,
   configure the required secrets, and record the approved signing
   certificate SHA-256 fingerprint. Never publish with a debug key.
   The current workflow checks signature validity but **does not pin the
   expected signing identity**. Independently compare fingerprints before
   publishing; automate that comparison before later releases.
5. **Quality and compatibility:** Review the current required CI results,
   including Android API 24/29/35/36 launch smoke coverage. Test the **signed
   release APK** on real Android devices, verify installation and upgrades
   from previously published builds, and exercise Indonesian, English,
   Simplified Chinese, navigation and startup. Debug CI does not prove a
   release APK works.
6. **Truthful release notes:** State exactly what is implemented and what
   remains simulated. No real authentication, merchant verification,
   inventory reservations, ordering, payments, messaging or pickup
   confirmation exists in the current prototype. Do not request real user
   credentials or payment data in testing.

## Asset provenance and redistribution

Some example food images may have been obtained from third-party menus.
Their original sources and permissions have not been verified in this
repository review. Neither educational nor non-commercial intent grants
automatic permission to redistribute copyrighted material.

| Content to check | Evidence to establish | Required action |
| --- | --- | --- |
| Food images in `app/assets/prototype/`, including `buns.webp`, `chicken.webp`, `rendang.webp`, `soto.webp`, and `store-croissants.webp` | Original creator, source and permission to distribute | Clear the rights or replace the assets |
| Branding and third-party marks in `app/assets/brand/` and `app/assets/prototype/` | Ownership and permitted use of logos and trademarks | Confirm permissions or replace/remove |
| `docs/screenshots/` | Whether screenshots reproduce unlicensed images or marks | Regenerate affected screenshots after replacing assets |
| Bundled Geist and downloaded Satoshi fonts | Relevant font licenses, redistribution terms and required notices | Retain and distribute applicable license notices |

Record the creator, provenance, license or permission, required attribution,
and rights to redistribute each third-party asset in the repository and APK.
Remove or replace unverified material before public distribution, including
affected screenshots. Assets already committed to a public repository also
need review; a disclaimer does not resolve missing permissions.

## Signing and release authorization

The manual beta workflow requires these GitHub Actions secrets:

| Secret | Purpose |
| --- | --- |
| `ANDROID_RELEASE_KEYSTORE_BASE64` | Base64-encoded release keystore |
| `ANDROID_RELEASE_STORE_PASSWORD` | Keystore password |
| `ANDROID_RELEASE_KEY_ALIAS` | Key alias |
| `ANDROID_RELEASE_KEY_PASSWORD` | Key password |

Never commit signing materials. Losing the release keystore can prevent
compatible Android updates for users of earlier releases.

The workflow also requires the repository Actions variable
`PANGANKITA_BETA_RELEASE_APPROVED=true`. Set it **only after** code
licensing, asset permissions, application ID, signing identity, and intended
tester audience have been reviewed. Unset it when release approval is not
active. This variable is a release gate, not legal verification.

## Prepare and publish a beta

1. Update `app/pubspec.yaml` with an appropriate prerelease version and
   monotonically increasing Android build number. Prepare
   `docs/releases/<version-without-v>.md` and update
   [CHANGELOG.md](../CHANGELOG.md) accurately. Do not mark a build as
   published before it actually is.
2. Once the checklist is satisfied and the preparation PR is merged,
   dispatch **Actions → Android beta release (manual)** from `main`
   with the matching tag (currently proposed: `v0.1.0-beta.1`,
   matching `0.1.0-beta.1+2`).
3. The workflow rejects the example application ID, missing approval
   variable or signing secrets, duplicate tags, and version mismatches.
   It builds a signed APK, checks signature validity, and creates a **draft**
   GitHub prerelease with the APK, SHA256SUMS, LICENSE and NOTICE.
4. Independently verify APK checksum, the expected signing certificate,
   asset clearance and notices. Test the signed APK and its upgrade path.
   The maintainer must then explicitly publish the draft prerelease.
5. After publication, record the actual release date in
   [CHANGELOG.md](../CHANGELOG.md); retain the version-specific tester notes
   and release artifacts. Never reuse a tag or downgrade Android version codes.

## Evidence boundary

A passing CI run does not certify contributor ownership, asset rights, legal
food-safety compliance, or production business behavior. Review and record
these separately. A valid APK signature alone does not identify the expected
signer.
