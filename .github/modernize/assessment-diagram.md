# PhotoAlbum-Java Application Architecture

## Overview

This document provides a visual representation of the PhotoAlbum-Java application architecture based on the assessment analysis.

## Current Architecture

```mermaid
flowchart TB
    subgraph "User Interface Layer"
        UI[Web Browser]
        TH[Thymeleaf Templates]
        CSS[Bootstrap CSS]
        JS[JavaScript]
    end

    subgraph "Application Layer - Spring Boot 2.7.18"
        HC[HomeController]
        DC[DetailController]
        PFC[PhotoFileController]
        PS[PhotoService]
        PR[PhotoRepository]
    end

    subgraph "Data Storage Layer"
        ORA[(Oracle Database 21c)]
        FS[File System Storage]
    end

    UI -->|HTTP Requests| HC
    UI -->|HTTP Requests| DC
    UI -->|HTTP Requests| PFC
    
    HC -->|Business Logic| PS
    DC -->|Business Logic| PS
    PFC -->|Business Logic| PS
    
    PS -->|JPA/Hibernate| PR
    PR -->|JDBC| ORA
    
    PS -->|File I/O| FS
    
    HC -->|Render| TH
    DC -->|Render| TH
    TH -->|Serve| UI
    CSS -->|Style| UI
    JS -->|Interactivity| UI

    style UI fill:#e1f5ff
    style ORA fill:#ff6b6b
    style FS fill:#ffd93d
    style PS fill:#6bcf7f
```

## Technology Stack

```mermaid
graph LR
    subgraph "Backend Technologies"
        SB[Spring Boot 2.7.18]
        J8[Java 8]
        JPA[Spring Data JPA]
        MVN[Maven Build]
    end

    subgraph "Frontend Technologies"
        BS[Bootstrap 5.3.0]
        JSV[Vanilla JavaScript]
        THL[Thymeleaf]
    end

    subgraph "Data Storage"
        ORCL[Oracle Database 21c]
        BLOB[BLOB Storage for Photos]
    end

    subgraph "Dependencies"
        CI[Commons-IO 2.11.0]
        VAL[Spring Validation]
        OJ[ojdbc8 Driver]
    end

    style SB fill:#6db33f
    style ORCL fill:#ff0000
    style BS fill:#7952b3
    style THL fill:#005f0f
```

## Application Flow

```mermaid
sequenceDiagram
    participant User
    participant Browser
    participant Controller
    participant Service
    participant Repository
    participant Database
    participant FileSystem

    User->>Browser: Access Photo Gallery
    Browser->>Controller: GET /
    Controller->>Service: getAllPhotos()
    Service->>Repository: findAll()
    Repository->>Database: SELECT * FROM photos
    Database-->>Repository: Photo Records
    Repository-->>Service: List of Photos
    Service-->>Controller: Photo List
    Controller-->>Browser: Render Gallery Page
    Browser-->>User: Display Photos

    User->>Browser: Upload Photo
    Browser->>Controller: POST /upload
    Controller->>Service: uploadPhoto(file)
    Service->>FileSystem: Save photo file
    FileSystem-->>Service: File saved
    Service->>Repository: save(photo)
    Repository->>Database: INSERT photo metadata
    Database-->>Repository: Success
    Repository-->>Service: Photo entity
    Service-->>Controller: Upload result
    Controller-->>Browser: JSON response
    Browser-->>User: Show upload success
```

## Key Components

### Controllers (Presentation Layer)
- **HomeController**: Gallery view and photo upload functionality
- **DetailController**: Individual photo detail view with navigation
- **PhotoFileController**: Photo file serving and deletion operations

### Services (Business Logic Layer)
- **PhotoService**: Core business logic for photo management
  - Photo upload validation and processing
  - Image metadata extraction (dimensions, file size)
  - Photo retrieval and deletion operations

### Repository (Data Access Layer)
- **PhotoRepository**: Spring Data JPA repository interface
  - Database CRUD operations
  - Custom query methods for photo management

### Model (Domain Layer)
- **Photo**: Entity representing a photo with metadata
- **UploadResult**: DTO for upload operation results

## Data Storage

### Oracle Database
- Stores photo metadata (filename, size, dimensions, timestamps)
- Uses BLOB type for storing photo binary data
- Connection via JDBC driver (ojdbc8)

### File System
- Alternative storage for photo files
- Managed through PhotoService

## Configuration

### Database Configuration
- **Database**: Oracle Database 21c Express Edition
- **Connection**: JDBC thin client
- **Schema Management**: Hibernate auto DDL (create mode)
- **Credentials**: Configured in application.properties

### File Upload Configuration
- **Max File Size**: 10MB
- **Max Request Size**: 50MB
- **Allowed Types**: JPEG, PNG, GIF, WebP
- **Max Files Per Upload**: 10

## Assessment Findings Summary

Based on the AppCAT assessment, the application has:
- **Total Issues**: 7
- **Total Incidents**: 26
- **Total Effort**: 84 story points

### Issue Categories
- **Database Migration**: 6 incidents
- **Framework Upgrade**: 10 incidents
- **Java Version Upgrade**: 3 incidents
- **Local Credential**: 3 incidents
- **Spring Migration**: 4 incidents

### Severity Distribution
- **Mandatory**: 13 incidents
- **Potential**: 13 incidents

## Target Azure Services

The application can be modernized for deployment to:
1. **Azure Kubernetes Service (AKS)** - Container orchestration
2. **Azure App Service** - Managed PaaS platform
3. **Azure Container Apps** - Serverless containers

### Recommended Azure Services for Migration
- **Azure Database for PostgreSQL/MySQL** - Replace Oracle Database
- **Azure Blob Storage** - Photo file storage
- **Azure Application Insights** - Monitoring and diagnostics
- **Azure Key Vault** - Secure credential management
- **Azure Container Registry** - Container image storage
