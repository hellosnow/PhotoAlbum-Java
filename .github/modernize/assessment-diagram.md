# Photo Album Application - Architecture Diagram

## Application Overview

This is a Spring Boot-based photo gallery application that allows users to upload, view, and manage photos. Photos are stored as BLOBs in Oracle Database.

## Architecture Diagram

```mermaid
graph TB
    subgraph "Presentation Layer"
        UI[Web Browser]
        Thymeleaf[Thymeleaf Templates]
    end
    
    subgraph "Application Layer - Spring Boot 2.7.18"
        Controllers[Controllers Layer]
        HomeCtrl[HomeController]
        PhotoCtrl[PhotoFileController]
        DetailCtrl[DetailController]
        
        Services[Service Layer]
        PhotoSvc[PhotoService]
        PhotoSvcImpl[PhotoServiceImpl]
        
        Controllers --> HomeCtrl
        Controllers --> PhotoCtrl
        Controllers --> DetailCtrl
        
        Services --> PhotoSvc
        Services --> PhotoSvcImpl
    end
    
    subgraph "Data Access Layer"
        JPA[Spring Data JPA]
        PhotoRepo[PhotoRepository]
        Hibernate[Hibernate ORM]
        
        JPA --> PhotoRepo
        JPA --> Hibernate
    end
    
    subgraph "Data Storage"
        OracleDB[(Oracle Database 21c XE)]
        PhotosTable[PHOTOS Table with BLOB Storage]
        
        OracleDB --> PhotosTable
    end
    
    UI -->|HTTP Requests| Controllers
    Controllers --> Thymeleaf
    Thymeleaf -->|HTML Response| UI
    
    Controllers --> Services
    Services --> JPA
    JPA --> OracleDB
    
    style UI fill:#e1f5ff
    style Controllers fill:#fff4e1
    style Services fill:#fff4e1
    style JPA fill:#e8f5e9
    style OracleDB fill:#f3e5f5
```

## Technology Stack

```mermaid
graph LR
    subgraph "Frontend"
        Bootstrap[Bootstrap 5.3.0]
        JS[Vanilla JavaScript]
        HTML[HTML5]
    end
    
    subgraph "Backend Framework"
        SpringBoot[Spring Boot 2.7.18]
        SpringWeb[Spring Web MVC]
        SpringData[Spring Data JPA]
        Validation[Spring Validation]
    end
    
    subgraph "Template Engine"
        ThymeEngine[Thymeleaf]
    end
    
    subgraph "Database"
        Oracle[Oracle Database 21c XE]
        JDBC[Oracle JDBC Driver ojdbc8]
        HibernateOrm[Hibernate ORM]
    end
    
    subgraph "Utilities"
        CommonsIO[Apache Commons IO 2.11.0]
        Maven[Maven Build Tool]
    end
    
    Frontend --> ThymeEngine
    ThymeEngine --> SpringBoot
    SpringBoot --> SpringWeb
    SpringBoot --> SpringData
    SpringBoot --> Validation
    SpringData --> HibernateOrm
    HibernateOrm --> JDBC
    JDBC --> Oracle
    SpringBoot --> CommonsIO
    
    style SpringBoot fill:#6db33f
    style Oracle fill:#f80000
    style Bootstrap fill:#7952b3
```

## Data Flow - Photo Upload

```mermaid
sequenceDiagram
    participant User
    participant Browser
    participant PhotoFileController
    participant PhotoService
    participant PhotoRepository
    participant OracleDB
    
    User->>Browser: Upload Photo(s)
    Browser->>PhotoFileController: POST /photo/upload
    PhotoFileController->>PhotoFileController: Validate File (Type, Size)
    PhotoFileController->>PhotoService: savePhoto(file)
    PhotoService->>PhotoService: Extract Metadata (Size, Dimensions)
    PhotoService->>PhotoService: Generate UUID
    PhotoService->>PhotoRepository: save(Photo Entity)
    PhotoRepository->>OracleDB: INSERT BLOB Data
    OracleDB-->>PhotoRepository: Success
    PhotoRepository-->>PhotoService: Photo Entity
    PhotoService-->>PhotoFileController: UploadResult
    PhotoFileController-->>Browser: JSON Response
    Browser-->>User: Display Success Message
```

## Data Flow - Photo Display

