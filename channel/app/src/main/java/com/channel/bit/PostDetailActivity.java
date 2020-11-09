package com.channel.bit;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.provider.FontRequest;
import androidx.databinding.DataBindingUtil;
import androidx.emoji.text.EmojiCompat;
import androidx.emoji.text.FontRequestEmojiCompatConfig;
import androidx.recyclerview.widget.LinearLayoutManager;
import tcking.github.com.giraffeplayer2.VideoInfo;

import android.Manifest;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.ActivityNotFoundException;
import android.content.ContentUris;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Point;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.provider.DocumentsContract;
import android.provider.MediaStore;
import android.provider.OpenableColumns;
import android.text.Editable;
import android.text.TextWatcher;
import android.text.util.Linkify;
import android.util.Base64;
import android.util.Log;
import android.view.Display;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.LinearLayout;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.channel.bit.adapter.Commentsdapter;
import com.channel.bit.common.CameraUtils;
import com.channel.bit.common.FilePath;
import com.channel.bit.common.FileUtils;
import com.channel.bit.common.LocaleHelper;
import com.channel.bit.common.Utils;
import com.channel.bit.databinding.ActivityPostDetailBinding;
import com.channel.bit.model.ChildCommentModel;
import com.channel.bit.model.CommentModel;
import com.channel.bit.model.ImagesModel;
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
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.TimeZone;

import static com.channel.bit.adapter.PostAdapter.getTimeAgo;
import static com.channel.bit.common.FilePath.getPath;

import static com.channel.bit.common.FileUtils.getLocalPath;
import static java.util.Arrays.asList;

