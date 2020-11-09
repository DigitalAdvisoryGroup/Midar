package com.channel.bit;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import com.channel.bit.common.LocaleHelper;
import com.channel.bit.common.Utils;
import com.channel.bit.databinding.ActivityVerifyotpBinding;

import org.apache.xmlrpc.XmlRpcException;
import org.apache.xmlrpc.client.XmlRpcClient;
import org.apache.xmlrpc.client.XmlRpcClientConfigImpl;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.Locale;

import androidx.appcompat.app.AppCompatActivity;
import androidx.databinding.DataBindingUtil;
import in.aabhasjindal.otptextview.OTPListener;

import static java.util.Arrays.asList;

public class VerifyOtpActivity extends AppCompatActivity {

    ActivityVerifyotpBinding mBinding;
    String otp = "";
    ProgressDialog progress;
    String uid="";
    String partner_id="";
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mBinding = DataBindingUtil.setContentView(this, R.layout.activity_verifyotp);
        LocaleHelper.setLocale(VerifyOtpActivity.this, Utils.getSavedData(getApplicationContext(),"language"));
        getsetData();
        setListener();
    }

    private void getsetData() {
        uid = getIntent().getStringExtra("uid");
        partner_id = getIntent().getStringExtra("partner_id");
    }
    private void setListener() {
        mBinding.otpView.setOtpListener(new OTPListener() {
            @Override
            public void onInteractionListener() {

            }
            @Override
            public void onOTPComplete(String otp1) {
                otp = otp1;
            }
        });
        mBinding.btnVerify.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(otp.equalsIgnoreCase("")){
                    Toast.makeText(getApplicationContext(),"Please enter otp..!!",Toast.LENGTH_SHORT).show();
                }
                else{
                    progress=new ProgressDialog(VerifyOtpActivity.this);
                    progress.setMessage("Please wait....");
                    progress.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
                    progress.setProgressNumberFormat(null);
                    progress.setProgressPercentFormat(null);
                    progress.setIndeterminate(true);
                    progress.setCancelable(false);
                    progress.show();
                    new otpVerify().execute();
                }
            }
        });
        mBinding.btnResend.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                progress=new ProgressDialog(VerifyOtpActivity.this);
                progress.setMessage("Please wait....");
                progress.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
                progress.setProgressNumberFormat(null);
                progress.setProgressPercentFormat(null);
                progress.setIndeterminate(true);
                progress.setCancelable(false);
                progress.show();
                new resendOtp().execute();
            }
        });
    }
    Object verify_otp;
    private class otpVerify extends AsyncTask<Void, Void, Integer> {
        @Override
        protected void onPreExecute() {
            super.onPreExecute();
        }
        @Override
        protected Integer doInBackground(Void... voids) {

            final XmlRpcClient models = new XmlRpcClient() {{
                setConfig(new XmlRpcClientConfigImpl() {{
                    try {
                        setServerURL(new URL(String.format("%s/xmlrpc/2/object", Utils.url)));
                    } catch (MalformedURLException e) {
                        Utils.printMessage(VerifyOtpActivity.this);
                        e.printStackTrace();
                    }
                }});
            }};
            try {
                int uid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"uid"));
                verify_otp = models.execute("execute_kw", asList(
                        Utils.db_name,uid, Utils.password,
                        "res.partner", "get_partner_otp_verify",asList(asList(),Utils.getSavedData(getApplicationContext(),"email"),otp)
                ));
            } catch (XmlRpcException e) {
                Utils.printMessage(VerifyOtpActivity.this);
                e.printStackTrace();
            }
            return null;
        }

        @Override
        protected void onPostExecute(Integer result) {
            super.onPostExecute(result);
            progress.dismiss();
            if((boolean)verify_otp == false){
                Toast.makeText(getApplicationContext(),"Incorrect otp..",Toast.LENGTH_SHORT).show();
            }else{
                Utils.saveData(getApplicationContext(),"otp","true");
                Intent intent = new Intent(VerifyOtpActivity.this,MainActivity.class);
                intent.putExtra("uid",uid);
                intent.putExtra("partner_id",partner_id);
                startActivity(intent);
            }
        }
    }
    Object resend_otp;
    private class resendOtp extends AsyncTask<Void, Void, Integer> {
        @Override
        protected void onPreExecute() {
            super.onPreExecute();
        }
        @Override
        protected Integer doInBackground(Void... voids) {

            final XmlRpcClient models = new XmlRpcClient() {{
                setConfig(new XmlRpcClientConfigImpl() {{
                    try {
                        setServerURL(new URL(String.format("%s/xmlrpc/2/object", Utils.url)));
                    } catch (MalformedURLException e) {
                        Utils.printMessage(VerifyOtpActivity.this);
                        e.printStackTrace();
                    }
                }});
            }};
            try {
                int uid = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"uid"));
                int partner_id = Integer.parseInt(Utils.getSavedData(getApplicationContext(),"partner_id"));
                resend_otp = models.execute("execute_kw", asList(
                        Utils.db_name,uid, Utils.password,
                        "res.partner", "send_otp_partner",asList(asList(partner_id))
                ));
                Log.e("resend_otp"," "+resend_otp);
            } catch (XmlRpcException e) {
                Utils.printMessage(VerifyOtpActivity.this);
                e.printStackTrace();
            }
            return null;
        }

        @Override
        protected void onPostExecute(Integer result) {
            super.onPostExecute(result);
            progress.dismiss();
            if((boolean)resend_otp == true){
                Toast.makeText(getApplicationContext(),"OTP successfully sent to your email id",Toast.LENGTH_SHORT).show();
            }else{
                Toast.makeText(getApplicationContext(),"Something goes wrong.Please click on Resend Button again..!!",Toast.LENGTH_SHORT).show();
            }
        }
    }

}