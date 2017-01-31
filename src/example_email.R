##############################################################################################
# File: example_email.R
# Author: FILL NAME HERE
# Date: FILL DATE HERE
# TLDR: Send email with attachment
##############################################################################################

flog.info('Executing example_email')


if(EMAIL_ENABLED == TRUE) {
  send.mail(from=EMAIL_USER, 
            to='foo@bar.com',
            subject='Test Email', 
            body='Body text here', 
            smtp=list(host.name=EMAIL_HOST,
                      port=EMAIL_PORT,
                      user.name=EMAIL_USER,
                      passwd=EMAIL_PW,
                      tls=TRUE),
            authenticate=TRUE,
            send=TRUE,
            attach.files='data/working/output/example_report.html')
}
