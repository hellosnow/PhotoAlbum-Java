# Photo Album Application - Architecture Diagram

## Overview

This document presents the current architecture of the Photo Album Java application based on the assessment results. The application is a Spring Boot-based web application that allows users to upload, view, and manage photos stored in an Oracle database.

## Current Architecture

### High-Level System Architecture

```mermaid
graph TB
    subgraph "User Interface Layer"
        Browser[Web Browser]
        UI[Thymeleaf Templates<br/>Bootstrap 5 UI]
    end
    
    subgraph "Application Layer - Spring Boot 2.7.18"
        Controller[Controllers<br/>HomeController<br/>DetailController<br/>PhotoFileController]
        Service[Service Layer<br/>PhotoService<br/>PhotoServiceImpl]
        Repository[Data Access Layer<br/>PhotoRepository<br/>Spring Data JPA]
    end
    
    subgraph "Data Layer"
        OracleDB[(Oracle Database 21c XE<br/>BLOB Storage)]
    end
    
    subgraph "Storage"
        FileSystem[Static Files<br/>CSS/JS/Images]
    end
    
    Browser -->|HTTP Requests| UI
    UI -->|Template Rendering| Controller
    Controller -->|Business Logic| Service
    Service -->|Data Operations| Repository
    Repository -->|JDBC/JPA| OracleDB
    Controller -->|Static Content| FileSystem
    
    style Browser fill:#e1f5ff
    style UI fill:#fff4e1
    style Controller fill:#ffe1f5
    style Service fill:#e1ffe1
    style Repository fill:#f5e1ff
    style OracleDB fill:#ffe1e1
    style FileSystem fill:#f0f0f0
```

### Technology Stack

```mermaid
graph LR
    subgraph "Frontend Technologies"
        HTML[HTML5<br/>Thymeleaf]
        CSS[CSS3<br/>Bootstrap 5.3.0]
        JS[JavaScript ES6<br/>Vanilla JS]
    end
    
    subgraph "Backend Technologies"
        SB[Spring Boot 2.7.18]
        Java[Java 8]
        Maven[Maven Build Tool]
    end
    
    subgraph "Frameworks & Libraries"
        Web[Spring Web MVC]
        JPA[Spring Data JPA<br/>Hibernate ORM]
        Validation[Spring Validation]
        Commons[Commons IO 2.11.0]
    end
    
    subgraph "Database"
        Oracle[Oracle Database 21c XE<br/>OJDBC8 Driver]
    end
    
    subgraph "Infrastructure"
        Docker[Docker Containers<br/>Docker Compose]
    end
    
    HTML --> Web
    CSS --> Web
    JS --> Web
    SB --> Web
    SB --> JPA
    SB --> Validation
    Java --> SB
    Maven --> Java
    JPA --> Oracle
    Commons --> SB
    Docker --> SB
    Docker --> Oracle
    
    style HTML fill:#e1f5ff
    style CSS fill:#ffe1e1
    style JS fill:#fff4e1
    style SB fill:#90EE90
    style Java fill:#FFD700
    style Oracle fill:#FF6B6B
    style Docker fill:#2496ED
```

### Data Flow - Photo Upload Process

```mermaid
sequenceDiagram
    participant User
    participant Browser
    participant Controller as PhotoFileController
    participant Service as PhotoService
    participant Validation as File Validator
    participant Repository as PhotoRepository
    participant DB as Oracle Database
    
    User->>Browser: Drag and drop photos
    Browser->>Controller: POST /api/photos/upload
    Controller->>Validation: Validate file type and size
    
    alt Valid Files
        Validation-->>Controller: Validation passed
        Controller->>Service: uploadPhoto(file)
        Service->>Service: Read image metadata<br/>width, height, size
        Service->>Service: Generate UUID
        Service->>Repository: save(Photo entity)
        Repository->>DB: INSERT photo with BLOB data
        DB-->>Repository: Success
        Repository-->>Service: Photo saved
        Service-->>Controller: UploadResult success
        Controller-->>Browser: JSON response success
        Browser-->>User: Show success message
    else Invalid Files
        Validation-->>Controller: Validation failed
        Controller-->>Browser: JSON error response
        Browser-->>User: Show error message
    end
```

### Data Flow - Photo Display Process

