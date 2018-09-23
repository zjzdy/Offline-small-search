package qt.oss;
import android.content.Intent;
import android.util.Log;
import android.net.Uri;
import android.os.Environment;
import android.os.Bundle;
import java.io.File;
import android.provider.MediaStore;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.content.pm.PackageManager;
import android.Manifest;
import android.widget.Toast;

public class OfflineSmallSearchActivity extends org.qtproject.qt5.android.bindings.QtActivity {
    private static final int CAPTURE_IMAGE_REQUEST_CODE = 2;
    private static OfflineSmallSearchActivity minstance;
    private static final String TAG = "OfflineSmallSearchActivity";
    private String mimagePath;

    public OfflineSmallSearchActivity(){
        minstance = this;
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data){
        if(requestCode == CAPTURE_IMAGE_REQUEST_CODE){
            new OfflineSmallSearchNative().onImageCaptured(resultCode, mimagePath);
        } else {
            super.onActivityResult(requestCode, resultCode, data);
        }
    }
	
    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        if(getSysVer() >= 23) {
            checkStoragePermission();
            checkCameraPermission();
        }
    }
	
    public void checkStoragePermission() {
        //PackageManager.PERMISSION_GRANTED表示同意授权
        if(ActivityCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            if(ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.WRITE_EXTERNAL_STORAGE)) {
                Toast.makeText(this, "请允许应用读写储存，否则无法正常使用本应用！", Toast.LENGTH_SHORT).show();
            }
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.READ_EXTERNAL_STORAGE,Manifest.permission.WRITE_EXTERNAL_STORAGE}, 1);
        }
    }

    public void checkCameraPermission() {
        if(ActivityCompat.checkSelfPermission(this, Manifest.permission.CAMERA) != PackageManager.PERMISSION_GRANTED) {
            if(ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.CAMERA)) {
                Toast.makeText(this, "请允许应用打开相机，否则无法拍照识别！", Toast.LENGTH_SHORT).show();
            }
            ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.CAMERA}, 2);
        }
    }

    public static String getSdcardPath(){
        boolean sdCardExist = Environment.getExternalStorageState()
                       .equals(android.os.Environment.MEDIA_MOUNTED);
        if(sdCardExist) {
            return Environment.getExternalStorageDirectory().toString();
        }
        return "";
    }

    public static void captureImage(){
        if(minstance.mimagePath == null ) {
           String sdPath = getSdcardPath();
            if(sdPath.isEmpty()) {
                sdPath = "/sdcard";
            }
            minstance.mimagePath = String.format("%s/oss", sdPath);
            File imageDir = new File(minstance.mimagePath);
            if(!imageDir.exists()) {
                imageDir.mkdirs();
            }
            minstance.mimagePath = String.format("%s/cap.png", minstance.mimagePath);
            Log.d(TAG, "capture to - " + minstance.mimagePath);
        }
        File image = new File(minstance.mimagePath);
        if(image.exists()) {
            image.delete();
        }
        Uri uri = Uri.fromFile(image);
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        intent.putExtra(MediaStore.EXTRA_OUTPUT, uri);
        minstance.startActivityForResult(intent, CAPTURE_IMAGE_REQUEST_CODE);
    }

    public static void clickHome(){
        Intent intent= new Intent(Intent.ACTION_MAIN);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        intent.addCategory(Intent.CATEGORY_HOME);
        minstance.startActivity(intent);
        android.os.Process.killProcess(android.os.Process.myPid());
    }

    public static int getSysVer(){
        //在使用非标准版本号时会奔溃
        try{
            return android.os.Build.VERSION.SDK_INT;
        }
        catch (Exception e){
            Log.d(TAG,"android.os.Build.VERSION.SDK_INT have question.Try to use android.os.Build.VERSION.RELEASE",e);
            int ver = 0;
            String release = android.os.Build.VERSION.RELEASE;
            if(release.startsWith("1")) {
                if(release.startsWith("1.1")) {
                    ver = 2;
                } else if(release.startsWith("1.5")) {
                    ver = 3;
                } else if(release.startsWith("1.6")) {
                    ver = 4;
                } else {
                    ver = 1;
                }
            } else if(release.startsWith("2")) {
                if(release.startsWith("2.0.1")) {
                    ver = 6;
                } else if(release.startsWith("2.1")) {
                    ver = 7;
                } else if(release.startsWith("2.2")) {
                    ver = 8;
                } else if(release.startsWith("2.3")) {
                    ver = 9;
                } else if(release.startsWith("2.3.3") || release.startsWith("2.3.4")) {
                    ver = 10;
                } else {
                    ver = 5;
                }
            } else if(release.startsWith("3")) {
                if(release.startsWith("3.1")) {
                    ver = 12;
                } else if(release.startsWith("3.2")) {
                    ver = 13;
                } else {
                    ver = 11;
                }
            } else if(release.startsWith("4")) {
                if(release.startsWith("4.0.3")) {
                    ver = 15;
                } else if(release.startsWith("4.0.4")) {
                    ver = 15;
                } else if(release.startsWith("4.1")) {
                    ver = 16;
                } else if(release.startsWith("4.2")) {
                    ver = 17;
                } else if(release.startsWith("4.3")) {
                    ver = 18;
                } else if(release.startsWith("4.4")) {
                    ver = 19;
                } else if(release.startsWith("4.4W")) {
                    ver = 20;
                } else {
                    ver = 14;
                }
            } else if(release.startsWith("5")) {
                if(release.startsWith("5.1")) {
                    ver = 22;
                } else {
                    ver = 21;
                }
            } else if(release.startsWith("6")) {
                ver = 23;
            } else if(release.startsWith("7")) {
                if(release.startsWith("7.1")) {
                    ver = 25;
                } else {
                    ver = 24;
                }
            } else if(release.startsWith("8")) {
                ver = 26;
            } else if(ver == 0) {
                ver = 24;
            }
            return ver;
        }
    }
}
