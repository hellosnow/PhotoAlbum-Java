# Architecture Diagram

This diagram represents the current architecture of the Photo Album application, a Spring Boot web application using Oracle Database for persistence and local file storage for photo uploads.

## Application Architecture

```mermaid
flowchart TD
    Browser["Browser\n(HTML/CSS/JavaScript)"]

    subgraph WebApp["Spring Boot Application (Java 8, Port 8080)"]
        subgraph Presentation["Presentation Layer"]
            HC["HomeController\nGET / - photo gallery"]
            DC["DetailController\nGET /detail - photo detail"]
            FC["PhotoFileController\nPOST /upload, GET /photo"]
            TH["Thymeleaf Templates\nindex.html, detail.html, layout.html"]
        end

        subgraph Business["Business Logic Layer"]
            PS["PhotoService\nUpload, retrieve, validate photos"]
        end

        subgraph DataAccess["Data Access Layer"]
            PR["PhotoRepository\nSpring Data JPA"]
        end

        subgraph Model["Domain Model"]
            PM["Photo Entity\nid, filename, contentType, data, uploadDate"]
        end
    end

    subgraph Storage["Data Storage"]
        ODB["Oracle Database\nPhoto metadata and binary data\nJDBC ojdbc8"]
        FS["Local File System\nstatic/uploads - uploaded image files"]
    end

    Browser -->|"HTTP requests"| HC
    Browser -->|"HTTP requests"| DC
    Browser -->|"Multipart file upload"| FC
    HC --> TH
    DC --> TH
    FC --> PS
    HC --> PS
    DC --> PS
    PS --> PR
    PS --> FS
    PR --> PM
    PR -->|"JPA / Hibernate OracleDialect"| ODB
```
