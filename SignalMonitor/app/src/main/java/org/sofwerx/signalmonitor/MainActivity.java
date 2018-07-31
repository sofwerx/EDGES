package org.sofwerx.signalmonitor;

import android.Manifest;
import android.os.Bundle;
import android.widget.TextView;

import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;


import java.util.Collection;
import java.util.HashMap;
import java.io.File;
import java.util.LinkedList;
import java.util.List;

import android.content.pm.PackageManager;
import android.telephony.SmsManager;


import android.support.v4.content.ContextCompat;
import android.support.v4.app.ActivityCompat;
import android.location.Location;
import android.location.Criteria;
import android.location.LocationManager;
import android.location.LocationListener;
import android.location.GnssStatus;
import android.location.GnssMeasurement;
import android.location.GnssMeasurementsEvent;

import org.json.JSONObject;
import static java.time.Instant.now;
import android.app.AlertDialog;

import mil.nga.geopackage.BoundingBox;
import mil.nga.geopackage.GeoPackage;
import mil.nga.geopackage.GeoPackageManager;
import mil.nga.geopackage.db.GeoPackageDataType;
import mil.nga.geopackage.factory.GeoPackageFactory;
import mil.nga.geopackage.features.columns.GeometryColumns;
import mil.nga.geopackage.features.user.FeatureColumn;
import mil.nga.geopackage.features.user.FeatureDao;
import mil.nga.geopackage.features.user.FeatureRow;
import mil.nga.geopackage.geom.GeoPackageGeometryData;
import mil.nga.geopackage.schema.TableColumnKey;
import mil.nga.sf.GeometryType;
import mil.nga.sf.Point;


public class MainActivity extends AppCompatActivity {

    String GpkgFilename = "SignalMonitor";
    final String PtsTable = "gps_observation_points";
    final String DataTable = "gps_observation_data";
    final long WGS84_SRS = 4326;


    HashMap<Integer, String> SatType = new HashMap<Integer, String>() {
        {
            put(0, "Unknown");
            put(1, "GPS");
            put(2, "SBAS");
            put(3, "Glonass");
            put(4, "QZSS");
            put(5, "Beidou");
            put(6, "Galileo");

        }
    };

    HashMap<String, HashMap> SatStatus = new HashMap<>();
    HashMap<String, HashMap> SatInfo = new HashMap<>();

    GeoPackageManager GpkgManager = null;
    GeoPackage GPSgpkg = null;
//    SQLiteDatabase GPSdb = null;

    private final GnssStatus.Callback StatusListener = new GnssStatus.Callback() {
        public void onSatelliteStatusChanged(final GnssStatus status) {

            int numSats = status.getSatelliteCount();

            for (int i = 0; i < numSats; ++i) {

                if (status.usedInFix(i)) {
                    String con = SatType.get(status.getConstellationType(i));

                    HashMap<String, String> thisSat = new HashMap<String, String>();
                    thisSat.put("HasAlmanac", String.valueOf(status.hasAlmanacData(i)));
                    thisSat.put("HasEphemeris", String.valueOf(status.hasEphemerisData(i)));
                    thisSat.put("HasCarrierFreq", String.valueOf(status.hasCarrierFrequencyHz(i)));

                    thisSat.put("ElevationDeg", String.valueOf(status.getElevationDegrees(i)));
                    thisSat.put("AzimuthDeg", String.valueOf(status.getAzimuthDegrees(i)));
                    thisSat.put("CarrierFreq", String.valueOf(status.getCarrierFrequencyHz(i)));
                    thisSat.put("Cn0DbHz", String.valueOf(status.getCn0DbHz(i)));
                    thisSat.put("Constellation", con);
                    thisSat.put("Svid", String.valueOf(status.getSvid(i)));
                    thisSat.put("UsedInFix", String.valueOf(status.usedInFix(i)));

                    String hashkey = con + status.getSvid(i);
                    SatStatus.put(hashkey, thisSat);
                }
            }

            JSONObject satJSON = new JSONObject();
            if (SatStatus != null) {
                satJSON = new JSONObject(SatStatus);
            }

            TextView stat_tv = findViewById(R.id.status_text);
            stat_tv.setText(satJSON.toString());
        }
    };

    private final GnssMeasurementsEvent.Callback MeasurementListener = new GnssMeasurementsEvent.Callback() {

        public void onGnssMeasurementsReceived(GnssMeasurementsEvent event) {
            Collection<GnssMeasurement> gm = event.getMeasurements();

//            Iterator<GnssMeasurement> gmiter = gm.iterator();
            for(final GnssMeasurement g : gm) {

                String con = SatType.get(g.getConstellationType());

                HashMap<String, String> thisSat = new HashMap<String, String>() {
                    {
                        put("AGCLevelDb", String.valueOf(g.getAutomaticGainControlLevelDb()));
                        put("Cn0DbHz", String.valueOf(g.getCn0DbHz()));
                        put("Multipath", String.valueOf(g.getMultipathIndicator()));
                        put("SnrDb", String.valueOf(g.getSnrInDb()));
                        put("SatState", String.valueOf(g.getState()));
                        put("Svid", String.valueOf(g.getSvid()));
                    }
                };

                String hashkey = con + g.getSvid();
                SatInfo.put(hashkey, thisSat);
            }

            JSONObject satJSON = new JSONObject(SatInfo);

            TextView meas_tv = findViewById(R.id.measurement_text);
            meas_tv.setText(satJSON.toString());
        }
    };

