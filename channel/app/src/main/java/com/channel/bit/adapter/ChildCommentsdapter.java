package com.channel.bit.adapter;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.channel.bit.CampaignActivity;
import com.channel.bit.OtherUserProfileActivity;
import com.channel.bit.ProfileActivity;
import com.channel.bit.R;
import com.channel.bit.SingleImageActivity;
import com.channel.bit.common.Utils;
import com.channel.bit.databinding.RowChildCommentBinding;
import com.channel.bit.databinding.RowCommentBinding;
import com.channel.bit.model.ChildCommentModel;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

import androidx.annotation.NonNull;
import androidx.appcompat.widget.PopupMenu;
import androidx.databinding.DataBindingUtil;
import androidx.recyclerview.widget.RecyclerView;

import static com.channel.bit.adapter.PostAdapter.getTimeAgo;

public class ChildCommentsdapter extends RecyclerView.Adapter<ChildCommentsdapter.MainitemHolder> {
    List<ChildCommentModel> list;
    private SetOnClickListener itemClickListener;
    Activity context;
    public ChildCommentsdapter(Activity context, List<ChildCommentModel> list) {
        this.context = context;
        this.list = list;
    }
    @NonNull
    @Override
    public MainitemHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.row_child_comment,parent,false);
        return new MainitemHolder(view);
    }
    @Override
    public void onBindViewHolder(@NonNull final MainitemHolder holder, final int position) {
        final ChildCommentModel childCommentModel = list.get(position);
        holder.mBinding.txtUserFirstName.setText(childCommentModel.getChild_author_name());
        holder.mBinding.txtMessage.setText(childCommentModel.getChild_comment());
        Glide.with(context).load(childCommentModel.getChild_author_image())
                .diskCacheStrategy(DiskCacheStrategy.NONE)
                .skipMemoryCache(true)
                .placeholder(R.drawable.ic_profile)
                .into(holder.mBinding.imgProfile);
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH);
        dateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
        Date date2 = null;
        try {
            date2 = dateFormat.parse(childCommentModel.getChild_date());
        } catch (ParseException e) {
            e.printStackTrace();
        }
        dateFormat.setTimeZone(TimeZone.getDefault());
        String formattedDate = dateFormat.format(date2);
        try {
            Date date = dateFormat.parse(formattedDate);
            String MyFinalValue = getTimeAgo(date,context);
            holder.mBinding.txtReplyTime.setText(MyFinalValue);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        /*option menu*/
        if(Utils.getSavedData(context,"partner_id").equalsIgnoreCase(childCommentModel.getChild_partner_id())){
            holder.mBinding.textReplyViewOptions.setVisibility(View.VISIBLE);
        }else{
            holder.mBinding.textReplyViewOptions.setVisibility(View.GONE);
        }
        holder.mBinding.textReplyViewOptions.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                PopupMenu popup = new PopupMenu(context, holder.mBinding.textReplyViewOptions);
                popup.inflate(R.menu.options_menu);
                popup.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener() {
                    @Override
                    public boolean onMenuItemClick(MenuItem item) {
                        switch (item.getItemId()) {
                            case R.id.delete_comment:
                                itemClickListener.onItemClick(childCommentModel,"deleteReply",position);
                                break;
                        }
                        return false;
                    }
                });
                popup.show();
            }
        });

        /*--------*/
        /*uploded image/PDF*/


        if(childCommentModel.getMimetypeImgPdf().equalsIgnoreCase("")){
            holder.mBinding.rlUplodedData.setVisibility(View.GONE);
        }else{
            holder.mBinding.rlUplodedData.setVisibility(View.VISIBLE);
            if(childCommentModel.getMimetypeImgPdf().equalsIgnoreCase("image")){
                holder.mBinding.imgSelected.setVisibility(View.VISIBLE);
                holder.mBinding.selectedPdf.setVisibility(View.GONE);
                Glide.with(context).load(childCommentModel.getImgPdf())
                        .placeholder(R.drawable.ic_profile)
                        .into(holder.mBinding.imgSelected);

            }else if(childCommentModel.getMimetypeImgPdf().equalsIgnoreCase("pdf")){
                holder.mBinding.imgSelected.setVisibility(View.GONE);
                holder.mBinding.selectedPdf.setVisibility(View.VISIBLE);
                holder.mBinding.pdfname.setText(childCommentModel.getImgPdf().substring(childCommentModel.getImgPdf().lastIndexOf("/") + 1));
            }
        }
        holder.mBinding.selectedPdf.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent pdfOpenintent = new Intent(Intent.ACTION_VIEW);
                pdfOpenintent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                pdfOpenintent.setDataAndType(Uri.parse(childCommentModel.getImgPdf()), "application/pdf");
                try {
                    context.startActivity(pdfOpenintent);
                }
                catch (ActivityNotFoundException e) {

                }
            }
        });
        holder.mBinding.imgSelected.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(context, SingleImageActivity.class);
                intent.putExtra("imgUrl",childCommentModel.getImgPdf());
                context.startActivity(intent);
            }
        });
        holder.mBinding.imgProfile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(Utils.getSavedData(context,"partner_id").equalsIgnoreCase(childCommentModel.getChild_partner_id())){
                    Intent intent = new Intent(context, ProfileActivity.class);
                    intent.putExtra("partner_id",childCommentModel.getChild_partner_id());
                    context.startActivity(intent);
                }else{
                    Intent intent = new Intent(context, OtherUserProfileActivity.class);
                    intent.putExtra("partner_id",childCommentModel.getChild_partner_id());
                    context.startActivity(intent);
                }
            }
        });
        holder.mBinding.txtUserFirstName.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(Utils.getSavedData(context,"partner_id").equalsIgnoreCase(childCommentModel.getChild_partner_id())){
                    Intent intent = new Intent(context, ProfileActivity.class);
                    intent.putExtra("partner_id",childCommentModel.getChild_partner_id());
                    context.startActivity(intent);
                }else{
                    Intent intent = new Intent(context, OtherUserProfileActivity.class);
                    intent.putExtra("partner_id",childCommentModel.getChild_partner_id());
                    context.startActivity(intent);
                }
            }
        });
    }

    @Override
    public int getItemCount() {
        return list.size();
    }
    public static class MainitemHolder extends RecyclerView.ViewHolder{
        public RowChildCommentBinding mBinding;
        public MainitemHolder(View itemView) {
            super(itemView);
            mBinding = DataBindingUtil.bind(itemView);
        }
    }
    public void setListener(SetOnClickListener listener){
        this.itemClickListener= listener;
    }
    public interface SetOnClickListener{
        public void onItemClick(ChildCommentModel ChildCommentModel, String status, int position);
    }

    public void removeAt(int position) {
        list.remove(position);
        notifyItemRemoved(position);
        notifyItemRangeChanged(position, list.size());
    }

}
