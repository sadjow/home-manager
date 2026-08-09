# Research Basis

This reference records the rationale for the skill. It is not required for routine comment drafting.

## Reduce unnecessary processing

Cognitive-load research supports removing irrelevant complexity while preserving the relationships needed for understanding. Meaningful segmentation can help, but the evidence comes mainly from instructional contexts. Applying it to PR comments is an informed design choice, not a validated universal template.

- [Sweller, van Merriënboer, and Paas, 2019](https://doi.org/10.1007/s10648-019-09465-5)
- [Paas and van Merriënboer, 2020](https://doi.org/10.1177/0963721420922183)
- [Rey et al., 2019](https://doi.org/10.1007/s10648-018-9456-4)

Apply this by keeping one concern per comment, putting the conclusion first, and joining the issue, consequence, and next action.

## Make review intent explicit

Google recommends courteous, code-focused comments, an explanation of the reason when useful, a balance between identifying the problem and prescribing the solution, and explicit severity when ambiguity would affect prioritization.

- [How to write code review comments](https://google.github.io/eng-practices/review/reviewer/comments.html)
- [The standard of code review](https://google.github.io/eng-practices/review/reviewer/standard.html)

Apply this by keeping requiredness visible while preserving author choice over valid implementations.

## Use precise code vocabulary

Empirical review research found associations between usefulness and references to relevant code elements or concepts. Other work identifies unclear wording and unclear rationale as common sources of author confusion. These studies do not prove that one comment format is universally best.

- [Rahman, Roy, and Kula, 2018](https://arxiv.org/abs/1807.04485)
- [Turzo and Bosu, 2023](https://arxiv.org/abs/2302.11686)
- [Investigating the Understandability of Review Comments, 2025](https://doi.org/10.1109/MSR66628.2025.00087)

Apply this by naming exact identifiers, states, and conditions and by stating the warranted action.

## Prefer plain language without semantic loss

Plain-language guidance recommends active voice, familiar words, front-loaded information, short paragraphs, and one topic per paragraph. Concision must not remove uncertainty, scope, safety conditions, or technical precision.

- [CPSC Plain Language Principles](https://www.cpsc.gov/About-CPSC/Policies-Statements-and-Directives/plain-language-principles)
- [Microsoft Style Guide: Top 10 tips](https://learn.microsoft.com/en-us/style-guide/top-10-tips-style-voice)

Apply this by removing filler and nested clauses while preserving every semantic constraint.

## Reduce review volume

Review usefulness depends on more than comment count. Repeated, vague, or low-value comments increase the number of decisions the author must process.

- [Bosu, Greiler, and Bird, 2015](https://www.microsoft.com/en-us/research/publication/characteristics-of-useful-code-reviews-an-empirical-study-at-microsoft/)
- [Turzo and Bosu, 2023](https://arxiv.org/abs/2302.11686)

Apply this by suppressing duplicates, consolidating repeated root causes, and ranking strong findings before optional feedback.
