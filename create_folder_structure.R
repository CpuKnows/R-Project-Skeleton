##############################################################################################
# File: create_folder_structure.R
# Author: John Maxwell
# Date: 2016-10-27
# TLDR: Creates the folder structure for R Project Skeleton. Delete after folder structure
#       is created.
##############################################################################################

setwd('root file path here')

# Create folder structure
if(!dir.exists('data')) {
  dir.create('data')
  dir.create('data/input')
  dir.create('data/intermediate')
  dir.create('data/outupt')
  dir.create('data/original')
}

if(!dir.exists('documentation')) {
  dir.create('documentation')
}

if(!dir.exists('logs')) {
  dir.create('logs')
}

if(!dir.exists('reports')) {
  dir.create('reports')
  dir.create('reports/src')
  dir.create('reports/data')
}

