package com.channel.bit;

import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.channel.bit.adapter.SlidingImage_Adapter;
import com.channel.bit.common.LocaleHelper;
import com.channel.bit.common.Utils;
import com.channel.bit.model.ImagesModel;
import com.channel.bit.model.PostModel;

import java.util.ArrayList;
import java.util.List;

import androidx.appcompat.app.AppCompatActivity;
import androidx.viewpager.widget.ViewPager;

public class ImagesActivity extends AppCompatActivity {

    ArrayList<ImagesModel> imagesModelArrayList = new ArrayList<>();
    ViewPager mPager;
    TextView txtPosition;
    TextView txtCount;
    ImageView imgPrevious;
    ImageView imgNext,imgClose;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_images);
        txtPosition = (TextView)findViewById(R.id.txtPosition);
        txtCount = (TextView)findViewById(R.id.txtCount);
        imgPrevious = (ImageView) findViewById(R.id.imgPrevious);
        imgNext = (ImageView)findViewById(R.id.imgNext);
        imgClose = (ImageView)findViewById(R.id.imgClose);
        LocaleHelper.setLocale(ImagesActivity.this, Utils.getSavedData(getApplicationContext(),"language"));
        getsetData();
        setListener();
    }

    private void setListener() {
    imgClose.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        imgNext.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mPager.setCurrentItem(getItem(+1), true);
            }
        });
        imgPrevious.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                mPager.setCurrentItem(getItem(-1), true);
            }
        });
        mPager.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
                txtPosition.setText(position+1+"");
            }
            @Override
            public void onPageSelected(int position) {

            }
            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
    }

    private void getsetData() {
        Bundle bundle = getIntent().getExtras();
        imagesModelArrayList = bundle.getParcelableArrayList("mylist");
        txtCount.setText(" / "+imagesModelArrayList.size()+"");
        mPager = (ViewPager) findViewById(R.id.pager);
        mPager.setAdapter(new SlidingImage_Adapter(ImagesActivity.this,imagesModelArrayList));
    }

    private int getItem(int i) {
        return mPager.getCurrentItem() + i;
    }
}