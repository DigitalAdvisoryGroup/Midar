package com.channel.bit;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Handler;
import android.provider.MediaStore;
import android.provider.OpenableColumns;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.Base64;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.channel.bit.adapter.ChildCommentsdapter;
import com.channel.bit.common.FilePath;
import com.channel.bit.common.LocaleHelper;
import com.channel.bit.common.Utils;
import com.channel.bit.databinding.ActivityCommentBinding;
import com.channel.bit.model.ChildCommentModel;
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
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.provider.FontRequest;
import androidx.databinding.DataBindingUtil;
import androidx.emoji.text.EmojiCompat;
import androidx.emoji.text.FontRequestEmojiCompatConfig;
import androidx.recyclerview.widget.LinearLayoutManager;

import static com.channel.bit.adapter.PostAdapter.getTimeAgo;
import static com.channel.bit.common.FilePath.getPath;
import static com.channel.bit.common.FileUtils.getLocalPath;
import static java.util.Arrays.asList;

public class CommentActivity extends AppCompatActivity {

  ActivityCommentBinding mBinding;
  String comment_user_name="";
  String comment_user_image="";
  String comment_user_comment="";
  String comment_user_time="";
  String postId;
  ArrayList<ChildCommentModel> commentModelArrayList = new ArrayList<>();
  boolean isLike;
  boolean isDislike;
  String record_type = "";
  String commentId;
  String comment = "";
  String partner_id = "";
  String base64 = "";
  String fileName = "";
  ProgressDialog progress;
  int upload_limit=0;
  int replyId=0;
  int replyPosition=0;
  ChildCommentsdapter adapter;
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
    mBinding = DataBindingUtil.setContentView(this, R.layout.activity_comment);
    LocaleHelper.setLocale(CommentActivity.this, Utils.getSavedData(getApplicationContext(),"language"));
    getsetData();
    setListener();
  }

  private void getsetData() {
    if (getIntent().getExtras() != null) {
      String notification = getIntent().getExtras().getString("notification");


        if(notification!=null){

          JSONObject jsonObject = null;
          try {
            jsonObject = new JSONObject(notification);
          } catch (JSONException e) {
            e.printStackTrace();
          }
          Log.d("notification--------"," "+jsonObject);
          commentId = jsonObject.optString("comment_id");
          postId = jsonObject.optString("post_id");
        }else{
          commentId = getIntent().getStringExtra("commentId");
          postId = getIntent().getStringExtra("postId");
        }

    }

    String profilePic = Utils.getSavedData(getApplicationContext(),"profilePic");
    Glide.with(getApplicationContext()).load(profilePic)
            .diskCacheStrategy(DiskCacheStrategy.NONE)
            .skipMemoryCache(true)
            .into(mBinding.imgProfile);
    checkInternet();
  }
  public void checkInternet(){
    ConnectivityManager conMgr =  (ConnectivityManager)getSystemService(CONNECTIVITY_SERVICE);
    NetworkInfo netInfo = conMgr.getActiveNetworkInfo();
    if (netInfo == null){
      new AlertDialog.Builder(CommentActivity.this)
              .setTitle(getResources().getString(R.string.app_name))
              .setMessage(getResources().getString(R.string.internet_error))
              .setPositiveButton(getResources().getString(R.string.ok), null).show();
    }else{
      new getReplies().execute();
    }
  }
  private void setListener() {
    mBinding.txtUserFirstName.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(View v) {
        if(Utils.getSavedData(getApplicationContext(),"partner_id").equalsIgnoreCase(partner_id)){
          Intent intent = new Intent(getApplicationContext(), ProfileActivity.class);
          intent.putExtra("partner_id",partner_id);
          startActivity(intent);
        }else{
          Intent intent = new Intent(getApplicationContext(), OtherUserProfileActivity.class);
          intent.putExtra("partner_id",partner_id);
          startActivity(intent);
        }
      }
    });
    mBinding.imgCommentProfile.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(View v) {
        if(Utils.getSavedData(getApplicationContext(),"partner_id").equalsIgnoreCase(partner_id)){
          Intent intent = new Intent(getApplicationContext(), ProfileActivity.class);
          intent.putExtra("partner_id",partner_id);
          startActivity(intent);
        }else{
          Intent intent = new Intent(getApplicationContext(), OtherUserProfileActivity.class);
          intent.putExtra("partner_id",partner_id);
          startActivity(intent);
        }
      }
    });
    mBinding.imgCancel.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(View view) {
        mBinding.rlSelected.setVisibility(View.GONE);
        fileName="";
        base64="";
      }
    });


    mBinding.cardselectedPdf.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(View view) {
        Intent pdfOpenintent = new Intent(Intent.ACTION_VIEW);
        pdfOpenintent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        pdfOpenintent.setDataAndType(Uri.parse(imagePdf), "application/pdf");
        try {
          startActivity(pdfOpenintent);
        }
        catch (ActivityNotFoundException e) {

        }
      }
    });
    mBinding.selectedImage.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(View view) {
        Intent intent = new Intent(getApplicationContext(), SingleImageActivity.class);
        intent.putExtra("imgUrl",imagePdf);
        startActivity(intent);
      }
    });
    mBinding.uploadFile.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(View view) {
        selectFile();
      }
    });
    mBinding.imgBack.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(View view) {
        onBackPressed();
      }
    });
    mBinding.txtPost.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(View v) {
        if(comment.length()==0){
          Toast.makeText(getApplicationContext(),"Please add comment..!!",Toast.LENGTH_SHORT).show();
        }else{
          mBinding.txtPost.setTextColor(getResources().getColor(R.color.colorPrimaryDark));
          progress=new ProgressDialog(CommentActivity.this);
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

    mBinding.imgLike.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(View v) {
        if (isLike==false){
          isLike = true;
          mBinding.imgLike.setImageResource(R.drawable.ic_baseline_favorite_24);
          isDislike = false;
          mBinding.imgUnLike.setImageResource(R.drawable.ic_dislike_foreground);
        }else{
          isLike = false;
          mBinding.imgLike.setImageResource(R.drawable.ic_like);
          isDislike = true;
          mBinding.imgUnLike.setImageResource(R.drawable.ic_dislikefill_foreground);
        }
        record_type = "com_like";
        new CommentLikeUnlike().execute();
      }
    });
    mBinding.imgUnLike.setOnClickListener(new View.OnClickListener() {
      @Override
      public void onClick(View view) {
        if (isDislike==false){
          isDislike = true;
          mBinding.imgUnLike.setImageResource(R.drawable.ic_dislikefill_foreground);
          isLike = false;
          mBinding.imgLike.setImageResource(R.drawable.ic_like);
        }else{
          isDislike = false;
          mBinding.imgUnLike.setImageResource(R.drawable.ic_dislike_foreground);
          isLike = true;
          mBinding.imgLike.setImageResource(R.drawable.ic_baseline_favorite_24);
        }
        record_type = "com_dislike";
        new CommentLikeUnlike().execute();
      }
    });
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
            Utils.printMessage(CommentActivity.this);
            e.printStackTrace();
          }
        }});
      }};
      try {
        int uid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"uid"));
        int finalpostId = Integer.parseInt(postId);
        int commentId1 = Integer.parseInt(commentId);

        Object likeUnlike_comment = models.execute("execute_kw", asList(
                Utils.db_name,uid, Utils.password,
                "social.bit.comments", "create", asList(new HashMap() {{
                  put("post_id",finalpostId);
                  put("parent_id",commentId1);
                  put("partner_id", Utils.getSavedData(getApplicationContext(),"partner_id"));
                  put("record_type",record_type);
                }}))
        );

      } catch (XmlRpcException e) {
        Log.e("exception"," "+e.getMessage());
        Utils.printMessage(CommentActivity.this);
        e.printStackTrace();
      }
      return null;
    }
    @Override
    protected void onPostExecute(Integer result) {
      super.onPostExecute(result);

    }
  }

  int replyid;
  private class Comment extends AsyncTask<Void, Void, Integer> {
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
            Utils.printMessage(CommentActivity.this);
            e.printStackTrace();
          }
        }});
      }};
      try {
        int uid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"uid"));
        int partner_id = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"partner_id"));
        int finalpostId = Integer.parseInt(postId);
        int commentId1 = Integer.parseInt(commentId);

        Object create_comment;
        if(base64.equalsIgnoreCase("")||base64==null){
          create_comment = models.execute("execute_kw", asList(
                  Utils.db_name,uid, Utils.password,
                  "social.bit.comments", "create", asList(new HashMap() {{
                    put("filename","");
                    put("content","");
                    put("post_id",finalpostId);
                    put("partner_id",partner_id);
                    put("comment", comment);
                    put("parent_id", commentId1);
                  }}))
          );
        }else {
          create_comment = models.execute("execute_kw", asList(
                  Utils.db_name,uid, Utils.password,
                  "social.bit.comments", "create", asList(new HashMap() {{
                    put("filename",fileName);
                    put("content",base64);
                    put("post_id",finalpostId);
                    put("partner_id",partner_id);
                    put("comment", comment);
                    put("parent_id", commentId1);
                  }}))
          );
        }
        replyid = (int)create_comment;
        Log.e("create_reply"," "+create_comment);

      } catch (XmlRpcException e) {
        Log.e("exception"," "+e.getMessage());
        Utils.printMessage(CommentActivity.this);
        e.printStackTrace();
      }
      return null;
    }
    @Override
    protected void onPostExecute(Integer result) {
      super.onPostExecute(result);
      progress.dismiss();
      if(replyid!=0){
        Toast.makeText(getApplicationContext(),"Comment added Successfully",Toast.LENGTH_SHORT).show();
        Intent intent = new Intent(CommentActivity.this,PostDetailActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
        intent.putExtra("postId",postId);
        startActivity(intent);
      }
    }
  }
  String imagePdf = "";
  String mimetype = "";
  private class getReplies extends AsyncTask<Void, Void, Integer> {
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
            Utils.printMessage(CommentActivity.this);
            e.printStackTrace();
          }
        }});
      }};
      try {
        int uid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"uid"));
        int commentId1 = Integer.parseInt(commentId);

        Object get_replies = models.execute("execute_kw", asList(
                Utils.db_name,uid, Utils.password,
                "social.bit.comments", "get_reply_for_comment", asList(asList(commentId1)))
        );
        Gson gson = new Gson();
        String get_replies_json = gson.toJson(get_replies);
        try {
          JSONObject jsonObject = new JSONObject(get_replies_json);
          JSONArray data = jsonObject.optJSONArray("data");
          if(data!=null&&data.length()>0){
            for(int i =0;i<data.length();i++){
              JSONObject jsonObject1 = data.optJSONObject(i);
              isLike = jsonObject1.optBoolean("comment_like");
              upload_limit = jsonObject1.optInt("upload_limit");
              isDislike = jsonObject1.optBoolean("comment_dislike");
              comment_user_name = jsonObject1.optString("author_name");
              comment_user_comment = jsonObject1.optString("comment");
              comment_user_time = jsonObject1.optString("date");
              partner_id = jsonObject1.optString("partner_id");
              comment_user_image = jsonObject1.optString("author_image");
              imagePdf = "";
              mimetype = "";
              JSONArray media_ids_main = jsonObject1.optJSONArray("media_ids");
              for(int k=0;k<media_ids_main.length();k++){
                JSONObject jsonObject2 = media_ids_main.optJSONObject(k);
                imagePdf = jsonObject2.optString("url");
                mimetype = jsonObject2.optString("mimetype");
              }
              String author_image="";
              String comment="";
              String author_name="";
              String date="";
              String partner_id="";
              String child_id="";
              JSONArray child_comments = jsonObject1.optJSONArray("child_comments");
              if(child_comments!=null&&child_comments.length()>0){
                for(int j = 0;j<child_comments.length();j++){
                  JSONObject jsonObject2 = child_comments.optJSONObject(j);
                  String imgPdf ="";
                  String mimetypeImgPdf ="";
                  JSONArray media_ids = jsonObject2.optJSONArray("media_ids");
                  for(int k=0;k<media_ids.length();k++){
                    JSONObject jsonObject4 = media_ids.optJSONObject(k);
                    imgPdf = jsonObject4.optString("url");
                    mimetypeImgPdf = jsonObject4.optString("mimetype");
                  }
                  author_image = jsonObject2.optString("author_image");
                  child_id = jsonObject2.optString("id");
                  comment = jsonObject2.optString("comment");
                  author_name = jsonObject2.optString("author_name");
                  date = jsonObject2.optString("date");
                  partner_id = jsonObject2.optString("partner_id");
                  commentModelArrayList.add(new ChildCommentModel(child_id,author_image,comment,author_name,date,imgPdf,mimetypeImgPdf,partner_id));
                }
              }
            }
          }
        } catch (JSONException e) {
          e.printStackTrace();
        }
        Log.e("get_replies"," "+get_replies_json);

      } catch (XmlRpcException e) {
        Log.e("exception"," "+e.getMessage());
        Utils.printMessage(CommentActivity.this);
        e.printStackTrace();
      }
      return null;
    }
    @Override
    protected void onPostExecute(Integer result) {
      super.onPostExecute(result);
      if(mimetype.equalsIgnoreCase("")){
        mBinding.rlUplodedData.setVisibility(View.GONE);
      }else{
        mBinding.rlUplodedData.setVisibility(View.VISIBLE);
        if(mimetype.equalsIgnoreCase("image")){
          mBinding.selectedImage.setVisibility(View.VISIBLE);
          mBinding.cardselectedPdf.setVisibility(View.GONE);
          Glide.with(getApplicationContext()).load(imagePdf)
                  .placeholder(R.drawable.ic_profile)
                  .into(mBinding.selectedImage);

        }else if(mimetype.equalsIgnoreCase("pdf")){
          mBinding.selectedImage.setVisibility(View.GONE);
          mBinding.cardselectedPdf.setVisibility(View.VISIBLE);
          mBinding.pdfName.setText(imagePdf.substring(imagePdf.lastIndexOf("/") + 1));
        }
      }

      Glide.with(getApplicationContext()).load(comment_user_image)
              .into(mBinding.imgCommentProfile);

      mBinding.txtReplyTo.setText(getResources().getString(R.string.Replies_to)+" "+comment_user_name+" "+getResources().getString(R.string.comment_on_this_post));
      mBinding.txtUserFirstName.setText(comment_user_name);
      mBinding.txtMessage.setText(comment_user_comment);
      SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
      try {
        Date date = dateFormat.parse(comment_user_time);
        String MyFinalValue = getTimeAgo(date,getApplicationContext());
        mBinding.txtTime.setText(MyFinalValue);

      } catch (ParseException e) {
        e.printStackTrace();
      }
      if(isLike==true){
        mBinding.imgLike.setImageResource(R.drawable.ic_baseline_favorite_24);
      }else {
        mBinding.imgLike.setImageResource(R.drawable.ic_like);
      }
      if(isDislike==true){
        mBinding.imgUnLike.setImageResource(R.drawable.ic_dislikefill_foreground);
      }else {
        mBinding.imgUnLike.setImageResource(R.drawable.ic_dislike_foreground);
      }
      LinearLayoutManager llm = new LinearLayoutManager(getApplicationContext());
      llm.setOrientation(LinearLayoutManager.VERTICAL);
      mBinding.rvComments.setLayoutManager(llm);
      adapter = new ChildCommentsdapter(CommentActivity.this,commentModelArrayList);
      mBinding.rvComments.setAdapter( adapter );
      adapter.setListener(new ChildCommentsdapter.SetOnClickListener() {
        @Override
        public void onItemClick(ChildCommentModel ChildCommentModel, String status, int position) {
          if(status.equalsIgnoreCase("deleteReply")){
            replyId = Integer.parseInt(ChildCommentModel.getChild_id());
            replyPosition = position;
            new DeleteReply().execute();
          }
        }
      });
    }
  }
  boolean delete;
  private class DeleteReply extends AsyncTask<Void, Void, Integer> {
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
            Utils.printMessage(CommentActivity.this);
            e.printStackTrace();
          }
        }});
      }};
      try {
        int uid = Integer.parseInt(Utils.getSavedData(CommentActivity.this,"uid"));
        Object delete_comment = models.execute("execute_kw", asList(
                Utils.db_name,uid, Utils.password,
                "social.bit.comments", "unlink",asList(asList(replyId)))
        );
        Log.e("delete_reply"," "+delete_comment);
        delete = (Boolean)delete_comment;
      } catch (XmlRpcException e) {
        Utils.printMessage(CommentActivity.this);
        e.printStackTrace();
      }
      return null;
    }
    @Override
    protected void onPostExecute(Integer result) {
      super.onPostExecute(result);
      if(delete == true){
        adapter.removeAt(replyPosition);
        finish();
      }
    }
  }
  @Override
  public void onBackPressed() {
    super.onBackPressed();
    Intent intent = new Intent(CommentActivity.this,PostDetailActivity.class);
    intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
    intent.putExtra("postId",postId);
    startActivity(intent);
  }

  @Override
  protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    if (resultCode == RESULT_OK){
      if (requestCode == 4) {
        Bitmap selectedImage1 = (Bitmap) data.getExtras().get("data");
        Uri mCapturedImageURI = getImageUri(CommentActivity.this,selectedImage1);
        File file = new File(getPath(getApplicationContext(),mCapturedImageURI));
        float uploadLimit = Float.valueOf(upload_limit);
        float originalSize = file.length()/1048576;
        if(originalSize>uploadLimit){
          Toast.makeText(getApplicationContext(),"Can't upload more than "+uploadLimit+"mb",Toast.LENGTH_SHORT).show();
        }else{
          base64 = encodeImage(selectedImage1);
          String[] projection = { MediaStore.Images.Media.DATA };
          Cursor cursor = managedQuery(mCapturedImageURI, projection, null,
                  null, null);
          int column_index_data = cursor
                  .getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
          cursor.moveToFirst();
          fileName = cursor.getString(column_index_data);
          fileName = fileName.substring(fileName.lastIndexOf("/") + 1);
          mBinding.rlSelected.setVisibility(View.VISIBLE);
          mBinding.txtSelectedFileName.setText(fileName);
        }

      } else if(requestCode == 5){
        Uri imageUri ;
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

  public Uri getImageUri(Context inContext, Bitmap inImage) {
    ByteArrayOutputStream bytes = new ByteArrayOutputStream();
    inImage.compress(Bitmap.CompressFormat.JPEG, 100, bytes);
    String path = MediaStore.Images.Media.insertImage(getContentResolver(), inImage, "Title","");
    return Uri.parse(path);
  }

  private void selectFile() {
    final CharSequence[] options = {getResources().getString(R.string.Camera),
            getResources().getString(R.string.Gallery),
            getResources().getString(R.string.Document),
            getResources().getString(R.string.cancel)};

    AlertDialog.Builder builder = new AlertDialog.Builder(CommentActivity.this);
    builder.setTitle(getResources().getString(R.string.upload_file));
    builder.setItems(options, new DialogInterface.OnClickListener() {
      @Override
      public void onClick(DialogInterface dialog, int item) {
        if (options[item].equals(getResources().getString(R.string.Camera)))
        {
          Intent takePicture = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
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

}