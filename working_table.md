Hi Cathy/Adnan,
  I tried to accommodate as much as possible but there are cases where we can’t just assume that these data are for business need only.  I believe that we need to have two types of data, one is for domain logic, the other is for application so we can do dynamic stuff.  Regarding to the mapping table.  This is one example of it and I can’t do anything if the name is not consistently mapped with the working and permanent table.  For example:

 [picture link]


I can dynamically generate the working table by using this formula:

EWPS_CE_[CE_SOURCE]_[FILE_NAME]  (removing {yyq} from the filename in the EWPS_FILE_TRANSFER_INFO.
W_ EWPS_CE_[CE_SOURCE]_[FILE_NAME]

I really don’t like to hard coding stuff unless I really have to.  The best and most flexible way to deal with this situation is to have another mapping table.  We should call this “EWPS_File_Table_Mapping” and the current one should be renamed it to “EWPS_FILE_COLUMN_MAPPING”

This will give us the ability to configure any permanent/working table for a particular file.  This is the most flexible way that I had encountered in my previous project.   If we decided not to go this route for any particular reason, I’m ok with that as well as long as we are consistent with the table name.  Otherwise, I will have to hard coding thing.



Hi Cathy/Adnan,

I have made an effort to accommodate as much as possible, but there are cases where we cannot assume that this data is exclusively for business needs. I believe we need to categorize data into two types: one for domain logic and the other for application, allowing for dynamic functionality. Regarding the mapping table, the presented example demonstrates a challenge when names are inconsistently mapped with the working and permanent tables.

Here is an example:

[picture link]

I can dynamically generate the working table using the formula:

- Working Table: EWPS_CE_[CE_SOURCE]_[FILE_NAME] (excluding {yyq} from the filename in the EWPS_FILE_TRANSFER_INFO.)
- Permanent Table: W_EWPS_CE_[CE_SOURCE]_[FILE_NAME]

I prefer to avoid hard-coding unless absolutely necessary. The most flexible approach to address this situation is to introduce another mapping table, named "EWPS_File_Table_Mapping." Meanwhile, the current one should be renamed to "EWPS_FILE_COLUMN_MAPPING."

This modification allows us to configure any permanent/working table for a particular file, a strategy I found to be highly flexible in my previous projects. If there are reasons not to pursue this approach, I am open to alternatives as long as we maintain consistency in table naming. Otherwise, hard-coding may become necessary.
