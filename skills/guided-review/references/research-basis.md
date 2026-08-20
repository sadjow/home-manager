# Guided Review Research Basis

This reference records the evidence and limits behind the guided-review workflow. It is not required for routine use.

## Start with purpose and the main change

Google's reviewer guidance recommends taking a broad view, examining the most important part first, and then choosing an appropriate sequence for the rest. GitHub's current documentation likewise emphasizes understanding the pull request's motivation and linked context before line-level review.

- [Google: Navigating a CL in review](https://google.github.io/eng-practices/review/reviewer/navigate.html)
- [GitHub: Reviewing proposed changes in a pull request](https://docs.github.com/en/pull-requests/how-tos/review-pull-requests/reviewing-proposed-changes-in-a-pull-request)

Apply this by orienting the reviewer before showing a file inventory and by making the core mechanism visible early.

## Group related change parts

Baum, Schneider, and Bacchelli developed a middle-range theory from interviews, a survey, and prior research. Their principal result is that a helpful review order is mainly a helpful grouping of change parts by relatedness. The study does not establish one universal file order.

- [On the Optimal Order of Reading Source Code Changes for Review](https://doi.org/10.1109/ICSME.2017.28)

Apply this by grouping behavioral and dependent changes together instead of accepting alphabetical file order or inventing fixed-size chunks.

## Decompose without overclaiming

In a controlled experiment with 28 professional and graduate-student developers, Di Biase and colleagues found that conceptually decomposed changes produced fewer wrongly reported issues and more context-seeking. They did not find an improvement in defect discovery or understanding of the change rationale.

- [The effects of change decomposition on code review](https://arxiv.org/abs/1805.10978)

Apply this by using coherent parts to reduce navigation noise. Do not claim that segmentation alone makes the review complete or more accurate.

## Use an adaptive, interactive strategy

A 2025 observational study followed ten experienced reviewers through 25 real review sessions. Most began with context building. Larger changes prompted difficulty-based reading and chunking; some reviewers started from the core and followed data or execution flow. The study also describes review comprehension as scoped, incremental, iterative, and interactive.

- [Code Review Comprehension: Reviewing Strategies Seen Through Code Comprehension Theories](https://arxiv.org/abs/2503.21455)

Apply this by choosing an order from the actual diff, walking through one part at a time, preserving a whole-change map, and letting the human redirect the session. The small qualitative sample supports useful design hypotheses, not mandatory universal steps.

A separate 2025 mining study examined first-round comments from 23,241 pull requests across 100 Java and Python repositories. It found several non-alphabetical patterns, including test-first, largest-diff-first, and description-related orders, but no single pattern explained reviewer behavior across contexts. Comment order is only a proxy for reading order, and the sample excluded reviews with fewer than two commented files.

- [Not One to Rule Them All: Mining Meaningful Code Review Orders From GitHub](https://doi.org/10.1145/3756681.3756961)

Apply this by making the chosen order transparent and revisable rather than hard-coding one strategy for every change.

## Externalize progress

GitHub supports file filtering, a file tree, per-file viewed state, and review progress. These features demonstrate the practical value of external progress tracking, although GitHub's file-at-a-time interface does not determine the best semantic grouping.

- [GitHub: Reviewing proposed changes in a pull request](https://docs.github.com/en/pull-requests/how-tos/review-pull-requests/reviewing-proposed-changes-in-a-pull-request)

Apply this by maintaining a part map, file coverage, questions, and parked observations without forcing the human to remember the entire diff.

## Human-in-the-loop boundary

The sources above study human review and code comprehension. They do not prove that an AI-guided walkthrough improves defect detection, review time, or understanding in every setting. Treat this workflow as an evidence-informed support pattern. Validate it through real review sessions, human corrections, missed coverage, intervention count, and whether reviewers can accurately explain the change after the walkthrough.
