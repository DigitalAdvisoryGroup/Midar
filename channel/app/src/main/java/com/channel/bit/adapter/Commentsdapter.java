package com.channel.bit.adapter;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.LinearLayout;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.channel.bit.CommentActivity;
import com.channel.bit.OtherUserProfileActivity;
import com.channel.bit.PostDetailActivity;
import com.channel.bit.ProfileActivity;
import com.channel.bit.R;
import com.channel.bit.SingleImageActivity;
import com.channel.bit.common.Utils;
import com.channel.bit.databinding.RowCommentBinding;
import com.channel.bit.databinding.RowPostBinding;
import com.channel.bit.model.ChildCommentModel;
import com.channel.bit.model.CommentModel;
import com.channel.bit.model.PostModel;

import org.apache.xmlrpc.XmlRpcException;
import org.apache.xmlrpc.client.XmlRpcClient;
import org.apache.xmlrpc.client.XmlRpcClientConfigImpl;
import org.json.JSONObject;

import java.net.MalformedURLException;
import java.net.URL;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.TimeZone;

import androidx.annotation.NonNull;
import androidx.appcompat.widget.PopupMenu;
import androidx.databinding.DataBindingUtil;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;

import static com.channel.bit.adapter.PostAdapter.getTimeAgo;
import static java.util.Arrays.asList;

