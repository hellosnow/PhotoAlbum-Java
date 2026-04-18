# Modernization Plan: Photo Album Upgrade

**Project**: Photo Album

---

## Technical Framework

- **Language**: Java 1.8
- **Framework**: Spring Boot 2.7.18
- **Build Tool**: Maven 3.9
- **Database**: Oracle (JDBC thin driver)
- **Key Dependencies**: Spring Data JPA, Thymeleaf,
  Hibernate, Commons IO, Spring Validation

---

## Overview

> This migration upgrades the Photo Album application
> from legacy Java 8 and Spring Boot 2.7.18 to modern
> supported versions, and addresses assessment-identified
> issues including Oracle database dependency and
> plaintext credentials in configuration files.
>
> The application currently runs on Java 8 with
> Spring Boot 2.7.18, uses Oracle DB with
> Oracle-specific SQL queries, and stores database
> credentials as plaintext in properties files.
>
> The modernization will:
>
> - Upgrade Java and Spring Boot to latest supported
>   LTS versions for long-term support and security
> - Migrate from Oracle to Azure Database for
>   PostgreSQL for cloud-native database management
> - Externalize credentials to Azure Key Vault for
>   secure secrets management
>
> The migration follows a phased approach: framework
> upgrade first, then database migration, then
> credential externalization.

---

## Migration Impact Summary

| Application | Original Service  | New Azure Service              | Authentication | Comments            |
|-------------|-------------------|--------------------------------|----------------|---------------------|
| Photo Album | Java 8            | Java 21                        | N/A            | Runtime upgrade     |
| Photo Album | Spring Boot 2.7   | Spring Boot 3.x                | N/A            | Framework upgrade   |
| Photo Album | Oracle DB         | Azure DB for PostgreSQL        | Managed Identity | DB migration      |
| Photo Album | Plaintext creds   | Azure Key Vault                | Managed Identity | Secrets mgmt      |
