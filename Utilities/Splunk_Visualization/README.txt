# Data from EDGES and putting them into Splunk

<img src=/Images/13Finished_Dashboard.png />

## BEFORE YOU BEGIN
    • Have your EDGES data in an easily accessible local directory.
    • Run the [EDGES_data_parser.sh](https://github.com/sofwerx/EDGES/blob/master/Utilities/EDGES_data_parser.sh) script to convert from JSON to CSV.
    • Reminder: Run the [EDGES_script.R](https://github.com/sofwerx/EDGES/blob/master/Utilities/EDGES_script.R) if you are in a low-bandwidth situation.

## SETTING UP SPLUNK 
    1. Run [Docker_Splunk_setup.sh](https://github.com/sofwerx/EDGES/blob/master/Utilities/Splunk_Visualization/Docker_Splunk_Setup.sh) script to setup a local Splunk instance for you.
    2. Reminder: If you just downloaded the script you may need to run this command before you can run Docker_Splunk_setup.sh.
        ◦ `chmod +x Docker_Splunk_setup.sh`
    3. Splunk should now be on localhost:8000
    4. To get to Splunk, open a web-browser and type in `localhost:8000`
    • Warning: Make sure the script was executed sucessfully. If you already have something allocated to `localhost:8000` this may cause a problem.

## LOGGING INTO SPLUNK
    • You should be greeted with a login screen. For the user enter `admin` and for the password use the password that you used during the installation.
    • You should now be on the Splunk Homepage. 
         <img src=”/Images/1Splunk Homepage.png” />

## GETTING YOUR DATA INTO SPLUNK
    1. Go to Settings on the top right hand side of the screen. Then click on Add Data.
         <img src=”/Images/2Settings on Homepage.png” />
    2. You should be redirected here. For our purposes, we will be using the Upload option.
         <img src=”/Images/3Add Data screen.png” />
    3. Click Select File and locate your EDGES data, then click Next at the top of the screen.
         <img src=”/Images/4Select source screen.png” />
    4. To get our data to appear, click on Delimited settings and change the Field delimiter to space. Make sure your data is being correctly parsed before continuing. Then press Next.
         <<img src=”/Images/5Set Source Type.png” />
    5. Under Index, change from Default to main. Then click Review at the top of the screen.
         <img src=”/Images/6Input Settings screen.png” />
    6. You should now be met with this screen. Your data has been ingested into Splunk.
         <img src=”/Images/7File Uploaded.png” />

## VERIFYING DATA INGEST
    • From the end of the last section, select the Start Searching option.
         <img src=”/Images/8Splunk Search bar.png” />
    • You should now see data start to populate on the screen. If you do not see this, give it a few minutes then refresh the page. If the problem persists, then redo GETTING YOUR DATA INTO SPLUNK.

## CREATING THE DASHBOARD
    1. At the top of the screen you should see five different tabs labeled: Search, Datasets, Reports, Alerts, and Dashbaords. Select the Dashboard tab.
        ◦ <img src=”/Images/9Dashboards Screen.png” />
    2. Select the Create New Dashboard button on the left of the screen. 
    3. A popup should appear. The Title should be EDGES Deep Dive. Then select Create Dashboard.
         <img src=”/Images/10Dashboard title.png” />
    4. Select Edit on the top right side of the screen, then select Source.
         <img src=”/Images/11Edit_Dashboard” />
    5. Delete the XML that already exists. Then copy the code from EDGES_Deep_Dive_Dashboard.txt and paste it into that area. Then press Save on the top right side. 
         <img src=”/Images/12Dashboard Source creation.png” />
    6. Your dashboard should now appear and the panels should start populating.
        ◦ Depending on how large your file is, it may take some time for the panels to populate. If they do not populate after a few minutes, put your mouse over the panel and click the small refresh icon on the bottom right of the panel.

