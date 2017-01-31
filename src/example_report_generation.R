##############################################################################################
# File: example_report_generation.R
# Author: FILL NAME HERE
# Date: FILL DATE HERE
# TLDR: Send email with attachment
##############################################################################################

flog.info('Executing example_report_generation')


rmarkdown::render('src/example_report.Rmd', output_format='html_document', output_dir='data/working/output', 
                  intermediates_dir='data/working/intermediate')
