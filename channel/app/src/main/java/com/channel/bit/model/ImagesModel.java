package com.channel.bit.model;

import android.os.Parcel;
import android.os.Parcelable;

public class ImagesModel implements Parcelable {

    public ImagesModel(Parcel in) {
        image_mimetype = in.readString();
        image_url = in.readString();
        height = in.readString();
        width = in.readString();
    }

    public static final Creator<ImagesModel> CREATOR = new Creator<ImagesModel>() {
        @Override
        public ImagesModel createFromParcel(Parcel in) {
            return new ImagesModel(in);
        }

        @Override
        public ImagesModel[] newArray(int size) {
            return new ImagesModel[size];
        }
    };

    public ImagesModel() {
    }

    public String getImage_mimetype() {
        return image_mimetype;
    }

    public void setImage_mimetype(String image_mimetype) {
        this.image_mimetype = image_mimetype;
    }

    public void setImage_url(String image_url) {
        this.image_url = image_url;
    }

    public String getImage_url() {
        return image_url;
    }

    String image_mimetype;
    String image_url;

    public String getHeight() {
        return height;
    }

    public String getWidth() {
        return width;
    }

    String height;

    public void setHeight(String height) {
        this.height = height;
    }

    public void setWidth(String width) {
        this.width = width;
    }

    String width;

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(image_mimetype);
        dest.writeString(image_url);
        dest.writeString(height);
        dest.writeString(width);
    }
}
