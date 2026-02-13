# Photo Album Application - Architecture Diagram

## Current Architecture Overview

This diagram shows the high-level architecture of the Photo Album Java application based on the assessment results.

```mermaid
flowchart TB
    subgraph "Client Layer"
        Browser[Web Browser]
    end
    
    subgraph "Application Layer"
        subgraph "Spring Boot Application"
            Controllers[Controllers Layer<br/>HomeController<br/>PhotoFileController<br/>DetailController]
            Services[Service Layer<br/>PhotoService<br/>PhotoServiceImpl]
            Repository[Data Access Layer<br/>PhotoRepository<br/>Spring Data JPA]
        end
        Thymeleaf[Thymeleaf<br/>Template Engine]
    end
    
    subgraph "Data Layer"
        OracleDB[(Oracle Database<br/>21c Express Edition<br/>BLOB Storage)]
    end
    
    Browser -->|HTTP Requests| Controllers
    Controllers -->|Render Views| Thymeleaf
    Thymeleaf -->|HTML Response| Browser
    Controllers -->|Business Logic| Services
    Services -->|Data Operations| Repository
    Repository -->|JDBC/JPA| OracleDB
    
    style Browser fill:#e1f5ff
    style Controllers fill:#fff4e6
    style Services fill:#fff4e6
    style Repository fill:#fff4e6
    style Thymeleaf fill:#f3e5f5
    style OracleDB fill:#e8f5e9
```

## Technology Stack

```mermaid
flowchart LR
    subgraph "Frontend"
        HTML[HTML5]
        CSS[Bootstrap 5.3.0]
        JS[JavaScript]
    end
    
    subgraph "Backend"
        SpringBoot[Spring Boot 2.7.18]
        Java[Java 8]
        Maven[Maven Build Tool]
    end
    
    subgraph "Frameworks & Libraries"
        SpringWeb[Spring Web MVC]
        SpringData[Spring Data JPA]
        Hibernate[Hibernate ORM]
        ThymeleafLib[Thymeleaf]
        CommonsIO[Apache Commons IO]
    end
    
    subgraph "Database"
        Oracle[Oracle Database 21c XE<br/>JDBC Driver ojdbc8]
    end
    
    subgraph "Deployment"
        Docker[Docker Container]
        DockerCompose[Docker Compose]
    end
    
    HTML --> SpringWeb
    CSS --> SpringWeb
    JS --> SpringWeb
    Java --> SpringBoot
    Maven --> SpringBoot
    SpringBoot --> SpringWeb
    SpringBoot --> SpringData
    SpringBoot --> ThymeleafLib
    SpringData --> Hibernate
    Hibernate --> Oracle
    Docker --> SpringBoot
    DockerCompose --> Docker
    
    style SpringBoot fill:#6db33f
    style Java fill:#f89820
    style Oracle fill:#f80000
    style Docker fill:#2496ed
```

## Data Flow - Photo Upload Process

```mermaid
sequenceDiagram
    participant User
    participant Browser
    participant Controller as PhotoFileController
    participant Service as PhotoService
    participant Repository as PhotoRepository
    participant DB as Oracle Database
    
    User->>Browser: Select and upload photos
    Browser->>Controller: POST with multipart files
    Controller->>Controller: Validate file types and sizes
    Controller->>Service: savePhotos(files)
    loop For each photo file
        Service->>Service: Extract metadata (width, height, size)
        Service->>Service: Generate UUID
        Service->>Repository: save(Photo entity)
        Repository->>DB: INSERT photo data as BLOB
        DB-->>Repository: Confirm save
    end
    Service-->>Controller: UploadResult (success/failures)
    Controller-->>Browser: JSON response with results
    Browser-->>User: Display upload status
```

## Data Flow - Photo Display Process

```mermaid
sequenceDiagram
    participant User
    participant Browser
    participant HomeCtrl as HomeController
    participant DetailCtrl as DetailController
    participant Service as PhotoService
    participant Repository as PhotoRepository
    participant DB as Oracle Database
    
    User->>Browser: Navigate to gallery
    Browser->>HomeCtrl: GET /
    HomeCtrl->>Service: getAllPhotos()
    Service->>Repository: findAll()
    Repository->>DB: SELECT metadata
    DB-->>Repository: Photo metadata list
    Repository-->>Service: List of Photos
    Service-->>HomeCtrl: Photo list
    HomeCtrl-->>Browser: Render gallery.html
    
    User->>Browser: Click photo thumbnail
    Browser->>HomeCtrl: GET /photo/{uuid}/data
    HomeCtrl->>Service: getPhotoData(uuid)
    Service->>Repository: findById(uuid)
    Repository->>DB: SELECT photo including BLOB
    DB-->>Repository: Photo with BLOB data
    Repository-->>Service: Photo entity
    Service-->>HomeCtrl: Photo bytes
    HomeCtrl-->>Browser: Image bytes (JPEG/PNG)
    
    User->>Browser: View photo details
    Browser->>DetailCtrl: GET /detail/{uuid}
    DetailCtrl->>Service: getPhotoById(uuid)
    Service->>Repository: findById(uuid)
    Repository->>DB: SELECT photo metadata
    DB-->>Repository: Photo metadata
    Repository-->>Service: Photo entity
    Service-->>DetailCtrl: Photo entity
    DetailCtrl-->>Browser: Render detail.html
```

## Application Architecture Layers

