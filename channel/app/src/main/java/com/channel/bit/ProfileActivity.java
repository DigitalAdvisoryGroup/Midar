package com.channel.bit;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Base64;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.widget.Button;
import android.widget.EditText;
import android.widget.RatingBar;
import android.widget.TextView;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.channel.bit.common.LocaleHelper;
import com.channel.bit.common.Utils;
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
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.HashMap;
import java.util.Locale;

import androidx.appcompat.app.AppCompatActivity;
import androidx.databinding.DataBindingUtil;

import static java.util.Arrays.asList;

public class ProfileActivity extends AppCompatActivity {

    ActivityProfileBinding mBinding;
    private static final int PICK_IMAGE = 100;
    Uri imageUri;
    String base64 ="";
    Locale myLocale;
    String currentLanguage = "en", currentLang;
    String languagePref="en";
    String uid="";
    String partnerid="";
    ProgressDialog progress;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mBinding = DataBindingUtil.setContentView(this, R.layout.activity_profile);
        LocaleHelper.setLocale(ProfileActivity.this, Utils.getSavedData(getApplicationContext(),"language"));
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
            new AlertDialog.Builder(ProfileActivity.this)
                    .setTitle(getResources().getString(R.string.app_name))
                    .setMessage(getResources().getString(R.string.internet_error))
                    .setPositiveButton("OK", null).show();
        }else{
            new ProfileActivity.getProfile().execute();
        }
    }

    private void setListener() {
        mBinding.imgBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        mBinding.llLogout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {

                new Logout().execute();

            }
        });

        mBinding.profileImage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                selectImage();
            }
        });
        mBinding.txtLanguage.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                selectLanguage();
            }
        });
    }
    private void selectImage() {
        final CharSequence[] options = { "Take Photo", "Choose from Gallery","Cancel" };
        AlertDialog.Builder builder = new AlertDialog.Builder(ProfileActivity.this);
        builder.setTitle("Add Photo!");
        builder.setItems(options, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int item) {
                if (options[item].equals("Take Photo"))
                {
                    Intent takePicture = new Intent(android.provider.MediaStore.ACTION_IMAGE_CAPTURE);
                    startActivityForResult(takePicture, 1);
                }
                else if (options[item].equals("Choose from Gallery"))
                {
                    Intent gallery = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.INTERNAL_CONTENT_URI);
                    startActivityForResult(gallery, PICK_IMAGE);
                }
                else if (options[item].equals("Cancel")) {
                    dialog.dismiss();
                }
            }
        });
        builder.show();
    }
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == RESULT_OK){
            if (requestCode == 1) {
                Bitmap selectedImage1 = (Bitmap) data.getExtras().get("data");
                base64 = encodeImage(selectedImage1);
                progress=new ProgressDialog(ProfileActivity.this);
                progress.setMessage("Please wait....");
                progress.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
                progress.setProgressNumberFormat(null);
                progress.setProgressPercentFormat(null);
                progress.setIndeterminate(true);
                progress.setCancelable(false);
                progress.show();
                new UpdateProfilePic().execute();
            } else if(requestCode == PICK_IMAGE){
                imageUri = data.getData();
                final InputStream imageStream;
                try {
                    imageStream = getContentResolver().openInputStream(imageUri);
                    final Bitmap selectedImage = BitmapFactory.decodeStream(imageStream);
                    base64 = encodeImage(selectedImage);
                    progress=new ProgressDialog(ProfileActivity.this);
                    progress.setMessage("Please wait....");
                    progress.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
                    progress.setProgressNumberFormat(null);
                    progress.setProgressPercentFormat(null);
                    progress.setIndeterminate(true);
                    progress.setCancelable(false);
                    progress.show();
                    new UpdateProfilePic().execute();
                } catch (FileNotFoundException e) {
                    Log.e("FileNotFoundException",e.getMessage());
                    e.printStackTrace();
                }

            }
        }
    }

    private String encodeImage(Bitmap bm)
    {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        bm.compress(Bitmap.CompressFormat.JPEG,100,baos);
        byte[] b = baos.toByteArray();
        String encImage = Base64.encodeToString(b, Base64.DEFAULT);

        return encImage;
    }
    Object Logout_response;
    private class Logout extends AsyncTask<Void, Void, Integer> {
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
                        setServerURL(new URL(String.format("%s/xmlrpc/2/object",Utils.url)));
                    } catch (MalformedURLException e) {
                        Utils.printMessage(ProfileActivity.this);
                        e.printStackTrace();
                    }
                }});
            }};
            try {
                int uid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"uid"));
                int partner_id = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"partner_id"));
                String token = FirebaseInstanceId.getInstance().getToken();
                Logout_response = models.execute("execute_kw", asList(
                        Utils.db_name,uid, Utils.password,
                        "res.partner","set_logout_app",asList(asList(partner_id),token)
                ));
                Log.e("logout_response"," "+Logout_response);
            } catch (XmlRpcException e) {
                Utils.printMessage(ProfileActivity.this);
                e.printStackTrace();
            }
            return null;
        }
        @Override
        protected void onPostExecute(Integer result) {
            super.onPostExecute(result);
            if((boolean)Logout_response == true){
                Utils.saveData(getApplicationContext(),"uid","");
                Utils.saveData(getApplicationContext(),"partner_id","");
                Utils.saveData(getApplicationContext(),"otp","");
                Intent intent = new Intent(ProfileActivity.this,LoginActivity.class);
                startActivity(intent);
            }else{
                Toast.makeText(getApplicationContext(),"Something went wrong..",Toast.LENGTH_SHORT).show();
            }
        }
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
                        Utils.printMessage(ProfileActivity.this);
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
                Utils.printMessage(ProfileActivity.this);
                e.printStackTrace();
            }
            return null;
        }
        @Override
        protected void onPostExecute(Integer result) {
            super.onPostExecute(result);
            if (lang.equalsIgnoreCase("en")) {
                mBinding.txtLanguage.setText(getResources().getString(R.string.english));
            }else{
                mBinding.txtLanguage.setText(getResources().getString(R.string.german));
            }
            mBinding.txtUserName.setText(name);
            mBinding.txtUserEmail.setText(email);
            mBinding.txtUserContact.setText(mobile);
            mBinding.txtUserAddress.setText(street+", "+street2+", "+"\n"+city+", "+
                    zip+", "+"\n"+state_id+", "+country_id);
            Glide.with(ProfileActivity.this)
                    .load(image_1920)
                    .diskCacheStrategy(DiskCacheStrategy.NONE)
                    .skipMemoryCache(true)
                    .into(mBinding.profileImage);
            Log.e("image_1920"," "+image_1920);
        }
    }
    Object profilepic_response;
    private class UpdateProfilePic extends AsyncTask<Void, Void, Integer> {
        @Override
        protected void onPreExecute() {
            super.onPreExecute();
        }
        @Override
        protected Integer doInBackground(Void... voids) {
            final XmlRpcClient models = new XmlRpcClient() {{
                setConfig(new XmlRpcClientConfigImpl() {{
                    try {
                        setServerURL(new URL(String.format("%s/xmlrpc/2/object",Utils.url)));
                    } catch (MalformedURLException e) {
                        Utils.printMessage(ProfileActivity.this);
                        e.printStackTrace();
                    }
                }});
            }};
            try {

                int uid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"uid"));
                int partner_id = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"partner_id"));

                profilepic_response = models.execute("execute_kw", asList(
                        Utils.db_name,uid, Utils.password,
                        "res.partner", "write", asList(asList(partner_id),new HashMap() {{
                            put("image_1920",base64);
                        }}))
                );

                Log.e("profilepic_response"," "+profilepic_response);
            } catch (XmlRpcException e) {
                Log.e("XmlRpcException"," "+e.getMessage());
                Utils.printMessage(ProfileActivity.this);
                e.printStackTrace();
            }
            return null;
        }
        @Override
        protected void onPostExecute(Integer result) {
            super.onPostExecute(result);
            if((boolean)profilepic_response==true){
                progress.dismiss();
                new ProfileActivity.getProfile().execute();
            }
        }
    }
    public void selectLanguage(){
        AlertDialog.Builder dialogBuilder = new AlertDialog.Builder(ProfileActivity.this);
        LayoutInflater inflater = ProfileActivity.this.getLayoutInflater();
        View dialogView = inflater.inflate(R.layout.dialog_select_language, null);
        dialogBuilder.setView(dialogView);
        TextView languageEnglish=dialogView.findViewById(R.id.languageEnglish);
        TextView languageGerman=dialogView.findViewById(R.id.languageGerman);
        TextView languageFrench=dialogView.findViewById(R.id.languageFrench);
        TextView languageItalian=dialogView.findViewById(R.id.languageItalian);
        Button btnCancel=dialogView.findViewById(R.id.btnCancel);
        final AlertDialog alertDialog = dialogBuilder.create();
        alertDialog.setCancelable(true);
        alertDialog.show();
        languageEnglish.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                languagePref = "en";
                setLocale(languagePref);
                alertDialog.dismiss();
            }
        });
        languageGerman.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                languagePref = "de";
                setLocale(languagePref);
                alertDialog.dismiss();
            }
        });
        languageFrench.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                languagePref = "fr";
                setLocale(languagePref);
                alertDialog.dismiss();
            }
        });
        languageItalian.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                languagePref = "it";
                setLocale(languagePref);
                alertDialog.dismiss();
            }
        });
        btnCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                alertDialog.dismiss();
            }
        });
    }
    public void setLocale(String localeName) {
        if (!languagePref.isEmpty()) {
            Utils.saveData(getApplicationContext(),"language",localeName);
            LocaleHelper.setLocale(ProfileActivity.this, localeName);
            recreate();
            new ChangeLanguage().execute();
        }
    }


    private class ChangeLanguage extends AsyncTask<Void, Void, Integer> {
        @Override
        protected void onPreExecute() {
            super.onPreExecute();
        }
        @Override
        protected Integer doInBackground(Void... voids) {

            final XmlRpcClient models = new XmlRpcClient() {{
                setConfig(new XmlRpcClientConfigImpl() {{
                    try {
                        setServerURL(new URL(String.format("%s/xmlrpc/2/object",Utils.url)));
                    } catch (MalformedURLException e) {
                        Utils.printMessage(ProfileActivity.this);
                        e.printStackTrace();
                    }
                }});
            }};
            try {
                int uid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"uid"));
                int partner_id = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"partner_id"));

                Object change_language = models.execute("execute_kw", asList(
                        Utils.db_name,uid, Utils.password,
                        "res.partner","set_partner_language", asList(asList(partner_id),languagePref))
                );

                Log.e("language_response"," "+change_language);

            } catch (XmlRpcException e) {
                Log.e("exception"," "+e.getMessage());
                Utils.printMessage(ProfileActivity.this);
                e.printStackTrace();
            }
            return null;
        }
        @Override
        protected void onPostExecute(Integer result) {
            super.onPostExecute(result);
        }
    }

}
