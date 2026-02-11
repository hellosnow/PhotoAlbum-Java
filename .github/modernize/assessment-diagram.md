# Photo Album Application - Architecture Diagram

This diagram represents the current architecture of the Photo Album Java application based on assessment analysis.

## Application Overview

The Photo Album is a Spring Boot web application that allows users to upload, store, and view photos. It uses Oracle Database for data persistence and stores photo binary data directly in the database.

## High-Level Architecture

```mermaid
graph TB
    subgraph "Presentation Layer"
        UI[Web Browser]
        Thymeleaf[Thymeleaf Templates]
    end
    
    subgraph "Application Layer - Spring Boot 2.7.18"
        Controllers[Controllers<br/>HomeController<br/>PhotoFileController<br/>DetailController]
        Services[Service Layer<br/>PhotoService]
        Validation[Validation Layer<br/>File Upload Validation]
    end
    
    subgraph "Data Access Layer"
        Repository[Spring Data JPA<br/>PhotoRepository]
        Entities[JPA Entities<br/>Photo Model]
    end
    
    subgraph "Data Storage"
        OracleDB[(Oracle Database<br/>Photo Metadata<br/>Binary Photo Data)]
    end
    
    UI -->|HTTP Requests| Controllers
    Controllers -->|Template Rendering| Thymeleaf
    Thymeleaf -->|HTML Response| UI
    Controllers -->|Business Logic| Services
    Services -->|Validation| Validation
    Services -->|Data Operations| Repository
    Repository -->|JPA/Hibernate| Entities
    Entities -->|JDBC| OracleDB
```

## Technology Stack

```mermaid
graph LR
    subgraph "Runtime"
        Java[Java 8]
    end
    
    subgraph "Framework"
        Spring[Spring Boot 2.7.18<br/>Spring Web MVC<br/>Spring Data JPA<br/>Thymeleaf]
    end
    
    subgraph "Database"
        Oracle[Oracle Database<br/>ojdbc8 Driver]
    end
    
    subgraph "Libraries"
        Commons[Commons IO 2.11.0<br/>File Operations]
        Hibernate[Hibernate ORM<br/>JPA Implementation]
    end
    
    Java --> Spring
    Spring --> Oracle
    Spring --> Commons
    Spring --> Hibernate
```

## Data Flow - Photo Upload Process

```mermaid
sequenceDiagram
    participant User
    participant Controller as PhotoFileController
    participant Service as PhotoService
    participant Validation as File Validation
    participant Repository as PhotoRepository
    participant DB as Oracle Database
    
    User->>Controller: Upload Photo File
    Controller->>Validation: Validate File Type and Size
    Validation-->>Controller: Validation Result
    
    alt Validation Passed
        Controller->>Service: Process Upload
        Service->>Service: Extract Metadata
        Service->>Service: Read Binary Data
        Service->>Repository: Save Photo Entity
        Repository->>DB: Store Metadata and Binary Data
        DB-->>Repository: Confirm Storage
        Repository-->>Service: Photo Entity Saved
        Service-->>Controller: Upload Success
        Controller-->>User: Display Success Message
    else Validation Failed
        Controller-->>User: Display Error Message
    end
```

## Key Components

### 1. Controllers
- **HomeController**: Displays photo gallery homepage
- **PhotoFileController**: Handles photo upload operations
- **DetailController**: Shows individual photo details

### 2. Service Layer
- **PhotoService**: Business logic for photo management
  - File validation
  - Metadata extraction
  - Photo storage coordination

### 3. Data Access
- **PhotoRepository**: Spring Data JPA repository
- **Photo Entity**: JPA entity with photo metadata and binary data

### 4. Storage
- **Oracle Database**: Stores both metadata and binary photo data
  - Uses BLOB storage for photo binary data
  - Indexed by upload timestamp for efficient retrieval

## Configuration Highlights

- **Server Port**: 8080
- **Max File Upload Size**: 10MB per file
- **Max Request Size**: 50MB
- **Allowed MIME Types**: image/jpeg, image/png, image/gif, image/webp
- **Max Files Per Upload**: 10 files
- **Database**: Oracle Database (jdbc:oracle:thin)
- **JPA DDL**: create (auto-create tables)

## Current State Analysis

### Strengths
- Well-structured Spring Boot application with clear layer separation
- Uses Spring Data JPA for database abstraction
- Comprehensive validation for file uploads
- Binary storage in database for simplified deployment

### Considerations for Azure Migration
- **Java Version**: Currently using Java 8 (consider upgrading to Java 11, 17, or 21)
- **Spring Boot Version**: Using 2.7.18 (consider upgrading to Spring Boot 3.x)
- **Database**: Oracle Database (consider migrating to Azure Database for PostgreSQL or Azure SQL)
- **File Storage**: Binary data in database (consider migrating to Azure Blob Storage for scalability)
- **Compute Target**: Can be deployed to:
  - Azure App Service
  - Azure Container Apps
  - Azure Kubernetes Service (AKS)

---

*Generated from application assessment on 2026-02-11*
