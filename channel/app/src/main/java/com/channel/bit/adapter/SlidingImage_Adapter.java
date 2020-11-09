package com.channel.bit.adapter;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Parcelable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.bumptech.glide.Glide;
import com.channel.bit.R;
import com.channel.bit.model.ImagesModel;

import java.util.ArrayList;

import androidx.core.content.FileProvider;
import androidx.viewpager.widget.PagerAdapter;

public class SlidingImage_Adapter extends PagerAdapter {
    private ArrayList<ImagesModel> IMAGES;
    private LayoutInflater inflater;
    private Context context;


    public SlidingImage_Adapter(Context context,ArrayList<ImagesModel> IMAGES) {
        this.context = context;
        this.IMAGES=IMAGES;
        inflater = LayoutInflater.from(context);
    }

    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        container.removeView((View) object);
    }

    @Override
    public int getCount() {
        return IMAGES.size();
    }

    @Override
    public Object instantiateItem(ViewGroup view, int position) {
        View imageLayout = inflater.inflate(R.layout.slidingimages_layout, view, false);
        ImagesModel imagesModel = IMAGES.get(position);
        assert imageLayout != null;
        final ImageView imageView = (ImageView) imageLayout
                .findViewById(R.id.image);
        ImageView imgShare = (ImageView) imageLayout
                .findViewById(R.id.imgShare);
        Glide.with(context).load(imagesModel.getImage_url())
                .placeholder(R.drawable.ic_profile)
                .into(imageView);
        imgShare.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Bitmap bm = ((android.graphics.drawable.BitmapDrawable) imageView.getDrawable()).getBitmap();
                try {
                    java.io.File file = new java.io.File(context.getExternalCacheDir() + "/image.jpg");
                    java.io.OutputStream out = new java.io.FileOutputStream(file);
                    bm.compress(Bitmap.CompressFormat.JPEG, 100, out);
                    out.flush();
                    out.close();
                } catch (Exception e) {
                }
                Intent iten = new Intent(android.content.Intent.ACTION_SEND);
                iten.setType("*/*");
                iten.putExtra(Intent.EXTRA_STREAM, FileProvider.getUriForFile(context, context.getApplicationContext().getPackageName() + ".provider",new java.io.File(context.getExternalCacheDir() + "/image.jpg")));
                context.startActivity(Intent.createChooser(iten, "Send image"));
            }
        });

        view.addView(imageLayout, 0);

        return imageLayout;
    }

    @Override
    public boolean isViewFromObject(View view, Object object) {
        return view.equals(object);
    }

    @Override
    public void restoreState(Parcelable state, ClassLoader loader) {
    }

    @Override
    public Parcelable saveState() {
        return null;
    }


}
