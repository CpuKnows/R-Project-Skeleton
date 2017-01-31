##############################################################################################
# File: helper.R
# Author: FILL NAME HERE
# Date: FILL DATE HERE
# TLDR: Helper Functions
##############################################################################################

##############################################################################################
# Import C++ functions
##############################################################################################
# imports function: foo(NumericVector abc)
sourceCpp("src/cpp/example.cpp")


##############################################################################################
# Import special functions from src
##############################################################################################
source('src/sql_functions.R')


##############################################################################################
# Standardize field functions
##############################################################################################

##############################################################################################
# Function: standardize_company
# Input:    character vector
# Output:   character vector
# TLDR:     Standardizes the name of companies
##############################################################################################
standardize_company = function(companies) {
  companies = str_to_upper(companies)
  
  # Dot com
  companies = str_replace(companies, '\\.COM', ' DOTCOM')
  # Abbreviations
  companies = str_replace(companies, 'L\\. L\\. C\\.', 'LLC')
  companies = str_replace(companies, 'L\\.L\\.C\\.', 'LLC')
  companies = str_replace(companies, 'L\\.L\\.C', 'LLC')
  companies = str_replace(companies, 'L L C', 'LLC')
  companies = str_replace(companies, 'U\\. S\\. A\\.', 'USA')
  companies = str_replace(companies, 'U\\.S\\.A\\.', 'USA')
  companies = str_replace(companies, 'U S A\\.', 'USA')
  
  # Squishing
  companies = str_replace(companies, 'ON LINE', 'ONLINE')
  companies = str_replace(companies, 'ON-LINE', 'ONLINE')
  
  # Only letters, numbers, spaces
  companies = str_replace_all(companies, '[^[:alnum:] ]', '')
  
  # Remove Words
  companies = str_replace_all(companies, '^INC | INC$', ' ')
  companies = str_replace_all(companies, ' INC ', ' ')
  companies = str_replace_all(companies, '^INCORPORATED | INCORPORATED$', ' ')
  companies = str_replace_all(companies, ' INCORPORATED ', ' ')
  companies = str_replace_all(companies, '^LLC | LLC$', ' ')
  companies = str_replace_all(companies, ' LLC ', ' ')
  companies = str_replace_all(companies, '^CORP | CORP$', ' ')
  companies = str_replace_all(companies, ' CORP ', ' ')
  companies = str_replace_all(companies, '^LTD | LTD$', ' ')
  companies = str_replace_all(companies, ' LTD ', ' ')
  companies = str_replace_all(companies, '^CORPORATION | CORPORATION$', ' ')
  companies = str_replace_all(companies, ' CORPORATION ', ' ')
  companies = str_replace_all(companies, '^CO | CO$', ' ')
  companies = str_replace_all(companies, ' CO ', ' ')
  companies = str_replace_all(companies, '^COMPANY | COMPANY$', ' ')
  companies = str_replace_all(companies, ' COMPANY ', ' ')
  companies = str_replace_all(companies, '[ ]{2,}', ' ')
  
  companies = str_trim(companies, 'both')
  
  companies = sapply(str_split(companies, ' '), 
                     function(x) if(length(x) > 10) {str_c(x[1:10], collapse=' ')} else {str_c(x, collapse=' ')})
  companies = str_sub(companies, 1, 60)
  
  return(companies)
}

##############################################################################################
# Function: standardize_phone
# Input:    character vector
# Output:   character vector
# TLDR:     Standardizes phone numbers
##############################################################################################
standardize_phone = function(phone) {
  df = data_frame(phone=phone)
  
  df$phone = str_to_lower(df$phone)
  df$phone = str_replace(df$phone, 'x.+$|ext.+$', '')
  
  df$phone_clean = str_replace_all(df$phone, '[^[:digit:]]', '')
  df$phone_clean_len = str_length(df$phone_clean)
  
  df$phone_keep = NA
  df$phone_keep = ifelse(df$phone_clean_len == 10, df$Phone_clean, df$phone_keep)
  df$phone_keep = ifelse(df$phone_clean_len == 11 & str_sub(df$phone_clean, 1, 1) == '1', 
                         str_sub(df$phone_clean, 2, -1), df$phone_keep)
  
  bad_phone_nums = c('11111111111', 
                     '1111111111', '2222222222', '3333333333', '4444444444', '5555555555',
                     '6666666666', '7777777777', '8888888888', '9999999999', '0000000000')
  df$phone_keep = ifelse(df$Phone_clean %in% bad_phone_nums, '', df$phone_keep)
  df$phone_keep = ifelse(is.na(df$phone_keep), '', df$phone_keep)
  
  return(df$phone_keep)
}


##############################################################################################
# Function: fix_zip
# Input:    character vector zips
#           int set_len - length to pad to
# Output:   character vector
# TLDR:     Pads zips with zeroes to a certain length. Doesn't pad empty strings.
##############################################################################################
fix_zip = function(zips, set_len) {
  
  for(i in seq_len(set_len - 1)) {
    zero_str = paste0(rep_len('0', set_len - i))
    
    zips = ifelse(str_length(zips) == i, paste0(zero_str, zips), zips)
  }
  
  return(zips)
}
