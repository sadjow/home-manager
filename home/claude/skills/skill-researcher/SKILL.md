---
name: skill-researcher
description: |
  Research concepts, technologies, and best practices from the internet to create or refine Claude Code skills with up-to-date, expert-level knowledge. Use when: (1) Creating a new skill and needing to research the subject first, (2) Refining an existing skill with current best practices, (3) User asks to "research [topic] for a skill", (4) User wants a skill informed by latest documentation and community patterns, (5) Enriching a skill with knowledge beyond Claude's training data.
---

# Skill Researcher

Research topics from the web and synthesize findings into well-structured skill content.

## Workflow

1. **Clarify scope** - Identify the subject, target skill, and research goals
2. **Research** - Search the web for authoritative, current knowledge
3. **Synthesize** - Extract actionable patterns, filter for skill relevance
4. **Produce** - Create or update the skill with researched knowledge

## Step 1: Clarify Scope

Determine before researching:
- **Subject**: What topic/technology/concept to research
- **Target**: Creating a new skill or refining an existing one?
- **Goals**: What specific knowledge gaps to fill (best practices, patterns, anti-patterns, configuration, API details)

If refining an existing skill, read it first to identify gaps.

## Step 2: Research

Use `WebSearch` and `WebFetch` to gather knowledge. See [references/research-strategies.md](references/research-strategies.md) for query patterns and source evaluation criteria.

### Research phases

**Phase 1 - Official sources**: Search for official documentation, guides, and changelogs. Fetch and extract key patterns.

**Phase 2 - Community wisdom**: Search for blog posts, conference talks, and real-world usage patterns. Focus on battle-tested advice.

**Phase 3 - Anti-patterns**: Search for common mistakes, pitfalls, and migration issues. These are high-value for skills.

### Research guidelines

- Run 3-6 targeted searches per phase (not more - diminishing returns)
- Prefer recent content
- Cross-reference findings across multiple sources
- Capture concrete code examples, not just descriptions
- Note version-specific details (breaking changes, deprecations)

## Step 3: Synthesize

Filter research through these criteria:

**Include** knowledge that is:
- Non-obvious to Claude (procedural, version-specific, configuration)
- Actionable (changes how code is written)
- Reusable (applies across multiple tasks)

**Exclude** knowledge that is:
- General programming advice Claude already knows
- Overly theoretical without practical application
- Outdated or contradicted by multiple sources

Organize findings into:
- **Core patterns** (go in SKILL.md body)
- **Detailed references** (go in references/ files)
- **Code templates** (go in assets/ if substantial)

## Step 4: Produce

### New skill
Follow the skill-creator workflow. Use research findings as the primary content source. Structure using progressive disclosure - core knowledge in SKILL.md, details in references/.

### Refining existing skill
1. Read the current skill files
2. Identify where research findings improve or complement existing content
3. Update SKILL.md and reference files with new knowledge
4. Remove outdated information replaced by research findings

### Quality checks
- Every pattern includes a concise code example
- Anti-patterns explain *why* to avoid (not just *what*)
- Version/compatibility notes are explicit
- Content follows skill-creator guidelines (concise, imperative form, progressive disclosure)
