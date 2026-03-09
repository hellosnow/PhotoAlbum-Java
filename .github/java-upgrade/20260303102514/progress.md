# Upgrade Progress

  ### ✅ Generate Upgrade Plan
  - [[View Log]](logs\1.generatePlan.log)

  ### ✅ Confirm Upgrade Plan
  - [[View Log]](logs\2.confirmPlan.log)

  ### ✅ Setup Development Environment
  - [[View Log]](logs\3.setupEnvironment.log)

  ### ✅ PreCheck
  - [[View Log]](logs\4.precheck.log)
  
  <details>
      <summary>[ click to toggle details ]</summary>
  
  - ###
    ### ✅ Precheck - Build project
    - [[View Log]](logs\4.1.precheck-buildProject.log)
    
    <details>
        <summary>[ click to toggle details ]</summary>
    
    #### Command
    `mvn clean test-compile -q -B -fn`
    </details>
  
    ### ✅ Precheck - Validate CVEs
    - [[View Log]](logs\4.2.precheck-validateCves.log)
    
    <details>
        <summary>[ click to toggle details ]</summary>
    
    #### CVE issues
    - Dependency `commons-io:commons-io:2.11.0` has **1** known CVEs:
      - [CVE-2024-47554](https://github.com/advisories/GHSA-78wr-2p64-hpwj): Apache Commons IO: Possible denial of service attack on untrusted input to XmlStreamReader
        - **Severity**: **HIGH**
        - **Details**: Uncontrolled Resource Consumption vulnerability in Apache Commons IO.
          
          The `org.apache.commons.io.input.XmlStreamReader` class may excessively consume CPU resources when processing maliciously crafted input.
          
          
          This issue affects Apache Commons IO: from 2.0 before 2.14.0.
          
          Users are recommended to upgrade to version 2.14.0 or later, which fixes the issue.
    - Dependency `com.h2database:h2:2.1.214` has **1** known CVEs:
      - [CVE-2022-45868](https://github.com/advisories/GHSA-22wj-vf5f-wrvj): Password exposure in H2 Database 
        - **Severity**: **HIGH**
        - **Details**: The web-based admin console in H2 Database Engine through 2.1.214 can be started via the CLI with the argument -webAdminPassword, which allows the user to specify the password in cleartext for the web admin console. Consequently, a local user (or an attacker that has obtained local access through some means) would be able to discover the password by listing processes and their arguments. NOTE: the vendor states "This is not a vulnerability of H2 Console ... Passwords should never be passed on the command line and every qualified DBA or system administrator is expected to know that."
    </details>
  
    ### ✅ Precheck - Run tests
    - [[View Log]](logs\4.3.precheck-runTests.log)
    
    <details>
        <summary>[ click to toggle details ]</summary>
    
    #### Test result
    | Total | Passed | Failed | Skipped | Errors |
    |-------|--------|--------|---------|--------|
    | 1 | 1 | 0 | 0 | 0 |
    </details>
  </details>

  ### ✅ Upgrade project to use `Spring Boot 3.3.x`, `Java 21`
  
  
  <details>
      <summary>[ click to toggle details ]</summary>
  
  - ###
    ### ✅ Upgrade using Agent
    - [[View Log]](logs\5.1.upgradeProjectUsingAgent.log)
    
    - 6 files changed, 16 insertions(+), 16 deletions(-)
    
    <details>
        <summary>[ click to toggle details ]</summary>
    
    #### Code changes
    - Upgrade Spring Boot from 2.7.18 to 3.3.13 and Java from 8 to 21
      - Updated spring-boot-starter-parent version to 3.3.13 in pom.xml
      - Updated java.version, maven.compiler.source, maven.compiler.target to 21
    - Migrate javax.* to jakarta.* namespace in Photo.java
      - Replaced javax.persistence.* with jakarta.persistence.*
      - Replaced javax.validation.constraints.* with jakarta.validation.constraints.*
    - Apply Java 21 idiomatic changes
      - Replaced !optional.isPresent() with optional.isEmpty() in controllers and service
      - Replaced list.get(0) with list.getFirst() in PhotoServiceImpl
      - Replaced String.format() with String.formatted() in PhotoServiceImpl
      - Updated @RequestParam("files") to @RequestParam in HomeController
    </details>
  
    ### ✅ Build Project
    - [[View Log]](logs\5.2.buildProject.log)
    
    - Build result: 100% Java files compiled
    
    <details>
        <summary>[ click to toggle details ]</summary>
    
    #### Command
    `mvn clean test-compile -q -B -fn`
    </details>
  </details>

  ### ✅ Upgrade project to use `Spring Boot 3.4.x`
  
  
  <details>
      <summary>[ click to toggle details ]</summary>
  
  - ###
    ### ✅ Upgrade using Agent
    - [[View Log]](logs\6.1.upgradeProjectUsingAgent.log)
    
    - 1 file changed, 1 insertion(+), 1 deletion(-)
    
    <details>
        <summary>[ click to toggle details ]</summary>
    
    #### Code changes
    - Upgrade Spring Boot from 3.3.13 to 3.4.5
      - Updated spring-boot-starter-parent version to 3.4.5 in pom.xml
    </details>
  
    ### ✅ Build Project
    - [[View Log]](logs\6.2.buildProject.log)
    
    - Build result: 100% Java files compiled
    
    <details>
        <summary>[ click to toggle details ]</summary>
    
    #### Command
    `mvn clean test-compile -q -B -fn`
    </details>
  </details>

  ### ✅ Validate & Fix
  
  
  <details>
      <summary>[ click to toggle details ]</summary>
  
  - ###
    ### ✅ Validate CVEs
    - [[View Log]](logs\7.1.validateCves.log)
    
    <details>
        <summary>[ click to toggle details ]</summary>
    
    #### Checked Dependencies
      - org.springframework.boot:spring-boot-starter-web:3.4.5:jar
      - org.springframework.boot:spring-boot-starter-thymeleaf:3.4.5:jar
      - org.springframework.boot:spring-boot-starter-data-jpa:3.4.5:jar
      - com.oracle.database.jdbc:ojdbc8:23.5.0.24.07:jar
      - org.springframework.boot:spring-boot-starter-validation:3.4.5:jar
      - org.springframework.boot:spring-boot-starter-json:3.4.5:jar
      - org.springframework.boot:spring-boot-starter-test:3.4.5:jar
      - com.h2database:h2:2.3.232:jar
      - org.springframework.boot:spring-boot-devtools:3.4.5:jar
      - java:*:21
    </details>
  
    ### ✅ Validate And Fix Code Behavior Changes
    - [[View Log]](logs\7.2.validateBehaviorChanges.log)
  
    ### ✅ Run Tests
    - [[View Log]](logs\7.3.runTests.log)
    
    <details>
        <summary>[ click to toggle details ]</summary>
    
    #### Test result
    | Total | Passed | Failed | Skipped | Errors |
    |-------|--------|--------|---------|--------|
    | 1 | 1 | 0 | 0 | 0 |
    </details>
  </details>

  ### ✅ Summarize Upgrade
  - [[View Log]](logs\8.summarizeUpgrade.log)