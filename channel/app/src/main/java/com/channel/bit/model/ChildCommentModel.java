package com.channel.bit.model;

import android.os.Parcel;
import android.os.Parcelable;

public class ChildCommentModel implements Parcelable {

    String child_author_image;
    String child_author_name;

    public String getImgPdf() {
        return imgPdf;
    }

    public String getMimetypeImgPdf() {
        return mimetypeImgPdf;
    }

    String imgPdf;
    String mimetypeImgPdf;

    public String getChild_partner_id() {
        return child_partner_id;
    }

    String child_partner_id;

    public String getChild_id() {
        return child_id;
    }

    String child_id;

    public ChildCommentModel(String child_id,String child_author_image, String child_comment, String child_author_name, String child_date,String imgPdf,String mimetypeImgPdf,String child_partner_id) {
        this.child_id = child_id;
        this.child_author_image = child_author_image;
        this.child_comment = child_comment;
        this.child_author_name = child_author_name;
        this.child_date = child_date;
        this.imgPdf = imgPdf;
        this.mimetypeImgPdf = mimetypeImgPdf;
        this.child_partner_id = child_partner_id;
    }

    protected ChildCommentModel(Parcel in) {
        child_author_image = in.readString();
        child_author_name = in.readString();
        child_date = in.readString();
        child_comment = in.readString();
        imgPdf = in.readString();
        mimetypeImgPdf = in.readString();
        child_partner_id = in.readString();
        child_id = in.readString();
    }

    public static final Creator<ChildCommentModel> CREATOR = new Creator<ChildCommentModel>() {
        @Override
        public ChildCommentModel createFromParcel(Parcel in) {
            return new ChildCommentModel(in);
        }

        @Override
        public ChildCommentModel[] newArray(int size) {
            return new ChildCommentModel[size];
        }
    };

    public String getChild_author_image() {
        return child_author_image;
    }

    public String getChild_author_name() {
        return child_author_name;
    }

    public String getChild_date() {
        return child_date;
    }

    public String getChild_comment() {
        return child_comment;
    }

    String child_date;
    String child_comment;

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel parcel, int i) {
        parcel.writeString(child_author_image);
        parcel.writeString(child_author_name);
        parcel.writeString(child_date);
        parcel.writeString(child_comment);
        parcel.writeString(imgPdf);
        parcel.writeString(mimetypeImgPdf);
        parcel.writeString(child_partner_id);
        parcel.writeString(child_id);
    }
}
