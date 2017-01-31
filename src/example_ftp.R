##############################################################################################
# File: example_ftp.R
# Author: FILL NAME HERE
# Date: FILL DATE HERE
# TLDR: Uploads output files to FTP
##############################################################################################

flog.info('Executing example_ftp')


url = paste0('sftp://', FTP_USER, ':', FTP_PW, '@', FTP_URL, ':', FTP_PORT, '/folder_name/')

if(FTP_ENABLED == TRUE) {
 tryCatch({
   ftpUpload('data/working/output/asdf.csv', paste0(url, 'asdf.csv'))
 }, error = function() {
   flog.error('Output files weren\'t uploaded to FTP.')
 })
}
