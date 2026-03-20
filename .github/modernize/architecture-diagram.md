# Architecture Diagram

This diagram shows the high-level architecture of the Photo Album application, a Spring Boot web application that stores photos as BLOBs in an Oracle database.

## Application Architecture

```mermaid
flowchart TD
    Browser["Browser\nHTML5 / CSS3 / JavaScript"]

    subgraph App["Spring Boot Application (Java 8, Spring Boot 2.7)"]
        WebLayer["Presentation Layer\nThymeleaf Templates\nHomeController\nDetailController\nPhotoFileController"]
        ServiceLayer["Business Logic Layer\nPhotoService\nPhotoServiceImpl\nFile validation, MIME-type check\nImage dimension extraction"]
        DataLayer["Data Access Layer\nSpring Data JPA\nPhotoRepository\nHibernate ORM"]
    end

    subgraph Storage["Data Storage"]
        OracleDB["Oracle Database\nFREEPDB1\nPhotos table with BLOB storage\nUUID-based primary keys"]
    end

    subgraph Build["Build and Packaging"]
        Maven["Maven\nspring-boot-maven-plugin\nJAR packaging"]
        Docker["Docker\ndocker-compose\nOracle DB container"]
    end

    Browser -->|"HTTP GET / POST multipart upload"| WebLayer
    WebLayer -->|"calls"| ServiceLayer
    ServiceLayer -->|"reads and writes"| DataLayer
    DataLayer -->|"JDBC ojdbc8 via JPA"| OracleDB
    Maven -->|"builds"| App
    Docker -->|"runs"| App
    Docker -->|"runs"| OracleDB
```
