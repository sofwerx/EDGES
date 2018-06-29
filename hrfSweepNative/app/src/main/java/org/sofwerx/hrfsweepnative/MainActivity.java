package org.sofwerx.hrfsweepnative;


import android.os.Bundle;
import android.widget.TextView;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.view.Menu;
import android.view.MenuItem;
import android.app.PendingIntent;
import android.content.Intent;
import android.hardware.usb.*;

import java.util.*;

import static android.app.PendingIntent.FLAG_UPDATE_CURRENT;

public class MainActivity extends AppCompatActivity {

    static {
        System.loadLibrary("native-lib");
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
                        .setAction("Action", null).show();
            }
        });
        TextView tv = (TextView) findViewById(R.id.sample_text);
        tv.setText("USB devices:\n");

        UsbManager usbMgr;
        HashMap<String, UsbDevice> usbDevs;
        usbMgr = getSystemService(UsbManager.class);
        Intent myIntent = new Intent();
        int hrfFD = 0; // HackRF file descriptor to pass to libusb

        PendingIntent pi = PendingIntent.getActivity(this, 1, myIntent, FLAG_UPDATE_CURRENT);
        if (usbMgr == null) {
            tv.append("FAILED to get UsbManager object.\n");
        } else {
            usbDevs = usbMgr.getDeviceList();

            for (String k : usbDevs.keySet()) {
                UsbDevice ud = usbDevs.get(k);
                usbMgr.requestPermission(ud, pi);

                tv.append(ud.getProductName());
                tv.append("\n");

                if (ud.getProductName().endsWith("HackRF One")) {
                    UsbDeviceConnection devconn = usbMgr.openDevice(ud);
                    hrfFD = devconn.getFileDescriptor();
                }
            }
        }

        // call to native method
        SensorInterface si = new SensorInterface();
        tv.append(si.listSensors(hrfFD));
    }

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

    /**
     * A native method that is implemented by the 'native-lib' native library,
     * which is packaged with this application.
     */
//    public native String stringFromJNI();

}

class HelloFromNative {
    native String stringFromJNI();
}

class SensorInterface {
    native String listSensors(int fd);
}