```mermaid
sequenceDiagram
    participant User
    participant Browser
    participant HomeController
    participant Service as PhotoService
    participant Repository as PhotoRepository
    participant DB as Oracle Database
    
    User->>Browser: Navigate to gallery
    Browser->>HomeController: GET /
    HomeController->>Service: getAllPhotos()
    Service->>Repository: findAll(Sort by uploadedAt DESC)
    Repository->>DB: SELECT * FROM photos ORDER BY uploaded_at DESC
    DB-->>Repository: Photo metadata list
    Repository-->>Service: List of Photo entities
    Service-->>HomeController: List of photos
    HomeController->>HomeController: Add photos to model
    HomeController-->>Browser: Render index.html template
    Browser->>Browser: Display photo thumbnails
    
    User->>Browser: Click photo thumbnail
    Browser->>HomeController: GET /api/photos/id/data
    HomeController->>Service: getPhotoById(id)
    Service->>Repository: findById(id)
    Repository->>DB: SELECT photo_data FROM photos WHERE id equals value
    DB-->>Repository: BLOB data
    Repository-->>Service: Photo with BLOB
    Service-->>HomeController: Photo entity
    HomeController-->>Browser: Binary image data<br/>Content-Type: image/jpeg
    Browser-->>User: Display full-size photo
```

### Application Layers

```mermaid
graph TB
    subgraph "Presentation Layer"
        Templates[Thymeleaf Templates<br/>index.html, detail.html, layout.html]
        Static[Static Resources<br/>CSS, JavaScript, Images]
        Controllers[Spring MVC Controllers<br/>Request Mapping and Response]
    end
    
    subgraph "Business Logic Layer"
        Services[Service Interfaces and Implementations<br/>PhotoService, PhotoServiceImpl]
        Validation[Validation Logic<br/>File Type, Size, MIME Type]
        Utils[Utility Classes<br/>MathUtil for calculations]
    end
    
    subgraph "Data Access Layer"
        Repositories[Spring Data JPA Repositories<br/>PhotoRepository extends JpaRepository]
        Entities[JPA Entities<br/>Photo model with annotations]
        Hibernate[Hibernate ORM<br/>SQL Generation and Execution]
    end
    
    subgraph "Database Layer"
        OracleDB[(Oracle Database<br/>Photos Table with BLOB Storage<br/>Indexes on uploaded_at)]
    end
    
    Templates --> Controllers
    Static --> Controllers
    Controllers --> Services
    Services --> Validation
    Services --> Utils
    Services --> Repositories
    Repositories --> Entities
    Entities --> Hibernate
    Hibernate --> OracleDB
    
    style Templates fill:#e1f5ff
    style Static fill:#f0f0f0
    style Controllers fill:#ffe1f5
    style Services fill:#e1ffe1
    style Validation fill:#fff4e1
    style Utils fill:#f5f5f5
    style Repositories fill:#f5e1ff
    style Entities fill:#ffe1e1
    style Hibernate fill:#ffd1dc
    style OracleDB fill:#ff6b6b
```

### Component Dependencies

```mermaid
graph TD
    App[PhotoAlbumApplication<br/>Spring Boot Entry Point]
    
    App --> HC[HomeController]
    App --> DC[DetailController]
    App --> PFC[PhotoFileController]
    
    HC --> PS[PhotoService]
    DC --> PS
    PFC --> PS
    
    PS --> PR[PhotoRepository]
    PS --> MU[MathUtil]
    
    PR --> PM[Photo Model]
    
    PM --> ODB[(Oracle Database)]
    
    subgraph "Configuration"
        Props[application.properties<br/>Database Config<br/>Upload Settings]
    end
    
    Props -.->|Configure| App
    Props -.->|Configure| ODB
    
    style App fill:#90EE90
    style HC fill:#ffe1f5
    style DC fill:#ffe1f5
    style PFC fill:#ffe1f5
    style PS fill:#e1ffe1
    style PR fill:#f5e1ff
    style PM fill:#ffe1e1
    style ODB fill:#ff6b6b
    style MU fill:#f5f5f5
    style Props fill:#fff4e1
```

## Key Architecture Characteristics

### Current Implementation

