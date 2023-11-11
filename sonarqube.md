DOCUMENT SCOPE
This document describes step-by-step for setting up SonarQube scanning in a dotnet and python project using GitLab CI/CD and a GitLab Runner.  Setting up SonarQube server is out-of-scope.
________________________________________
Section 1: Prerequisites:
The following is the list of required software that needs to be install prior to setup.
1.	SonarQube server is already installed and ready to be integrate with GitLab runner.  Current provided SonarQube server is available at http://cpidev3v:9000/ (http://146.142.205.3:9000).
2.	Java Run Time is available on the built server (cpidev1).  JRE version must meet Sonar Qube Scanner requirements. See sonar scanner release documentation for requirements.
3.	Dotnet runtime must be available on the built server.
Section 2: SonarQube Scanner:
For DotNet project, download SonarQube scanner from the official website: https://github.com/SonarSource/sonar-scanner-msbuild/releases
1.	Using ewpsapp credential and sign into cpidev1 server.  Issues all commands from steps a-d.
a.	cd /cnsdevopsdev
b.	newgrp cnsdevopsdev
c.	mkdir utility
d.	chmod ug+wxr utility
2.	Unizip the downloaded sonar scanner and upload all extracted files to utility folder
3.	Issue the following command: chmod -R ug+wxr utility
For Python project, visit the official website to download the latest SonarQube Scanner (Linux 64-bit) https://docs.sonarsource.com/sonarqube/9.9/analyzing-source-code/scanners/sonarscanner/.  Follow step 1 above to upload the unzip files to utility folder.
Section 2: SonarQube User and Token:
Visit SonarQube server (http://cpidev3v:9000)
1.	Create a new user with Execute Analysis, Quality Gate, Quality Profile
2.	From the newly created user profile, create a new token with no expiration date.  Make sure to copy the token before navigate away
Section 3: GitLab CI/CD Variables:
Create the following variables:
Variable Name	Value
sonar_host_url	http://146.142.205.3:9000
sonar_java_home	/etc/alternatives/jre_11_openjdk
sonar_project_id	EWPS_Rebuild_UI
sonar_scanar_home	If this is dotnet project:
/cnsdevopsdev/utility/dotnet-sonar-scanner-5.14.0
If this is python:
/cnsdevopsdev/utility/ sonar-scanner-5.0.1.3006-linux
sonar_temp_dir	/cnsdevopsdev/utility/tmp
sonar_token	Use the token create in step 2 above.

Section 4: GitLab Runner YML:
See Sonar Qube Analysis section in .gitlab-ci.yml for details.




