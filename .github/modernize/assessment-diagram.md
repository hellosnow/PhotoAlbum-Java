# Photo Album Application - Architecture Diagram

## Application Overview

Photo Album is a Spring Boot web application for managing and displaying photos with gallery and detail views. It uses Oracle Database for storage with BLOB-based photo persistence.

## Current Architecture Diagram

```mermaid
graph TB
    subgraph "Client Layer"
        Browser[Web Browser]
        UI[Bootstrap 5 UI<br/>Thymeleaf Templates]
    end
    
    subgraph "Application Layer - Spring Boot 2.7.18"
        Controllers[Controllers Layer<br/>HomeController<br/>DetailController<br/>PhotoFileController]
        Services[Service Layer<br/>PhotoService]
        Repositories[Repository Layer<br/>PhotoRepository<br/>Spring Data JPA]
    end
    
    subgraph "Data Layer"
        OracleDB[(Oracle Database 21c XE<br/>PHOTOS Table<br/>BLOB Storage)]
    end
    
    Browser -->|HTTP Requests| UI
    UI -->|MVC Pattern| Controllers
    Controllers -->|Business Logic| Services
    Services -->|Data Access| Repositories
    Repositories -->|JDBC/JPA| OracleDB
    
    style Browser fill:#e1f5ff
    style UI fill:#fff4e1
    style Controllers fill:#ffe1e1
    style Services fill:#e1ffe1
    style Repositories fill:#f0e1ff
    style OracleDB fill:#ffe1f5
```

## Technology Stack

```mermaid
graph LR
    subgraph "Frontend"
        A[Bootstrap 5.3.0]
        B[Thymeleaf]
        C[JavaScript]
    end
    
    subgraph "Backend Framework"
        D[Spring Boot 2.7.18]
        E[Spring Web MVC]
        F[Spring Data JPA]
        G[Hibernate ORM]
    end
    
    subgraph "Database"
        H[Oracle 21c Express]
        I[JDBC Driver ojdbc8]
    end
    
    subgraph "Build and Runtime"
        J[Maven]
        K[Java 8]
        L[Docker]
    end
    
    style A fill:#e1f5ff
    style B fill:#e1f5ff
    style C fill:#e1f5ff
    style D fill:#ffe1e1
    style E fill:#ffe1e1
    style F fill:#ffe1e1
    style G fill:#ffe1e1
    style H fill:#f0e1ff
    style I fill:#f0e1ff
    style J fill:#fff4e1
    style K fill:#fff4e1
    style L fill:#fff4e1
```

## Application Flow - Photo Upload

```mermaid
sequenceDiagram
    participant User
    participant Browser
    participant Controller as PhotoFileController
    participant Service as PhotoService
    participant Repository as PhotoRepository
    participant DB as Oracle Database
    
    User->>Browser: Upload Photo Files
    Browser->>Controller: POST request with files
    Controller->>Controller: Validate file type and size
    Controller->>Service: Process photo upload
    Service->>Service: Extract metadata dimensions
    Service->>Service: Generate UUID
    Service->>Repository: Save Photo entity
    Repository->>DB: Store photo data as BLOB
    DB-->>Repository: Confirm saved
    Repository-->>Service: Return Photo entity
    Service-->>Controller: Return UploadResult
    Controller-->>Browser: JSON response with success
    Browser-->>User: Display gallery update
```

## Application Flow - Photo Display

```mermaid
sequenceDiagram
    participant User
    participant Browser
    participant Controller as HomeController/DetailController
    participant Service as PhotoService
    participant Repository as PhotoRepository
    participant DB as Oracle Database
    
    User->>Browser: Request Gallery or Detail View
    Browser->>Controller: GET request
    Controller->>Service: Request photo list or single photo
    Service->>Repository: Query photos
    Repository->>DB: SELECT from PHOTOS table
    DB-->>Repository: Return photo metadata
    Repository-->>Service: Return Photo entities
    Service-->>Controller: Return photos
    Controller->>Controller: Add to Model
    Controller-->>Browser: Render Thymeleaf template
    Browser->>Controller: Request photo binary data
    Controller->>Service: Get photo by ID
    Service->>Repository: Find photo
    Repository->>DB: SELECT PHOTO_DATA BLOB
    DB-->>Repository: Return BLOB data
    Repository-->>Service: Return Photo with data
    Service-->>Controller: Return photo bytes
    Controller-->>Browser: Stream image bytes
    Browser-->>User: Display photos
```

## Data Model

```mermaid
erDiagram
    PHOTOS {
        VARCHAR2_36 ID PK "UUID Primary Key"
        VARCHAR2_255 ORIGINAL_FILE_NAME "Original filename"
        VARCHAR2_255 STORED_FILE_NAME "Stored filename"
        VARCHAR2_500 FILE_PATH "File path (nullable)"
        NUMBER FILE_SIZE "File size in bytes"
        VARCHAR2_50 MIME_TYPE "Image MIME type"
        TIMESTAMP UPLOADED_AT "Upload timestamp"
        NUMBER WIDTH "Image width pixels"
        NUMBER HEIGHT "Image height pixels"
        BLOB PHOTO_DATA "Binary photo data"
    }
```

## Key Components and Dependencies

### Spring Boot Dependencies
- **spring-boot-starter-web**: Web MVC framework
- **spring-boot-starter-thymeleaf**: Server-side templating
- **spring-boot-starter-data-jpa**: ORM and data access
- **spring-boot-starter-validation**: Input validation

### Database Dependencies
- **ojdbc8**: Oracle JDBC driver for database connectivity

### Utilities
- **commons-io (2.11.0)**: File operation utilities

## Storage Architecture

- **Photo Storage**: BLOB (Binary Large Object) in Oracle Database
- **Benefits**: 
  - No file system dependencies
  - ACID compliance
  - Simplified backup
  - Container-friendly
- **Trade-offs**: Database size increases with photo volume

## Deployment Architecture

```mermaid
graph TB
    subgraph "Docker Environment"
        subgraph "App Container"
            SpringBoot[Spring Boot App<br/>Port 8080<br/>Java 8]
        end
        
        subgraph "DB Container"
            Oracle[Oracle 21c XE<br/>Port 1521<br/>Enterprise Manager 5500]
        end
        
        SpringBoot -->|JDBC Connection| Oracle
    end
    
    Client[Web Browser] -->|HTTP 8080| SpringBoot
    Admin[Database Admin] -->|HTTP 5500| Oracle
    
    style SpringBoot fill:#ffe1e1
    style Oracle fill:#f0e1ff
    style Client fill:#e1f5ff
    style Admin fill:#e1f5ff
```

## Configuration Management

- **Application Properties**: application.properties, application-docker.properties
- **Server Configuration**: Port 8080, UTF-8 encoding
- **Database Configuration**: Oracle connection, JPA/Hibernate settings
- **File Upload Limits**: 10MB per file, 50MB per request
- **Allowed MIME Types**: image/jpeg, image/png, image/gif, image/webp

## Assessment Summary

### Application Type
- **Framework**: Spring Boot 2.7.18
- **Pattern**: MVC (Model-View-Controller)
- **Architecture**: Layered (Controller, Service, Repository)

### Key Features
- Photo upload with drag-and-drop
- Gallery view with responsive grid
- Detail view with navigation
- BLOB-based database storage
- File validation and metadata extraction

### Technology Assessment
- **Java Version**: 1.8 (Legacy, consider upgrading to Java 11 or 17)
- **Spring Boot Version**: 2.7.18 (Mature but not latest)
- **Database**: Oracle 21c Express Edition
- **Build Tool**: Maven
- **Containerization**: Docker and Docker Compose ready