    LocationListener locListener = new LocationListener() {
        public void onProviderEnabled(String provider) {
            TextView cur_tv = findViewById(R.id.current_text);
            cur_tv.setText(provider + " enabled");
        }

        public void onProviderDisabled(String provider) {
            TextView cur_tv = findViewById(R.id.current_text);
            cur_tv.setText(provider + " disabled");
        }

        public void onStatusChanged(final String provider, int status, Bundle extras) {
            TextView cur_tv = findViewById(R.id.current_text);
//            cur_tv.setText(provider + " status changed");
        }

        public void onLocationChanged(final Location loc) {
            TextView cur_tv = findViewById(R.id.current_text);

            HashMap<String, String> locData = new HashMap<String, String>() {
                {
                    put("Lat", String.valueOf(loc.getLatitude()));
                    put("Lon", String.valueOf(loc.getLongitude()));
                    put("Alt", String.valueOf(loc.getAltitude()));
                    put("Provider", String.valueOf(loc.getProvider()));
                    put("Time", String.valueOf(loc.getTime()));
                    put("FixSatCount", String.valueOf(loc.getExtras().getInt("satellites")));
                    put("HasRadialAccuracy", String.valueOf(loc.hasAccuracy()));
                    put("HasVerticalAccuracy", String.valueOf(loc.hasVerticalAccuracy()));
                    put("RadialAccuracy", String.valueOf(loc.getAccuracy()));
                    put("VerticalAccuracy", String.valueOf(loc.getVerticalAccuracyMeters()));
                }
            };

            String txt = locData.toString() + "\n\n" + loc.toString() + "\n\n" + GpkgFilename;
            cur_tv.setText(txt);

            FeatureDao featDao = GPSgpkg.getFeatureDao(PtsTable);

            FeatureRow frow = featDao.newRow();

            Point fix = new Point(loc.getLongitude(), loc.getLatitude(), loc.getAltitude());

            GeoPackageGeometryData geomData = new GeoPackageGeometryData(WGS84_SRS);
            geomData.setGeometry(fix);

            frow.setGeometry(geomData);

            frow.setValue("SysTime", now().toString());
            frow.setValue("Lat", (float) loc.getLatitude());
            frow.setValue("Lon", (float) loc.getLongitude());
            frow.setValue("Alt", (float) loc.getAltitude());
            frow.setValue("Provider", loc.getProvider());
            frow.setValue("GPSTime", loc.getTime());
            frow.setValue("FixSatCount", loc.getExtras().getInt("satellites"));
            frow.setValue("HasRadialAccuracy", loc.hasAccuracy());
            frow.setValue("HasVerticalAccuracy", loc.hasVerticalAccuracy());
            frow.setValue("RadialAccuracy", loc.getAccuracy());
            frow.setValue("VerticalAccuracy", loc.getVerticalAccuracyMeters());
            frow.setValue("data_dump", loc.toString());


            featDao.insert(frow);

            boolean dirty = false;
            BoundingBox bb = featDao.getBoundingBox();
            if (loc.getLatitude() < bb.getMinLatitude()) {
                bb.setMinLatitude(loc.getLatitude());
                dirty = true;
            }
            if (loc.getLatitude() > bb.getMaxLatitude()) {
                bb.setMaxLatitude(loc.getLatitude());
                dirty = true;
            }

            if (loc.getLongitude() < bb.getMinLongitude()) {
                bb.setMinLongitude(loc.getLongitude());
            }
            if (loc.getLongitude() > bb.getMaxLongitude()) {
                bb.setMaxLongitude(loc.getLongitude());
            }

            if (dirty) {
                String sql = "UPDATE gpkg_contents SET " +
                        " min_x = " + bb.getMinLongitude() +
                        ", max_x = " + bb.getMaxLongitude() +
                        ", min_y = " + bb.getMinLatitude() +
                        ", max_y = " + bb.getMaxLatitude() +
                        " WHERE table_name = '" + PtsTable + "';";
                GPSgpkg.execSQL(sql);
            }

//            String phoneNumber = "";
//
//            SmsManager smsMgr = SmsManager.getDefault();
//            smsMgr.sendTextMessage(phoneNumber, null, txt, null, null);
        }
    };



//////////////////////////////////////////////////////////////////////////////////////
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        TextView cur_tv = findViewById(R.id.current_text);

