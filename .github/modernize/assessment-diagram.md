# PhotoAlbum Application Architecture Diagram

This diagram shows the high-level architecture of the PhotoAlbum Java application based on the assessment analysis.

## Application Architecture

```mermaid
graph TB
    subgraph "Presentation Layer"
        A[Web Browser]
        B[Thymeleaf Templates]
    end
    
    subgraph "Application Layer - Spring Boot 2.7.18"
        C[HomeController]
        D[DetailController]
        E[PhotoFileController]
        F[PhotoService]
    end
    
    subgraph "Data Access Layer"
        G[PhotoRepository]
        H[Spring Data JPA]
    end
    
    subgraph "Data Storage"
        I[(Oracle Database)]
        J[File System - Photo Storage]
    end
    
    A -->|HTTP Requests| C
    A -->|HTTP Requests| D
    A -->|HTTP Requests| E
    
    C -->|Render Views| B
    D -->|Render Views| B
    E -->|Render Views| B
    
    C -->|Business Logic| F
    D -->|Business Logic| F
    E -->|Photo Upload/Download| F
    
    F -->|Data Operations| G
    F -->|File Operations| J
    
    G -->|JPA Operations| H
    H -->|JDBC| I
    
    style A fill:#e1f5ff
    style B fill:#fff4e6
    style C fill:#e8f5e9
    style D fill:#e8f5e9
    style E fill:#e8f5e9
    style F fill:#fff3e0
    style G fill:#f3e5f5
    style H fill:#f3e5f5
    style I fill:#ffebee
    style J fill:#ffebee
```

## Technology Stack

### Framework & Runtime
- **Framework**: Spring Boot 2.7.18
- **Java Version**: Java 8 (JDK 1.8)
- **Build Tool**: Maven

### Web Layer
- **Web Framework**: Spring MVC (spring-boot-starter-web)
- **Template Engine**: Thymeleaf
- **REST Controller**: Spring REST

### Data Layer
- **ORM**: Spring Data JPA with Hibernate
- **Database**: Oracle Database (Oracle JDBC Driver - ojdbc8)
- **Database Dialect**: OracleDialect
- **Connection**: JDBC (jdbc:oracle:thin)

### File Processing
- **File Upload**: Spring Multipart (max 10MB per file, 50MB per request)
- **File Operations**: Apache Commons IO 2.11.0
- **Image Processing**: Spring Boot JSON Starter
- **Allowed Formats**: JPEG, PNG, GIF, WebP

### Additional Libraries
- **Validation**: Spring Boot Validation
- **Development**: Spring Boot DevTools
- **Testing**: Spring Boot Test, H2 Database (test scope)

## Component Descriptions

### Presentation Layer
- **Web Browser**: User interface for accessing the photo album
- **Thymeleaf Templates**: Server-side HTML rendering engine

### Application Layer (Controllers & Services)
- **HomeController**: Main landing page and photo gallery display
- **DetailController**: Individual photo detail views
- **PhotoFileController**: Handles photo upload and download operations
- **PhotoService**: Business logic for photo management

### Data Access Layer
- **PhotoRepository**: Spring Data JPA repository for database operations
- **Spring Data JPA**: Abstraction layer for data persistence

### Data Storage
- **Oracle Database**: Primary data store for photo metadata
- **File System**: Physical storage for photo files

## Key Features
- Photo upload with validation (size, type, count limits)
- Photo gallery display
- Photo detail viewing
- File system storage with database metadata tracking
- Multi-file upload support (up to 10 files per request)

## Architecture Pattern
- **Pattern**: Traditional 3-tier MVC architecture
- **Layer 1**: Presentation (Thymeleaf + Controllers)
- **Layer 2**: Business Logic (Services)
- **Layer 3**: Data Access (Repositories + JPA)

## Deployment Configuration
- **Server Port**: 8080
- **Character Encoding**: UTF-8
- **Database**: Oracle Database running on oracle-db:1521
- **Schema**: FREEPDB1
- **Hibernate DDL**: create (auto-create schema)
