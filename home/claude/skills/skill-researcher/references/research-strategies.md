# Research Strategies

## Search Query Patterns

### Breadth-first discovery
Start broad, then narrow based on findings:
1. `"[topic] best practices"` - current conventions
2. `"[topic] common mistakes"` - anti-patterns to document
3. `"[topic] vs [alternative]"` - comparison insights
4. `"[topic] advanced patterns"` - expert-level knowledge

### Framework/library research
1. `"[name] official documentation"` - authoritative source
2. `"[name] changelog latest"` - recent changes
3. `"[name] migration guide"` - breaking changes
4. `"[name] real world examples"` - practical patterns

### Problem-domain research
1. `"[domain] architecture patterns"` - structural approaches
2. `"[domain] production lessons learned"` - battle-tested insights
3. `"[domain] testing strategies"` - quality assurance

## Source Evaluation

### Priority order
1. **Official documentation** - most authoritative
2. **Core team blog posts / RFCs** - design rationale
3. **Reputable tech blogs** (engineering blogs from known companies)
4. **Conference talks / workshops** - practitioner insights
5. **Community resources** (Stack Overflow, forums) - practical solutions

### Quality signals
- Recency (prefer recent content)
- Author credibility (core contributors, known practitioners)
- Specificity (concrete examples > vague advice)
- Consistency across multiple sources

## Synthesis Approach

### Extract actionable knowledge
For each source, capture:
- **Patterns**: reusable approaches with code examples
- **Anti-patterns**: what to avoid and why
- **Configuration**: non-obvious setup details
- **Edge cases**: gotchas Claude would not know

### Filter for skill relevance
Include only knowledge that:
- Claude does not already possess (non-obvious)
- Requires procedural steps (not just facts)
- Changes how code is written (actionable)
- Saves time when repeated (reusable)

### Organize by progressive disclosure
- Core workflow and essential patterns go in SKILL.md
- Detailed references, variant-specific guides go in references/
- Large code templates go in assets/
