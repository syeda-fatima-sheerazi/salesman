<!--
  This file is the master template for the create-spec skill.

  It ships bundled with the skill. The first time create-spec runs in a
  project that has no spec template of its own, it copies this file
  verbatim into that project's specs folder (as sample-spec.md) so the
  format becomes a durable, in-repo convention — visible to humans, to
  future runs of create-spec, and to any other agent working in the repo.

  From that point on, THIS project's copy is authoritative, not the
  bundled one. If a team edits their in-repo sample-spec.md to better fit
  how they work, create-spec follows their version, not this one. Feel
  free to edit the placeholder text below (not the section headings) once
  it's living in a project.

  Delete this comment block when adapting the template for a real spec —
  it's instructional, not part of the document shape.
-->

# <Feature / Change Name>

> **Status:** Draft
> **Author:** <name, team, or "AI-generated from prompt">
> **Date:** <YYYY-MM-DD>
> **Related:** <ticket links, related specs, related plans — or "N/A">

## Summary

2–4 sentences: what is being built and why, written so a non-technical
stakeholder could follow it. This is the paragraph someone reads if they
only read one paragraph.

## Problem Statement

What user pain point, business need, or technical gap this addresses.
Include the "why now" if it's known — what prompted this to be written
today rather than earlier or later.

## Goals

Specific, measurable outcomes this change is responsible for achieving.

- ...

## Non-goals

Explicitly out of scope — stated on purpose, so scope doesn't quietly
creep during implementation. If nothing is out of scope, say so
explicitly rather than omitting the section.

- ...

## User Stories / Use Cases

- As a <role>, I want to <action>, so that <benefit>.

## Functional Requirements

Numbered and independently testable — "the system must X when Y" — not
vague aspiration like "the system should handle errors well."

1. ...

## UX / UI Requirements

Only for user-facing changes — mark "N/A" otherwise, don't delete the
heading. Describe the expected screens/states (empty, loading, error,
success, offline if relevant) in words. Explicitly note where this must
follow the project's existing design system — real design tokens,
color/typography scale, spacing units, and component library found
during research, cited by name or file, not generic placeholders like
"use nice colors." If no visual mock exists, describe the layout and
flow in enough detail that someone could sketch it.

## Technical Context & Constraints

Grounded in the real codebase, not aspirational — this is what lets an
implementer (human or agent) trust the spec instead of re-deriving
context from scratch. Cite actual files as examples wherever possible.

- **Architecture:** the pattern/layering this change must fit into.
- **State management:** the approach already in use (and where it's
  used elsewhere in the codebase, as a concrete example to mirror).
- **Coding style / conventions:** naming, formatting, linting rules,
  and any project-specific idioms this change must follow.
- **Governance constraints:** relevant do's and don'ts pulled from
  AGENTS.md, CLAUDE.md, or other rules files — quote or paraphrase the
  specific rule, don't just say "follow project conventions."
- **Existing modules/files this touches or should mirror:** ...

## Data Model / API Contract

New or changed schemas, endpoints, request/response shapes, database
migrations — or "N/A".

## Dependencies & Integrations

New packages, external services, feature flags, or other in-flight
specs/plans this depends on or blocks — or "N/A".

## Edge Cases & Error Handling

What can go wrong, and what the system should do about it — invalid
input, network failure, concurrent edits, permission boundaries, empty
states, rate limits, partial failure, etc.

- ...

## Non-functional Requirements

Performance, security, accessibility, scalability, internationalization
/localization, offline behavior, observability/logging. Include only
what's relevant to this change, but state "N/A" explicitly for
categories that don't apply rather than dropping them — a reader
shouldn't have to guess whether accessibility was considered and ruled
out, or just never thought about.

- **Performance:** ...
- **Security:** ...
- **Accessibility:** ...
- **Scalability:** ...
- **Internationalization:** ...
- **Observability:** ...

## Acceptance Criteria

Concrete and checkable — this is the definition of done, and what a
reviewer (or do-plan, when it turns this into an implementation plan)
will hold the finished work to.

- [ ] ...

## Assumptions & Open Questions

- Assumptions made where the original request was ambiguous, and the
  reasoning behind each.
- Anything unresolved that needs a human decision before this moves to
  implementation planning.

## Out of Scope / Future Considerations

Related ideas deliberately deferred, so they're on record without
inflating this change's scope.

- ...
