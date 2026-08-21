# Context and authority

## Separate the dimensions

Country, locale, currency, time zone, units, address format, phone format, and
communication channel are distinct. Never derive one solely from another.

For each input, record:

| Concern | Example owner |
| --- | --- |
| Stored semantic value | Domain aggregate or command |
| Authoring locale | Explicit task/business/user context |
| Display locale | Current interface or audience context |
| Currency/unit | Commercial or measurement context |
| Syntax classifier | Browser component for that semantic type |
| Domain validity | Server/domain command |

A user may travel, use an English browser in another country, or author data
for a remote operation. Regional signals are suggestions, not facts.

## Apply suggestions once

A device/browser/edge hint may fill only a blank, unreviewed value. Mark when a
person reviews or changes it. Never reapply the hint after a reactive render,
overwrite a non-empty hidden/submitted field, or silently mutate a reviewed
choice.

Keep the suggestion visible and editable. Request precise geolocation only
when the actual task needs it, not to choose a formatting default.

## Keep canonical values stable

Store domain values in a representation independent of decoration: minor
units/decimal plus currency, normalized phone identity plus authored display,
structured address facts, or a parsed date/time with explicit zone semantics.

Do not erase the authored draft before the server accepts normalization. When
ambiguity cannot be resolved deterministically, ask rather than guessing.
