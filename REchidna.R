## Setting your working directory
## Assuming you also have Echidna installed at "C:/Program Files/Echidna/v1.63/BIN/Echidna"
dir="c:/Test"
setwd(dir)

## Use ASReml-R wheat data set as an example
df=asreml::wheat

## Write the input file to your working directory
write.csv(df,"dat.csv",row.names=F)

## This is to create .es test file into your working directory
fileConn<-file(paste0("example.es"))
writeLines(c(
  "!WS 16 !RML                                                ",
  "Example Analysis                                           ",
  "  yield                                                    ",
  "  weed                                                     ",
  "  col *                                                    ",
  "  row *                                                    ",
  paste0("  var ",length(unique(df$Variety))," !A             "),
  "dat.csv  !SKIP 1 !MAXIT 50 !DDF -1                         ",
  "                                                           ",
  "yield ~ mu !r var                                          ",
  "residual ar1(row).ar1(col)                                 "
),fileConn)
close(fileConn)

## Executing Echidna
epath=paste0('"C:/Program Files/Echidna/v1.63/BIN/Echidna"',' \"',dir,'/example.es\"')
shell(sprintf('cd & %s',epath))

## !RML qualifier generated some outputs can be read back into R
source("example_e.R")                               ## This will load the primary results into an object example 
example$coeff=read.csv("example.ess",header=T)      ## This adds in the solutions to example 
example$yht=read.csv("example.esy",header=T)        ## This adds the residuals and fitted values 
example$esv=read.csv("example.esv",header=T,skip=5) ## This adds the list of variance components 
names(example)                                      ## This will list the contents of example
