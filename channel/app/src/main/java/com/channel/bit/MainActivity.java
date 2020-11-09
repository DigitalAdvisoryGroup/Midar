package com.channel.bit;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;
import androidx.databinding.DataBindingUtil;
import androidx.recyclerview.widget.ItemTouchHelper;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import androidx.swiperefreshlayout.widget.SwipeRefreshLayout;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.res.Configuration;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.EventLogTags;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.channel.bit.adapter.PostAdapter;
import com.channel.bit.common.LocaleHelper;
import com.channel.bit.common.SwipeToDeleteCallback;
import com.channel.bit.common.Utils;
import com.channel.bit.databinding.ActivityMainBinding;
import com.channel.bit.model.CommentModel;
import com.channel.bit.model.ImagesModel;
import com.channel.bit.model.PostModel;
import com.google.gson.Gson;
import org.apache.xmlrpc.XmlRpcException;
import org.apache.xmlrpc.client.XmlRpcClient;
import org.apache.xmlrpc.client.XmlRpcClientConfigImpl;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;

import static java.util.Arrays.asList;

public class MainActivity extends AppCompatActivity implements SwipeRefreshLayout.OnRefreshListener {

    ActivityMainBinding mBinding;
    PostAdapter mAdapter;
    ArrayList<PostModel> postModelArrayList = new ArrayList<>();
    ArrayList<CommentModel> commentModelArrayList = new ArrayList<>();
    String likeUnlike = "";
    ProgressDialog progress;
    String uid="";


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mBinding = DataBindingUtil.setContentView(this, R.layout.activity_main);
        mAdapter = new PostAdapter(MainActivity.this,postModelArrayList);
        LocaleHelper.setLocale(MainActivity.this, Utils.getSavedData(getApplicationContext(),"language"));
        getListApi();
        search();
    }

    private void search() {
        mBinding.imgInfo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MainActivity.this,ImpressumActivity.class);
                startActivity(intent);
            }
        });
        mBinding.imgprofile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(MainActivity.this,ProfileActivity.class);
                intent.putExtra("uid",uid);
                intent.putExtra("partner_id",Utils.getSavedData(getApplicationContext(),"partner_id"));
                startActivity(intent);
            }
        });

        mBinding.simpleSwipeRefreshLayout.setOnRefreshListener(this);

        mBinding.edtSearshPost.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {
                mBinding.imgSearch.setVisibility(View.GONE);
            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {

            }

            @Override
            public void afterTextChanged(Editable editable) {
                //after the change calling the method and passing the search input
                filter(editable.toString());
            }
        });
    }

    private void filter(String text) {
        //new array list that will hold the filtered data
        ArrayList<PostModel> filterdNames = new ArrayList<>();

        //looping through existing elements
        for (PostModel s : postModelArrayList) {
            //if the existing elements contains the search input
            if (s.getMessage().toLowerCase().contains(text.toLowerCase())) {
                //adding the element to filtered list
                filterdNames.add(s);
            }
        }

        //calling a method of the adapter class and passing the filtered list
        mAdapter.filterList(filterdNames);
    }

    public void getListApi(){
        String profilePic = Utils.getSavedData(getApplicationContext(),"profilePic");
        Glide.with(this).load(profilePic)
                .diskCacheStrategy(DiskCacheStrategy.NONE)
                .skipMemoryCache(true)
                .into(mBinding.imgprofile);
        postModelArrayList = new ArrayList<>();
        commentModelArrayList = new ArrayList<>();
        checkInternet();
    }

    @Override
    public void onRefresh() {
        mBinding.simpleSwipeRefreshLayout.setRefreshing(false);
        getListApi();
    }

    private class Verify extends AsyncTask<Void, Void, Integer> {

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
                        Utils.printMessage(MainActivity.this);
                        e.printStackTrace();
                    }
                }});
            }};
            try {

                int uid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"uid"));
                Object post_list = models.execute("execute_kw", asList(
                        Utils.db_name,uid, Utils.password,
                        "social.post", "get_post_api",asList(asList(),Utils.getSavedData(getApplicationContext(),"partner_id")))
                );
                Gson gson = new Gson();
                String json = gson.toJson(post_list);
                Log.e("postList"," "+json);
                String lastCommentUsername;
                String lastCommentUserImage;
                String lastCommentMessage;

                try {
                    JSONObject jsonObject1 = new JSONObject(json);
                    JSONArray data = jsonObject1.optJSONArray("data");
                    for(int i=0;i<data.length();i++){
                        JSONObject jsonObject2 = data.optJSONObject(i);
                        String name = jsonObject2.optString("name");
                        String total_like_count = jsonObject2.optString("total_like_count");
                        String total_dislike_count = jsonObject2.optString("total_dislike_count");
                        String total_share_count = jsonObject2.optString("total_share_count");
                        String campaign_owner = jsonObject2.optString("campaign_owner");
                        String campaign_name = jsonObject2.optString("campaign_name");
                        String date = jsonObject2.optString("date");
                        boolean like = jsonObject2.optBoolean("like");
                        boolean dislike = jsonObject2.optBoolean("dislike");
                        String message = jsonObject2.optString("message","");
                        String post_owner = jsonObject2.optString("post_owner");
                        String rating = jsonObject2.optString("rating");
                        int id = jsonObject2.optInt("id");
                        String image = jsonObject2.optString("image");

                        String commentsNumber="";
                        boolean comment_like;
                        boolean comment_dislike;
                        JSONArray comments = jsonObject2.optJSONArray("comments");
                        commentsNumber = comments.length()+"";
                        String finalProfileImage = "";
                        String finalName = "";
                        String finalComment = "";
                        if(comments.length()>0){
                            for(int j=0;j<comments.length();j++){
                                JSONObject jsonObject3 = comments.optJSONObject(j);
                                lastCommentUsername = jsonObject3.optString("author_name");
                                lastCommentUserImage = jsonObject3.optString("author_image");
                                lastCommentMessage = jsonObject3.optString("comment");
                                comment_like = jsonObject3.optBoolean("comment_like");
                                comment_dislike = jsonObject3.optBoolean("comment_dislike");
                                commentModelArrayList.add(new CommentModel(lastCommentUsername,lastCommentUserImage,lastCommentMessage,comment_like,comment_dislike));
                            }
                            finalName = commentModelArrayList.get(commentModelArrayList.size()-1).getAuthor_name();
                            finalComment = commentModelArrayList.get(commentModelArrayList.size()-1).getComment();
                            finalProfileImage = commentModelArrayList.get(commentModelArrayList.size()-1).getAuthor_image();
                        }
                        ArrayList<ImagesModel> beanImages = new ArrayList<>();
                        JSONArray media_ids = jsonObject2.optJSONArray("media_ids");
                        String mimetype = "";
                        String imagePost = "";
                        String height = "";
                        String width = "";
                        if(media_ids.length()>0) {
                            for (int k = 0; k < media_ids.length(); k++) {
                                JSONObject jsonObject3 = media_ids.optJSONObject(k);
                                mimetype = jsonObject3.optString("mimetype");
                                imagePost = jsonObject3.optString("url");
                                height = jsonObject3.optString("height");
                                width = jsonObject3.optString("width");
                                ImagesModel beanImage = new ImagesModel();
                                beanImage.setImage_url(imagePost);
                                beanImage.setImage_mimetype(mimetype);
                                beanImage.setHeight(height);
                                beanImage.setWidth(width);
                                beanImages.add(beanImage);
                            }
                        }
                        postModelArrayList.add(new PostModel(campaign_owner,campaign_name,name,date,like,dislike,message,id,image,
                                finalName,finalComment,finalProfileImage,mimetype,imagePost,post_owner,rating,comments,beanImages,
                                commentsNumber,total_like_count,total_dislike_count,total_share_count));
                    }
                } catch (JSONException e) {
                    Utils.printMessage(MainActivity.this);
                    e.printStackTrace();
                }
            } catch (XmlRpcException e) {
                Utils.printMessage(MainActivity.this);
                e.printStackTrace();
            }
            return null;
        }

        @Override
        protected void onPostExecute(Integer result) {
            super.onPostExecute(result);
            if(postModelArrayList.size() == 0){
                mBinding.txtNoPost.setVisibility(View.VISIBLE);
                mBinding.rvPost.setVisibility(View.GONE);
            }else{
                mBinding.txtNoPost.setVisibility(View.GONE);
                mBinding.rvPost.setVisibility(View.VISIBLE);
            }
            setData();
        }

        private void setData() {
            mAdapter = new PostAdapter(MainActivity.this,postModelArrayList);
            LinearLayoutManager mLayoutManager = new LinearLayoutManager(getApplicationContext());

            mBinding.rvPost.setLayoutManager(mLayoutManager);
            mBinding.rvPost.setHasFixedSize(true);
            mBinding.rvPost.setNestedScrollingEnabled(false);
            mBinding.rvPost.setAdapter(mAdapter);
            mAdapter.setListener(new PostAdapter.SetOnClickListener() {
                @Override
                public void onItemClick(PostModel PostModel, String status, int position, int rating, String messageRating) {
                    Utils.saveData(getApplicationContext(),"position",position+"");
                    Utils.saveData(getApplicationContext(),"rating",rating+"");
                    Utils.saveData(getApplicationContext(),"messageRating",messageRating+"");
                    Utils.saveData(getApplicationContext(),"postId",PostModel.getId()+"");
                    if(status.equalsIgnoreCase("like")){
                        new MainActivity.Like().execute();
                    }else if(status.equalsIgnoreCase("dislike")){
                        new MainActivity.disLike().execute();
                    }else if(status.equalsIgnoreCase("delete")){
                        progress=new ProgressDialog(MainActivity.this);
                        progress.setMessage("Please wait....");
                        progress.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
                        progress.setProgressNumberFormat(null);
                        progress.setProgressPercentFormat(null);
                        progress.setIndeterminate(true);
                        progress.setCancelable(false);
                        progress.show();
                        new MainActivity.Delete().execute();
                    }else if(status.equalsIgnoreCase("comment")){
                        Intent intent = new Intent(MainActivity.this, PostDetailActivity.class);
                        intent.putExtra("postId", PostModel.getId()+"");
                        intent.putExtra("postLikeUnlike", PostModel.isLike()+"");
                        startActivity(intent);
                    }else if(status.equalsIgnoreCase("rating")){
                        new MainActivity.submitRating().execute();
                    }else if(status.equalsIgnoreCase("share")){
                        new MainActivity.share().execute();
                    }
                }
            });
            enableSwipeToDeleteAndUndo();
        }
    }
    boolean delete;
    private class Delete extends AsyncTask<Void, Void, Integer> {
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
                        Utils.printMessage(MainActivity.this);
                        e.printStackTrace();
                    }
                }});
            }};
            try {
                int uid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"uid"));
                likeUnlike = Utils.getSavedData(getApplicationContext(),"likeUnlike");
                int postid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"postId"));
                Object delete_status = models.execute("execute_kw", asList(
                        Utils.db_name,uid, Utils.password,
                        "social.post", "set_post_delete",asList(asList(postid),Utils.getSavedData(getApplicationContext(),"partner_id")))
                );
                Log.e("delete_status"," "+delete_status);
                delete = (Boolean)delete_status;
            } catch (XmlRpcException e) {
                Utils.printMessage(MainActivity.this);
                e.printStackTrace();
            }
            return null;
        }
        @Override
        protected void onPostExecute(Integer result) {
            super.onPostExecute(result);
            progress.dismiss();
            if(delete == true){
                int position = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"position"));
                mAdapter.removeAt(position);
            }
        }
    }
    private class Like extends AsyncTask<Void, Void, Integer> {
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
                        Utils.printMessage(MainActivity.this);
                        e.printStackTrace();
                    }
                }});
            }};
            try {
                int uid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"uid"));

                int postId = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"postId"));
                Object like_response = models.execute("execute_kw", asList(
                        Utils.db_name,uid, Utils.password,
                        "social.post", "set_post_like",asList(asList(postId),Utils.getSavedData(getApplicationContext(),"partner_id")))
                );
                Log.e("like_response"," "+like_response);

            } catch (XmlRpcException e) {
                Utils.printMessage(MainActivity.this);
                e.printStackTrace();
            }
            return null;
        }
        @Override
        protected void onPostExecute(Integer result) {
            super.onPostExecute(result);
        }
    }

    private class disLike extends AsyncTask<Void, Void, Integer> {
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
                        Utils.printMessage(MainActivity.this);
                        e.printStackTrace();
                    }
                }});
            }};
            try {
                int uid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"uid"));
                int postId = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"postId"));
                Object dislike_response = models.execute("execute_kw", asList(
                        Utils.db_name,uid, Utils.password,
                        "social.post", "set_post_dislike",asList(asList(postId),Utils.getSavedData(getApplicationContext(),"partner_id")))
                );
                Log.e("dislike_response"," "+dislike_response);

            } catch (XmlRpcException e) {
                Utils.printMessage(MainActivity.this);
                e.printStackTrace();
            }
            return null;
        }
        @Override
        protected void onPostExecute(Integer result) {
            super.onPostExecute(result);
        }
    }


    @Override
    public void onBackPressed() {
        super.onBackPressed();
        if(getResources().getConfiguration().orientation == Configuration.ORIENTATION_LANDSCAPE){
            Intent intent = getIntent();
            finish();
            startActivity(intent);
        }else {
            this.finishAffinity();
        }
    }
    private void enableSwipeToDeleteAndUndo() {
        SwipeToDeleteCallback swipeToDeleteCallback = new SwipeToDeleteCallback(this) {
            @Override
            public void onSwiped(@NonNull RecyclerView.ViewHolder viewHolder, int i) {
                final int position = viewHolder.getAdapterPosition();
                Utils.saveData(getApplicationContext(),"position",position+"");
                progress=new ProgressDialog(MainActivity.this);
                progress.setMessage("Please wait....");
                progress.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
                progress.setProgressNumberFormat(null);
                progress.setProgressPercentFormat(null);
                progress.setIndeterminate(true);
                progress.setCancelable(false);
                progress.show();
                new MainActivity.Delete().execute();
            }
        };
        ItemTouchHelper itemTouchhelper = new ItemTouchHelper(swipeToDeleteCallback);
        itemTouchhelper.attachToRecyclerView(mBinding.rvPost);
    }

    private class submitRating extends AsyncTask<Void, Void, Integer> {

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
                        Utils.printMessage(MainActivity.this);
                        e.printStackTrace();
                    }
                }});
            }};
            try {
                int uid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"uid"));
                int postId = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"postId"));
                int rating = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"rating"));
                String messageRating = Utils.getSavedData(getApplicationContext(),"messageRating");

                Object rating_response = models.execute("execute_kw", asList(
                        Utils.db_name,uid, Utils.password,
                        "social.bit.comments", "create", asList(new HashMap() {{
                            put("post_id",postId);
                            put("partner_id", Utils.getSavedData(getApplicationContext(),"partner_id"));
                            put("record_type", "rating");
                            put("rating",rating);
                            put("comment",messageRating);
                        }}))
                );

                Gson gson = new Gson();
                String json_rating_response = gson.toJson(rating_response);
                Log.e("rating_response"," "+json_rating_response);

            } catch (XmlRpcException e) {
                Utils.printMessage(MainActivity.this);
                e.printStackTrace();
            }
            return null;
        }

        @Override
        protected void onPostExecute(Integer result) {
            super.onPostExecute(result);
            mBinding.simpleSwipeRefreshLayout.setRefreshing(false);
            getListApi();
        }

    }

    private class share extends AsyncTask<Void, Void, Integer> {

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
                        Utils.printMessage(MainActivity.this);
                        e.printStackTrace();
                    }
                }});
            }};
            try {
                int uid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"uid"));
                int postId = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"postId"));

                Object share_response = models.execute("execute_kw", asList(
                        Utils.db_name,uid, Utils.password,
                        "social.bit.comments", "create", asList(new HashMap() {{
                            put("post_id",postId);
                            put("partner_id", Utils.getSavedData(getApplicationContext(),"partner_id"));
                            put("record_type", "share");
                        }}))
                );

                Gson gson = new Gson();
                String json_share_response = gson.toJson(share_response);
                Log.e("share_response"," "+json_share_response);

            } catch (XmlRpcException e) {
                Utils.printMessage(MainActivity.this);
                e.printStackTrace();
            }
            return null;
        }

        @Override
        protected void onPostExecute(Integer result) {
            super.onPostExecute(result);
            mBinding.simpleSwipeRefreshLayout.setRefreshing(false);
            getListApi();
        }

    }
    public void checkInternet(){
        ConnectivityManager conMgr =  (ConnectivityManager)getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo netInfo = conMgr.getActiveNetworkInfo();
        if (netInfo == null){
            new AlertDialog.Builder(MainActivity.this)
                    .setTitle(getResources().getString(R.string.app_name))
                    .setMessage(getResources().getString(R.string.internet_error))
                    .setPositiveButton("OK", null).show();
        }else{
            new MainActivity.Verify().execute();
        }
    }

}