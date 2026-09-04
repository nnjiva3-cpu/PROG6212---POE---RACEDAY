# RaceDay - PROG6212 POE (Part 1)

## System Description

RaceDay is a system for managing race events. Organisers can create and
manage events (e.g. marathons, fun runs, trail challenges), each of which
can have multiple categories (e.g. 5km, 10km, Half Marathon). Participants
can browse events, enrol in a specific event category, and view their
results once the event has taken place. 

This repository contains the Part 1 planning deliverables: the Entity
Relationship Diagram (ERD), the API endpoint plan, and the SQL script
that creates and seeds the database schema.

## Roles

- **Organiser** — can create, update, and delete their own events; can
  attach categories to events; can record results for participants
  enrolled in their events.
- **Participant** — can browse events and categories, enrol in an event
  category, view their own enrolments, and view results.

## Repository Structure

```
/docs
  raceday_erd.png                  - Entity Relationship Diagram
  raceday_api_endpoint_plan.md     - API endpoint specification table
  raceday_schema.sql               - SQL Server database creation script
README.md                          - this file
```

## CI/CD

A GitHub Actions workflow (`.github/workflows/validate-structure.yml`)
runs on every push and pull request to `main`. It checks that:
- the `/docs` folder exists
- the ERD, endpoint plan, and SQL script are present inside it
- `README.md` exists at the repository root

## Video Walkthrough

Unlisted YouTube video walking through the planning documents, the ERD
decisions, the endpoint plan choices, and running the SQL script live in
SSMS:

**Video link:** _(insert your unlisted YouTube link here)_
