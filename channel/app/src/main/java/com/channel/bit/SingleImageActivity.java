package com.channel.bit;

import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;

import com.bumptech.glide.Glide;
import com.channel.bit.common.LocaleHelper;
import com.channel.bit.common.Utils;
import com.channel.bit.databinding.ActivitySingleImageBinding;

import androidx.appcompat.app.AppCompatActivity;
import androidx.core.content.FileProvider;
import androidx.databinding.DataBindingUtil;

public class SingleImageActivity extends AppCompatActivity {


    ActivitySingleImageBinding mBinding;
    String imgUrl="";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mBinding = DataBindingUtil.setContentView(this, R.layout.activity_single_image);
        LocaleHelper.setLocale(SingleImageActivity.this, Utils.getSavedData(getApplicationContext(),"language"));
        getsetData();
        setListener();

    }

    private void getsetData() {
        imgUrl = getIntent().getStringExtra("imgUrl");
        Glide.with(getApplicationContext()).load(imgUrl)
                .into(mBinding.imgView);
    }

    private void setListener() {
        mBinding.imgClose.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });
        mBinding.imgShare.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Bitmap bm = ((android.graphics.drawable.BitmapDrawable) mBinding.imgView.getDrawable()).getBitmap();
                try {
                    java.io.File file = new java.io.File(getExternalCacheDir() + "/image.jpg");
                    java.io.OutputStream out = new java.io.FileOutputStream(file);
                    bm.compress(Bitmap.CompressFormat.JPEG, 100, out);
                    out.flush();
                    out.close();
                } catch (Exception e) {
                }
                Intent iten = new Intent(android.content.Intent.ACTION_SEND);
                iten.setType("*/*");
                iten.putExtra(Intent.EXTRA_STREAM, FileProvider.getUriForFile(getApplicationContext(), getApplicationContext().getPackageName() + ".provider",new java.io.File(getExternalCacheDir() + "/image.jpg")));
                startActivity(Intent.createChooser(iten, "Send image"));
            }
        });
    }

}