# PhotoAlbum-Java Application Architecture

## Overview

This diagram illustrates the high-level architecture of the PhotoAlbum-Java application, a Spring Boot-based photo storage and gallery system using Oracle Database.

## Current Architecture Diagram

```mermaid
graph TB
    subgraph "Presentation Layer"
        UI[Web UI - Thymeleaf Templates]
        Controller[Controllers Layer]
    end
    
    subgraph "Business Logic Layer"
        PhotoService[Photo Service]
        FileValidation[File Upload Validation]
        MathUtil[Utility Services]
    end
    
    subgraph "Data Access Layer"
        PhotoRepo[Photo Repository - Spring Data JPA]
        FileSystem[Local File System Storage]
    end
    
    subgraph "Data Storage"
        OracleDB[(Oracle Database)]
        PhotoFiles[Photo Files Storage]
    end
    
    UI --> Controller
    Controller --> PhotoService
    Controller --> FileValidation
    PhotoService --> PhotoRepo
    PhotoService --> FileSystem
    PhotoService --> MathUtil
    PhotoRepo --> OracleDB
    FileSystem --> PhotoFiles
    
    style UI fill:#e1f5ff
    style Controller fill:#b3e5fc
    style PhotoService fill:#81d4fa
    style PhotoRepo fill:#4fc3f7
    style OracleDB fill:#0288d1
    style PhotoFiles fill:#0288d1
```

## Technology Stack

```mermaid
graph LR
    subgraph "Backend Framework"
        SpringBoot[Spring Boot 2.7.18]
        SpringWeb[Spring Web MVC]
        SpringData[Spring Data JPA]
    end
    
    subgraph "View Layer"
        Thymeleaf[Thymeleaf Templates]
    end
    
    subgraph "Database"
        Oracle[Oracle Database]
        OJDBC[Oracle JDBC Driver ojdbc8]
    end
    
    subgraph "Java Runtime"
        Java8[Java 8]
    end
    
    SpringBoot --> SpringWeb
    SpringBoot --> SpringData
    SpringBoot --> Thymeleaf
    SpringData --> Oracle
    SpringData --> OJDBC
    SpringBoot --> Java8
    
    style SpringBoot fill:#6db33f
    style Oracle fill:#f80000
    style Java8 fill:#007396
```

## Application Components

### Controllers
- **HomeController**: Main landing page and gallery view
- **DetailController**: Individual photo details page
- **PhotoFileController**: File upload and management endpoints

### Services
- **PhotoService**: Business logic for photo management
  - Photo upload processing
  - File validation and storage
  - Photo retrieval and filtering

### Repository
- **PhotoRepository**: Spring Data JPA repository for database operations

### Models
- **Photo**: Entity representing photo metadata
- **UploadResult**: Result object for file upload operations

## Key Features

1. **Photo Upload**: Multi-file upload with validation
   - Maximum file size: 10MB
   - Allowed types: JPEG, PNG, GIF, WebP
   - Maximum files per upload: 10

2. **Photo Gallery**: Browse and view uploaded photos

3. **Database**: Oracle Database for metadata storage

4. **File Storage**: Local file system for photo storage

## Configuration

- **Server Port**: 8080
- **Database**: Oracle Database (FREEPDB1)
- **JPA Configuration**: DDL auto-create, SQL logging enabled
- **Character Encoding**: UTF-8

## Deployment Configuration

The application includes Docker support:
- **Dockerfile**: Container image definition
- **docker-compose.yml**: Multi-container setup with Oracle DB
- **Oracle Init Scripts**: Database initialization

## Architecture Characteristics

- **Layered Architecture**: Clear separation between presentation, business, and data layers
- **MVC Pattern**: Spring MVC for web request handling
- **ORM**: Hibernate/JPA for database operations
- **Template Engine**: Server-side rendering with Thymeleaf
- **File Upload**: Multipart form data handling with validation
- **Database**: Oracle Database for relational data storage