        TextView meas_tv = findViewById(R.id.measurement_text);
        TextView stat_tv = findViewById(R.id.status_text);
        meas_tv.setText("Acquiring satellites...\n", TextView.BufferType.EDITABLE);
        stat_tv.setText("Acquiring satellites...\n", TextView.BufferType.EDITABLE);
        cur_tv.setText("Acquiring satellites...\n", TextView.BufferType.EDITABLE);

        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        ActivityCompat.requestPermissions(this, new String[]{android.Manifest.permission.ACCESS_FINE_LOCATION}, 1);

        if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            stat_tv.setText("Location access denied.");
        } else {
            LocationManager locMgr = getSystemService(LocationManager.class);
            locMgr.registerGnssMeasurementsCallback(MeasurementListener);
            locMgr.registerGnssStatusCallback(StatusListener);
            Criteria crit = new Criteria();
            locMgr.requestLocationUpdates(locMgr.getBestProvider(crit, true), (long) 1000, (float) 0.0, locListener);
        }

        ActivityCompat.requestPermissions(this, new String[]{android.Manifest.permission.SEND_SMS}, 2);

        ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, 3);

        GpkgFilename = GpkgFilename + now().toString() + ".gpkg";
        File dbFile = new File(this.getFilesDir(), GpkgFilename);

        GpkgManager = GeoPackageFactory.getManager(this);
        if (GpkgManager.exists(GpkgFilename)) {
//            GPSgpkg = GpkgManager.open(GpkgFilename, true);
            GpkgManager.delete(GpkgFilename);

        }

        if (GpkgManager.create(GpkgFilename)) {
                GPSgpkg = GpkgManager.open(GpkgFilename, true);
        }


        AlertDialog.Builder dlgBuilder = new AlertDialog.Builder(this);
        if (GPSgpkg == null) {
            // TODO: handle this for real
            dlgBuilder.setMessage("GPSgpkg is null")
                    .setTitle("Oops!");
        } else {
            GPSgpkg.createGeometryColumnsTable();
            GPSgpkg.createExtensionsTable();

            GeometryColumns gcol = new GeometryColumns();
            gcol.setId(new TableColumnKey(PtsTable, "geom"));
            gcol.setGeometryType(GeometryType.POINT);
            gcol.setZ((byte) 0);
            gcol.setM((byte) 0);

            List<FeatureColumn> tblcols = new LinkedList<>();
//            tblcols.add(FeatureColumn.createPrimaryKeyColumn(0,"id"));
            tblcols.add(FeatureColumn.createColumn(2, "SysTime", GeoPackageDataType.DATETIME, false, null));
            tblcols.add(FeatureColumn.createColumn(3, "Lat", GeoPackageDataType.FLOAT, false, null));
            tblcols.add(FeatureColumn.createColumn(4, "Lon", GeoPackageDataType.FLOAT, false, null));
            tblcols.add(FeatureColumn.createColumn(5, "Alt", GeoPackageDataType.FLOAT, false, null));
            tblcols.add(FeatureColumn.createColumn(6, "Provider", GeoPackageDataType.TEXT, false, null));
            tblcols.add(FeatureColumn.createColumn(7, "GPSTime", GeoPackageDataType.INTEGER, false, null));
            tblcols.add(FeatureColumn.createColumn(8, "FixSatCount", GeoPackageDataType.INTEGER, false, null));
            tblcols.add(FeatureColumn.createColumn(9, "HasRadialAccuracy", GeoPackageDataType.BOOLEAN, false, null));
            tblcols.add(FeatureColumn.createColumn(10, "HasVerticalAccuracy", GeoPackageDataType.BOOLEAN, false, null));
            tblcols.add(FeatureColumn.createColumn(11, "RadialAccuracy", GeoPackageDataType.FLOAT, false, null));
            tblcols.add(FeatureColumn.createColumn(12, "VerticalAccuracy", GeoPackageDataType.FLOAT, false, null));
            tblcols.add(FeatureColumn.createColumn(13, "data_dump", GeoPackageDataType.TEXT, false, null));

//            tblcols.add(FeatureColumn.createGeometryColumn(13, "geom", GeometryType.POINT, false, null));


            GPSgpkg.createFeatureTableWithMetadata(gcol, tblcols,
                    new BoundingBox(180.0, 90.0, -180.0, -90.0),
                    WGS84_SRS);

            List<String> tbls = GPSgpkg.getTables();
            tbls.add(GPSgpkg.getApplicationId());
            String dlgMsg = String.join(" - ", tbls);
            dlgBuilder.setMessage(dlgMsg)
                    .setTitle(GpkgFilename);
        }
        AlertDialog gpkgDlg = dlgBuilder.create();
        gpkgDlg.show();
//        GPSgpkg.execSQL("PRAGMA journal_mode = OFF;");
        GPSgpkg.close();

        GPSgpkg = GpkgManager.open(GpkgFilename, true);

    }
//////////////////////////////////////////////////////////////////////////////////////





    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }



}