```mermaid
sequenceDiagram
    participant User
    participant Browser
    participant HomeController
    participant PhotoService
    participant PhotoRepository
    participant OracleDB
    
    User->>Browser: Access Gallery
    Browser->>HomeController: GET /
    HomeController->>PhotoService: getAllPhotos()
    PhotoService->>PhotoRepository: findAll()
    PhotoRepository->>OracleDB: SELECT (without BLOB)
    OracleDB-->>PhotoRepository: Photo Metadata
    PhotoRepository-->>PhotoService: List of Photos
    PhotoService-->>HomeController: Photo List
    HomeController-->>Browser: Render Thymeleaf Template
    Browser->>PhotoFileController: GET /photo/{id}/image
    PhotoFileController->>PhotoService: getPhotoById(id)
    PhotoService->>PhotoRepository: findById(id)
    PhotoRepository->>OracleDB: SELECT with BLOB
    OracleDB-->>PhotoRepository: Photo with BLOB Data
    PhotoRepository-->>PhotoService: Photo Entity
    PhotoService-->>PhotoFileController: Photo Data
    PhotoFileController-->>Browser: Image Bytes (JPEG/PNG/GIF/WebP)
    Browser-->>User: Display Photo
```

## Application Layers

### 1. Presentation Layer
- **Thymeleaf Templates**: Server-side rendering of HTML views
- **Bootstrap 5**: Responsive UI framework
- **Vanilla JavaScript**: Client-side interactions (drag-and-drop, AJAX)

### 2. Controller Layer
- **HomeController**: Gallery view and navigation
- **PhotoFileController**: Photo upload, image serving, delete operations
- **DetailController**: Photo detail view with metadata display

### 3. Service Layer
- **PhotoService**: Business logic interface
- **PhotoServiceImpl**: Implementation with photo processing logic
  - File validation (type, size)
  - Metadata extraction (dimensions, file size)
  - UUID generation for cache-busting

### 4. Data Access Layer
- **PhotoRepository**: Spring Data JPA repository interface
- **Spring Data JPA**: Data access abstraction
- **Hibernate**: ORM for database operations

### 5. Data Storage Layer
- **Oracle Database 21c Express Edition**
- **PHOTOS Table**: Stores photo metadata and BLOB data
  - Photo metadata (filename, size, dimensions, mime type)
  - Photo data as BLOB (binary large object)
  - UUID-based primary key

## Key Dependencies

| Dependency | Version | Purpose |
|------------|---------|---------|
| Spring Boot | 2.7.18 | Application framework |
| Spring Web | (via starter) | Web MVC and REST |
| Spring Data JPA | (via starter) | Data access layer |
| Thymeleaf | (via starter) | Template engine |
| Oracle JDBC Driver | ojdbc8 | Database connectivity |
| Apache Commons IO | 2.11.0 | File operations |
| Spring Validation | (via starter) | Input validation |
| Bootstrap | 5.3.0 | Frontend styling |

## Configuration Highlights

### Database Configuration
- **Connection**: `jdbc:oracle:thin:@oracle-db:1521/FREEPDB1`
- **Hibernate DDL**: Auto-create schema
- **Dialect**: Oracle

### File Upload Configuration
- **Max File Size**: 10MB
- **Max Request Size**: 50MB
- **Allowed Types**: JPEG, PNG, GIF, WebP
- **Max Files per Upload**: 10

### Application Settings
- **Server Port**: 8080
- **Java Version**: 1.8
- **Encoding**: UTF-8
- **Logging**: DEBUG level for application and Spring Web

## Deployment Architecture

```mermaid
graph TB
    subgraph "Docker Environment"
        subgraph "photoalbum-java-app Container"
            JavaApp[Spring Boot Application<br/>Port 8080]
        end
        
        subgraph "oracle-db Container"
            OracleContainer[Oracle Database 21c XE<br/>Port 1521]
            OracleEM[Enterprise Manager<br/>Port 5500]
        end
        
        InitScripts[Oracle Init Scripts]
        InitScripts -.->|Initialize Schema| OracleContainer
    end
    
    Client[Web Browser] -->|http://localhost:8080| JavaApp
    JavaApp -->|JDBC Connection| OracleContainer
    Admin[DB Admin] -.->|http://localhost:5500/em| OracleEM
    
    style JavaApp fill:#6db33f
    style OracleContainer fill:#f80000
    style OracleEM fill:#f80000
```

## Storage Strategy

### BLOB Storage in Database
- Photos stored directly in Oracle Database as BLOB data
- No file system dependencies
- Benefits:
  - ACID compliance for photo operations
  - Simplified backup and restore
  - Perfect for containerized environments
  - No shared file system needed

### UUID System
- Each photo assigned a unique UUID identifier
- Generated by Java: `UUID.randomUUID().toString()`
- Benefits:
  - Eliminates browser caching issues
  - Globally unique across systems
  - URL-safe identifiers

## External Integrations

- **None**: This is a self-contained application with no external service dependencies

## Summary

This Photo Album application follows a traditional **3-tier architecture**:

1. **Presentation Tier**: Thymeleaf templates + Bootstrap + JavaScript
2. **Application Tier**: Spring Boot with MVC pattern (Controllers → Services → Repositories)
3. **Data Tier**: Oracle Database with BLOB storage

The architecture is well-suited for containerized deployment and follows Spring Boot best practices with clear separation of concerns across layers.
