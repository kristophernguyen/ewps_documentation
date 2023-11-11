Certainly! Here's a proofread version of your document:

---

**DOCUMENT SCOPE**

This document provides a step-by-step guide for setting up SonarQube scanning in a .NET and Python project using GitLab CI/CD and a GitLab Runner. The setup of the SonarQube server is out of scope.

---

**Section 1: Prerequisites:**

The following is a list of required software that needs to be installed before setup:

1. SonarQube server is already installed and ready to be integrated with the GitLab runner. The provided SonarQube server is available at [http://cpidev3v:9000/](http://146.142.205.3:9000).

2. Java Runtime is available on the build server (cpidev1). The JRE version must meet SonarQube Scanner requirements. Refer to the Sonar Scanner release documentation for specific requirements.

3. Dotnet runtime must be available on the build server.

---

**Section 2: SonarQube Scanner:**

**For DotNet project:**
1. Download the SonarQube scanner from the official website: [SonarScanner for MSBuild Releases](https://github.com/SonarSource/sonar-scanner-msbuild/releases).
2. Using the ewpsapp credentials, sign into the cpidev1 server and execute the following commands from steps a to d:
   a. `cd /cnsdevopsdev`
   b. `newgrp cnsdevopsdev`
   c. `mkdir utility`
   d. `chmod ug+wxr utility`
3. Unzip the downloaded Sonar Scanner and upload all extracted files to the utility folder.
4. Issue the following command: `chmod -R ug+wxr utility`.

**For Python project:**
- Visit the official website to download the latest SonarQube Scanner (Linux 64-bit): [SonarScanner for Python](https://docs.sonarsource.com/sonarqube/9.9/analyzing-source-code/scanners/sonarscanner/). Follow step 1 above to upload the unzipped files to the utility folder.

---

**Section 3: SonarQube User and Token:**

Visit the SonarQube server ([http://cpidev3v:9000](http://cpidev3v:9000)).

1. Create a new user with Execute Analysis, Quality Gate, and Quality Profile permissions.
2. From the newly created user profile, generate a new token with no expiration date. Ensure to copy the token before navigating away.

---

**Section 4: GitLab CI/CD Variables:**

Create the following variables:

| Variable Name       | Value                                            |
|---------------------|--------------------------------------------------|
| sonar_host_url      | [http://146.142.205.3:9000](http://146.142.205.3:9000) |
| sonar_java_home     | /etc/alternatives/jre_11_openjdk                 |
| sonar_project_id    | EWPS_Rebuild_UI                                  |
| sonar_scanner_home  | If this is a .NET project: /cnsdevopsdev/utility/dotnet-sonar-scanner-5.14.0<br> If this is Python: /cnsdevopsdev/utility/sonar-scanner-5.0.1.3006-linux |
| sonar_temp_dir      | /cnsdevopsdev/utility/tmp                        |
| sonar_token         | Use the token created in step 2 above.           |

---

**Section 5: GitLab Runner YML:**

See the SonarQube Analysis section in `.gitlab-ci.yml` for details.

--- 

I've made some corrections for clarity and consistency. Feel free to adjust as needed for your specific requirements.
