##############################################################################################
# File: helper.R
# Author: FILL NAME HERE
# Date: FILL DATE HERE
# TLDR: SQL Functions using RPostgreSQL package
##############################################################################################

##############################################################################################
# Fuction:  get_sql_table
# Input:    table_name - name of SQL table
# Output:   dataframe of table
# TLDR:     Returns a table from SQL DB
##############################################################################################
get_sql_table = function(table_name) {
  
  drv = dbDriver('PostgreSQL')
  con = dbConnect(drv, dbname=DBNAME, host=HOST, port=PORT, user=USER, password=PASSWORD)
  if(class(con) != 'PostgreSQLConnection') {
    if(LOGGING_ENABLED) {
      flog.error('Failed to connect to %s', table_name)
    }
    return(data.frame())
  }
  
  # Clean up
  on.exit(dbDisconnect(con), add=TRUE)
  on.exit(dbUnloadDriver(drv), add=TRUE)
  
  is_success = dbExistsTable(con, table_name)
  if(is_success == FALSE) {
    if(LOGGING_ENABLED) {
      flog.error('Table %s doesnt exist', table_name)
    }
    return(data.frame())
  }
  
  df = dbGetQuery(con, paste0('SELECT * FROM ', table_name))
  
  return(df)
}


##############################################################################################
# Fuction:  upsert_to_table
# Input:    table_name - name of SQL table
#           df - data.frame to upsert
# Output:   Error code
#             0 - success
#             1 - no connection to DB
#             2 - table_name not in DB
# TLDR:     Upserts data into SQL table. Must be customize for each table
##############################################################################################
upsert_to_table = function(table_name, df) {
  
  drv = dbDriver('PostgreSQL')
  con = dbConnect(drv, dbname=DBNAME, host=HOST, port=PORT, user=USER, password=PASSWORD)
  if(class(con) != 'PostgreSQLConnection') {
    if(LOGGING_ENABLED) {
      flog.error('Failed to connect to %s', table_name)
    }
    return(1)
  }
  
  # Clean up
  on.exit(dbDisconnect(con), add=TRUE)
  on.exit(dbUnloadDriver(drv), add=TRUE)
  
  is_success = dbExistsTable(con, table_name)
  if(is_success == FALSE) {
    if(LOGGING_ENABLED) {
      flog.error('Table %s doesnt exist', table_name)
    }
    return(2)
  }
  
  for(i in seq_len(nrow(df))) {
    # Upsert SQL query:
    #   INSERT INTO table (pkey1, pkey2)
    #   VALUES ('00', '1960-01-01', 0)
    #     ON CONFLICT ON CONSTRAINT table_pkey DO UPDATE
    #     SET a_char='00', a_date='1960-01-01', an_int=0;
    upsert_str = paste0("INSERT INTO ", table_name, " (a_char, a_date) ",
                        "VALUES ('", df[i, 'a_char'], "', '", df[i, 'a_date'], "') ",
                        "ON CONFLICT ON CONSTRAINT ", table_name, "_pkey DO UPDATE ",
                        "SET a_char='", df[i, 'a_char'], "', a_date='", df[i, 'a_date'],
                        "', an_int=", df[i, 'an_int'])
    
    dbSendQuery(con, upsert_str)
  }
  
  return(0)
}


##############################################################################################
# Fuction:  append_to_table
# Input:    table_name - name of SQL table
#           df - data.frame to upsert
# Output:   Error code
#             0 - success
#             1 - no connection to DB
#             2 - table_name not in DB
#             3 - DB write failed
# TLDR:     Append data to SQL table
##############################################################################################
append_to_table = function(db_name, df) {
  
  drv = dbDriver('PostgreSQL')
  con = dbConnect(drv, dbname=DBNAME, host=HOST, port=PORT, user=USER, password=PASSWORD)
  if(class(con) != 'PostgreSQLConnection') {
    if(LOGGING_ENABLED) {
      flog.error('Failed to connect to %s', db_name)
    }
    return(1)
  }
  
  # Clean up
  on.exit(dbDisconnect(con), add=TRUE)
  on.exit(dbUnloadDriver(drv), add=TRUE)
  
  is_success = dbExistsTable(con, table_name)
  if(is_success == FALSE) {
    if(LOGGING_ENABLED) {
      flog.error('Table %s doesnt exist', table_name)
    }
    return(2)
  }
  
  df = as.data.frame(df)
  is_success = dbWriteTable(con, table_name, df, append=TRUE, row.names=FALSE)
  
  if(is_success == FALSE) {
    return(3)
  } else {
    return(0)
  }
}
