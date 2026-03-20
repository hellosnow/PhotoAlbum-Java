# Architecture Diagram

This diagram illustrates the current architecture of the PhotoAlbum Java application, a Spring Boot web application that stores and serves photo images using an Oracle database backend.

## Application Architecture

```mermaid
flowchart TD
    Browser["Browser\nHTML/CSS/JavaScript"]

    subgraph AppContainer["Spring Boot Application - Java 8 / Port 8080"]
        subgraph Presentation["Presentation Layer - Spring MVC + Thymeleaf"]
            HC["HomeController\nGET / - Gallery view\nPOST /upload - Multi-file upload"]
            PFC["PhotoFileController\nGET /photo/{id} - Serve binary image"]
            DC["DetailController\nGET /detail/{id} - Photo detail\nPOST /detail/{id}/delete"]
        end

        subgraph Business["Business Logic Layer - Spring Service"]
            PS["PhotoServiceImpl\nUpload validation (MIME type, file size)\nImage dimension extraction\nBLOB storage and retrieval\nPhoto navigation (prev/next)"]
        end

        subgraph DataAccess["Data Access Layer - Spring Data JPA"]
            PR["PhotoRepository\nSpring Data JPA + Native Oracle SQL\nROWNUM pagination\nOracle analytical functions"]
        end
    end

    subgraph DBContainer["Oracle Database Container - Port 1521"]
        OracleDB["Oracle Free DB\nSchema: photoalbum\nTable: photos\nBLOB column: photo_data"]
        OracleVol[("oracle_data volume\nPersistent storage\n/opt/oracle/oradata")]
    end

    Browser -- "HTTP requests / Thymeleaf HTML responses" --> Presentation
    HC --> PS
    PFC --> PS
    DC --> PS
    PS -- "JPA / OJDBC8" --> PR
    PR -- "JDBC / Oracle dialect" --> OracleDB
    OracleDB --- OracleVol
```
