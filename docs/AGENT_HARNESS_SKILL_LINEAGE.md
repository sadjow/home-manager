# Agent Harness Skill Lineage

This diagram shows how a portable personal capability can benefit a project while both owners retain an independent, useful version. It is human-facing documentation and is intentionally kept outside the agent-loaded skill instructions.

```mermaid
flowchart TB
  portable["Personal harness · Home Manager<br/>Portable principle or skill<br/>canonical personal source"]
  adopt{"Does this project<br/>choose to adopt it?"}
  unchanged["No project change"]
  projectCopy["Project harness · repository<br/>Self-contained project-owned<br/>copy or adaptation"]
  specialize["Add project rules, examples,<br/>commands, and checks"]
  feedback["Use it and identify<br/>a validated learning"]
  retain["Retain the full-fidelity learning<br/>in the project harness"]
  generalized["Distill the abstract principle<br/>remove all project-specific content"]
  improve["Improve the personal source<br/>without removing the project copy"]

  portable -->|"Propose"| adopt
  adopt -->|"Yes · seed and record provenance"| projectCopy
  adopt -->|"No"| unchanged
  projectCopy --> specialize --> feedback
  feedback -->|"Always retain in the project"| retain
  retain -->|"Improve project copy"| projectCopy
  feedback -->|"Abstract for personal use"| generalized --> improve
  improve -. "Next project or reviewed refresh" .-> portable
```

Every validated project learning follows both paths. The project retains the full-fidelity learning in its own harness. The personal harness receives a new abstract representation that contains no project-specific content. Authorization is not a decision point in this loop; abstraction is the boundary.

The personal source survives loss of project access. The project-owned version survives a contributor's departure and can start as an identical snapshot or an immediate adaptation. Secrets, confidential knowledge, private identifiers, and proprietary project details remain in the project. When frequent synchronization makes two independent copies expensive, move the shared core to a neutral source that both owners can review.
