CREATE OR REPLACE PACKAGE PKG_EWPS_API AS
 /*************************************************************************
Name of File    : PKG_EWPS_API.sql
Purpose         : 
Contains        :  
-	SP_EWPS_DELETE_JOB_LOG
-	SP_EWPS_DELETE_USER
-	SP_EWPS_GET_ALL_APP_FUNCTIONS_REF
-   SP_EWPS_GET_ALL_CE_SOURCE_REF
-	SP_EWPS_GET_ALL_FILE_TRANSFER_INFO
-   SP_EWPS_GET_ALL_JOBS_REF
-	SP_EWPS_GET_JOB_LOGS
-   SP_EWPS_GET_JOB_LOG_DETAILS
-	SP_EWPS_GET_USER_DETAILS
-	SP_EWPS_GET_USERS
-   SP_EWPS_GET_USER_DETAILS
-	SP_EWPS_INSERT_USER
-	SP_EWPS_SAVE_JOB_LOG
Date Written    : 
Created By      : Kristopher N.
**************************************************************************/

  PROCEDURE SP_EWPS_DELETE_JOB_LOG (
    P_LOG_ID IN NUMBER,
    P_COUNT OUT NUMBER
  );

  PROCEDURE SP_EWPS_DELETE_USER(
    P_USER_NAME VARCHAR2
  );

  PROCEDURE SP_EWPS_GET_ALL_APP_FUNCTIONS_REF(
    P_RECORDSET OUT SYS_REFCURSOR
  );

  PROCEDURE SP_EWPS_GET_ALL_CE_SOURCE_REF (
    P_RECORDSET OUT SYS_REFCURSOR
  );

  PROCEDURE SP_EWPS_GET_ALL_FILE_TRANSFER_INFO(
    P_RECORDSET OUT SYS_REFCURSOR
  );

  PROCEDURE SP_EWPS_GET_ALL_JOBS_REF (
    P_RECORDSET OUT SYS_REFCURSOR
  );

  PROCEDURE SP_EWPS_GET_JOB_LOGS (
    P_RECORDSET OUT SYS_REFCURSOR,
    P_OFFSET IN NUMBER,
    P_PAGE_SIZE IN NUMBER
  );

  PROCEDURE SP_EWPS_GET_JOB_LOG_DETAILS(
    P_RECORDSET OUT SYS_REFCURSOR,
    P_LOG_ID IN VARCHAR2
  );

  PROCEDURE SP_EWPS_GET_USERS (
    P_RECORDSET OUT SYS_REFCURSOR,
    P_SEARCH_TEXT IN VARCHAR2,
    P_OFFSET IN NUMBER,
    P_PAGE_SIZE IN NUMBER
  );

  PROCEDURE SP_EWPS_GET_USER_DETAILS(
    P_RECORDSET OUT SYS_REFCURSOR,
    P_USER_NAME VARCHAR2
  );

  PROCEDURE SP_EWPS_INSERT_USER(
    P_APP_FUNCTION VARCHAR2,
    P_USER_NAME VARCHAR2,
    P_ACCESS_LEVEL INT
  );

  PROCEDURE SP_EWPS_SAVE_JOB_LOG (
    P_LOG_ID IN NUMBER,
    P_JOB_START_DTTM IN TIMESTAMP,
    P_JOB_END_DTTM IN TIMESTAMP,
    P_JOB_ID IN VARCHAR2,
    P_JOB_PARAMETERS IN VARCHAR2,
    P_JOB_STATUS IN NUMBER,
    P_JOB_STATUS_DESC IN VARCHAR2,
    P_USER_NAME IN VARCHAR2,
    P_ID OUT NUMBER
  );
END PKG_EWPS_API;
/

