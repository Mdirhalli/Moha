## How to connect R with SQL Server 

## 1. Install package 

install.packages("RODBC")
library(RODBC)


install.packages("odbc")
library(odbc)


dbconnection <- odbcDriverConnect("Driver=SQL Server;
					     Server=(local)\\pv91374timdbw01.npc.lan;
					     Database=wfs_live;
					     trusted_connection=yes;
						User Id= ; password= ")
            
                        
 data <- sqlFetch(dbconnection, 'dbo.temp_table', colnames=FALSE, rows_at_time=1000)

## OR

dbconnection <- odbcDriverConnect("Driver= SQL Server;
					     Server=pv91374timdbw01.npc.lan;
					     Database=wfs_live;
					     User Id= Maldirhalli; 
					     password= @Hunterm7891#;
						trusted_connection=yes;")
            
            
initdata <- sqlQuery(dbconnection,paste("select * from FD__clients;"))
odbcClose(channel)
