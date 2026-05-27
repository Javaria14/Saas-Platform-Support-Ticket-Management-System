# SaaS Support Ticket Management System

A relational database system built in SQL Server for managing customer support tickets end-to-end from submission to resolution.

---

## Database Schema

9 tables covering the full ticket lifecycle:

| Table | Purpose |
|---|---|
| `Roles` | Defines user roles: Admin, Agent, Customer |
| `Users` | All system users with role assignment |
| `Tickets` | Core table — stores all support tickets |
| `Ticket_Status` | Status values: New → Assigned → In Progress → Resolved → Closed |
| `Ticket_Priority` | Priority levels: Low, Medium, High |
| `Categories` | Ticket categories: Technical, Billing, Account |
| `SLA` | Response & resolution time limits per priority |
| `Ticket_Assignments` | Maps tickets to agents |
| `Responses` | Public and internal (agent-only) replies |
| `Ticket_History` | Full audit log of every status change |

---

## SLA Policy

| Priority | Response Time | Resolution Time |
|---|---|---|
| Low | 48 hrs | 72 hrs |
| Medium | 24 hrs | 48 hrs |
| High | 12 hrs | 24 hrs |

---

## Key Queries

- Tickets filtered by status, priority, or category
- Agent workload — ticket count per agent
- Agents with more than one assigned ticket (`HAVING`)
- Internal-only responses (`is_internal = 1`)
- Users involved in the system as creators or agents (`DISTINCT` + multiple `LEFT JOIN`)
- Subqueries for highest-priority tickets and users who raised tickets
- Aggregations: total tickets, average resolution time, tickets by status/priority

---

## How to Run

1. Open SQL Server Management Studio (SSMS)
2. Run `dbms project.sql` — it creates the database, all tables, sample data, and queries in one script

---

## Tech

- **SQL Server** (T-SQL)
- Concepts used: DDL, DML, JOINs, subqueries, GROUP BY, HAVING, aggregations, foreign keys, default constraints


