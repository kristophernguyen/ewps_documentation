I think we need to be consistent in our design.  The users don’t need to know if we have a mapping table or not.  One thing I can say here is that the mapping table give us the abstraction benefits.  
-	When it comes to insert one single record in the UI, we don’t have a file to rely on, we need some sort of mapping to reliably insert/update records
-	If the user have extra columns in their input files, we can have a warning in the process log file.  
-	If in the future, user want to add a new column for the work/permanent table, all we need to do is add the data into the mapping table and let tester test it without any source code (API) change.
There are more benefits than not having this abstraction layer and be CONSISTENT throughout the load process regardless of file types
