DECLARE
    v_cursor SYS_REFCURSOR;
    v_column_not_found EXCEPTION;
    v_cursor_not_open EXCEPTION;
    PRAGMA EXCEPTION_INIT(v_column_not_found, -1007); -- ORA-01007: variable not in select list
    PRAGMA EXCEPTION_INIT(v_cursor_not_open, -1001);  -- ORA-01001: invalid cursor
BEGIN
    PKG_EWPS_API.SP_EWPS_GET_ALL_APP_FUNCTIONS_REF(v_cursor);

    -- Check if cursor is open
    IF v_cursor%ISOPEN THEN
        -- Check for the existence of specific columns
        FOR c IN (SELECT * FROM USER_TAB_COLUMNS WHERE TABLE_NAME = 'EWPS_REF_APP_FUNCTION') LOOP
            BEGIN
                IF NOT dbms_sql.describe_columns(v_cursor, c.COLUMN_NAME) THEN
                    RAISE v_column_not_found;
                END IF;
            EXCEPTION
                WHEN v_column_not_found THEN
                    dbms_output.put_line('Column ' || c.COLUMN_NAME || ' does not exist in the result set.');
            END;
        END LOOP;

        -- Close the cursor
        CLOSE v_cursor;
    ELSE
        -- Handle the invalid cursor exception
        dbms_output.put_line('Cursor is not open.');
        RAISE v_cursor_not_open;
    END IF;
EXCEPTION
    WHEN v_cursor_not_open THEN
        -- Handle the invalid cursor exception
        dbms_output.put_line('Invalid cursor exception occurred. Handle as needed.');
END;


