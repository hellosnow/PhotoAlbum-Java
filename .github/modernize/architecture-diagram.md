# Architecture Diagram

This diagram illustrates the current architecture of the PhotoAlbum Java application, a Spring Boot web application that stores and serves photo files using Oracle Database as the backend.

## Application Architecture

```mermaid
flowchart TD
    Browser["Browser\nBootstrap 5 + Thymeleaf"]

    subgraph AppLayer["Spring Boot 2.7 Application (Java 8, Port 8080)"]
        direction TB

        subgraph Controllers["Controller Layer"]
            HC["HomeController\nGET / - Gallery View\nPOST /upload - Upload Photo"]
            DC["DetailController\nGET /detail/id - Photo Detail\nPOST /detail/id/delete - Delete Photo"]
            PFC["PhotoFileController\nGET /photo/id - Serve BLOB"]
        end

        subgraph Services["Service Layer"]
            PS["PhotoServiceImpl\nUpload Validation (type, size, 10MB max)\nImage Dimension Extraction (ImageIO)\nTransaction Management"]
        end

        subgraph Repositories["Repository Layer"]
            PR["PhotoRepository (Spring Data JPA)\nfindAllOrderByUploadedAtDesc\nfindPhotosByUploadMonth\nfindPhotosWithPagination (ROWNUM)\nfindPhotosWithStatistics (RANK OVER)"]
        end
    end

    subgraph DataLayer["Data Layer"]
        ODB["Oracle Database Free 23ai\nPHOTOS table\nid (UUID), originalFileName\nphotoData (BLOB), mimeType\nfileSize, width, height, uploadedAt"]
    end

    Browser -->|"HTTP Requests"| HC
    Browser -->|"HTTP Requests"| DC
    Browser -->|"HTTP Requests"| PFC
    HC --> PS
    DC --> PS
    PFC --> PS
    PS --> PR
    PR -->|"JDBC - ojdbc8\nHibernate ORM\nOracleDialect"| ODB
    ODB -->|"BLOB Data"| PR
    PR --> PS
    PS --> HC
    PS --> DC
    PS --> PFC
    HC -->|"Thymeleaf HTML"| Browser
    DC -->|"Thymeleaf HTML"| Browser
    PFC -->|"image/jpeg, image/png,\nimage/gif, image/webp"| Browser
```
