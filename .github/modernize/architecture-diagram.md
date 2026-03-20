# Architecture Diagram

This diagram shows the high-level architecture of the Photo Album application, a Spring Boot 2.7 web application that stores photos as BLOBs in an Oracle database.

## Application Architecture

```mermaid
flowchart TD
    Browser["🌐 Web Browser\nHTML / CSS / JavaScript"]

    subgraph AppContainer["photoalbum-java-app (Docker Container)"]
        subgraph Presentation["Presentation Layer"]
            Templates["Thymeleaf Templates\nindex.html · detail.html · layout.html"]
            Static["Static Assets\nsite.css · upload.js"]
        end

        subgraph Controllers["Controller Layer - Spring MVC"]
            HomeCtrl["HomeController\nGET / · POST /upload"]
            PhotoCtrl["PhotoFileController\nGET /photo/{id}"]
            DetailCtrl["DetailController\nGET /detail/{id} · POST /detail/{id}/delete"]
        end

        subgraph Services["Service Layer"]
            PhotoSvc["PhotoServiceImpl\nUpload Validation · Image Dimension Extraction\nNavigation Logic · Transactional Operations"]
        end

        subgraph Repository["Repository Layer - Spring Data JPA"]
            PhotoRepo["PhotoRepository\nJpaRepository · 6 Native Oracle SQL Queries\nROWNUM Pagination · Window Functions"]
        end

        subgraph Model["Domain Model"]
            PhotoEntity["Photo Entity\nUUID PK · BLOB photoData\nfileName · mimeType · fileSize\nwidth · height · uploadedAt"]
        end
    end

    subgraph DBContainer["oracle-db (Docker Container)"]
        OracleDB["Oracle Database Free 23ai\nPHOTOS Table\nBLOB Column · UUID PK\nIndex on uploaded_at"]
        OracleVol[("oracle_data\nPersistent Volume")]
    end

    Browser -->|"HTTP requests port 8080"| HomeCtrl
    Browser -->|"Image requests"| PhotoCtrl
    Browser -->|"Detail and delete"| DetailCtrl
    HomeCtrl --> Templates
    DetailCtrl --> Templates
    Templates --> Static
    Templates -->|"renders HTML"| Browser
    PhotoCtrl -->|"binary image response"| Browser
    HomeCtrl --> PhotoSvc
    PhotoCtrl --> PhotoSvc
    DetailCtrl --> PhotoSvc
    PhotoSvc --> PhotoRepo
    PhotoSvc --> PhotoEntity
    PhotoRepo --> PhotoEntity
    PhotoRepo -->|"Hibernate ORM · ojdbc8"| OracleDB
    OracleDB --- OracleVol

    subgraph Runtime["Runtime - Java 8 · Spring Boot 2.7.18 · Embedded Tomcat · Maven 3.9.6"]
    end
```
