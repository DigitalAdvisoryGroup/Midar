package com.channel.bit;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;

import com.channel.bit.common.LocaleHelper;
import com.channel.bit.common.Utils;

import androidx.appcompat.app.AppCompatActivity;

public class SplashActivity extends AppCompatActivity {
    String uid = "";
    String partner_id = "";
    String otp = "";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);
        LocaleHelper.setLocale(SplashActivity.this, Utils.getSavedData(getApplicationContext(),"language"));
        uid = Utils.getSavedData(getApplicationContext(),"uid");
        partner_id = Utils.getSavedData(getApplicationContext(),"partner_id");
        otp = Utils.getSavedData(getApplicationContext(),"otp");

            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    if(!uid.equalsIgnoreCase("")&&!partner_id.equalsIgnoreCase("")&&
                            !otp.equalsIgnoreCase("")){
                        Intent i = new Intent(SplashActivity.this, MainActivity.class);
                        startActivity(i);
                        finish();
                    }else{
                        Intent i = new Intent(SplashActivity.this, LoginActivity.class);
                        startActivity(i);
                        finish();
                    }

                }
            }, 3*1000);

    }

}