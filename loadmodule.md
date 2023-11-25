**EWPS Load CE Data Module**

**DOCUMENT SCOPE**

This document outlines the design and architecture of the Load CE Data Module. Anything other than loading CE data is outside the scope of this document.

**Introduction**

The objective of the Load CE Data Module is to facilitate the loading of CE data from SAS datasets into an Oracle database. Initiation of the loading process is triggered by an API call from a UI client. Upon successfully loading data, all CE datasets are removed from the server where the parsing occurred. Ensuring adherence to database constraints, the data from the SAS dataset must exist in the final permanent table. The diagram below illustrates the general flow of the Load CE module:

[PICTURE LINK]

**Prerequisites**

Before initiating the Load CE Data job, ensure the following prerequisites are met:

1. A Transfer CE Data job must occur, and after completion, a set of artifacts must exist on a designated CE storage server, the location of which is configured via application settings.
2. A set of CE data columns, EWPS columns, and EWPS table mapping must exist in the EWPS_LOAD_FILE_MAPPING table.
3. The availability flag must be set to 'Y' for the transfer job record.

**Architecture Overview**

The Load CE Module is an integral part of the EWPS API ecosystem. To process a load job, a call is made via a Client (EWPS Blazor UI), with request parameters in the form of a JSON object (refer to the Data Model for details). To enhance UI responsiveness, a series of validations is performed, and the results are promptly returned to the client.

*Up-front Validations:*

1. **validate_job_availability:** Ensure one transfer job is available to load. If "data_availability_fl" is set to "N", an error message is immediately returned to the client.
2. **validate_file_metadata:** Validate based on records stored in the database, using the EWPS_FILE_TRANSFER_INFO and EWPS_CE_DATA_VERSION_CNTL tables. Mismatched information triggers an immediate error for the client.
3. **validate_file_mapping:** Return a validation error if the number of files does not match the number of tables stored in EWPS_LOAD_FILE_MAPPING.

[PICTURE LINK TO DESCRIBE FLOW]

If all validations succeed, the system initiates a background job to execute this lengthy process. Each step is logged in the process log file. The general flow of the background job is as follows:

1. **Artifact gathering:** Retrieve all files from the transfer jobs, stored in specific CE Data storage compliance servers. Refer to EWPS_FILE_TRANSFER/Write_File_Path for file locations.
2. **Validate_File_Mapping:** This step is crucial before parsing the SAS file. Utilize the EWPS_Common_Module database package to perform database truncate and disable table constraints.
3. **Parse & Persist data:** Parse each SAS file and persist only mapped columns. After data is persisted in the work table, utilize EWPS_Common_Module to re-enable constraints. All errors are saved in the EST_Exception table.
4. **Cleanup:** The process terminates if errors are reported inside the EST_Exception table. Otherwise, move data from the work table to the permanent table. If this process succeeds, the load process is completed.

[PICTURE LINK TO DESCRIBE BACKGROUND JOB FLOW]

**Data Model**

Each SAS dataset file is associated with a work and permanent Oracle table, with mapping stored in the EWPS_LOAD_FILE_MAPPING under the EWPS_TABLE_NAME column. Each SAS dataset column is mapped to a specific column in the work/permanent table. SAS Column is associated with CE_COLUMN_NAME, and EWPS_COLUMN_NAME is where the value is stored in the database table.

**Error Handling**

While the Load CE module is running, each primary step of the load processing is logged in the process log file. The file location is configured via the environment setting file – logging_location. Any exceptions encountered are also saved in this file, along with the exception stack trace.

**Documentation for API**

Load Module API documentation is accessible via Swagger, automatically enabled in devl/syst/acct environments.

Swagger URL: [https://ewpsapidev.psb.bls.gov/](https://ewpsapidev.psb.bls.gov/)

**Testing Strategy**

The following test cases are employed to test the Load module implementation, with two sets of test suites for manual and automatic testing using unit tests. This section will be continually updated as more is discovered about the nature of the requirements.

**Test via Swagger tool or Unit Test:**

*Up-front Validation:*

- Set Availability Flag to 'N', invalid ce_source, or quarter will trigger the following error when calling API via Swagger or Unit Test:

```json
{
  "has_error": true,
  "data": null,
  "message": "Failed to validate the current job.",
  "message_details": [
    {
      "has_error": true,
      "message": "No job found for the given quarter start and ce source."
    }
  ]
}
```

- Calling API with invalid parameters:

  Error: Unprocessable Entity

```json
{
  "detail": [
    {
      "loc": [
        "body",
        "ce_year"
      ],
      "msg": "field required",
      "type": "value_error.missing"
    }
  ]
}
```

- All SAS files are correctly mapped to work/permanent tables.

- All columns are correctly mapped to work/permanent column table.

- EWPS_CE_DATA_VERSION_CNTL contains the number of files less than in the EWPS_TRANSFER_INFO table.

**Authentication:**

- Call API with a valid JWT Token. The result will be:

```json
{
  "detail": "Invalid access token

!"
}
```

**Background job:**

- If all up-front validations are successful, a background job is created with specific status. See the table below for details.

| JOB_STATUS | JOB_STATUS_DESC | Note                                                              |
|------------|-----------------|-------------------------------------------------------------------|
| 0          | PENDING         | Beginning of background job                                       |
| 1          | IN_PROGRESS     | This status remains throughout the life cycle of the load process |
| 3          | COMPLETE        | Successfully load all files                                       |
| 10         | ERROR           | Anytime an error occurs                                           |

- Remove at least one file from the source server. An exception will be caught and logged in the process log file, and the job status should switch to error.

**EWPS_Common_Module:**

- Add duplicate rows to at least one SAS file, which should be recorded in the Process Log and EST_Exception table.
- Remove at least one mapped column in the EWPS_LOAD_FILE_MAPPING should produce an error and record in the Process Log.
- After the load process is complete, all work tables need to be empty, and constraints need to be enabled.
