# Architecture Diagram

This diagram illustrates the high-level architecture of the Photo Album application, a Spring Boot web application with Oracle Database backend.

## Application Architecture

```mermaid
flowchart TD
    Browser["Web Browser\n(HTTP Client)"]

    subgraph Presentation["Presentation Layer"]
        Thymeleaf["Thymeleaf Templates\n(HTML Views)"]
        HomeCtrl["HomeController\nGallery / Album List"]
        DetailCtrl["DetailController\nPhoto Detail View"]
        FileCtrl["PhotoFileController\nUpload / Download / Delete"]
    end

    subgraph Business["Business Logic Layer"]
        PhotoSvc["PhotoService\nSpring Boot Service"]
        MathUtil["MathUtil\nHelper Utilities"]
    end

    subgraph DataAccess["Data Access Layer"]
        PhotoRepo["PhotoRepository\nSpring Data JPA"]
        PhotoModel["Photo Entity\nJPA / Hibernate ORM"]
    end

    subgraph Storage["Data Storage"]
        OracleDB[("Oracle Database\nFREEPDB1 - port 1521\nPhoto Metadata")]
        LocalFS["Local File System\nBinary Photo Storage\n(up to 10 MB per file)"]
    end

    Browser -- "HTTP GET / POST\n(Multipart Upload)" --> HomeCtrl
    Browser -- "HTTP GET" --> DetailCtrl
    Browser -- "HTTP GET / POST / DELETE\n(File Requests)" --> FileCtrl

    HomeCtrl --> Thymeleaf
    DetailCtrl --> Thymeleaf
    FileCtrl --> Thymeleaf

    HomeCtrl --> PhotoSvc
    DetailCtrl --> PhotoSvc
    FileCtrl --> PhotoSvc

    PhotoSvc --> MathUtil
    PhotoSvc --> PhotoRepo
    PhotoSvc --> LocalFS

    PhotoRepo --> PhotoModel
    PhotoModel -- "JDBC (ojdbc8)\nOracle Dialect" --> OracleDB
```
