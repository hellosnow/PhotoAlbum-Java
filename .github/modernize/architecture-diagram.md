# Architecture Diagram

This diagram represents the high-level architecture of the Photo Album application, a Spring Boot web application that stores and serves photos using Oracle Database BLOB storage.

## Application Architecture

```mermaid
flowchart TD
    Browser["Browser\nHTML / CSS / JS"]

    subgraph AppLayer["Application Layer - Spring Boot 2.7.18 / Java 8 / Embedded Tomcat"]
        HC["HomeController\nGET / · POST /upload"]
        PFC["PhotoFileController\nGET /photo/{id}"]
        DC["DetailController\nGET /detail/{id} · POST /detail/{id}/delete"]
        PS["PhotoService\nValidation · ImageIO · Transactions"]
        TH["Thymeleaf Templates\nindex.html · detail.html"]
    end

    subgraph DataLayer["Data Access Layer - Spring Data JPA / Hibernate"]
        PR["PhotoRepository\nJpaRepository - Oracle native queries"]
        Photo["Photo Entity\nid · photoData BLOB · mimeType · dimensions · uploadedAt"]
    end

    subgraph StorageLayer["Storage Layer"]
        OracleDB[("Oracle Database Free 23ai\nPhotos table - BLOB storage")]
    end

    Browser -->|"HTTP GET /"| HC
    Browser -->|"HTTP POST /upload multipart"| HC
    Browser -->|"HTTP GET /photo/{id}"| PFC
    Browser -->|"HTTP GET /detail/{id}"| DC
    Browser -->|"HTTP POST /detail/{id}/delete"| DC

    HC -->|"upload / list photos"| PS
    PFC -->|"serve photo binary"| PS
    DC -->|"view / delete photo"| PS

    PS -->|"save / find / delete"| PR
    PR -->|"JPA / Hibernate"| Photo
    Photo -->|"INSERT / SELECT / DELETE"| OracleDB

    PS -->|"render gallery"| TH
    DC -->|"render detail view"| TH
    TH -->|"HTML response"| Browser
    PFC -->|"binary response with MIME headers"| Browser
```
