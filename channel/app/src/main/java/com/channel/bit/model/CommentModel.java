package com.channel.bit.model;

import android.os.Parcel;
import android.os.Parcelable;

import org.json.JSONArray;

import java.io.Serializable;
import java.util.ArrayList;

public class CommentModel implements Parcelable {


    protected CommentModel(Parcel in) {
        comment_like = in.readByte() != 0;
        comment_dislike = in.readByte() != 0;
        author_name = in.readString();
        partner_id = in.readString();
        id = in.readString();
        date = in.readString();
        comment = in.readString();
        author_image = in.readString();
        rating = in.readString();
        Commentpartner_id = in.readString();
        imgPdf = in.readString();
        mimetypeImgPdf = in.readString();
        like_counter = in.readString();
        dislike_counter = in.readString();
        replay_counter = in.readString();
    }

    public static final Creator<CommentModel> CREATOR = new Creator<CommentModel>() {
        @Override
        public CommentModel createFromParcel(Parcel in) {
            return new CommentModel(in);
        }

        @Override
        public CommentModel[] newArray(int size) {
            return new CommentModel[size];
        }
    };

    public boolean isComment_like() {
        return comment_like;
    }

    public boolean isComment_dislike() {
        return comment_dislike;
    }

    public void setComment_like(boolean comment_like) {
        this.comment_like = comment_like;
    }

    public void setComment_dislike(boolean comment_dislike) {
        this.comment_dislike = comment_dislike;
    }

    boolean comment_like;
    boolean comment_dislike;

    public ArrayList<ChildCommentModel> getChildCommentModelArrayList() {
        return childCommentModelArrayList;
    }


    public CommentModel(String lastCommentUsername, String lastCommentUserImage, String lastCommentMessage, boolean comment_like,
                        boolean comment_dislike) {
        this.author_name = lastCommentUsername;
        this.author_image = lastCommentUserImage;
        this.comment = lastCommentMessage;
        this.comment_like = comment_like;
        this.comment_dislike = comment_dislike;
    }

    public String getAuthor_name() {
        return author_name;
    }

    public String getId() {
        return id;
    }

    public String getDate() {
        return date;
    }

    public String getComment() {
        return comment;
    }

    public String getAuthor_image() {
        return author_image;
    }

    String author_name;

    public String getPartner_id() {
        return partner_id;
    }

    String partner_id;
    String id;
    String date;
    String comment;
    String author_image;

    public String getRating() {
        return rating;
    }

    String rating;

    public String getCommentpartner_id() {
        return Commentpartner_id;
    }

    String Commentpartner_id;
    String imgPdf;

    public String getImgPdf() {
        return imgPdf;
    }

    public String getMimetypeImgPdf() {
        return mimetypeImgPdf;
    }

    String mimetypeImgPdf;
    ArrayList<ChildCommentModel> childCommentModelArrayList;
    String replay_counter;

    public String getReplay_counter() {
        return replay_counter;
    }

    public String getLike_counter() {
        return like_counter;
    }

    public String getDislike_counter() {
        return dislike_counter;
    }

    String like_counter;
    String dislike_counter;
    public CommentModel(String rating,String id, String date, String comment, String author_name,String author_image,String Commentpartner_id
            , boolean comment_like,boolean comment_dislike, String imgPdf, String mimetypeImgPdf,
                        String like_counter, String dislike_counter,String replay_counter,
                        ArrayList<ChildCommentModel> childCommentModelArrayList) {
        this.id = id;
        this.date = date;
        this.comment = comment;
        this.author_name = author_name;
        this.author_image = author_image;
        this.rating = rating;
        this.Commentpartner_id = Commentpartner_id;
        this.comment_like = comment_like;
        this.comment_dislike = comment_dislike;
        this.imgPdf = imgPdf;
        this.mimetypeImgPdf = mimetypeImgPdf;
        this.like_counter = like_counter;
        this.dislike_counter = dislike_counter;
        this.replay_counter = replay_counter;
        this.childCommentModelArrayList = childCommentModelArrayList;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeByte((byte) (comment_like ? 1 : 0));
        parcel.writeByte((byte) (comment_dislike ? 1 : 0));
        parcel.writeString(author_name);
        parcel.writeString(partner_id);
        parcel.writeString(id);
        parcel.writeString(date);
        parcel.writeString(comment);
        parcel.writeString(author_image);
        parcel.writeString(rating);
        parcel.writeString(Commentpartner_id);
        parcel.writeString(imgPdf);
        parcel.writeString(mimetypeImgPdf);
        parcel.writeString(like_counter);
        parcel.writeString(dislike_counter);
        parcel.writeString(replay_counter);
    }
}
