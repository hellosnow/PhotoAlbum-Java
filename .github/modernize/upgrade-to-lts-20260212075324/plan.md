# Upgrade Plan

## Overview
Upgrade Java project to latest LTS versions: Java 21 and Spring Boot 3.4.

## Tasks
See `tasks.json` for detailed task breakdown and execution requirements.

## Target Versions
- **Java**: 21 (LTS)
- **Spring Boot**: 3.4
- **Spring Framework**: 6.x (included with Spring Boot 3.4)
- **Jakarta EE**: Migration from javax.* to jakarta.* namespace as needed

## Success Criteria
- Project must build successfully
- All existing unit tests must pass
- Dependencies updated to compatible versions
