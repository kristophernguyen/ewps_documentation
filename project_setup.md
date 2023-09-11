**Document Scope**

This document describes the detailed steps to set up EWPS projects for development and debugging purposes.

**Prerequisites:**

**Software:**

1. Visual Studio 2022 (version 17.6.6+)
   Workloads:
   a. ASP.NET and web development
   b. Python development
   c. .NET Multi-platform App UI Development
   d. .NET desktop development

2. Dotnet SDK
   a. dotnet SDK 6.0+
   b. dotnet SDK 7.0+

3. Visual Studio Code
4. Python 3.11.1
5. Oracle SQL Developer or FROG

**OS Access:**

1. CPIDev1 access
2. CPIDev2v access

**GROUP MEMBERS:**

1. cnsdevopsdev

**Database Access:**

Ensure that the above software is installed before proceeding with the following steps:

**EWPS-UI Project Setup**

**General**

**Prerequisites:**

Before proceeding, ensure that you have already created a new feature branch and are ready to work on your UI/Authentication/API user stories. Refer to [EWPS Developer Gitlab](http://oplc.cfsp.bls.gov/sites/CPICE/CPI/teams/CSTPOPS/Shared%20Documents/EWPS/Design_Documents/EWPS%20Developers%20GitLab%20Workflow.docx) for instructions on how to create a new feature branch.

1. Clone the UI project and make sure you are on the feature branch.
2. Copy the `appsettings.template.json` file under EWPS-UI/Web.Main.EWPS.UI project and paste it into the same location as the copied file.

3. Rename the pasted file to `appsettings.local.json`.  Make sure to change 'Copy to output directory' to 'Copy if newer'. This new file will be ignored and untracked by Git.

4. Ensure to configure the connection string parameters (schema, username) to match the schema you want to test against.

5. For the password, follow these steps to generate an encrypted password using the encryption API endpoint:
   a. Go to [Encryption API Documentation](https://ewpsauthapidev.psb.bls.gov/docs/index.html).
   b. Utilize the encrypt API to generate an encrypted password.

6. Setting the logging location is optional. The default location for system logging is the 'log' folder relative to the EWPS UI solution folder ("../logs/"). However, if you need to configure a specific location, you can change this value to an absolute or relative path (e.g., c:\temp\mylog or ../mylog, etc.). The default location serves as an example of a relative path setting.

**Security - Configuration for the Authentication API**

By default, the application points to the development authentication API (https://cfapcpi01v.psb.bls.gov:9503). However, if you require local authentication for debugging purposes, you can change this value to point to a locally running authentication API (https://localhost:9503). These settings are stored in the `appsettings.local.json` file under the 'ApiHosts' section.

**New Offline Resources (NuGet Package)**

**Updating Offline Resource File**

Whenever a new NuGet package is added to any of the projects, it's necessary to regenerate the offline resource file on the server. The CI/CD pipeline relies on this offline file for building and deploying the project. Follow these instructions to update the offline resource file:

1. Open the command prompt and navigate to the `.gitlab/scripts` folder.

2. Execute `compress.bat`.

3. Open an FTP session to `cpidev1`. Upload the newly generated file, `offline.tar.gz`, to the `/cnsdevopsdev/ewps_offline_resource/linux/ui` folder. Ensure that the newly uploaded file is assigned to the `cnsdevopsdev` group (use `chgrp cnsdevopsdev`).

**EWPS-UI TEST Project Setup**

**General**

1. Copy the `test_application.template` file under Test.EWPS.UI project and paste it into the same location as the copied file.

2. Rename the pasted file to `test_appsettings.json`. Make sure to change 'Copy to output directory' to 'Copy if newer'.  Note that this file is untrack and ignore by Git.

3. Ensure to configure the connection string parameters (schema, username) to the schema that you want to test against.

4. For the password, use the encryption API endpoint to generate an encrypted password.

5. Run all tests to verify if the setup is correctly configured.

**Updating Offline Resource File**

Whenever a new NuGet package is added to any of the projects, it's necessary to regenerate the offline resource file on the server. The CI/CD pipeline relies on this offline file for building and deploying the project. Follow these instructions to update the offline resource file:

1. Open the command prompt and navigate to the `.gitlab/scripts` folder.

2. Execute `compress.bat`.

3. Open an FTP session to `cpidev1`. Upload the newly generated file, `offline.tar.gz`, to the `/cnsdevopsdev/ewps_offline_resource/linux/auth` folder. Ensure that the newly uploaded file is assigned to the `cnsdevopsdev` group (use `chgrp cnsdevopsdev`).

**Auth_API Project Setup**
1. Clone the AUTH project and make sure you are on the feature branch.
2. Copy the `appsettings.template.json` file under AUTH_API/Web.Auth project and paste it into the same location as the copied file.

3. Rename the pasted file to `appsettings.local.json`. Make sure to change 'Copy to output directory' to 'Copy if newer'.  Note that this file is untrack and ignore by Git.

4. Ensure that you configure the connection string parameters (schema, username) to match the schema you want to test against.

5. For the password, follow these steps to generate an encrypted password using the encryption API endpoint:
   a. Go to [Encryption API Documentation](https://ewpsauthapidev.psb.bls.gov/docs/index.html).
   b. Utilize the encrypt API to generate an encrypted password.

**AUTH-API TEST Project Setup**

1. Copy the `test_application.template` file under Test.Auth project and paste it into the same location as the copied file.

2. Rename the pasted file to `test_appsettings.json`. Make sure to change 'Copy to output directory' to 'Copy if newer'.  Note that this file is untrack and ignore by Git.

3. Ensure that you configure the connection string parameters (schema, username) to the schema that you want to test against.

4. For the password, use the encryption API endpoint to generate an encrypted password.

5. Run all tests to verify if the setup is correctly configured.

**EWPS-API Project Setup**
Visual studio code is used as the main IDE. Most of the steps here are very similiar to the ASP.NET projects.  The main differentce is how to create/run the python environment.
1. Clone the EWPS-API project and make sure you are on the feature branch.
2. Open the command prompt and navigate to the root of the project
3. Issue the command (python -m venv .venv).  Once virtual environment is created, make sure to activate the new environment before proceed to the next step.
4. Issue the command (pip install -r requirements.txt).  This command will install all the required packages this project required.  Note that NTLM need to started before installing.
5. Copy the `config.template` file under API/Config folde and paste it into the same location as the copied file.
6. Rename the pasted file to `config.local.env`.
7. Repeat step 5-6 for devl environment.  Rename the pasted file to 'config.devl.env'
8. 
