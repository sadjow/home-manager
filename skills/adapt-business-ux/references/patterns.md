# Business UX patterns

Use these examples as capability mappings, not fixed taxonomies.

## Capability map

| Business example | Customer job | Common capabilities | Owner operation |
| --- | --- | --- | --- |
| Restaurant | Choose food and receive or collect it | catalog, modifiers, order, pickup/delivery, queue | availability, preparation, fulfillment |
| Retail | Find a suitable item and variant | catalog, options, stock state, request/order | local price, availability, fulfillment |
| Salon or clinic | Obtain a service at a useful time | service catalog, preference, booking/queue | professionals/resources, schedule, status |
| Vehicle service | Choose work and reduce waiting uncertainty | packages, asset details, quote, booking/queue | capacity, assignment, duration, status |
| Accommodation | Request an appropriate stay | dates, occupancy, availability request, extras | inventory, rates, confirmation |
| Professional service | Explain a need and obtain the next step | consultation, quote, appointment, attachments | qualification, assignment, proposal |
| Home service | Request service at a destination | service area, address, time window, quote/booking | routing, assignment, status |
| Mixed retail/service | Buy products and request related work | mixed request, variants, appointment/delivery | separate fulfillment and service ownership |

## Field treatment

| Technical or generic UI | Prefer | Reason |
| --- | --- | --- |
| Currency code alone | Familiar localized name/symbol with stable code available | Preserve canonical value without exposing implementation jargon |
| Category free text | Known sections, contextual suggestions, then an escape hatch | Reduce burden without constraining future businesses |
| Generic placeholder | Example matching business and item kind | Explain the expected content in context |
| Currency on every item | Inherit the owning commercial context and link to settings | Avoid duplicate durable policy |
| Required professional | Safe default such as first available plus optional preference | Support time- and relationship-oriented customers |
| Product-style cart for one service | Request/service flow with optional products or notes | Match intent while allowing mixed needs |
| One fulfillment selector | Composable capabilities with a clear primary path | Businesses often combine operating modes |
| Ambiguous destination labels | Describe who or what moves | Delivery and service at customer location are different operations |
| Long all-purpose settings form | Focused task pages with local save states | Prevent unrelated validation from blocking work |

## Progressive disclosure test

1. Can the person reach a useful submitted or published state with visible
   fields only?
2. Is every visible choice understandable without knowing the internal model?
3. Can reviewed context supply a safe default?
4. Can an unusual business escape the suggested path?
5. Is durable policy edited once at the correct owner level?
6. Does the receiving operation have enough information to act?
7. Can the person recover after validation, interruption, or reconnect?

## Evidence ladder

Rank evidence from team intuition, interview preference, observed attempt,
repeated operational problem, continued owner use without concierge support,
to confirmed customer outcome or willingness to pay. Flexible foundations may
be cheap, but visible complexity and commercial rollout should rise with
evidence.