CREATE OR REPLACE PACKAGE BODY PKG_EWPS_API AS
 /*************************************************************************
Name of File    : PKG_EWPS_API.sql
Purpose         : 
Contains        :  
-	SP_EWPS_DELETE_JOB_LOG
-	SP_EWPS_DELETE_USER
-	SP_EWPS_GET_ALL_APP_FUNCTIONS_REF
-   SP_EWPS_GET_ALL_CE_SOURCE_REF
-	SP_EWPS_GET_ALL_FILE_TRANSFER_INFO
-   SP_EWPS_GET_ALL_JOBS_REF
-	SP_EWPS_GET_JOB_LOGS
-   SP_EWPS_GET_JOB_LOG_DETAILS
-	SP_EWPS_GET_USER_DETAILS
-	SP_EWPS_GET_USERS
-   SP_EWPS_GET_USER_DETAILS
-	SP_EWPS_INSERT_USER
-	SP_EWPS_SAVE_JOB_LOG
Date Written    : 
Created By      : Kristopher N.
**************************************************************************/

  PROCEDURE SP_EWPS_DELETE_JOB_LOG (
    P_LOG_ID IN NUMBER,
    P_COUNT OUT NUMBER
  ) IS
  BEGIN
    DELETE FROM EWPS_JOB_LOG
    WHERE
      LOG_ID=P_LOG_ID;
    P_COUNT := SQL%ROWCOUNT;
    COMMIT;
  END SP_EWPS_DELETE_JOB_LOG;

  PROCEDURE SP_EWPS_DELETE_USER(
    P_USER_NAME VARCHAR2
  ) AS
  BEGIN
    DELETE FROM EWPS_ACCESS_CONTROL
    WHERE
      LOWER(USER_NAME)=LOWER(P_USER_NAME);
  END SP_EWPS_DELETE_USER;

  PROCEDURE SP_EWPS_GET_ALL_APP_FUNCTIONS_REF(
    P_RECORDSET OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN P_RECORDSET FOR
      SELECT
        *
      FROM
        EWPS_REF_APP_FUNCTION;
  END SP_EWPS_GET_ALL_APP_FUNCTIONS_REF;

  PROCEDURE SP_EWPS_GET_ALL_CE_SOURCE_REF (
    P_RECORDSET OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN P_RECORDSET FOR
      SELECT
        *
      FROM
        EWPS_REF_CE_SOURCE;
  END SP_EWPS_GET_ALL_CE_SOURCE_REF;

  PROCEDURE SP_EWPS_GET_ALL_FILE_TRANSFER_INFO(
    P_RECORDSET OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN P_RECORDSET FOR
      SELECT
        *
      FROM
        EWPS_FILE_TRANSFER_INFO;
  END SP_EWPS_GET_ALL_FILE_TRANSFER_INFO;

  PROCEDURE SP_EWPS_GET_ALL_JOBS_REF (
    P_RECORDSET OUT SYS_REFCURSOR
  ) AS
  BEGIN
    OPEN P_RECORDSET FOR
      SELECT
        *
      FROM
        EWPS_REF_JOB;
  END SP_EWPS_GET_ALL_JOBS_REF;

  PROCEDURE SP_EWPS_GET_JOB_LOGS (
    P_RECORDSET OUT SYS_REFCURSOR,
    P_OFFSET IN NUMBER,
    P_PAGE_SIZE IN NUMBER
  ) AS
    V_TOTAL_ROW  NUMBER;
    V_TOTAL_PAGE NUMBER;
  BEGIN
    SELECT
      COUNT(*) INTO V_TOTAL_ROW
    FROM
      EWPS_JOB_LOG
    WHERE
      1=1;
    V_TOTAL_PAGE := V_TOTAL_ROW / P_PAGE_SIZE;
    OPEN P_RECORDSET FOR
      SELECT
        J.*,
        REF.JOB_ID,
        REF.JOB_NAME,
        V_TOTAL_PAGE AS TOTAL_PAGE
      FROM
        EWPS_JOB_LOG J
        JOIN EWPS_REF_JOB REF
        ON REF.JOB_ID = J.JOB_ID
      ORDER BY
        JOB_START_DTTM DESC OFFSET P_OFFSET ROWS FETCH NEXT P_PAGE_SIZE ROWS ONLY;
  END SP_EWPS_GET_JOB_LOGS;

  PROCEDURE SP_EWPS_GET_JOB_LOG_DETAILS(
    P_RECORDSET OUT SYS_REFCURSOR,
    P_LOG_ID IN VARCHAR2
  ) AS
  BEGIN
    OPEN P_RECORDSET FOR
      SELECT
        J.*,
        RX.JOB_NAME
      FROM
        EWPS_JOB_LOG J
        JOIN EWPS_REF_JOB RX
        ON J.JOB_ID=RX.JOB_ID
      WHERE
        LOG_ID=P_LOG_ID;
  END;

  PROCEDURE SP_EWPS_GET_USERS (
    P_RECORDSET OUT SYS_REFCURSOR,
    P_SEARCH_TEXT IN VARCHAR2,
    P_OFFSET IN NUMBER,
    P_PAGE_SIZE IN NUMBER
  ) AS
    V_TOTAL_ROW  NUMBER;
    V_TOTAL_PAGE NUMBER;
    V_NEXT_ROWS  NUMBER;
  BEGIN
    IF P_SEARCH_TEXT IS NULL THEN
      SELECT
        COUNT(*) INTO V_TOTAL_ROW
      FROM
        (
          SELECT
            USER_NAME
          FROM
            EWPS_ACCESS_CONTROL
          GROUP BY
            USER_NAME
        );
      V_TOTAL_PAGE :=CEIL(V_TOTAL_ROW / P_PAGE_SIZE);
    ELSE
      SELECT
        COUNT(*) INTO V_TOTAL_ROW
      FROM
        (
          SELECT
            USER_NAME
          FROM
            EWPS_ACCESS_CONTROL
          WHERE
            USER_NAME LIKE '%'
                           || P_SEARCH_TEXT
                           ||'%'
          GROUP BY
            USER_NAME
        );
      V_TOTAL_PAGE := CEIL(V_TOTAL_ROW / P_PAGE_SIZE);
    END IF;
    V_NEXT_ROWS := P_OFFSET + P_PAGE_SIZE;
    DBMS_OUTPUT.PUT_LINE('offset: '
                         || P_OFFSET);
    DBMS_OUTPUT.PUT_LINE('next rows: '
                         || V_NEXT_ROWS);
    OPEN P_RECORDSET FOR WITH CTE_ACCOUNT AS (
      SELECT
        T.*,
        V_TOTAL_PAGE                           AS TOTAL_PAGE,
        REF.CLIENT_TYPE,
        DENSE_RANK() OVER (ORDER BY USER_NAME) AS RANK
      FROM
        EWPS_ACCESS_CONTROL   T
        JOIN EWPS_REF_APP_FUNCTION REF
        ON REF.APP_FUNCTION = T.APP_FUNCTION
    )
      SELECT
        *
      FROM
        CTE_ACCOUNT
      WHERE
        RANK BETWEEN P_OFFSET AND V_NEXT_ROWS;
  END SP_EWPS_GET_USERS;

  PROCEDURE SP_EWPS_GET_USER_DETAILS(
    P_RECORDSET OUT SYS_REFCURSOR,
    P_USER_NAME VARCHAR2
  ) AS
  BEGIN
    OPEN P_RECORDSET FOR
      SELECT
        USER_NAME,
        AF.APP_FUNCTION,
        AF.CLIENT_TYPE,
        ACCESS_LEVEL
      FROM
        EWPS_ACCESS_CONTROL   AC
        JOIN EWPS_REF_APP_FUNCTION AF
        ON AF.APP_FUNCTION = AC.APP_FUNCTION
      WHERE
        LOWER(USER_NAME)=LOWER(P_USER_NAME) UNION
        SELECT
          LOWER(P_USER_NAME) AS USER_NAME,
          ROLE               AS APP_FUNCTION,
          'db'               AS CLIENT_TYPE,
          7 AS ACCESS_LEVEL
        FROM
          ROLE_SYS_PRIVS
        WHERE
          ROLE LIKE '%EWPS%'
          OR ROLE LIKE '%ewps%'
        ORDER BY
          1;
  END SP_EWPS_GET_USER_DETAILS;

  PROCEDURE SP_EWPS_INSERT_USER(
    P_APP_FUNCTION VARCHAR2,
    P_USER_NAME VARCHAR2,
    P_ACCESS_LEVEL INT
  ) AS
  BEGIN
    INSERT INTO EWPS_ACCESS_CONTROL (
      APP_FUNCTION,
      USER_NAME,
      ACCESS_LEVEL
    ) VALUES (
      P_APP_FUNCTION,
      P_USER_NAME,
      P_ACCESS_LEVEL
    );
  END SP_EWPS_INSERT_USER;

  PROCEDURE SP_EWPS_SAVE_JOB_LOG (
    P_LOG_ID IN NUMBER,
    P_JOB_START_DTTM IN TIMESTAMP,
    P_JOB_END_DTTM IN TIMESTAMP,
    P_JOB_ID IN VARCHAR2,
    P_JOB_PARAMETERS IN VARCHAR2,
    P_JOB_STATUS IN NUMBER,
    P_JOB_STATUS_DESC IN VARCHAR2,
    P_USER_NAME IN VARCHAR2,
    P_ID OUT NUMBER
  ) AS
  BEGIN
    IF P_LOG_ID > 0 THEN
      UPDATE EWPS_JOB_LOG
      SET
        JOB_START_DTTM =P_JOB_START_DTTM,
        JOB_END_DTTM=P_JOB_END_DTTM,
        JOB_STATUS = P_JOB_STATUS,
        JOB_STATUS_DESC =P_JOB_STATUS_DESC,
        USER_NAME = P_USER_NAME
      WHERE
        LOG_ID = P_LOG_ID RETURNING LOG_ID INTO P_ID;
    ELSE
      INSERT INTO EWPS_JOB_LOG (
        JOB_START_DTTM,
        JOB_END_DTTM,
        JOB_ID,
        JOB_PARAMETERS,
        JOB_STATUS,
        JOB_STATUS_DESC,
        USER_NAME
      ) VALUES (
        P_JOB_START_DTTM,
        P_JOB_END_DTTM,
        P_JOB_ID,
        P_JOB_PARAMETERS,
        P_JOB_STATUS,
        P_JOB_STATUS_DESC,
        P_USER_NAME
      ) RETURNING LOG_ID INTO P_ID;
    END IF;
    COMMIT;
  END SP_EWPS_SAVE_JOB_LOG;
END PKG_EWPS_API;
/