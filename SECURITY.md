# Security Policy

## Project scope

PanganKita's maintained `android` repository currently implements an offline
Flutter demonstration with sample merchant, order, account, and payment
screens. These previews **do not** implement real authentication, payment
processing, inventory reservation, or a production backend.

Security findings involving repository code, build tooling, dependencies,
GitHub workflows, release artifacts, or exposure of secrets are relevant to
the maintainers. An issue that only demonstrates that a labeled demo action
is not connected to a service is not by itself a production security flaw.

## Supported versions and commitments

Security fixes are considered against the **current maintained `main` branch**.
There is no declared production release-support matrix, security bounty,
guaranteed response time, or promised patch deadline. Do not infer support for
older APKs or the existence of production infrastructure.

## Report suspected vulnerabilities safely

1. Open the repository's
   [Security advisories page](https://github.com/PanganKita-Labs/android/security/advisories).
2. **If** the repository exposes **Report a vulnerability**, use that private
   GitHub reporting form. Private vulnerability reporting must be enabled by
   repository administrators; the existence of this policy alone does not
   mean the button is available.
3. If private reporting is **not** available, open a
   [new issue](https://github.com/PanganKita-Labs/android/issues/new/choose)
   asking maintainers to establish a private security contact. Include
   **no vulnerability details, exploit code, affected private data, or
   sensitive reproduction steps** in that public request. Do not disclose
   a vulnerability in a public PR or issue.
4. If no safe private communication is available, retain sensitive details
   privately until maintainers establish one. The maintainers should enable
   GitHub private vulnerability reporting or publish a verified secure
   alternative before inviting sensitive reports.

When a private channel is available, include: affected commit/version, concise
impact, prerequisites, sanitized steps to reproduce, and a minimal proof using
synthetic data. Avoid testing on third-party accounts or real user information.

See [GitHub's private reporting guidance](https://docs.github.com/en/code-security/how-tos/report-and-fix-vulnerabilities/report-privately)
for how that feature works.

## Responsible handling

- Do not access, modify, or disclose data you do not own.
- Avoid disruptive tests, social engineering, denial of service, or scanning
  systems without authorization.
- Do not upload real credentials, tokens, signing keys, precise private
  locations, or sensitive logs to public issues or PRs.
- Allow maintainers an opportunity to investigate and coordinate a fix before
  public disclosure; no response deadline or guaranteed outcome is promised.
- Maintainers should assess impact against actual deployed functionality,
  privately coordinate any necessary fix, and disclose only verified facts.

For ordinary non-sensitive bugs, use [contribution guidance](CONTRIBUTING.md).
For harmful community behavior, see [the code of conduct](CODE_OF_CONDUCT.md).

## Maintainer configuration decision

**Before advertising confidential intake as operational**, a repository admin
must verify that GitHub's **Report a vulnerability** action is enabled and
usable, or designate a maintained private alternative. This policy deliberately
does not invent an email address or falsely claim private reporting is active.
