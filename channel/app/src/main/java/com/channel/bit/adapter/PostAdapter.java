package com.channel.bit.adapter;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Point;
import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.provider.MediaStore;
import android.text.util.Linkify;
import android.util.Log;
import android.view.Display;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.RatingBar;

import com.bumptech.glide.Glide;
import com.channel.bit.ImagesActivity;
import com.channel.bit.PostDetailActivity;
import com.channel.bit.R;
import com.channel.bit.databinding.RowPostBinding;
import com.channel.bit.model.PostModel;


import java.io.ByteArrayOutputStream;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

import androidx.annotation.NonNull;
import androidx.databinding.DataBindingUtil;
import androidx.recyclerview.widget.RecyclerView;
import tcking.github.com.giraffeplayer2.VideoInfo;


public class PostAdapter extends RecyclerView.Adapter<PostAdapter.MainitemHolder> {
    List<PostModel> list;
    private SetOnClickListener itemClickListener;
    Activity context;
    String url ="https://bit.candidroot.com/web/content/444/file_example_MP4_480_1_5MG.mp4";
    private static final int SECOND_MILLIS = 1000;
    private static final int MINUTE_MILLIS = 60 * SECOND_MILLIS;
    private static final int HOUR_MILLIS = 60 * MINUTE_MILLIS;
    private static final int DAY_MILLIS = 24 * HOUR_MILLIS;
    public PostAdapter(Activity context, List<PostModel> list) {
        this.context = context;
        this.list = list;
    }
    @NonNull
    @Override
    public MainitemHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.row_post,parent,false);
        return new MainitemHolder(view);
    }
    @Override
    public void onBindViewHolder(@NonNull final MainitemHolder holder, final int position) {
        final PostModel postModel = list.get(position);

        /*count*/
        holder.mBinding.txtLikeCount.setText(postModel.getTotal_like_count());
        holder.mBinding.txtDisLikeCount.setText(postModel.getTotal_dislike_count());
        holder.mBinding.txtShareCount.setText(postModel.getTotal_share_count());
        /*-----*/
        holder.mBinding.txtUserFirstName.setText(postModel.getName());
        if(postModel.getMessage()!=null){
            holder.mBinding.txtMessage.setText(postModel.getMessage());
            Linkify.addLinks( holder.mBinding.txtMessage, Linkify.ALL);
            holder.mBinding.txtMessage.setLinkTextColor(context.getResources().getColor(R.color.colorBlue));
        }
        holder.mBinding.txtRating.setText(postModel.getRating());
        holder.mBinding.ratingBar.setRating(Float.parseFloat(postModel.getRating()));
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH);
        dateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
        Date date2 = null;
        try {
            date2 = dateFormat.parse(postModel.getDate());
        } catch (ParseException e) {
            e.printStackTrace();
        }
        dateFormat.setTimeZone(TimeZone.getDefault());
        String formattedDate = dateFormat.format(date2);
        try {
            Date date = dateFormat.parse(formattedDate);
            String MyFinalValue = getTimeAgo(date,context);
            holder.mBinding.txtDate.setText(context.getResources().getString(R.string.published_by)+" "+postModel.getPost_owner()+" "+MyFinalValue);

        } catch (ParseException e) {
            e.printStackTrace();
        }

        if(list.get(position).isLike()==true){
            holder.mBinding.imgLike.setImageResource(R.drawable.ic_baseline_favorite_24);
        }else {
            holder.mBinding.imgLike.setImageResource(R.drawable.ic_like);
        }
        if(list.get(position).isDislike()==true){
            holder.mBinding.imgDislike.setImageResource(R.drawable.ic_dislikefill_foreground);
        }else {
            holder.mBinding.imgDislike.setImageResource(R.drawable.ic_dislike_foreground);
        }

        holder.mBinding.llLike.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (list.get(position).isLike()==false){
                    list.get(position).setLike(true);
                    holder.mBinding.imgLike.setImageResource(R.drawable.ic_baseline_favorite_24);
                    list.get(position).setDislike(false);
                    holder.mBinding.imgDislike.setImageResource(R.drawable.ic_dislike_foreground);
                }else{
                    list.get(position).setLike(false);
                    holder.mBinding.imgLike.setImageResource(R.drawable.ic_like);
                    list.get(position).setDislike(true);
                    holder.mBinding.imgDislike.setImageResource(R.drawable.ic_dislikefill_foreground);
                }
                itemClickListener.onItemClick(postModel,"like",position,1,"");
            }
        });
        holder.mBinding.llDisLike.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (list.get(position).isDislike()==false){
                    list.get(position).setDislike(true);
                    holder.mBinding.imgDislike.setImageResource(R.drawable.ic_dislikefill_foreground);
                    list.get(position).setLike(false);
                    holder.mBinding.imgLike.setImageResource(R.drawable.ic_like);
                }else{
                    list.get(position).setDislike(false);
                    holder.mBinding.imgDislike.setImageResource(R.drawable.ic_dislike_foreground);
                    list.get(position).setLike(true);
                    holder.mBinding.imgLike.setImageResource(R.drawable.ic_baseline_favorite_24);
                }
                itemClickListener.onItemClick(postModel,"dislike",position,1,"");
            }
        });
        holder.mBinding.llComment.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                itemClickListener.onItemClick(postModel,"comment",position,1,"");
            }
        });
        holder.mBinding.llShare.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(android.content.Intent.ACTION_SEND);
                if(postModel.getBeanImages().size()>0){
                    intent.putExtra(android.content.Intent.EXTRA_TEXT,holder.mBinding.txtMessage.getText().toString()+"\n"+ postModel.getBeanImages().get(0).getImage_url());
                }else{
                    intent.putExtra(android.content.Intent.EXTRA_TEXT,holder.mBinding.txtMessage.getText().toString());
                }
                intent.setType("text/plain");
                context.startActivity(Intent.createChooser(intent,"Share Using"));
                if(postModel.getMimetype()!=null&&postModel.getMimetype().equalsIgnoreCase("video")){
                    itemClickListener.onItemClick(postModel,"share",position,1,"");
                }
            }
        });
        holder.mBinding.imgDelete.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AlertDialog.Builder dialogBuilder = new AlertDialog.Builder(context);
                LayoutInflater inflater = context.getLayoutInflater();
                View dialogView = inflater.inflate(R.layout.dialog_delete, null);
                dialogBuilder.setView(dialogView);

                final AlertDialog alertDialog = dialogBuilder.create();
                alertDialog.setCancelable(false);
                alertDialog.show();
                Button cancel=dialogView.findViewById(R.id.btncancel);
                Button btnDelete=dialogView.findViewById(R.id.btnDelete);
                cancel.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        alertDialog.dismiss();
                    }
                });
                btnDelete.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        alertDialog.dismiss();
                        itemClickListener.onItemClick(postModel,"delete",position,1,"");
                    }
                });
            }
        });
        holder.mBinding.rlRating.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                AlertDialog.Builder dialogBuilder = new AlertDialog.Builder(context);
                LayoutInflater inflater = context.getLayoutInflater();
                View dialogView = inflater.inflate(R.layout.dialog_rating, null);
                dialogBuilder.setView(dialogView);
                final AlertDialog alertDialog = dialogBuilder.create();
                alertDialog.setCancelable(true);
                alertDialog.show();
                Button btnSubmit=dialogView.findViewById(R.id.btnSubmit);
                RatingBar ratingBar=dialogView.findViewById(R.id.ratingBar);
                EditText edtMessageRating=dialogView.findViewById(R.id.edtMessageRating);
                btnSubmit.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        int rating = (int) ratingBar.getRating();
                        alertDialog.dismiss();
                        itemClickListener.onItemClick(postModel,"rating",position,rating,edtMessageRating.getText().toString().trim());
                    }
                });
            }
        });
        holder.mBinding.postClick.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                itemClickListener.onItemClick(postModel,"comment",position,1,"");
            }
        });

        Glide.with(context).load(postModel.getImage())
                .placeholder(R.drawable.ic_profile)
                .into(holder.mBinding.imgProfile);

        holder.mBinding.txtCommentCount.setText(postModel.getCommentsNumber()+" "+context.getResources().getString(R.string.comments));


        if(postModel.getMimetype().equalsIgnoreCase("video")){
            holder.mBinding.imgframe.setVisibility(View.GONE);
            holder.mBinding.rlPdf.setVisibility(View.GONE);
            holder.mBinding.VideoView.setVisibility(View.VISIBLE);

            Glide.with(context).load(postModel.getBeanImages().get(0).getImage_url())
                    .placeholder(R.drawable.ic_profile)
                    .into(holder.mBinding.VideoView.getCoverView());
            holder.mBinding.VideoView.getVideoInfo().setAspectRatio(VideoInfo.AR_MATCH_PARENT);
            holder.mBinding.VideoView.setVideoPath(postModel.getBeanImages().get(0).getImage_url()).setFingerprint(position);

        }else if(postModel.getMimetype().equalsIgnoreCase("image")){
            holder.mBinding.imgframe.setVisibility(View.VISIBLE);
            holder.mBinding.rlPdf.setVisibility(View.GONE);
            holder.mBinding.VideoView.setVisibility(View.GONE);
            if(postModel.getBeanImages().size()>0){
                holder.mBinding.imgframe.setVisibility(View.VISIBLE);
                if(postModel.getBeanImages().size()==1)
                {
                    Display display = context.getWindowManager().getDefaultDisplay();
                    Point size = new Point();
                    display.getSize(size);
                    int width = size.x;
                    Float floatheight = Float.valueOf(postModel.getBeanImages().get(0).getHeight()).floatValue();
                    Float floatWidth= Float.valueOf(postModel.getBeanImages().get(0).getWidth()).floatValue();
                    int apiheight =Math.round(floatheight);
                    int apiwidth =Math.round(floatWidth);
                    holder.mBinding.ll1.setVisibility(View.VISIBLE);
                    holder.mBinding.img2.setVisibility(View.GONE);
                    holder.mBinding.ll2.setVisibility(View.GONE);
                    Glide.with(context).load(postModel.getBeanImages().get(0).getImage_url())
                            .placeholder(R.drawable.ic_profile)
                            .into(holder.mBinding.img1);
                    int Height = width*apiwidth;

                    holder.mBinding.img1.setLayoutParams(new LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));
                }
                if(postModel.getBeanImages().size()==2)
                {
                    holder.mBinding.ll1.setVisibility(View.VISIBLE);
                    holder.mBinding.ll2.setVisibility(View.GONE);
                    Glide.with(context).load(postModel.getBeanImages().get(0).getImage_url())
                            .placeholder(R.drawable.ic_profile)
                            .into(holder.mBinding.img1);
                    Glide.with(context).load(postModel.getBeanImages().get(1).getImage_url())
                            .placeholder(R.drawable.ic_profile)
                            .into(holder.mBinding.img2);
                }
                if(postModel.getBeanImages().size()==3)
                {
                    Display display = context.getWindowManager().getDefaultDisplay();
                    Point size = new Point();
                    display.getSize(size);
                    int width = size.x;
                    holder.mBinding.ll1.setVisibility(View.VISIBLE);
                    holder.mBinding.ll2.setVisibility(View.VISIBLE);
                    holder.mBinding.img2.setVisibility(View.GONE);
                    holder.mBinding.img1.setVisibility(View.VISIBLE);
                    holder.mBinding.img3.setVisibility(View.VISIBLE);
                    holder.mBinding.img4.setVisibility(View.VISIBLE);
                    holder.mBinding.img1.setMinimumWidth(width);
                    holder.mBinding.txtCount.setVisibility(View.GONE);
                    Glide.with(context).load(postModel.getBeanImages().get(0).getImage_url())
                            .placeholder(R.drawable.ic_profile)
                            .into(holder.mBinding.img1);
                    Glide.with(context).load(postModel.getBeanImages().get(1).getImage_url())
                            .placeholder(R.drawable.ic_profile)
                            .into(holder.mBinding.img3);
                    Glide.with(context).load(postModel.getBeanImages().get(2).getImage_url())
                            .placeholder(R.drawable.ic_profile)
                            .into(holder.mBinding.img4);
                }
                if(postModel.getBeanImages().size()==4)
                {
                    holder.mBinding.ll1.setVisibility(View.VISIBLE);
                    holder.mBinding.ll2.setVisibility(View.VISIBLE);
                    holder.mBinding.txtCount.setVisibility(View.GONE);
                    Glide.with(context).load(postModel.getBeanImages().get(0).getImage_url())
                            .placeholder(R.drawable.ic_profile)
                            .into(holder.mBinding.img1);
                    Glide.with(context).load(postModel.getBeanImages().get(1).getImage_url())
                            .placeholder(R.drawable.ic_profile)
                            .into(holder.mBinding.img2);
                    Glide.with(context).load(postModel.getBeanImages().get(2).getImage_url())
                            .placeholder(R.drawable.ic_profile)
                            .into(holder.mBinding.img3);
                    Glide.with(context).load(postModel.getBeanImages().get(3).getImage_url())
                            .placeholder(R.drawable.ic_profile)
                            .into(holder.mBinding.img4);
                }
                if(postModel.getBeanImages().size()>4){
                    holder.mBinding.ll1.setVisibility(View.VISIBLE);
                    holder.mBinding.ll2.setVisibility(View.VISIBLE);
                    holder.mBinding.txtCount.setVisibility(View.VISIBLE);
                    holder.mBinding.txtCount.setText("+"+String.valueOf(postModel.getBeanImages().size()-4));
                    Glide.with(context).load(postModel.getBeanImages().get(0).getImage_url())
                            .placeholder(R.drawable.ic_profile)
                            .into(holder.mBinding.img1);
                    Glide.with(context).load(postModel.getBeanImages().get(1).getImage_url())
                            .placeholder(R.drawable.ic_profile)
                            .into(holder.mBinding.img2);
                    Glide.with(context).load(postModel.getBeanImages().get(2).getImage_url())
                            .placeholder(R.drawable.ic_profile)
                            .into(holder.mBinding.img3);
                    Glide.with(context).load(postModel.getBeanImages().get(3).getImage_url())
                            .placeholder(R.drawable.ic_profile)
                            .into(holder.mBinding.img4);


                }
                holder.mBinding.imgframe.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Intent intent = new Intent(context, ImagesActivity.class);
                        Bundle bundle = new Bundle();
                        bundle.putParcelableArrayList("mylist", postModel.getBeanImages());
                        intent.putExtras(bundle);
                        context.startActivity(intent);
                    }
                });
            }else{
                holder.mBinding.imgframe.setVisibility(View.GONE);
            }
        }else if(postModel.getMimetype().equalsIgnoreCase("pdf")){
            holder.mBinding.imgframe.setVisibility(View.GONE);
            holder.mBinding.VideoView.setVisibility(View.GONE);
            holder.mBinding.rlPdf.setVisibility(View.VISIBLE);
            holder.mBinding.txtPdfName.setText(postModel.getBeanImages().get(0).getImage_url().substring(postModel.getBeanImages().get(0).getImage_url().lastIndexOf("/") + 1));
        }else{
            holder.mBinding.imgframe.setVisibility(View.GONE);
            holder.mBinding.VideoView.setVisibility(View.GONE);
            holder.mBinding.rlPdf.setVisibility(View.GONE);
        }
        holder.mBinding.rlPdf.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent pdfOpenintent = new Intent(Intent.ACTION_VIEW);
                pdfOpenintent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                pdfOpenintent.setDataAndType(Uri.parse(postModel.getBeanImages().get(0).getImage_url()), "application/pdf");
                try {
                    context.startActivity(pdfOpenintent);
                }
                catch (ActivityNotFoundException e) {

                }
            }
        });
        holder.mBinding.llCommentcounts.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(context, PostDetailActivity.class);
                intent.putExtra("postId", postModel.getId()+"");
                context.startActivity(intent);
            }
        });
    }
    @Override
    public int getItemCount() {
        return list.size();
    }

    public static class MainitemHolder extends RecyclerView.ViewHolder{
        public RowPostBinding mBinding;
        public MainitemHolder(View itemView) {
            super(itemView);
            mBinding = DataBindingUtil.bind(itemView);
        }
    }
    public void setListener(SetOnClickListener listener){
        this.itemClickListener= listener;
    }
    public interface SetOnClickListener{
        public void onItemClick(PostModel PostModel, String status, int position, int rating, String messageRating);
    }
    public void filterList(ArrayList<PostModel> filterdNames) {
        this.list = filterdNames;
        notifyDataSetChanged();
    }

    public void removeAt(int position) {
        list.remove(position);
        notifyItemRemoved(position);
        notifyItemRangeChanged(position, list.size());
    }
    public void removeItem(int position) {
        list.remove(position);
        notifyItemRemoved(position);
    }
    public static Bitmap retriveVideoFrameFromVideo(String videoPath)throws Throwable
    {
        Bitmap bitmap = null;
        MediaMetadataRetriever mediaMetadataRetriever = null;
        try
        {
            mediaMetadataRetriever = new MediaMetadataRetriever();
            if (Build.VERSION.SDK_INT >= 14)
                mediaMetadataRetriever.setDataSource(videoPath, new HashMap<String, String>());
            else
                mediaMetadataRetriever.setDataSource(videoPath);
            bitmap = mediaMetadataRetriever.getFrameAtTime(1, MediaMetadataRetriever.OPTION_CLOSEST);
        }
        catch (Exception e)
        {
            e.printStackTrace();
            throw new Throwable("Exception in retriveVideoFrameFromVideo(String videoPath)"+ e.getMessage());
        }
        finally
        {
            if (mediaMetadataRetriever != null)
            {
                mediaMetadataRetriever.release();
            }
        }
        return bitmap;
    }

    public List<PostModel> getData() {
        return list;
    }

    private static Date currentDate() {
        Calendar calendar = Calendar.getInstance();
        return calendar.getTime();
    }

    public static String getTimeAgo(Date date,Context context) {
        long time = date.getTime();
        if (time < 1000000000000L) {
            time *= 1000;
        }

        long now = currentDate().getTime();
        if (time > now || time <= 0) {
            return "in the future";
        }

        final long diff = now - time;
        if (diff < MINUTE_MILLIS) {
            return context.getResources().getString(R.string.moments_ago);
        } else if (diff < 2 * MINUTE_MILLIS) {
            return context.getResources().getString(R.string.min_ago);
        } else if (diff < 60 * MINUTE_MILLIS) {
            return diff / MINUTE_MILLIS + context.getResources().getString(R.string.minutes_ago);
        } else if (diff < 2 * HOUR_MILLIS) {
            return context.getResources().getString(R.string.hour_ago);
        } else if (diff < 24 * HOUR_MILLIS) {
            return diff / HOUR_MILLIS + context.getResources().getString(R.string.hours_ago);
        } else if (diff < 48 * HOUR_MILLIS) {
            return context.getResources().getString(R.string.day_ago);
        } else {
            return diff / DAY_MILLIS + context.getResources().getString(R.string.days_ago);
        }
    }

}
