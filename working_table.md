Hi Cathy/Adnan,
  I tried to accommodate as much as possible but there are cases where we can’t just assume that these data are for business need only.  I believe that we need to have two types of data, one is for domain logic, the other is for application so we can do dynamic stuff.  Regarding to the mapping table.  This is one example of it and I can’t do anything if the name is not consistently mapped with the working and permanent table.  For example:

 


I can dynamically generate the working table by using this formula:

EWPS_CE_[CE_SOURCE]_[FILE_NAME]  (removing {yyq} from the filename in the EWPS_FILE_TRANSFER_INFO.
W_ EWPS_CE_[CE_SOURCE]_[FILE_NAME]

I really don’t like to hard coding stuff unless I really have to.  The best and most flexible way to deal with this situation is to have another mapping table.  We should call this “EWPS_File_Table_Mapping” and the current one should be renamed it to “EWPS_FILE_COLUMN_MAPPING”

This will give us the ability to configure any permanent/working table for a particular file.  This is the most flexible way that I had encountered in my previous project.   If we decided not to go this route for any particular reason, I’m ok with that as well as long as we are consistent with the table name.  Otherwise, I will have to hard coding thing.