public class Commentsdapter extends RecyclerView.Adapter<Commentsdapter.MainitemHolder> {
    List<CommentModel> list;
    private SetOnClickListener itemClickListener;
    Activity context;
    String postId;
    ChildCommentsdapter adapter;
    int replyId;
    int replyPosition;
    public Commentsdapter(Activity context, List<CommentModel> list,String postId) {
        this.context = context;
        this.list = list;
        this.postId = postId;
    }
    @NonNull
    @Override
    public MainitemHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View view = LayoutInflater.from(parent.getContext()).inflate(R.layout.row_comment,parent,false);
        return new MainitemHolder(view);
    }
    @Override
    public void onBindViewHolder(@NonNull final MainitemHolder holder, final int position) {
        final CommentModel commentModel = list.get(position);

        if(commentModel.getChildCommentModelArrayList().size()>0){
            replyId = Integer.parseInt(commentModel.getChildCommentModelArrayList().get(commentModel.getChildCommentModelArrayList().size()-1).getChild_id());
        }

        holder.mBinding.txtUserFirstName.setText(commentModel.getAuthor_name());
        holder.mBinding.txtMessage.setText(commentModel.getComment());
        Glide.with(context).load(commentModel.getAuthor_image())
                .diskCacheStrategy(DiskCacheStrategy.NONE)
                .skipMemoryCache(true)
                .placeholder(R.drawable.ic_profile)
                .into(holder.mBinding.imgProfile);
        holder.mBinding.imgProfile.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(Utils.getSavedData(context,"partner_id").equalsIgnoreCase(commentModel.getCommentpartner_id())){
                    Intent intent = new Intent(context, ProfileActivity.class);
                    intent.putExtra("partner_id",commentModel.getCommentpartner_id());
                    context.startActivity(intent);
                }else{
                    Intent intent = new Intent(context, OtherUserProfileActivity.class);
                    intent.putExtra("partner_id",commentModel.getCommentpartner_id());
                    context.startActivity(intent);
                }
            }
        });
        holder.mBinding.txtUserFirstName.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(Utils.getSavedData(context,"partner_id").equalsIgnoreCase(commentModel.getCommentpartner_id())){
                    Intent intent = new Intent(context, ProfileActivity.class);
                    intent.putExtra("partner_id",commentModel.getCommentpartner_id());
                    context.startActivity(intent);
                }else{
                    Intent intent = new Intent(context, OtherUserProfileActivity.class);
                    intent.putExtra("partner_id",commentModel.getCommentpartner_id());
                    context.startActivity(intent);
                }
            }
        });
        /*option menu*/
        if(Utils.getSavedData(context,"partner_id").equalsIgnoreCase(commentModel.getCommentpartner_id())){
            holder.mBinding.textViewOptions.setVisibility(View.VISIBLE);
        }else{
            holder.mBinding.textViewOptions.setVisibility(View.GONE);
        }

        /*count*/
        holder.mBinding.txtLikeCount.setText(commentModel.getLike_counter());
        holder.mBinding.txtDisLkeCount.setText(commentModel.getDislike_counter());
        holder.mBinding.txtReplyCount.setText(commentModel.getReplay_counter());
        /*-----*/
        holder.mBinding.textViewOptions.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                PopupMenu popup = new PopupMenu(context, holder.mBinding.textViewOptions);
                popup.inflate(R.menu.options_menu);
                popup.setOnMenuItemClickListener(new PopupMenu.OnMenuItemClickListener() {
                    @Override
                    public boolean onMenuItemClick(MenuItem item) {
                        switch (item.getItemId()) {
                            case R.id.delete_comment:
                                itemClickListener.onItemClick(commentModel,"delete",position);
                                break;
                        }
                        return false;
                    }
                });
                popup.show();
            }
        });
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
                               // new DeleteReplySingle().execute();
                                break;
                        }
                        return false;
                    }
                });
                popup.show();
            }
        });
        /*-----*/
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss",Locale.ENGLISH);
        dateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
        Date date2 = null;
        try {
            date2 = dateFormat.parse(commentModel.getDate());
        } catch (ParseException e) {
            e.printStackTrace();
        }
        dateFormat.setTimeZone(TimeZone.getDefault());
        String formattedDate = dateFormat.format(date2);
        try {
            Date date = dateFormat.parse(formattedDate);
            String MyFinalValue = getTimeAgo(date,context);
            holder.mBinding.txtTime.setText(MyFinalValue);

        } catch (ParseException e) {
            e.printStackTrace();
        }

        /*like-unlike*/
        if(list.get(position).isComment_like()==true){
            holder.mBinding.imgLike.setImageResource(R.drawable.ic_baseline_favorite_24);
        }else {
            holder.mBinding.imgLike.setImageResource(R.drawable.ic_like);
        }
        if(list.get(position).isComment_dislike()==true){
            holder.mBinding.imgUnLike.setImageResource(R.drawable.ic_dislikefill_foreground);
        }else {
            holder.mBinding.imgUnLike.setImageResource(R.drawable.ic_dislike_foreground);
        }

        holder.mBinding.imgLike.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (list.get(position).isComment_like()==false){
                    list.get(position).setComment_like(true);
                    holder.mBinding.imgLike.setImageResource(R.drawable.ic_baseline_favorite_24);
                    list.get(position).setComment_dislike(false);
                    holder.mBinding.imgUnLike.setImageResource(R.drawable.ic_dislike_foreground);
                }else{
                    list.get(position).setComment_like(false);
                    holder.mBinding.imgLike.setImageResource(R.drawable.ic_like);
                    list.get(position).setComment_dislike(true);
                    holder.mBinding.imgUnLike.setImageResource(R.drawable.ic_dislikefill_foreground);
                }
                itemClickListener.onItemClick(commentModel,"like",position);
            }
        });
        holder.mBinding.imgUnLike.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (list.get(position).isComment_dislike()==false){
                    list.get(position).setComment_dislike(true);
                    holder.mBinding.imgUnLike.setImageResource(R.drawable.ic_dislikefill_foreground);
                    list.get(position).setComment_like(false);
                    holder.mBinding.imgLike.setImageResource(R.drawable.ic_like);
                }else{
                    list.get(position).setComment_dislike(false);
                    holder.mBinding.imgUnLike.setImageResource(R.drawable.ic_dislike_foreground);
                    list.get(position).setComment_like(true);
                    holder.mBinding.imgLike.setImageResource(R.drawable.ic_baseline_favorite_24);
                }
                itemClickListener.onItemClick(commentModel,"dislike",position);
            }
        });
        holder.mBinding.imgReply.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(context, CommentActivity.class);
                intent.putExtra("postId",postId);
                intent.putExtra("commentId",commentModel.getId());
                Bundle bundle = new Bundle();
                bundle.putParcelableArrayList("reply_list", commentModel.getChildCommentModelArrayList());
                intent.putExtras(bundle);
                context.startActivity(intent);
            }
        });
        /*child comments*/
        if(commentModel.getChildCommentModelArrayList().size()>1){
            holder.mBinding.imgExpandCollapse.setVisibility(View.VISIBLE);
        }else{
            holder.mBinding.imgExpandCollapse.setVisibility(View.GONE);
        }
        holder.mBinding.imgChildSelected.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(context, SingleImageActivity.class);
                intent.putExtra("imgUrl",commentModel.getChildCommentModelArrayList()
                        .get(0).getImgPdf());
                context.startActivity(intent);
            }
        });
        holder.mBinding.selectedChildPdf.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent pdfOpenintent = new Intent(Intent.ACTION_VIEW);
                pdfOpenintent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                pdfOpenintent.setDataAndType(Uri.parse(commentModel.getChildCommentModelArrayList()
                        .get(0).getImgPdf()), "application/pdf");
                try {
                    context.startActivity(pdfOpenintent);
                }
                catch (ActivityNotFoundException e) {

                }
            }
        });
        /*single child item*/
        if(commentModel.getChildCommentModelArrayList().size()>0){
            holder.mBinding.imgReplyProfile.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if(Utils.getSavedData(context,"partner_id").equalsIgnoreCase(commentModel.getChildCommentModelArrayList().get(commentModel.getChildCommentModelArrayList().size()-1).getChild_partner_id())){
                        Intent intent = new Intent(context, ProfileActivity.class);
                        intent.putExtra("partner_id",commentModel.getChildCommentModelArrayList().get(commentModel.getChildCommentModelArrayList().size()-1).getChild_partner_id());
                        context.startActivity(intent);
                    }else{
                        Intent intent = new Intent(context, OtherUserProfileActivity.class);
                        intent.putExtra("partner_id",commentModel.getChildCommentModelArrayList().get(commentModel.getChildCommentModelArrayList().size()-1).getChild_partner_id());
                        context.startActivity(intent);
                    }
                }
            });
            holder.mBinding.txtreplyUserFirstName.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if(Utils.getSavedData(context,"partner_id").equalsIgnoreCase(commentModel.getChildCommentModelArrayList().get(commentModel.getChildCommentModelArrayList().size()-1).getChild_partner_id())){
                        Intent intent = new Intent(context, ProfileActivity.class);
                        intent.putExtra("partner_id",commentModel.getChildCommentModelArrayList().get(commentModel.getChildCommentModelArrayList().size()-1).getChild_partner_id());
                        context.startActivity(intent);
                    }else{
                        Intent intent = new Intent(context, OtherUserProfileActivity.class);
                        intent.putExtra("partner_id",commentModel.getChildCommentModelArrayList().get(commentModel.getChildCommentModelArrayList().size()-1).getChild_partner_id());
                        context.startActivity(intent);
                    }
                }
            });
            if(Utils.getSavedData(context,"partner_id").equalsIgnoreCase(commentModel.getChildCommentModelArrayList().get(0).getChild_partner_id())){
                holder.mBinding.textReplyViewOptions.setVisibility(View.VISIBLE);
            }else{
                holder.mBinding.textReplyViewOptions.setVisibility(View.GONE);
            }
            dateFormat.setTimeZone(TimeZone.getTimeZone("UTC"));
            Date date3 = null;
            try {
                date3 = dateFormat.parse(commentModel.getChildCommentModelArrayList().get(0).getChild_date());
            } catch (ParseException e) {
                e.printStackTrace();
            }
            dateFormat.setTimeZone(TimeZone.getDefault());
            String formattedDate2 = dateFormat.format(date3);
            try {
                Date date = dateFormat.parse(formattedDate2);
                String MyFinalValue = getTimeAgo(date,context);
                holder.mBinding.txtReplyTime.setText(MyFinalValue);

            } catch (ParseException e) {
                e.printStackTrace();
            }
            holder.mBinding.imgReplyProfile.setVisibility(View.VISIBLE);
            holder.mBinding.rlReply.setVisibility(View.VISIBLE);
            holder.mBinding.rlChildUplodedData.setVisibility(View.VISIBLE);
            if(commentModel.getChildCommentModelArrayList().get(0).getMimetypeImgPdf().equalsIgnoreCase("pdf")){
                holder.mBinding.selectedChildPdf.setVisibility(View.VISIBLE);
                holder.mBinding.imgChildSelected.setVisibility(View.GONE);
                holder.mBinding.pdfChildname.setText(commentModel.getChildCommentModelArrayList().get(0).getImgPdf().
                        substring((commentModel.getChildCommentModelArrayList().get(0).getImgPdf().lastIndexOf("/") + 1)));

            }else if(commentModel.getChildCommentModelArrayList().get(0).getMimetypeImgPdf().equalsIgnoreCase("image")){
                holder.mBinding.selectedChildPdf.setVisibility(View.GONE);
                holder.mBinding.imgChildSelected.setVisibility(View.VISIBLE);
                Glide.with(context).load(commentModel.getChildCommentModelArrayList().get(0).getImgPdf())
                        .placeholder(R.drawable.ic_profile)
                        .into(holder.mBinding.imgSelected);
            }
            Collections.reverse(commentModel.getChildCommentModelArrayList());
            Glide.with(context).load(commentModel.getChildCommentModelArrayList()
                    .get(0).getImgPdf())
                    .placeholder(R.drawable.ic_profile)
                    .into(holder.mBinding.imgChildSelected);
            Glide.with(context).load(commentModel.getChildCommentModelArrayList()
                    .get(commentModel.getChildCommentModelArrayList().size()-1).getChild_author_image())
                    .diskCacheStrategy(DiskCacheStrategy.NONE)
                    .skipMemoryCache(true)
                    .placeholder(R.drawable.ic_profile)
                    .into(holder.mBinding.imgReplyProfile);
            holder.mBinding.txtreplyMessage.setText(commentModel.getChildCommentModelArrayList()
                    .get(commentModel.getChildCommentModelArrayList().size()-1).getChild_comment());
            holder.mBinding.txtreplyUserFirstName.setText(commentModel.getChildCommentModelArrayList()
                    .get(commentModel.getChildCommentModelArrayList().size()-1).getChild_author_name());
        }else{
            holder.mBinding.imgReplyProfile.setVisibility(View.GONE);
            holder.mBinding.rlReply.setVisibility(View.GONE);
        }
        holder.mBinding.imgExpandCollapse.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if(holder.mBinding.rvReply.getVisibility()==View.VISIBLE){
                    holder.mBinding.rvReply.setVisibility(View.GONE);
                    holder.mBinding.imgReplyProfile.setVisibility(View.VISIBLE);
                    holder.mBinding.rlReply.setVisibility(View.VISIBLE);
                }else if(holder.mBinding.rvReply.getVisibility()==View.GONE){
                    holder.mBinding.rvReply.setVisibility(View.VISIBLE);
                    holder.mBinding.imgReplyProfile.setVisibility(View.GONE);
                    holder.mBinding.rlReply.setVisibility(View.GONE);
                }
            }
        });
        /*--------------------------------------------*/
        LinearLayoutManager llm = new LinearLayoutManager(context);
        llm.setOrientation(LinearLayoutManager.VERTICAL);
        holder.mBinding.rvReply.setLayoutManager(llm);
        adapter = new ChildCommentsdapter(context,commentModel.getChildCommentModelArrayList());
        holder.mBinding.rvReply.setAdapter( adapter );
        adapter.setListener(new ChildCommentsdapter.SetOnClickListener() {
            @Override
            public void onItemClick(ChildCommentModel ChildCommentModel, String status, int position) {
                replyPosition = position;
                replyId = Integer.parseInt(ChildCommentModel.getChild_id());
                if(status.equalsIgnoreCase("deleteReply")){
                    new DeleteReply().execute();
                }
            }
        });

        /*uploded image/PDF*/
        if(commentModel.getMimetypeImgPdf().equalsIgnoreCase("")){
            holder.mBinding.rlUplodedData.setVisibility(View.GONE);
        }else{
            holder.mBinding.rlUplodedData.setVisibility(View.VISIBLE);
            if(commentModel.getMimetypeImgPdf().equalsIgnoreCase("image")){
                holder.mBinding.imgSelected.setVisibility(View.VISIBLE);
                holder.mBinding.selectedPdf.setVisibility(View.GONE);
                Glide.with(context).load(commentModel.getImgPdf())
                        .placeholder(R.drawable.ic_profile)
                        .into(holder.mBinding.imgSelected);

            }else if(commentModel.getMimetypeImgPdf().equalsIgnoreCase("pdf")){
                holder.mBinding.imgSelected.setVisibility(View.GONE);
                holder.mBinding.selectedPdf.setVisibility(View.VISIBLE);
                holder.mBinding.pdfname.setText(commentModel.getImgPdf().substring(commentModel.getImgPdf().lastIndexOf("/") + 1));
            }
        }
        holder.mBinding.selectedPdf.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent pdfOpenintent = new Intent(Intent.ACTION_VIEW);
                pdfOpenintent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
                pdfOpenintent.setDataAndType(Uri.parse(commentModel.getImgPdf()), "application/pdf");
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
                intent.putExtra("imgUrl",commentModel.getImgPdf());
                context.startActivity(intent);
            }
        });
    }
    @Override
    public int getItemCount() {
        Log.e("effrffr"," "+list.size());
        return list.size();
    }
    public static class MainitemHolder extends RecyclerView.ViewHolder{
        public RowCommentBinding mBinding;
        public MainitemHolder(View itemView) {
            super(itemView);
            mBinding = DataBindingUtil.bind(itemView);
        }
    }
    public void setListener(SetOnClickListener listener){
        this.itemClickListener= listener;
    }
    public interface SetOnClickListener{
        public void onItemClick(CommentModel CommentModel, String status, int position);
    }
    public void filterList(ArrayList<CommentModel> filterdNames) {
        this.list = filterdNames;
        notifyDataSetChanged();
    }

    public void removeAt(int position) {
        list.remove(position);
        notifyItemRemoved(position);
        notifyItemRangeChanged(position, list.size());
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
                        Utils.printMessage(context);
                        e.printStackTrace();
                    }
                }});
            }};
            try {
                int uid = Integer.parseInt(Utils.getSavedData(context,"uid"));
                Object delete_comment = models.execute("execute_kw", asList(
                        Utils.db_name,uid, Utils.password,
                        "social.bit.comments", "unlink",asList(asList(replyId)))
                );
                Log.e("delete_reply"," "+delete_comment);
                delete = (Boolean)delete_comment;
            } catch (XmlRpcException e) {
                Utils.printMessage(context);
                e.printStackTrace();
            }
            return null;
        }
        @Override
        protected void onPostExecute(Integer result) {
            super.onPostExecute(result);
            if(delete == true){
                adapter.removeAt(replyPosition);
            }
        }
    }
    private class DeleteReplySingle extends AsyncTask<Void, Void, Integer> {
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
                        Utils.printMessage(context);
                        e.printStackTrace();
                    }
                }});
            }};
            try {
                int uid = Integer.parseInt(Utils.getSavedData(context,"uid"));
                Object delete_comment = models.execute("execute_kw", asList(
                        Utils.db_name,uid, Utils.password,
                        "social.bit.comments", "unlink",asList(asList(replyId)))
                );
                Log.e("delete_reply"," "+delete_comment);
                delete = (Boolean)delete_comment;
            } catch (XmlRpcException e) {
                Utils.printMessage(context);
                e.printStackTrace();
            }
            return null;
        }
        @Override
        protected void onPostExecute(Integer result) {
            super.onPostExecute(result);
            if(delete == true){
                adapter.removeAt(replyPosition);
            }
        }
    }

}