public class PostDetailActivity extends AppCompatActivity {
    ActivityPostDetailBinding mBinding;
    String base64 ="";
    String fileName;
    Commentsdapter adapter;
    ArrayList<CommentModel> commentModelArrayList;
    String likeUnlike = "";String postId = "";String postLikeUnlike = "";
    String comment = "";
    ProgressDialog progress;String record_type="";
    ArrayList<ImagesModel> beanImages = new ArrayList<>();
    int upload_limit=0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FontRequest fontRequest = new FontRequest(
                "com.example.fontprovider",
                "com.example",
                "emoji compat Font Query",
                R.array.com_google_android_gms_fonts_certs);
        EmojiCompat.Config config = new FontRequestEmojiCompatConfig(this, fontRequest);
        EmojiCompat.init(config);
        mBinding = DataBindingUtil.setContentView(this, R.layout.activity_post_detail);
        LocaleHelper.setLocale(PostDetailActivity.this, Utils.getSavedData(getApplicationContext(),"language"));
        getsetData();
        setListener();
    }
    public Uri getImageUri(Context inContext, Bitmap inImage) {
        ByteArrayOutputStream bytes = new ByteArrayOutputStream();
        inImage.compress(Bitmap.CompressFormat.JPEG, 100, bytes);
        String path = MediaStore.Images.Media.insertImage(inContext.getContentResolver(), inImage, "Title","");
        return Uri.parse(path);
    }
    private void setListener() {
        mBinding.imgCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                mBinding.rlSelected.setVisibility(View.GONE);
                fileName="";
                base64="";
            }
        });

        mBinding.uploadFile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                selectFile();
            }
        });
        mBinding.rlClick.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(PostDetailActivity.this,CampaignActivity.class);
                intent.putExtra("utm_campaign_id",utm_campaign_id);
                intent.putExtra("postId",postId);
                startActivity(intent);
            }
        });
        mBinding.rlPdf.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent pdfOpenintent = new Intent(Intent.ACTION_VIEW);
                pdfOpenintent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                pdfOpenintent.setDataAndType(Uri.parse(imagePost), "application/pdf");
                try {
                    startActivity(pdfOpenintent);
                }
                catch (ActivityNotFoundException e) {

                }
            }
        });
        mBinding.imgBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        mBinding.llLike.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (like==false){
                    like = true;
                    mBinding.imgLike.setImageResource(R.drawable.ic_baseline_favorite_24);
                }else{
                    like = false;
                    mBinding.imgLike.setImageResource(R.drawable.ic_like);
                }
                if(like==true){
                    Utils.saveData(getApplicationContext(),"likeUnlike","like");
                }else{
                    Utils.saveData(getApplicationContext(),"likeUnlike","dislike");
                }
                new LikeUnlike().execute();
            }
        });
        mBinding.llShare.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(Intent.ACTION_SEND);
                if(beanImages.size()>0){
                    intent.putExtra(Intent.EXTRA_TEXT,mBinding.txtMessage.getText().toString()+"\n"+beanImages.get(0).getImage_url());
                }else{
                    intent.putExtra(Intent.EXTRA_TEXT,mBinding.txtMessage.getText().toString());
                }
                intent.setType("text/plain");
                startActivity(Intent.createChooser(intent,"Share Using"));
            }
        });
        mBinding.edtComment.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {

            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                comment = mBinding.edtComment.getText().toString().trim();
                if(comment.length()>0){
                    mBinding.txtPost.setTextColor(getResources().getColor(R.color.colorPrimaryDark));
                }else{
                    mBinding.txtPost.setTextColor(getResources().getColor(R.color.colorLightPrimary));
                }
            }

            @Override
            public void afterTextChanged(Editable s) {

            }
        });
        mBinding.txtPost.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(comment.length()==0){
                    Toast.makeText(getApplicationContext(),"Please add comment..!!",Toast.LENGTH_SHORT).show();
                }else{
                    mBinding.txtPost.setTextColor(getResources().getColor(R.color.colorPrimaryDark));
                    progress=new ProgressDialog(PostDetailActivity.this);
                    progress.setMessage("Please wait....");
                    progress.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
                    progress.setProgressNumberFormat(null);
                    progress.setProgressPercentFormat(null);
                    progress.setIndeterminate(true);
                    progress.setCancelable(false);
                    progress.show();
                    new Comment().execute();
                }
            }
        });
    }
    String name="";String campaign_owner="";String campaign_name=""; String date="";boolean like;
    String message="";String post_owner="";int id;String image="";String rating ="";String mimetype = "";
    String imagePost = "";String utm_campaign_id = "";String replay_counter="";String like_counter="";
    String dislike_counter="";
    private class PostDetail extends AsyncTask<Void, Void, Integer> {

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
                        Utils.printMessage(PostDetailActivity.this);
                        e.printStackTrace();
                    }
                }});
            }};
            try {
                int uid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"uid"));
                Object post_list = models.execute("execute_kw", asList(
                        Utils.db_name,uid, Utils.password,
                        "social.post", "get_post_api",asList(asList(Integer.parseInt(postId)),Utils.getSavedData(getApplicationContext(),"partner_id")))
                );
                Gson gson = new Gson();
                String json = gson.toJson(post_list);
                Log.e("post_detail"," "+json);
                try {
                    JSONObject jsonObject1 = new JSONObject(json);
                    JSONArray data = jsonObject1.optJSONArray("data");
                    for(int i=0;i<data.length();i++){
                        JSONObject jsonObject2 = data.optJSONObject(i);
                        JSONArray mainmedia_ids = jsonObject2.optJSONArray("media_ids");
                        
                        name = jsonObject2.optString("name");
                        campaign_owner = jsonObject2.optString("campaign_owner");
                        campaign_name = jsonObject2.optString("campaign_name");
                        date = jsonObject2.optString("date");
                        like = jsonObject2.optBoolean("like");
                        message = jsonObject2.optString("message");
                        post_owner = jsonObject2.optString("post_owner");
                        upload_limit = jsonObject2.optInt("upload_limit");
                        utm_campaign_id = jsonObject2.optString("utm_campaign_id");
                        rating = jsonObject2.optString("rating");
                        id = jsonObject2.optInt("id");
                        image = jsonObject2.optString("image");
                        String commentsNumber="";
                        boolean comment_like;
                        boolean comment_dislike;
                        JSONArray comments = jsonObject2.optJSONArray("comments");
                        commentModelArrayList = new ArrayList<>();
                        if(comments.length()>0){
                            for (int j = 0; j < comments.length(); j++) {
                                JSONObject jsonObject3 = comments.optJSONObject(j);
                                String imgPdf ="";
                                String mimetypeImgPdf ="";
                                JSONArray media_ids = jsonObject3.optJSONArray("media_ids");
                                if(media_ids!=null&&media_ids.length()>0){
                                    for(int l =0;l<media_ids.length();l++){
                                        JSONObject jsonObject4 = media_ids.optJSONObject(l);
                                        imgPdf = jsonObject4.optString("url");
                                        mimetypeImgPdf = jsonObject4.optString("mimetype");
                                    }
                                }
                                String id = jsonObject3.optString("id");
                                String date = jsonObject3.optString("date");
                                String comment = jsonObject3.optString("comment");
                                String author_name = jsonObject3.optString("author_name");
                                String author_image = jsonObject3.optString("author_image");
                                String Commentpartner_id = jsonObject3.optString("partner_id");
                                comment_like = jsonObject3.optBoolean("comment_like");
                                comment_dislike = jsonObject3.optBoolean("comment_dislike");
                                replay_counter = jsonObject3.optString("replay_counter");
                                like_counter = jsonObject3.optString("like_counter");
                                dislike_counter= jsonObject3.optString("dislike_counter");
                                String child_author_image="";
                                String child_author_name="";
                                String child_date="";
                                String child_comment="";
                                String child_partner_id="";
                                String child_id="";

                                ArrayList<ChildCommentModel> childCommentModelArrayList = new ArrayList<>();
                                JSONArray child_comments = jsonObject3.optJSONArray("child_comments");
                                for(int k=0;k<child_comments.length();k++){
                                    JSONObject jsonObject4 = child_comments.optJSONObject(k);
                                    child_author_image = jsonObject4.optString("author_image");
                                    child_comment = jsonObject4.optString("comment");
                                    child_author_name = jsonObject4.optString("author_name");
                                    child_date = jsonObject4.optString("date");
                                    child_partner_id = jsonObject4.optString("partner_id");
                                    child_id = jsonObject4.optString("id");
                                    String child_imgPdf="";
                                    String child_mimetypeImgPdf="";
                                    JSONArray child_media_ids = jsonObject4.optJSONArray("media_ids");
                                    JSONObject jsonObject5 = child_media_ids.optJSONObject(0);
                                    if(jsonObject5!=null){
                                        child_imgPdf = jsonObject5.optString("url");
                                        child_mimetypeImgPdf = jsonObject5.optString("mimetype");
                                    }
                                    childCommentModelArrayList.add(new ChildCommentModel(child_id,child_author_image,child_comment,child_author_name,child_date,child_imgPdf,child_mimetypeImgPdf,child_partner_id));
                                }
                                commentModelArrayList.add(new CommentModel(rating,id,date,comment,author_name,author_image,Commentpartner_id,comment_like,comment_dislike,
                                        imgPdf,mimetypeImgPdf,like_counter,dislike_counter,replay_counter,childCommentModelArrayList));
                            }
                        }

                        beanImages = new ArrayList<>();
                        JSONArray media_ids = jsonObject2.optJSONArray("media_ids");
                        mimetype = "";
                        imagePost = "";
                        if(media_ids.length()>0) {
                            for (int k = 0; k < media_ids.length(); k++) {
                                JSONObject jsonObject3 = media_ids.optJSONObject(k);
                                mimetype = jsonObject3.optString("mimetype");
                                imagePost = jsonObject3.optString("url");
                                ImagesModel beanImage = new ImagesModel();
                                beanImage.setImage_url(imagePost);
                                beanImage.setImage_mimetype(mimetype);
                                beanImages.add(beanImage);
                            }
                        }
                    }
                } catch (JSONException e) {
                    Utils.printMessage(PostDetailActivity.this);
                    e.printStackTrace();
                }


            } catch (XmlRpcException e) {
                Utils.printMessage(PostDetailActivity.this);
                e.printStackTrace();
            }
            return null;
        }

        @Override
        protected void onPostExecute(Integer result) {
            super.onPostExecute(result);
            mBinding.ratingBar.setRating(Float.parseFloat(rating));
            if(mimetype!=null&&mimetype.equalsIgnoreCase("pdf")){
                mBinding.imgframe.setVisibility(View.GONE);
                mBinding.rlPdf.setVisibility(View.VISIBLE);
                mBinding.VideoView.setVisibility(View.GONE);
                mBinding.txtPdfName.setText(imagePost.substring(imagePost.lastIndexOf("/") + 1));
            }
            else if(mimetype!=null&&mimetype.equalsIgnoreCase("image")){
                if(beanImages.size()>0){
                    mBinding.imgframe.setVisibility(View.VISIBLE);
                    mBinding.VideoView.setVisibility(View.GONE);
                    if(beanImages.size()==1)
                    {
                        mBinding.ll1.setVisibility(View.VISIBLE);
                        mBinding.img2.setVisibility(View.GONE);
                        mBinding.ll2.setVisibility(View.GONE);
                        Glide.with(PostDetailActivity.this).load(beanImages.get(0).getImage_url())
                                .into(mBinding.img1);
                        mBinding.img1.setLayoutParams(new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
                    }
                    if(beanImages.size()==2)
                    {
                        mBinding.ll1.setVisibility(View.VISIBLE);
                        mBinding.ll2.setVisibility(View.GONE);
                        Glide.with(PostDetailActivity.this).load(beanImages.get(0).getImage_url())
                                .into(mBinding.img1);
                        Glide.with(PostDetailActivity.this).load(beanImages.get(1).getImage_url())
                                .into(mBinding.img2);
                    }
                    if(beanImages.size()==3)
                    {
                        Display display = getWindowManager().getDefaultDisplay();
                        Point size = new Point();
                        display.getSize(size);
                        int width = size.x;
                        mBinding.ll1.setVisibility(View.VISIBLE);
                        mBinding.ll2.setVisibility(View.VISIBLE);
                        mBinding.img2.setVisibility(View.GONE);
                        mBinding.img1.setVisibility(View.VISIBLE);
                        mBinding.txtCount.setVisibility(View.GONE);
                        Glide.with(PostDetailActivity.this).load(beanImages.get(0).getImage_url())
                                .into(mBinding.img1);
                        Glide.with(PostDetailActivity.this).load(beanImages.get(1).getImage_url())
                                .into(mBinding.img3);
                        Glide.with(PostDetailActivity.this).load(beanImages.get(2).getImage_url())
                                .into(mBinding.img4);
                    }
                    if(beanImages.size()==4)
                    {
                        mBinding.ll1.setVisibility(View.VISIBLE);
                        mBinding.ll2.setVisibility(View.VISIBLE);
                        mBinding.txtCount.setVisibility(View.GONE);
                        Glide.with(PostDetailActivity.this).load(beanImages.get(0).getImage_url())
                                .into(mBinding.img1);
                        Glide.with(PostDetailActivity.this).load(beanImages.get(1).getImage_url())
                                .into(mBinding.img2);
                        Glide.with(PostDetailActivity.this).load(beanImages.get(2).getImage_url())
                                .into(mBinding.img3);
                        Glide.with(PostDetailActivity.this).load(beanImages.get(3).getImage_url())
                                .into(mBinding.img4);
                    }
                    if(beanImages.size()>4){
                        mBinding.ll1.setVisibility(View.VISIBLE);
                        mBinding.ll2.setVisibility(View.VISIBLE);
                        mBinding.txtCount.setVisibility(View.VISIBLE);
                        mBinding.txtCount.setText("+"+String.valueOf(beanImages.size()-4));
                        Glide.with(PostDetailActivity.this).load(beanImages.get(0).getImage_url())
                                .into(mBinding.img1);
                        Glide.with(PostDetailActivity.this).load(beanImages.get(1).getImage_url())
                                .into(mBinding.img2);
                        Glide.with(PostDetailActivity.this).load(beanImages.get(2).getImage_url())
                                .into(mBinding.img3);
                        Glide.with(PostDetailActivity.this).load(beanImages.get(3).getImage_url())
                                .into(mBinding.img4);
                    }
                    mBinding.imgframe.setOnClickListener(new View.OnClickListener() {
                        @Override
                        public void onClick(View v) {
                            Intent intent = new Intent(PostDetailActivity.this, ImagesActivity.class);
                            Bundle bundle = new Bundle();
                            bundle.putParcelableArrayList("mylist", beanImages);
                            intent.putExtras(bundle);
                            startActivity(intent);
                        }
                    });

                }
            }else if(mimetype!=null&&mimetype.equalsIgnoreCase("video")){
                mBinding.imgframe.setVisibility(View.GONE);
                mBinding.rlPdf.setVisibility(View.GONE);
                mBinding.VideoView.setVisibility(View.VISIBLE);

                Glide.with(getApplicationContext()).load(beanImages.get(0).getImage_url())
                        .placeholder(R.drawable.ic_profile)
                        .into(mBinding.VideoView.getCoverView());
                mBinding.VideoView.getVideoInfo().setAspectRatio(VideoInfo.AR_MATCH_PARENT);
                mBinding.VideoView.setVideoPath(beanImages.get(0).getImage_url());

            }
            else{
                mBinding.imgframe.setVisibility(View.GONE);
                mBinding.rlPdf.setVisibility(View.GONE);
                mBinding.VideoView.setVisibility(View.GONE);
            }
            String profilePic = Utils.getSavedData(getApplicationContext(),"profilePic");
            Glide.with(PostDetailActivity.this).load(profilePic)
                    .diskCacheStrategy(DiskCacheStrategy.NONE)
                    .skipMemoryCache(true)
                    .into(mBinding.imgCommentProfile);

            if(!campaign_name.equalsIgnoreCase("")){
                mBinding.txtcampaignName.setVisibility(View.VISIBLE);
                mBinding.txtcampaignName.setText("Campaign name :- "+campaign_name);
            }else{
                mBinding.txtcampaignName.setVisibility(View.GONE);
            }
            if(!campaign_owner.equalsIgnoreCase("")){
                mBinding.txtcampaignOwner.setVisibility(View.VISIBLE);
                mBinding.txtcampaignOwner.setText("Campaign owner :- "+campaign_owner);
            }else{
                mBinding.txtcampaignOwner.setVisibility(View.GONE);
            }
            if(postLikeUnlike.equalsIgnoreCase("true")){
                mBinding.imgLike.setImageResource(R.drawable.ic_baseline_favorite_24);
            }else{
                mBinding.imgLike.setImageResource(R.drawable.ic_like);
            }
            Glide.with(getApplicationContext()).load(image)
                    .into(mBinding.imgProfile);
            mBinding.txtUserFirstName.setText(name);
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH);
            dateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
            Date date2 = null;
            try {
                date2 = dateFormat.parse(date);
            } catch (ParseException e) {
                e.printStackTrace();
            }
            dateFormat.setTimeZone(TimeZone.getDefault());
            String formattedDate = dateFormat.format(date2);
            try {
                Date date3 = dateFormat.parse(formattedDate);
                String MyFinalValue = getTimeAgo(date3,getApplicationContext());
                mBinding.txtDate.setText(getResources().getString(R.string.published_by)+" "+post_owner+" "+MyFinalValue);

            } catch (ParseException e) {
                e.printStackTrace();
            }
            mBinding.txtMessage.setText(message);
            Linkify.addLinks(mBinding.txtMessage, Linkify.ALL);
            mBinding.txtMessage.setLinkTextColor(getResources().getColor(R.color.colorBlue));
            mBinding.txtComments.setText(commentModelArrayList.size()+" "+getResources().getString(R.string.comments));
            LinearLayoutManager llm = new LinearLayoutManager(getApplicationContext());
            llm.setOrientation(LinearLayoutManager.VERTICAL);
            mBinding.rvComments.setLayoutManager(llm);
            adapter = new Commentsdapter(PostDetailActivity.this,commentModelArrayList,postId);
            mBinding.rvComments.setAdapter( adapter );
            adapter.setListener(new Commentsdapter.SetOnClickListener() {
                @Override
                public void onItemClick(CommentModel CommentModel, String status, int position) {
                    record_type="";
                    Utils.saveData(getApplicationContext(),"commentId",CommentModel.getId());
                    if(status.equalsIgnoreCase("delete")){
                        progress=new ProgressDialog(PostDetailActivity.this);
                        progress.setMessage("Please wait....");
                        progress.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
                        progress.setProgressNumberFormat(null);
                        progress.setProgressPercentFormat(null);
                        progress.setIndeterminate(true);
                        progress.setCancelable(false);
                        progress.show();
                        Utils.saveData(getApplicationContext(),"Commentposition",position+"");
                        new DeleteComment().execute();
                    }else if(status.equalsIgnoreCase("like")){
                        record_type="com_like";
                        new CommentLikeUnlike().execute();
                    }else if(status.equalsIgnoreCase("dislike")){
                        record_type="com_dislike";
                        new CommentLikeUnlike().execute();
                    }
                }
            });
        }
    }

    private void getsetData() {
        postId = getIntent().getStringExtra("postId");
        checkInternet();
    }
    public void checkInternet(){
        ConnectivityManager conMgr =  (ConnectivityManager)getSystemService(Context.CONNECTIVITY_SERVICE);
        NetworkInfo netInfo = conMgr.getActiveNetworkInfo();
        if (netInfo == null){
            new AlertDialog.Builder(PostDetailActivity.this)
                    .setTitle(getResources().getString(R.string.app_name))
                    .setMessage(getResources().getString(R.string.internet_error))
                    .setPositiveButton("OK", null).show();
        }else{
            new PostDetail().execute();
        }
    }

    boolean delete;
    private class DeleteComment extends AsyncTask<Void, Void, Integer> {
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
                        Utils.printMessage(PostDetailActivity.this);
                        e.printStackTrace();
                    }
                }});
            }};
            try {
                int commentId = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"commentId"));
                int uid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"uid"));
                Object delete_comment = models.execute("execute_kw", asList(
                        Utils.db_name,uid, Utils.password,
                        "social.bit.comments", "unlink",asList(asList(commentId)))
                );
                Log.e("delete_comment"," "+delete_comment);
                delete = (Boolean)delete_comment;
            } catch (XmlRpcException e) {
                Utils.printMessage(PostDetailActivity.this);
                e.printStackTrace();
            }
            return null;
        }
        @Override
        protected void onPostExecute(Integer result) {
            super.onPostExecute(result);
            progress.dismiss();
            if(delete == true){
                int position = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"Commentposition"));
                adapter.removeAt(position);
            }
        }
    }

    private class LikeUnlike extends AsyncTask<Void, Void, Integer> {
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
                        Utils.printMessage(PostDetailActivity.this);
                        e.printStackTrace();
                    }
                }});
            }};
            try {
                likeUnlike = Utils.getSavedData(getApplicationContext(),"likeUnlike");
                int uid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"uid"));
                int postId = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"postId"));
                Object rating_response = models.execute("execute_kw", asList(
                        Utils.db_name,uid, Utils.password,
                        "social.bit.comments", "create", asList(new HashMap() {{
                            put("post_id",postId);
                            put("partner_id", Utils.getSavedData(getApplicationContext(),"partner_id"));
                            put("record_type", likeUnlike);
                        }}))
                );
            } catch (XmlRpcException e) {
                Utils.printMessage(PostDetailActivity.this);
                e.printStackTrace();
            }
            return null;
        }
        @Override
        protected void onPostExecute(Integer result) {
            super.onPostExecute(result);
        }
    }
    int comment_id;
    private class Comment extends AsyncTask<Void, Void, Integer> {
        @Override
        protected void onPreExecute() {
            super.onPreExecute();
        }
        @Override
        protected Integer doInBackground(Void... voids) {
            int postid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"postId"));
            Log.e("dvvfvdvdvdfv"," "+base64);

            final XmlRpcClient models = new XmlRpcClient() {{
                setConfig(new XmlRpcClientConfigImpl() {{
                    try {
                        setServerURL(new URL(String.format("%s/xmlrpc/2/object",Utils.url)));
                    } catch (MalformedURLException e) {
                        Utils.printMessage(PostDetailActivity.this);
                        e.printStackTrace();
                    }
                }});
            }};
            try {
                Object create_comment;
                int uid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"uid"));
                int finalpostId = Integer.parseInt(postId);
                if(base64.equalsIgnoreCase("")||base64==null){
                    create_comment = models.execute("execute_kw", asList(
                            Utils.db_name,uid, Utils.password,
                            "social.bit.comments", "create", asList(new HashMap() {{
                                put("filename","");
                                put("content","");
                                put("post_id",finalpostId);
                                put("partner_id", Utils.getSavedData(getApplicationContext(),"partner_id"));
                                put("comment", comment);
                            }}))
                    );
                }else {
                    create_comment = models.execute("execute_kw", asList(
                            Utils.db_name,uid, Utils.password,
                            "social.bit.comments", "create", asList(new HashMap() {{
                                put("filename",fileName);
                                put("content",base64);
                                put("post_id",finalpostId);
                                put("partner_id", Utils.getSavedData(getApplicationContext(),"partner_id"));
                                put("comment", comment);
                            }}))
                    );
                }

                comment_id = (int)create_comment;
                Log.e("create_comment"," "+create_comment);
                /*
                 */
            } catch (XmlRpcException e) {
                Log.e("exception"," "+e.getMessage());
                Utils.printMessage(PostDetailActivity.this);
                e.printStackTrace();
            }
            return null;
        }
        @Override
        protected void onPostExecute(Integer result) {
            super.onPostExecute(result);
            progress.dismiss();
            if(comment_id!=0){
                mBinding.edtComment.setText("");
                mBinding.rlSelected.setVisibility(View.GONE);
                mBinding.imgCancel.setVisibility(View.GONE);
                fileName="";
                base64="";
                InputMethodManager imm = (InputMethodManager) getSystemService(Activity.INPUT_METHOD_SERVICE);
                View view = getCurrentFocus();
                if (view == null) {
                    view = new View(getApplicationContext());
                }
                imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
                Toast.makeText(getApplicationContext(),"Comment added Successfully",Toast.LENGTH_SHORT).show();
                new PostDetail().execute();
            }
        }
    }

    private class CommentLikeUnlike extends AsyncTask<Void, Void, Integer> {
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
                        Utils.printMessage(PostDetailActivity.this);
                        e.printStackTrace();
                    }
                }});
            }};
            try {
                int uid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"uid"));
                int finalpostId = Integer.parseInt(postId);
                int commentId = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"commentId"));

                Object likeUnlike_comment = models.execute("execute_kw", asList(
                        Utils.db_name,uid, Utils.password,
                        "social.bit.comments", "create", asList(new HashMap() {{
                            put("post_id",finalpostId);
                            put("parent_id",commentId);
                            put("partner_id", Utils.getSavedData(getApplicationContext(),"partner_id"));
                            put("record_type",record_type);
                        }}))
                );
                comment_id = (int)likeUnlike_comment;
                Log.e("likeUnlike_comment"," "+likeUnlike_comment);
                /*
                 */
            } catch (XmlRpcException e) {
                Log.e("exception"," "+e.getMessage());
                Utils.printMessage(PostDetailActivity.this);
                e.printStackTrace();
            }
            return null;
        }
        @Override
        protected void onPostExecute(Integer result) {
            super.onPostExecute(result);
            if(comment_id!=0){
            }
        }
    }
    Uri fileUri;
    private void selectFile() {
        final CharSequence[] options = {getResources().getString(R.string.Camera),
                getResources().getString(R.string.Gallery),
                getResources().getString(R.string.Document),
                getResources().getString(R.string.cancel)};
        AlertDialog.Builder builder = new AlertDialog.Builder(PostDetailActivity.this);
        builder.setTitle(getResources().getString(R.string.upload_file));
        builder.setItems(options, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int item) {
                if (options[item].equals(getResources().getString(R.string.Camera)))
                {
                    Intent takePicture = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
                    fileUri = CameraUtils.getOutputMediaFileUri(getApplicationContext());//get fileUri from CameraUtils
                    takePicture.putExtra(MediaStore.EXTRA_OUTPUT, fileUri);//Send fileUri with intent
                    startActivityForResult(takePicture, 4);
                }
                else if (options[item].equals(getResources().getString(R.string.Gallery)))
                {
                    Intent gallery = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.INTERNAL_CONTENT_URI);
                    startActivityForResult(gallery, 5);
                }
                else if (options[item].equals(getResources().getString(R.string.Document)))
                {
                    Intent intent = new Intent();
                    intent.setAction(Intent.ACTION_GET_CONTENT);
                    intent.setType("application/pdf");
                    startActivityForResult(intent, 6);
                }
                else if (options[item].equals(getResources().getString(R.string.cancel))) {
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
            if (requestCode == 4) {
                String path = fileUri.getPath();
                File file2 = new File(getExternalFilesDir(Environment.DIRECTORY_PICTURES), "Camera/"+fileUri.getLastPathSegment());

                Uri mCapturedImageURI =Uri.fromFile(file2);

                File file = new File(getPath(getApplicationContext(),mCapturedImageURI));
                float uploadLimit = Float.valueOf(upload_limit);
                float originalSize = file.length()/1048576;
                if(originalSize>uploadLimit){
                    Toast.makeText(getApplicationContext(),"Can't upload more than "+uploadLimit+"mb",Toast.LENGTH_SHORT).show();
                }else{
                    final InputStream imageStream;
                    try {
                        imageStream = getContentResolver().openInputStream(mCapturedImageURI);
                        final Bitmap selectedImage = BitmapFactory.decodeStream(imageStream);
                        base64 = encodeImage(selectedImage);
                    } catch (FileNotFoundException e) {
                        e.printStackTrace();
                    }
                    fileName = path.substring(path.lastIndexOf("/") + 1);
                    mBinding.rlSelected.setVisibility(View.VISIBLE);
                    mBinding.txtSelectedFileName.setText(fileName);

                }
            } else if(requestCode == 5){
                Uri imageUri;

                imageUri = data.getData();
                File file = new File(getPath(getApplicationContext(),imageUri));
                float uploadLimit = Float.valueOf(upload_limit);
                float originalSize = file.length()/1048576;

                if(originalSize>uploadLimit){
                    Toast.makeText(getApplicationContext(),"Can't upload more than "+uploadLimit+"mb",Toast.LENGTH_SHORT).show();
                }else{
                    String uriString = imageUri.toString();
                    File myFile = new File(uriString);
                    fileName = null;
                    if (uriString.startsWith("content://")) {
                        Cursor cursor = null;
                        try {
                            cursor = getContentResolver().query(imageUri, null, null, null, null);
                            if (cursor != null && cursor.moveToFirst()) {
                                fileName = cursor.getString(cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME));
                            }
                        } finally {
                            cursor.close();
                        }
                    } else if (uriString.startsWith("file://")) {
                        fileName = myFile.getName();
                    }
                    mBinding.rlSelected.setVisibility(View.VISIBLE);
                    mBinding.txtSelectedFileName.setText(fileName);
                    final InputStream imageStream;
                    try {
                        imageStream = getContentResolver().openInputStream(imageUri);
                        final Bitmap selectedImage = BitmapFactory.decodeStream(imageStream);
                        base64 = encodeImage(selectedImage);
                    } catch (FileNotFoundException e) {
                        e.printStackTrace();
                    }
                }
            }else if(requestCode == 6){
                    Uri uri = data.getData();
                    File file = new File(getLocalPath(getApplicationContext(),uri));
                    float uploadLimit = Float.valueOf(upload_limit);
                    float originalSize = file.length()/1048576;

                    if(originalSize>uploadLimit){
                        Toast.makeText(getApplicationContext(),"Can't upload more than "+uploadLimit+"mb",Toast.LENGTH_SHORT).show();
                    }else{
                        String mimeType = getLocalPath(getApplicationContext(),uri);
                        fileName=mimeType.substring(mimeType.lastIndexOf("/")+1);
                        mBinding.rlSelected.setVisibility(View.VISIBLE);
                        mBinding.txtSelectedFileName.setText(fileName);
                        String path = getLocalPath(getApplicationContext(),uri);
                        try {
                            base64 = Utils.encodeFileToBase64Binary(path);
                            Log.e("base64"," "+base64);
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
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
}