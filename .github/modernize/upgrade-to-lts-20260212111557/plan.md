# Upgrade Plan: Upgrade to Latest LTS Versions

## Overview

This plan upgrades the Java application to the latest Long-Term Support (LTS) versions:
- **Java 21** (latest LTS)
- **Spring Boot 3.4** (latest stable with Spring Framework 6.x)

The upgrade includes migrating to Jakarta EE namespace and updating all dependencies to compatible versions.

## Tasks

See `tasks.json` for the detailed task breakdown with execution order, dependencies, and success criteria.

## Execution Order

1. Upgrade Java to version 21
2. Upgrade Spring Boot to version 3.4 (depends on Java upgrade)
3. Update all project dependencies (depends on Spring Boot upgrade)
