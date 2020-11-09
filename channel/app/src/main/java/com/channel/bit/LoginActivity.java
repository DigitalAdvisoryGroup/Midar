package com.channel.bit;

import android.Manifest;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.text.method.LinkMovementMethod;
import android.text.util.Linkify;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import com.channel.bit.common.LocaleHelper;
import com.channel.bit.common.Utils;
import com.channel.bit.databinding.ActivityLoginBinding;
import com.google.firebase.FirebaseApp;
import com.google.firebase.iid.FirebaseInstanceId;
import com.google.gson.Gson;

import org.apache.xmlrpc.XmlRpcException;
import org.apache.xmlrpc.client.XmlRpcClient;
import org.apache.xmlrpc.client.XmlRpcClientConfigImpl;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.databinding.DataBindingUtil;

import static java.util.Arrays.asList;
import static java.util.Collections.emptyList;
import static java.util.Collections.emptyMap;

public class LoginActivity extends AppCompatActivity {
    ActivityLoginBinding mBinding;
    String token;
    ProgressDialog progress;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mBinding = DataBindingUtil.setContentView(this, R.layout.activity_login);
        LocaleHelper.setLocale(LoginActivity.this, Utils.getSavedData(getApplicationContext(),"language"));
        // checkPermissionWRITE_EXTERNAL_STORAGE(this);
        ActivityCompat.requestPermissions(LoginActivity.this,
                new String[]{Manifest.permission.READ_EXTERNAL_STORAGE,Manifest.permission.WRITE_EXTERNAL_STORAGE},
                1);
        token = FirebaseInstanceId.getInstance().getToken();
        setListener();

    }

    private void setListener() {
        mBinding.txtTerms2.setMovementMethod(LinkMovementMethod.getInstance());
        mBinding.txtTerms2.setLinkTextColor(getResources().getColor(R.color.colorPrimary));
        mBinding.txtSignin.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(!mBinding.chkTerms.isChecked()){
                    Toast.makeText(getApplicationContext(),"Please agree to the terms and conditions..!!",Toast.LENGTH_SHORT).show();
                }else {
                    progress=new ProgressDialog(LoginActivity.this);
                    progress.setMessage("Please wait....");
                    progress.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
                    progress.setProgressNumberFormat(null);
                    progress.setProgressPercentFormat(null);
                    progress.setIndeterminate(true);
                    progress.setCancelable(false);
                    progress.show();
                    new CreateAPICall().execute();
                }
            }
        });
        mBinding.imgInfo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(LoginActivity.this,ImpressumActivity.class);
                startActivity(intent);
            }
        });
    }

    int uid;
    private class CreateAPICall extends AsyncTask<Void, Void, Integer> {

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
        }

        @Override
        protected Integer doInBackground(Void... voids) {

            final XmlRpcClient client = new XmlRpcClient();
            final XmlRpcClientConfigImpl common_config = new XmlRpcClientConfigImpl();
            try {
                common_config.setServerURL(
                        new URL(String.format("%s/xmlrpc/2/common", Utils.url)));
                try {
                    client.execute(common_config, "version", emptyList());
                } catch (XmlRpcException e) {
                    Utils.printMessage(LoginActivity.this);
                    e.printStackTrace();
                }
                try {
                    uid = (int)client.execute(
                            common_config, "authenticate", asList(
                                    Utils.db_name,Utils.username, Utils.password, emptyMap()
                            )
                    );
                    Log.e("uid"," "+uid);
                    Utils.saveData(getApplicationContext(),"uid",String.valueOf(uid));
                } catch (XmlRpcException e) {
                    Utils.printMessage(LoginActivity.this);
                    e.printStackTrace();
                }
            } catch (MalformedURLException e) {
                Utils.printMessage(LoginActivity.this);
                e.printStackTrace();
            }
            return null;
        }

        @Override
        protected void onPostExecute(Integer result) {
            super.onPostExecute(result);
            if(uid == 0){
                progress.dismiss();
                Utils.printMessage(LoginActivity.this);
            }else{
                new Verify().execute();
            }
        }
    }
    int partner_id=0;
    Object final_partner_id;
    private class Verify extends AsyncTask<Void, Void, Integer> {

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
        }

        @Override
        protected Integer doInBackground(Void... voids) {

            final XmlRpcClient models = new XmlRpcClient() {{
                setConfig(new XmlRpcClientConfigImpl() {{
                    try {
                        setServerURL(new URL(String.format("%s/xmlrpc/2/object", Utils.url)));
                    } catch (MalformedURLException e) {
                        Utils.printMessage(LoginActivity.this);
                        e.printStackTrace();
                    }
                }});
            }};
            try {
                int uid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"uid"));
                String email = mBinding.edtEmail.getText().toString().trim();
                Utils.saveData(getApplicationContext(),"email",email);
                final_partner_id = models.execute("execute_kw", asList(
                        Utils.db_name,uid, Utils.password,
                        "res.partner", "get_partner_from_email",asList(asList(),email,token, Locale.getDefault().toString())
                ));
                Gson gson = new Gson();
                String login_response = gson.toJson(final_partner_id);
                Utils.saveData(getApplicationContext(),"login_response",login_response);
                Log.e("login_response"," "+login_response);

                JSONObject jsonObject1 = null;

                try {
                    jsonObject1 = new JSONObject(login_response);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                String image_1920 = "";
                JSONArray data = jsonObject1.optJSONArray("data");
                for(int i=0;i<data.length();i++) {
                    JSONObject jsonObject2 = data.optJSONObject(i);
                    partner_id = jsonObject2.optInt("id");
                    image_1920 = jsonObject2.optString("image_1920");
                }
                Utils.saveData(getApplicationContext(),"profilePic",image_1920);
                Utils.saveData(getApplicationContext(),"partner_id",String.valueOf(partner_id));

                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if(partner_id == 0){
                            progress.dismiss();
                            mBinding.edtEmail.setError(getResources().getString(R.string.Please_Enter_Valid_Email));
                        }else{
                            progress.dismiss();
                            Intent intent = new Intent(LoginActivity.this,VerifyOtpActivity.class);
                            intent.putExtra("uid",uid);
                            intent.putExtra("partner_id", String.valueOf(partner_id));
                            startActivity(intent);
                        }
                    }
                });
            } catch (XmlRpcException e) {
                Utils.printMessage(LoginActivity.this);
                e.printStackTrace();
            }
            return null;
        }

        @Override
        protected void onPostExecute(Integer result) {
            super.onPostExecute(result);
            if (result != null) {
                Log.e("message"," "+result.toString());

            } else {

            }
        }
    }

    public static final int MY_PERMISSIONS_REQUEST_WRITE_EXTERNAL_STORAGE = 123;

    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           String permissions[], int[] grantResults) {
        switch (requestCode) {
            case 1: {
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {

                } else {

                    Toast.makeText(LoginActivity.this, "Permission denied to read your External storage", Toast.LENGTH_SHORT).show();
                }
                return;
            }

        }
    }

    @Override
    protected void onResume() {
        super.onResume();
    }

    @Override
    public void onBackPressed() {
        super.onBackPressed();
        this.finishAffinity();
    }
}