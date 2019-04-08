
/* https://docs.microsoft.com/en-us/sql/relational-databases/system-stored-procedures/sp-help-transact-sql?view=sql-server-2017 */


-- Reports information about a database object (any object listed in the sys.sysobjects compatibility view),
-- a user-defined data type, or a data type.

sp_help FD__DIAGNOSIS_DETAIL

-- Returns column information for the specified objects that can be queried in the current environment.

exec sp_columns FD__clients