```mermaid
flowchart TB
    subgraph "Presentation Layer"
        UI[Web UI - Thymeleaf Templates<br/>gallery.html, detail.html]
        Static[Static Resources<br/>CSS, JavaScript, Images]
    end
    
    subgraph "Controller Layer"
        Home[HomeController<br/>Gallery & Photo Display]
        Upload[PhotoFileController<br/>File Upload & Validation]
        Detail[DetailController<br/>Photo Details & Navigation]
    end
    
    subgraph "Service Layer"
        PhotoSvc[PhotoService Interface]
        PhotoImpl[PhotoServiceImpl<br/>Business Logic & Validation]
    end
    
    subgraph "Repository Layer"
        Repo[PhotoRepository<br/>Spring Data JPA Repository<br/>Custom JPQL Queries]
    end
    
    subgraph "Domain Model"
        Photo[Photo Entity<br/>UUID, Metadata, BLOB Data]
        UploadRes[UploadResult DTO]
    end
    
    subgraph "Data Persistence"
        OracleDB[(Oracle Database<br/>PHOTOS Table<br/>BLOB Storage)]
    end
    
    UI --> Home
    UI --> Upload
    UI --> Detail
    Static --> UI
    Home --> PhotoSvc
    Upload --> PhotoSvc
    Detail --> PhotoSvc
    PhotoSvc --> PhotoImpl
    PhotoImpl --> Repo
    PhotoImpl --> Photo
    PhotoImpl --> UploadRes
    Repo --> Photo
    Repo --> OracleDB
    
    style UI fill:#e3f2fd
    style Home fill:#fff3e0
    style Upload fill:#fff3e0
    style Detail fill:#fff3e0
    style PhotoSvc fill:#f3e5f5
    style PhotoImpl fill:#f3e5f5
    style Repo fill:#e8f5e9
    style OracleDB fill:#c8e6c9
    style Photo fill:#fff9c4
```

## Key Components

### Application Components

- **Controllers**: Handle HTTP requests and responses
  - `HomeController`: Gallery view and photo data endpoints
  - `PhotoFileController`: Photo upload with validation
  - `DetailController`: Individual photo details and navigation

- **Service Layer**: Business logic and orchestration
  - `PhotoService`: Interface defining photo operations
  - `PhotoServiceImpl`: Implementation with validation and metadata extraction

- **Repository Layer**: Data access abstraction
  - `PhotoRepository`: Spring Data JPA repository with custom queries
  - Extends `JpaRepository` for standard CRUD operations

- **Domain Model**:
  - `Photo`: JPA entity with UUID, metadata fields, and BLOB data
  - `UploadResult`: DTO for upload operation results

### Technology Components

- **Spring Boot 2.7.18**: Application framework (Java 8)
- **Spring Web MVC**: RESTful controllers and request handling
- **Spring Data JPA**: Repository pattern and data access
- **Hibernate**: ORM for database interactions
- **Thymeleaf**: Server-side template engine
- **Oracle Database 21c XE**: Relational database with BLOB storage
- **Oracle JDBC Driver (ojdbc8)**: Database connectivity
- **Apache Commons IO**: File operations utilities
- **Bootstrap 5.3.0**: Frontend UI framework
- **Maven**: Build and dependency management

### Data Storage

- **Oracle Database 21c Express Edition**
  - Connection: JDBC thin client
  - Schema: `photoalbum` user
  - Table: `PHOTOS` with BLOB column for image data
  - Indexes: Uploaded timestamp for chronological ordering

### Deployment

- **Docker**: Application containerization
- **Docker Compose**: Multi-container orchestration (app + database)
- **Port 8080**: Application HTTP endpoint
- **Port 1521**: Oracle database connection

## Key Features

1. **Photo Upload**
   - Drag-and-drop and click-to-upload interface
   - Multi-file upload support (max 10 files)
   - File validation: type (JPEG, PNG, GIF, WebP) and size (max 10MB)
   - Metadata extraction: width, height, file size
   - UUID generation for unique identification

2. **Photo Gallery**
   - Responsive grid layout
   - Thumbnail display with metadata
   - Photo count and sorting by upload date
   - Delete functionality

3. **Photo Details**
   - Full-size photo display
   - Metadata display (dimensions, size, aspect ratio, timestamp)
   - Previous/Next navigation
   - Delete functionality

4. **Data Storage**
   - Photos stored as BLOBs in Oracle Database
   - No file system dependencies
   - ACID compliance for operations
   - Simplified backup and migration

## Assessment Summary

### Current State

- **Framework**: Spring Boot 2.7.18 with Java 8
- **Database**: Oracle Database 21c Express Edition
- **Architecture**: Traditional 3-tier web application
- **Storage**: Database BLOB storage (in-database photo storage)
- **Deployment**: Docker containers with Docker Compose

### Architecture Characteristics

- **Monolithic**: Single deployable unit
- **Stateless**: Application server can scale horizontally
- **Database-Centric**: All data including photos stored in database
- **Container-Ready**: Already containerized with Docker

### Considerations for Azure Migration

Based on the assessment, key considerations for migrating to Azure:

1. **Compute Services**
   - Azure App Service (PaaS, easiest migration)
   - Azure Container Apps (container-native, modern)
   - Azure Kubernetes Service (enterprise scale)

2. **Database Options**
   - Azure Database for PostgreSQL (recommended for migration from Oracle)
   - Azure SQL Database (alternative relational database)
   - Maintain Oracle via Azure VM (lift-and-shift)

3. **Storage Optimization**
   - Consider Azure Blob Storage for photos (more scalable than database BLOBs)
   - Keep metadata in relational database
   - Leverage Azure CDN for image delivery

4. **Modernization Opportunities**
   - Upgrade to Java 17 or 21 (LTS versions)
   - Upgrade to Spring Boot 3.x
   - Implement Azure services (Key Vault, Application Insights)
   - Add authentication with Azure AD

---

*Generated from AppCAT assessment results*