1. **Monolithic Architecture**: Single Spring Boot application handling all concerns
2. **MVC Pattern**: Clear separation between Model, View, and Controller layers
3. **Database-Centric Storage**: Photos stored as BLOBs directly in Oracle database
4. **Session-less**: RESTful APIs with no server-side session management
5. **Containerized**: Docker and Docker Compose for deployment
6. **JPA/Hibernate**: ORM for database operations with automatic schema generation

### Technology Decisions

| Component | Technology | Version |
|-----------|-----------|---------|
| Programming Language | Java | 8 |
| Framework | Spring Boot | 2.7.18 |
| Database | Oracle Database | 21c Express Edition |
| ORM | Hibernate/JPA | Included with Spring Boot |
| Template Engine | Thymeleaf | Included with Spring Boot |
| Build Tool | Maven | 3.x |
| Frontend Framework | Bootstrap | 5.3.0 |
| JDBC Driver | Oracle OJDBC8 | Managed by Spring Boot |
| File Utilities | Commons IO | 2.11.0 |

### Data Storage Strategy

**Photo Storage**: All photos are stored as BLOB (Binary Large Object) data directly in the Oracle database.

**Benefits**:
- No file system dependencies
- ACID compliance for all operations
- Simplified backup and restore
- Perfect for containerized environments
- Consistent data management

**Trade-offs**:
- Database size grows with photo uploads
- May impact database performance at scale
- Requires adequate database storage capacity

### External Dependencies

1. **Oracle Database 21c XE**
   - Connection: JDBC via ojdbc8 driver
   - Port: 1521
   - Schema: photoalbum

2. **Static File System**
   - CSS stylesheets
   - JavaScript files
   - No photo files stored on filesystem

## Deployment Architecture

```mermaid
graph TB
    subgraph "Docker Compose Environment"
        subgraph "App Container"
            SpringBoot[Spring Boot Application<br/>Port 8080<br/>Java 8 Runtime]
        end
        
        subgraph "Database Container"
            Oracle[Oracle Database 21c XE<br/>Port 1521 - Database<br/>Port 5500 - Enterprise Manager]
        end
        
        subgraph "Shared Network"
            Network[Docker Bridge Network<br/>Service Discovery]
        end
    end
    
    subgraph "External Access"
        Client[Web Browser]
    end
    
    Client -->|HTTP 8080| SpringBoot
    Client -.->|HTTP 5500| Oracle
    SpringBoot -->|JDBC 1521| Oracle
    Network -.->|DNS Resolution| SpringBoot
    Network -.->|DNS Resolution| Oracle
    
    style SpringBoot fill:#90EE90
    style Oracle fill:#ff6b6b
    style Network fill:#e0e0e0
    style Client fill:#e1f5ff
```

### Container Configuration

**Application Container**:
- Base Image: maven:3.8.6-openjdk-8
- Exposed Port: 8080
- Build: Multi-stage Maven build
- Dependencies: All managed in pom.xml

**Database Container**:
- Base Image: container-registry.oracle.com/database/express:21.3.0-xe
- Exposed Ports: 1521 (database), 5500 (Enterprise Manager)
- Volume: Persistent storage for database files
- Init Scripts: Automatic user and schema creation

## Assessment Summary

Based on the code analysis and assessment:

### Strengths
- Clean layered architecture with good separation of concerns
- RESTful API design for photo operations
- Comprehensive validation for file uploads
- Containerized deployment ready
- Well-structured Spring Boot application

### Areas for Consideration
- Java 8 is end-of-life; consider upgrading to Java 11, 17, or 21
- Spring Boot 2.7.x will reach end-of-support; migration to Spring Boot 3.x recommended
- Oracle Database dependency may require Azure-specific considerations
- BLOB storage approach may need review for high-volume scenarios
- No distributed caching or CDN for photo delivery

### Azure Migration Opportunities
- **Compute**: Azure App Service, Azure Container Apps, or Azure Kubernetes Service (AKS)
- **Database**: Azure Database for PostgreSQL, Azure SQL Database, or Oracle Database on Azure
- **Storage**: Consider Azure Blob Storage for photo files instead of database BLOBs
- **CDN**: Azure CDN for optimized photo delivery
- **Caching**: Azure Cache for Redis for frequently accessed photos
- **Monitoring**: Azure Application Insights for observability

---

*Generated from assessment results on February 10, 2026*
