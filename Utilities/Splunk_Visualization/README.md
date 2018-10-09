# SPLUNK VISUALIZATIONS FOR EDGES

### LEGEND
- [GETTING THE DATA IN](#getting-the-data-in)
   * [BEFORE YOU BEGIN](#before-you-begin)
   * [SETTING UP SPLUNK](#setting-up-splunk)
   * [LOGGING IN](#logging-in)
   * [GETTING YOUR DATA](#getting-your-data) 
   * [VERIFYING DATA INGEST](#verifying-data-ingest)
   * [CREATING THE DASHBOARD](#creating-the-dashboard)
- [EDGES DEEP DIVE](#edges-deep-dive)
   * [REQUIREMENTS](#deep-dive-requirements)
   * [REMINDERS](deep-dive-reminders)
- [THE HUNT](#the-hunt)
   * [REQUIREMENTS](#hunt-requirements)
   * [REMINDERS](#hunt-reminders)
   
# GETTING THE DATA IN

## BEFORE YOU BEGIN
* Have your EDGES data in an easily accessible local directory.
* Run the [EDGES_data_parser.sh](https://github.com/sofwerx/EDGES/blob/master/Utilities/EDGES_data_parser.sh) script to convert from JSON to CSV.
* Reminder: Run the [EDGES_script.R](https://github.com/sofwerx/EDGES/blob/master/Utilities/EDGES_script.R) if you are in a low-bandwidth situation.

## SETTING UP SPLUNK 
1. Run [Docker_Splunk_setup.sh](https://github.com/sofwerx/EDGES/blob/master/Utilities/Splunk_Visualization/Docker_Splunk_Setup.sh) script to setup a local Splunk instance for you.
2. Reminder: If you just downloaded the script you may need to run this command before you can run Docker_Splunk_setup.sh.
    * `chmod +x Docker_Splunk_setup.sh`
3. Splunk should now be on localhost:8000
4. To get to Splunk, open a web-browser and type in `localhost:8000`
    * Warning: Make sure the script was executed sucessfully. If you already have something allocated to `localhost:8000` this may cause a problem.

## LOGGING IN
* You should be greeted with a login screen. For the user enter `admin` and for the password use the password that you used during the installation.
* You should now be on the Splunk Homepage. 
         ![1](https://github.com/sofwerx/EDGES/blob/master/Utilities/Splunk_Visualization/Images/1Splunk%20Homepage.png)

## GETTING YOUR DATA 
1. Go to Settings on the top right hand side of the screen. Then click on Add Data.
         ![2](https://github.com/sofwerx/EDGES/blob/master/Utilities/Splunk_Visualization/Images/2Settings%20on%20Homepage.png)
2. You should be redirected here. For our purposes, we will be using the Upload option.
         ![3](https://github.com/sofwerx/EDGES/blob/master/Utilities/Splunk_Visualization/Images/3Add%20Data%20screen.png)
3. Click Select File and locate your EDGES data, then click Next at the top of the screen.
         ![4](https://github.com/sofwerx/EDGES/blob/master/Utilities/Splunk_Visualization/Images/4Select%20source%20screen.png)
4. To get our data to appear, click on Delimited settings and change the Field delimiter to space. Make sure your data is being correctly parsed before continuing. Then press Next.
         ![5](https://github.com/sofwerx/EDGES/blob/master/Utilities/Splunk_Visualization/Images/5Set%20Source%20Type.png)
5. Under Index, change from Default to main. Then click Review at the top of the screen.
         ![6](https://github.com/sofwerx/EDGES/blob/master/Utilities/Splunk_Visualization/Images/6Input%20Settings%20screen.png)
6. You should now be met with this screen. Your data has been ingested into Splunk.
         ![7](https://github.com/sofwerx/EDGES/blob/master/Utilities/Splunk_Visualization/Images/7File%20Uploaded.png)

## VERIFYING DATA INGEST
* From the end of the last section, select the Start Searching option.
         ![8](https://github.com/sofwerx/EDGES/blob/master/Utilities/Splunk_Visualization/Images/8Splunk%20Search%20bar.png)
* You should now see data start to populate on the screen. If you do not see this, give it a few minutes then refresh the page. If the problem persists, then redo GETTING YOUR DATA INTO SPLUNK.

## CREATING THE DASHBOARD
1. At the top of the screen you should see five different tabs labeled: Search, Datasets, Reports, Alerts, and Dashbaords. Select the Dashboard tab.
        ![9](https://github.com/sofwerx/EDGES/blob/master/Utilities/Splunk_Visualization/Images/9Dashboards%20Screen.png)
2. Select the Create New Dashboard button on the left of the screen. 
3. A popup should appear. The Title should be EDGES Deep Dive. Then select Create Dashboard.
         ![10](https://github.com/sofwerx/EDGES/blob/master/Utilities/Splunk_Visualization/Images/10Dashboard%20title.png)
4. Select Edit on the top right side of the screen, then select Source.
         ![11](https://github.com/sofwerx/EDGES/blob/master/Utilities/Splunk_Visualization/Images/11Edit_Dashboard.png)
5. Delete the XML that already exists. Then copy the code from EDGES_Deep_Dive_Dashboard.txt and paste it into that area. Then press Save on the top right side. 
         ![12](https://github.com/sofwerx/EDGES/blob/master/Utilities/Splunk_Visualization/Images/12Dashboard%20Source%20creation.png)
6. Your dashboard should now appear and the panels should start populating.
        ◦ Depending on how large your file is, it may take some time for the panels to populate. If they do not populate after a few minutes, put your mouse over the panel and click the small refresh icon on the bottom right of the panel.

## EDGES DEEP DIVE

![Deep Dive](https://github.com/sofwerx/EDGES/blob/master/Utilities/Splunk_Visualization/Images/13Finished_Dashboard.png)

### DEEP DIVE REQUIREMENTS

There are no special requirements to run this dashbord. This dashboard utilizes out of the box Splunk capabilites. 

### DEEP DIVE REMINDERS

If you ingest multiple sourcetypes, you have to adjust the SPL to reflect this. By default, the dashboard is set to run with one sourcetype and uses a catchall csv to accomplish this.

A suggested method to accomplish multiple sourcetypes is to use a standard naming convention for all of your EDGES data. Then create an input for the dashboard that only selects one sourcetype at a time. This way, you can use tokens from the input into each panel and have all the panels adjust automatically. 

## THE HUNT

![The Hunt](https://github.com/sofwerx/EDGES/blob/master/Utilities/Splunk_Visualization/Images/The_Hunt_pic.png)

### HUNT REQUIREMENTS

This dashboard requires [the Location Tracker app from Splunkbase](https://splunkbase.splunk.com/app/3164/). Out of the box Splunk does not include the Sattelite imagery required to run this dashboard. 

I used https://www.cellmapper.net/ in testing to help verify results. Results seemed to agree with the information on the website and in the same direction the website stated. While I am not endorsing the website, it may be a useful tool.

### HUNT REMINDERS 

There is an assumption made in the dashboard regarding what power constitutes a possible tower location. During testing, power greater than -15 dB seemed to give the most accurate resutls with the least amount of noise. Test data was conducted in an urban setting with ample cell tower coverage. Depending on your testing location, you may need to adjust this value. 

If you ingest multiple sourcetypes, you have to adjust the SPL to reflect this. By default, the dashboard is set to run with one sourcetype and uses a catchall csv to accomplish this.

A suggested method to accomplish multiple sourcetypes is to use a standard naming convention for all of your EDGES data. Then create an input for the dashboard that only selects one sourcetype at a time. This way, you can use tokens from the input into each panel and have all the panels adjust automatically. 
