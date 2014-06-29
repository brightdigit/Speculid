package com.brightdigit.tgio;

import android.app.Activity;
import android.content.Context;
import android.graphics.Typeface;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

public class MainActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ViewGroup root = (ViewGroup)this.findViewById(android.R.id.content);
        
        Typeface tf = Typeface.createFromAsset(getAssets(), "fonts/Lato/Lato-Regular.ttf");
        overrideFonts(tf, root);
        int childcount = root.getChildCount();
        for (int i=0; i < childcount; i++){
              View v = root.getChildAt(i);
              String msg = String.format("index: %d", i);
              Log.i("app", msg);
              if (v instanceof TextView) {
            	  TextView tv = (TextView) v;
            	  tv.setTypeface(tf);
              }
        }
    }
    private void overrideFonts(final Typeface tf , final View v) {
        try {
            if (v instanceof ViewGroup) {
                ViewGroup vg = (ViewGroup) v;
                for (int i = 0; i < vg.getChildCount(); i++) {
                    View child = vg.getChildAt(i);
                    overrideFonts(tf, child);
             }
            } else if (v instanceof TextView ) {
                ((TextView) v).setTypeface(tf);
            }
        } catch (Exception e) {
     }
     }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }
    
    public void login(View view) {
        // Do something in response to button
    	Log.i(getCallingPackage(), "login");
    }
    
    public void createAccount(View view) {
        // Do something in response to button
    	Log.i(getCallingPackage(), "createAccount");
    }
}
