package com.channel.bit;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.channel.bit.common.LocaleHelper;
import com.channel.bit.common.Utils;
import com.channel.bit.databinding.ActivityCampaignBinding;
import com.google.gson.Gson;

import org.apache.xmlrpc.XmlRpcException;
import org.apache.xmlrpc.client.XmlRpcClient;
import org.apache.xmlrpc.client.XmlRpcClientConfigImpl;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.net.MalformedURLException;
import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.TimeZone;

import androidx.appcompat.app.AppCompatActivity;
import androidx.databinding.DataBindingUtil;

import static com.channel.bit.adapter.PostAdapter.getTimeAgo;
import static java.util.Arrays.asList;

public class CampaignActivity extends AppCompatActivity {

    ActivityCampaignBinding mBinding;
    String utm_campaign_id ="";
    String postId ="";
  String responsible_partner_id = "";
    ProgressDialog progress;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mBinding = DataBindingUtil.setContentView(this, R.layout.activity_campaign);
        LocaleHelper.setLocale(CampaignActivity.this, Utils.getSavedData(getApplicationContext(),"language"));
        getsetData();
        setListener();
    }

    private void getsetData() {
        utm_campaign_id = getIntent().getStringExtra("utm_campaign_id");
        postId = getIntent().getStringExtra("postId");
        checkInternet();
    }
    public void checkInternet(){
        ConnectivityManager conMgr =  (ConnectivityManager)getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo netInfo = conMgr.getActiveNetworkInfo();
        if (netInfo == null){
            new AlertDialog.Builder(CampaignActivity.this)
                    .setTitle(getResources().getString(R.string.app_name))
                    .setMessage(getResources().getString(R.string.internet_error))
                    .setPositiveButton("OK", null).show();
        }else{
            new CampaignActivity.CampaignDetail().execute();
        }
    }

    private void setListener() {
        mBinding.txtResponsible.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(CampaignActivity.this,OtherUserProfileActivity.class);
                Log.e("------partner_id-------",""+responsible_partner_id);
                intent.putExtra("partner_id",responsible_partner_id);
                startActivity(intent);
            }
        });
        mBinding.imgBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                onBackPressed();
            }
        });

        mBinding.btnSubmit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(mBinding.edtRating.length()==0){
                    Toast.makeText(getApplicationContext(),"Please add comment..!!",Toast.LENGTH_SHORT).show();
                }else{
                    progress=new ProgressDialog(CampaignActivity.this);
                    progress.setMessage("Please wait....");
                    progress.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
                    progress.setProgressNumberFormat(null);
                    progress.setProgressPercentFormat(null);
                    progress.setIndeterminate(true);
                    progress.setCancelable(false);
                    progress.show();
                    new CampaignActivity.Rating().execute();
                }
            }
        });
    }
    String post_count ="";String responsible ="";String create_date ="";String mailing_count ="";String image ="";
    String avg_rating ="";String dislike_count ="";String my_rating ="";String comments_count ="";
    String like_count ="";String shares_count ="";String rating_count ="";String name="";

    private class CampaignDetail extends AsyncTask<Void, Void, Integer> {
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
                        Utils.printMessage(CampaignActivity.this);
                        e.printStackTrace();
                    }
                }});
            }};
            try {
                int uid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"uid"));
                int campaign_id = Integer.parseInt(utm_campaign_id);
                Object campaign_response = models.execute("execute_kw", asList(
                        Utils.db_name,uid, Utils.password,
                        "utm.campaign", "get_campaign_details",asList(asList(campaign_id),Utils.getSavedData(getApplicationContext(),"partner_id")))
                );
                Gson gson = new Gson();
                String json = gson.toJson(campaign_response);
                try {
                    JSONObject jsonObject1 = new JSONObject(json);
                    JSONArray data = jsonObject1.optJSONArray("data");
                    for(int i =0;i<data.length();i++){
                        JSONObject jsonObject2 = data.optJSONObject(i);
                        post_count = jsonObject2.optString("post_count");
                        responsible = jsonObject2.optString("responsible");
                        responsible_partner_id = jsonObject2.optString("responsible_partner_id");
                        create_date = jsonObject2.optString("create_date");
                        image = jsonObject2.optString("image");
                        mailing_count = jsonObject2.optString("mailing_count");
                        avg_rating = jsonObject2.optString("avg_rating");
                        dislike_count = jsonObject2.optString("dislike_count");
                        my_rating = jsonObject2.optString("my_rating");
                        comments_count = jsonObject2.optString("comments_count");
                        like_count = jsonObject2.optString("like_count");
                        shares_count = jsonObject2.optString("shares_count");
                        rating_count = jsonObject2.optString("rating_count");
                        name = jsonObject2.optString("name");
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }
                Log.e("campaign_response"," "+json);
            } catch (XmlRpcException e) {
                Utils.printMessage(CampaignActivity.this);
                e.printStackTrace();
            }
            return null;
        }
        @Override
        protected void onPostExecute(Integer result) {
            super.onPostExecute(result);
            mBinding.ratingBar.setRating(Float.parseFloat(avg_rating));
            mBinding.myratingBar.setRating(Float.parseFloat(my_rating));
            mBinding.txtResponsible.setText(responsible);
            mBinding.txtName.setText(name);
            mBinding.txtMyRating.setText(my_rating);
            mBinding.txtAverageRating.setText(avg_rating);

            Glide.with(getApplicationContext()).load(image)
                    .diskCacheStrategy(DiskCacheStrategy.NONE)
                    .skipMemoryCache(true)
                    .into(mBinding.redLogo);
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH);
            dateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
            Date date2 = null;
            try {
                date2 = dateFormat.parse(create_date);
            } catch (ParseException e) {
                e.printStackTrace();
            }
            dateFormat.setTimeZone(TimeZone.getDefault());
            String formattedDate = dateFormat.format(date2);
            try {
                Date date3 = dateFormat.parse(formattedDate);
                String MyFinalValue = getTimeAgo(date3,getApplicationContext());
                mBinding.txtDate.setText(getResources().getString(R.string.published_by)+" "+responsible+" "+MyFinalValue);

            } catch (ParseException e) {
                e.printStackTrace();
            }
            mBinding.txtPosts.setText(post_count+" "+getResources().getString(R.string.posts));
            mBinding.txtMails.setText(mailing_count+" "+getResources().getString(R.string.mailings));
            mBinding.txtRatings.setText(rating_count+" "+getResources().getString(R.string.ratings));
            mBinding.txtLikeComments.setText(like_count+" Likes"+"\n"+dislike_count+" "+getResources().getString(R.string.Dislikes)+
                    "\n"+comments_count+" "+getResources().getString(R.string.comments)+
                    "\n"+shares_count+" "+getResources().getString(R.string.Sharings));
        }
    }
    Object rating;
    private class Rating extends AsyncTask<Void, Void, Integer> {
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
                        Utils.printMessage(CampaignActivity.this);
                        e.printStackTrace();
                    }
                }});
            }};
            try {
                int uid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"uid"));
                int partner_id = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"partner_id"));

                rating = models.execute("execute_kw", asList(
                        Utils.db_name,uid, Utils.password,
                        "utm.campaign","campaign_rating", asList(asList(utm_campaign_id),partner_id,
                                Math.round(mBinding.finalRate.getRating()),mBinding.edtRating.getText().toString().trim()))
                );
                rating = (boolean)rating;

            } catch (XmlRpcException e) {
                Utils.printMessage(CampaignActivity.this);
                e.printStackTrace();
            }
            return null;
        }
        @Override
        protected void onPostExecute(Integer result) {
            super.onPostExecute(result);
            progress.dismiss();
            if((boolean)rating==true){
                Toast.makeText(getApplicationContext(),"Review added Successfully..!!",Toast.LENGTH_SHORT).show();
                finish();
            }
        }
    }

}
