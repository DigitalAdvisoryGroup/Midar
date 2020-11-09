package com.channel.bit;

import android.os.Bundle;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.method.LinkMovementMethod;
import android.text.style.URLSpan;
import android.view.View;
import android.widget.TextView;

import com.channel.bit.common.LocaleHelper;
import com.channel.bit.common.URLSpanNoUnderline;
import com.channel.bit.common.Utils;
import com.channel.bit.databinding.ActivityImpressumBinding;
import androidx.appcompat.app.AppCompatActivity;
import androidx.databinding.DataBindingUtil;


public class ImpressumActivity extends AppCompatActivity {
    ActivityImpressumBinding mBinding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mBinding = DataBindingUtil.setContentView(this, R.layout.activity_impressum);
        LocaleHelper.setLocale(ImpressumActivity.this, Utils.getSavedData(getApplicationContext(),"language"));
        setListener();

    }

    private void setListener() {
        mBinding.txtLink1.setMovementMethod(LinkMovementMethod.getInstance());
        stripUnderlines(mBinding.txtLink1);
        mBinding.txtLink1.setLinkTextColor(getResources().getColor(R.color.colorPrimary));
        mBinding.txtLink3.setMovementMethod(LinkMovementMethod.getInstance());
        stripUnderlines(mBinding.txtLink3);
        mBinding.txtLink3.setLinkTextColor(getResources().getColor(R.color.colorPrimary));
        mBinding.txtLink4.setMovementMethod(LinkMovementMethod.getInstance());
        stripUnderlines(mBinding.txtLink4);
        mBinding.txtLink4.setLinkTextColor(getResources().getColor(R.color.colorPrimary));
        mBinding.txtLink2.setMovementMethod(LinkMovementMethod.getInstance());
        stripUnderlines(mBinding.txtLink2);
        mBinding.txtLink2.setLinkTextColor(getResources().getColor(R.color.colorPrimary));

        mBinding.imgBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finish();
            }
        });
    }

    @Override
    protected void onResume() {
        super.onResume();
    }
    private void stripUnderlines(TextView textView) {
        Spannable s = new SpannableString(textView.getText());
        URLSpan[] spans = s.getSpans(0, s.length(), URLSpan.class);
        for (URLSpan span: spans) {
            int start = s.getSpanStart(span);
            int end = s.getSpanEnd(span);
            s.removeSpan(span);
            span = new URLSpanNoUnderline(span.getURL());
            s.setSpan(span, start, end, 0);
        }
        textView.setText(s);
    }
}