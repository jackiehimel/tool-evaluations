# License notes — Cascade

Every conclusion here is marked **counsel to confirm**; this is an engineer's reading of license texts and package manifests, not legal advice.

## Source license
- Cascade itself: **MIT** (`LICENSE` in the checkout at aee88e20; `package.json` `"license": "MIT"`, name `cascade`, version 1.0.0). Copyright line names the upstream author and "CASCADE Contributors".
- MIT permits commercial use, modification, redistribution and hosted use, and requires the copyright and permission notice to be kept in copies or substantial portions. It grants no trademark rights. **Counsel to confirm.**

## Trademark and attribution
- No trademark statement, NOTICE file or branding policy exists in the repository (searched README, LICENSE, `docs/`). The name "Cascade" and the bot identity `Cascade Bot <bot@cascade.dev>` are hard-coded in source (finding 5); rebranding means changing them in a fork.
- Attribution required by MIT: keep the LICENSE text and copyright line in any distribution, including a rebranded one. A hosted offering that does not distribute the code has no attribution obligation under MIT, but the worker image and CLI that a customer installs are distributions. **Counsel to confirm.**

## Dependency licenses
### Router, dashboard, CLI (the checkout, production dependencies, `npx license-checker --production`, E-025)
392 packages: MIT 293, Apache-2.0 45, ISC 28, BSD-3-Clause 15, BlueOak-1.0.0 4, Python-2.0 1, 0BSD 1, Unlicense 1, (MIT OR CC0-1.0) 1, custom 2, unknown 1.

### Worker image (`cascade-worker:local`, `/app/node_modules` manifests read offline, E-024)
353 packages: MIT 261, Apache-2.0 43, ISC 24, BSD-3-Clause 15, BlueOak-1.0.0 3, Python-2.0 1, 0BSD 1, Unlicense 1, (MIT OR CC0-1.0) 1, "see license in README/LICENSE" 2, unknown 1.

### Flagged (not MIT/Apache/BSD/ISC)
| Package | License | Where | Note |
|---|---|---|---|
| `@anthropic-ai/claude-agent-sdk` 0.3.185 and its platform binaries | Proprietary: "© Anthropic PBC. All rights reserved. Use is subject to the Legal Agreements" (SDK `LICENSE.md`) | checkout and worker image | The Claude Code engine. Not open source; use is governed by Anthropic's commercial terms and the customer's own Anthropic account. Redistributing the worker image to customers means redistributing this SDK; **counsel to confirm** whether Anthropic's terms allow that or whether each customer must install it under their own agreement. |
| `zangief` 1.0.5 | No license field, no repository field | checkout (direct dependency, `package.json:89`) | "llmist gadgets for exploring GitHub repos via Sourcegraph API", from the same author ecosystem as the LLMist engine. No license means no grant; **counsel to confirm** or replace before redistribution. |
| BlueOak-1.0.0 (4 packages), Python-2.0 (1), 0BSD, Unlicense, CC0 | Permissive | both | Listed for completeness; permissive but not on the plan's four-name allow-list. |

## Hosted-use terms
- Cascade: none beyond MIT; there is no hosted service or terms of service in the repository.
- Model provider: Anthropic's terms apply to the API key used; every run sends repository content and card text to Anthropic (SECURITY.md).
- Trello and GitHub: the customer's own accounts and API terms; Cascade acts under the customer's tokens (finding 4).

## Conclusion (counsel to confirm)
MIT permits commercial use, rebranding and hosted use of Cascade. Two items need a legal answer before shipping under our brand: the proprietary Claude Agent SDK inside the worker image, and the unlicensed `zangief` dependency.
