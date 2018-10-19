### Utility Scripts

## EDGES_data_parser.sh

This script takes the JSON file produced by EDGES and converts it into a CSV. It is important to note that the deliminator for this file is a space instead of the ususal commma. 
# Dependencies 
You do not have to be connected to the internet to run this script. However, you do need to have `jq` installed before you run it. Once connected to the internet, run `sudo apt-get install jq` to acquire `jq`.
# How to Run
The script will display some information about the process when you start. 
* You start by inputting the file path for the data you want to process. For example: `/home/bob/Documents/EDGES_DATA.json `.
* After this you will enter the path to the save location for the new csv. For example: `/home/bob/Documents/`
* After this you will enter the file's new name. For example: `data.csv` .
Finally, you will see a confirmation of the information you entered and the file will begin to process. This process will take some time. In my situation, a 200 MB JSON takes about 30 minutes to process and the resulting CSV is 95 MB.  

## EDGES_script.R 

This script is a low-bandwidth solution for gathering data from EDGES. After using the above script, you can run this script to get a report and four graphs. 
# Dependencies 
You do not have to be connected to the internet to run this script. However, it does depend on having `r-base`, `readr`,and `ggplot2` installed. This means that you need to have been connected to the Internet to install these packages before you can run the script for the first time. Running the script after the installing those packages can be done without the Internet. 
You can install `r-base` by running `sudo apt-get install r-base`. This will allow us to run the script from terminal. To get `readr` and `ggplot2`, type `install.packages('readr')` and press enter. After that type `install.packaes('ggplot2')` and press enter. This will install the necessary libraries. 
# How to Run 
In terminal, type `r -i EDGES_script.R`. You only need to supply the file name and extension. For example, `data.csv`. Yes, it must be a CSV file. Please see the EDGES_datas_parser.csv ffor help with this. This will create a new directory in the current directory with the report and graphs in it. The directory will be "EDGES" followed by the current date.
