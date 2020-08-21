# Getting and cleaning data Assignment
Output of the the peer review data cleaning project

To run the the analysis, save the contents of this repo in your directory and enter source('<directory>/run_analysis.R')
The run_analysis.R file takes the data from the URL https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip as input.
The output is a tidy data set that is called "merged" of witch the first few rows are printed to the screen. 
The secondary output is a tidy data frame of the means of all the variables grouped by the activity and the subject of the accelerometer experiment. It is printed to a file in your directory called "groupedmeansfinaldataset.txt" which is also saved in this repo.

The source code is annotated to explain the process with comments. The variables are described in the file "codebook.txt" saved in this repo
