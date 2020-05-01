# General Assembly Web Portal

![Logo](https://general-assembly-portal.herokuapp.com/general-assembly-banner.jpg)

[Access the GA web portal here](https://general-assembly-portal.herokuapp.com/)

My goal for this app is to create a staff portal for Instructors at General Assembly. The app utilises the following Ruby Gems to function:
- PG
- HTTParty
- Bcrypt
- Sinatra

I've also leveraged on the Random User Generator API designed Arron Hunt, and developed by Keith Armstrong, in order to generate placeholder dummy data to populate the student database.

The web portal I've created utilises two databases: one for students, and another for instructors. At this stage, the portal is for staff only, with the goal of expanding the login to include creating separate interfaces for different user categories.

# Thought Process

## Mocking up a wireframe

The first step is to create a storyboard, setting up a brief for myself with deliverables on each page.

This planning stage ensures coherence of design theme across all pages, and dictates the coding strucure to avoid doing too much redundant code.

## Establishing routes and methods

Through trial and error during the coding process, some routes were modified, before landing on this eventual control flow.