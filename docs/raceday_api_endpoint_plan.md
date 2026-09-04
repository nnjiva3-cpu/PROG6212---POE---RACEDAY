# RaceDay API Endpoint Plan

This document lists every API endpoint planned for the RaceDay system, covering Authentication, User Profile, Events, Categories, Event Enrolments, and Results. This plan was completed before any Part 2 application code was written, and the implemented API is expected to closely match this table.

**Roles referenced below:**
- **None (public)** — no login required
- **Any (logged in)** — any authenticated user, regardless of role
- **Organiser** — an authenticated user with the Organiser role
- **Participant** — an authenticated user with the Participant role

---

## Authentication

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| POST | /api/auth/register | Registers a new user as either an Organiser or a Participant. | None (public) | `{ name, email, password, role }` | 201 Created — returns the new user (without password) <br> 400 Bad Request — missing/invalid fields <br> 409 Conflict — email already registered |
| POST | /api/auth/login | Authenticates a user and returns a JWT access token. | None (public) | `{ email, password }` | 200 OK — returns `{ token, user }` <br> 401 Unauthorized — invalid credentials |

## User Profile

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| GET | /api/users/me | Returns the profile of the currently logged-in user. | Any (logged in) | None | 200 OK — returns user object <br> 401 Unauthorized |
| PUT | /api/users/me | Updates the currently logged-in user's profile details. | Any (logged in) | `{ name, email }` | 200 OK — returns updated user <br> 400 Bad Request <br> 401 Unauthorized |

## Events

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| GET | /api/events | Lists all events, optionally filtered by status or date. | None (public) | None | 200 OK — returns array of events |
| GET | /api/events/{id} | Returns the details of a single event, including its categories. | None (public) | None | 200 OK — returns event object <br> 404 Not Found |
| POST | /api/events | Creates a new event owned by the logged-in Organiser. | Organiser | `{ title, description, event_date, location }` | 201 Created — returns new event <br> 400 Bad Request <br> 401 Unauthorized |
| PUT | /api/events/{id} | Updates an event that belongs to the logged-in Organiser. | Organiser (owner only) | `{ title, description, event_date, location, status }` | 200 OK — returns updated event <br> 403 Forbidden — not the event owner <br> 404 Not Found |
| DELETE | /api/events/{id} | Deletes an event that belongs to the logged-in Organiser. | Organiser (owner only) | None | 204 No Content <br> 403 Forbidden <br> 404 Not Found |

## Categories

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| GET | /api/categories | Lists all categories available in the system (e.g. 5km, 10km). | None (public) | None | 200 OK — returns array of categories |
| POST | /api/categories | Creates a new category. | Organiser | `{ name }` | 201 Created — returns new category <br> 409 Conflict — category already exists |
| POST | /api/events/{id}/categories | Attaches an existing category to a specific event. | Organiser (owner only) | `{ category_id }` | 201 Created — returns the event-category link <br> 403 Forbidden <br> 404 Not Found — event or category does not exist |
| GET | /api/events/{id}/categories | Lists all categories attached to a specific event. | None (public) | None | 200 OK — returns array of categories <br> 404 Not Found |

## Event Enrolments

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| POST | /api/event-categories/{id}/enrol | Enrols the logged-in Participant into a specific event category. | Participant | None | 201 Created — returns new enrolment <br> 404 Not Found — event category does not exist <br> 409 Conflict — already enrolled |
| GET | /api/users/me/enrolments | Lists all enrolments belonging to the logged-in Participant. | Participant | None | 200 OK — returns array of enrolments |
| DELETE | /api/enrolments/{id} | Cancels an enrolment belonging to the logged-in Participant. | Participant (owner only) | None | 204 No Content <br> 403 Forbidden <br> 404 Not Found |

## Results

| HTTP Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| POST | /api/enrolments/{id}/result | Records a result (finish time and position) for a participant's enrolment. | Organiser (of that event only) | `{ finish_time, position }` | 201 Created — returns new result <br> 403 Forbidden — not the organiser of this event <br> 404 Not Found |
| GET | /api/events/{id}/results | Returns all results for a specific event, ordered by position. | None (public) | None | 200 OK — returns array of results <br> 404 Not Found |

---

*Note: This plan covers all functionality required by the brief (Authentication, User Profile, Events, Categories, Event Enrolments, Results). Any additional endpoints identified during Part 2 implementation should be added here with a note explaining the deviation, per the README requirement.*
