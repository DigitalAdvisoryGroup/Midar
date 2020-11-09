package com.channel.bit;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.MediaStore;
import android.util.Base64;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.channel.bit.common.LocaleHelper;
import com.channel.bit.common.Utils;
import com.channel.bit.databinding.ActivityOtherUserProfileBinding;
import com.channel.bit.databinding.ActivityProfileBinding;
import com.google.firebase.iid.FirebaseInstanceId;
import com.google.gson.Gson;

import org.apache.xmlrpc.XmlRpcException;
import org.apache.xmlrpc.client.XmlRpcClient;
import org.apache.xmlrpc.client.XmlRpcClientConfigImpl;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.ByteArrayOutputStream;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Locale;

import androidx.appcompat.app.AppCompatActivity;
import androidx.databinding.DataBindingUtil;

import static java.util.Arrays.asList;

public class OtherUserProfileActivity extends AppCompatActivity {

    ActivityOtherUserProfileBinding mBinding;
    private static final int PICK_IMAGE = 100;
    String uid="";
    String partnerid="";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mBinding = DataBindingUtil.setContentView(this, R.layout.activity_other_user_profile);
        LocaleHelper.setLocale(OtherUserProfileActivity.this, Utils.getSavedData(getApplicationContext(),"language"));
        getsetData();
        setListener();
    }

    private void getsetData() {
        uid = getIntent().getStringExtra("uid");
        partnerid = getIntent().getStringExtra("partner_id");
        checkInternet();
    }
    public void checkInternet(){
        ConnectivityManager conMgr =  (ConnectivityManager)getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo netInfo = conMgr.getActiveNetworkInfo();
        if (netInfo == null){
            new AlertDialog.Builder(OtherUserProfileActivity.this)
                    .setTitle(getResources().getString(R.string.app_name))
                    .setMessage(getResources().getString(R.string.internet_error))
                    .setPositiveButton("OK", null).show();
        }else{
            new OtherUserProfileActivity.getProfile().execute();
        }
    }

    private void setListener() {
        mBinding.imgBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
    }

    String email = "";
    String mobile = "";
    String city = "";
    String street = "";
    String lang = "";
    String street2 = "";
    String zip = "";
    String name = "";
    String image_1920 = "";
    String state_id = "";
    String country_id = "";
    private class getProfile extends AsyncTask<Void, Void, Integer> {
        @Override
        protected void onPreExecute() {
            super.onPreExecute();
        }
        @Override
        protected Integer doInBackground(Void... voids) {
            JSONObject jsonObject = null;
            final XmlRpcClient models = new XmlRpcClient() {{
                setConfig(new XmlRpcClientConfigImpl() {{
                    try {
                        setServerURL(new URL(String.format("%s/xmlrpc/2/object", Utils.url)));
                    } catch (MalformedURLException e) {
                        Utils.printMessage(OtherUserProfileActivity.this);
                        e.printStackTrace();
                    }
                }});
            }};
            try {
                int uid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"uid"));
                int partner_id = Integer.parseInt(partnerid);
                Object profile_data = models.execute("execute_kw", asList(
                        Utils.db_name,uid, Utils.password,
                        "res.partner", "get_partner_profile_data",asList(partner_id))
                );
                Gson gson = new Gson();
                String profile_data_json = gson.toJson(profile_data);
                try {
                    JSONObject jsonObject1 = new JSONObject(profile_data_json);
                    JSONArray data = jsonObject1.optJSONArray("data");
                    if(data!=null&&data.length()>0){
                        for (int i=0;i<data.length();i++){
                            JSONObject jsonObject2 = data.optJSONObject(i);
                            email = jsonObject2.optString("email");
                            mobile = jsonObject2.optString("mobile");
                            city = jsonObject2.optString("city");
                            street = jsonObject2.optString("street");
                            lang = jsonObject2.optString("lang");
                            street2 = jsonObject2.optString("street2");
                            zip = jsonObject2.optString("zip");
                            name = jsonObject2.optString("name");
                            image_1920 = jsonObject2.optString("image_1920");
                            state_id = jsonObject2.optString("state_id");
                            country_id = jsonObject2.optString("country_id");
                        }
                    }

                } catch (JSONException e) {
                    e.printStackTrace();
                }
                Log.e("profile_data"," "+profile_data_json);
            } catch (XmlRpcException e) {
                Utils.printMessage(OtherUserProfileActivity.this);
                e.printStackTrace();
            }
            return null;
        }
        @Override
        protected void onPostExecute(Integer result) {
            super.onPostExecute(result);
            mBinding.txtUserName.setText(name);
            mBinding.txtUserEmail.setText(email);
            mBinding.txtUserContact.setText(mobile);
            mBinding.txtUserAddress.setText(street+", "+street2+", "+"\n"+city+", "+
                    zip+", "+"\n"+state_id+", "+country_id);
            Glide.with(OtherUserProfileActivity.this).load(image_1920)
                    .diskCacheStrategy(DiskCacheStrategy.NONE)
                    .placeholder(R.drawable.ic_profile)
                    .into(mBinding.profileImage);
            Log.e("image_1920"," "+image_1920);
        }
    }




}