package com.channel.bit.model;

import android.os.Parcel;
import android.os.Parcelable;
import org.json.JSONArray;
import java.util.ArrayList;

public class PostModel implements Parcelable {
    String name;
    String date;
    String message;

    public boolean isDislike() {
        return dislike;
    }

    public void setDislike(boolean dislike) {
        this.dislike = dislike;
    }

    boolean dislike;

    public String getCommentsNumber() {
        return commentsNumber;
    }

    String commentsNumber;

    public String getMimetype() {
        return mimetype;
    }

    public String getImagePost() {
        return imagePost;
    }

    String mimetype;
    String imagePost;
    public String getFinalName() {
        return finalName;
    }

    public String getFinalComment() {
        return finalComment;
    }

    public String getFinalProfileImage() {
        return finalProfileImage;
    }

    String finalName;
    String finalComment;
    String campaign_owner ;

    public String getCampaign_owner() {
        return campaign_owner;
    }

    public String getCampaign_name() {
        return campaign_name;
    }

    String campaign_name;
    String finalProfileImage;
    JSONArray jsonArray;

    public ArrayList<ImagesModel> getBeanImages() {
        return beanImages;
    }

    public void setBeanImages(ArrayList<ImagesModel> beanImages) {
        this.beanImages = beanImages;
    }

    ArrayList<ImagesModel> beanImages;
    String post_owner;

    public String getRating() {
        return rating;
    }

    String rating;
    String total_like_count;
    String total_dislike_count;

    public String getTotal_like_count() {
        return total_like_count;
    }

    public String getTotal_dislike_count() {
        return total_dislike_count;
    }

    public String getTotal_share_count() {
        return total_share_count;
    }

    String total_share_count;

    public String getPost_owner() {
        return post_owner;
    }

    public PostModel(String campaign_owner, String campaign_name, String name, String date, boolean like,boolean dislike, String message,
                     int id, String image, String finalName, String finalComment,
                     String finalProfileImage, String mimetype, String imagePost, String post_owner,
                     String rating, JSONArray jsonArray, ArrayList<ImagesModel> beanImages,String commentsNumber,String total_like_count,
                     String total_dislike_count,String total_share_count) {
        this.campaign_owner = campaign_owner;
        this.campaign_name = campaign_name;
        this.name = name;
        this.date = date;
        this.like = like;
        this.dislike = dislike;
        this.message = message;
        this.id = id;
        this.image = image;
        this.finalName = finalName;
        this.finalComment = finalComment;
        this.finalProfileImage = finalProfileImage;
        this.mimetype = mimetype;
        this.imagePost = imagePost;
        this.jsonArray = jsonArray;
        this.beanImages = beanImages;
        this.post_owner = post_owner;
        this.rating = rating;
        this.commentsNumber = commentsNumber;
        this.total_like_count = total_like_count;
        this.total_dislike_count = total_dislike_count;
        this.total_share_count = total_share_count;
    }

    public static final Creator<PostModel> CREATOR = new Creator<PostModel>() {
        @Override
        public PostModel createFromParcel(Parcel in) {
            return new PostModel(in);
        }

        @Override
        public PostModel[] newArray(int size) {
            return new PostModel[size];
        }
    };

    public JSONArray getJsonArray() {
        return jsonArray;
    }
    public String getName() {
        return name;
    }

    public String getDate() {
        return date;
    }

    public String getMessage() {
        return message;
    }

    public String getImage() {
        return image;
    }

    public void setLike(boolean like) {
        this.like = like;
    }

    public boolean isLike() {
        return like;
    }

    public int getId() {
        return id;
    }

    String image;
    boolean like;
    int id;

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(name);
        dest.writeString(campaign_name);
        dest.writeString(campaign_owner);
        dest.writeString(date);
        dest.writeString(message);
        dest.writeString(image);
        dest.writeByte((byte) (like ? 1 : 0));
        dest.writeByte((byte) (dislike ? 1 : 0));
        dest.writeInt(id);
        dest.writeString(post_owner);
        dest.writeString(rating);
        dest.writeString(commentsNumber);
        dest.writeString(total_like_count);
        dest.writeString(total_dislike_count);
        dest.writeString(total_share_count);
//        dest.writeValue(beanImages);
    }
    protected PostModel(Parcel in) {
        name = in.readString();
        campaign_name = in.readString();
        campaign_owner = in.readString();
        date = in.readString();
        message = in.readString();
        image = in.readString();
        like = in.readByte() != 0;
        dislike = in.readByte() != 0;
        id = in.readInt();
        post_owner = in.readString();
        rating = in.readString();
        commentsNumber = in.readString();
        total_like_count = in.readString();
        total_dislike_count = in.readString();
        total_share_count = in.readString();
    //   in.readList(beanImages, getClass().getClassLoader());
    }
   /* @Override
    public String toString() {
        return "ItemList{" +
                "IID=" + id +
                ", ItemName='" + ItemName + '\'' +
                ", Images=" + Images +
                '}';
    }*/

}
