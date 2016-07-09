package qt.oss;
import android.content.Intent;
import android.util.Log;
import android.net.Uri;
import android.os.Environment;
import android.os.Build;
import java.io.File;
import android.provider.MediaStore;

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

   public static String getSdcardPath(){
       boolean sdCardExist = Environment.getExternalStorageState()
                       .equals(android.os.Environment.MEDIA_MOUNTED);
       if(sdCardExist) {
            File sdDir = null;
            sdDir = Environment.getExternalStorageDirectory();
            return sdDir.toString();
       }
       return "";
   }

   public void initCaptureImagePath(){
       if( mimagePath == null ){
           String sdPath = getSdcardPath();
           if(sdPath.isEmpty()){
               sdPath = "/sdcard";
           }
           mimagePath = String.format("%s/oss", sdPath);
           File imageDir = new File(mimagePath);
           if(!imageDir.exists()){
               imageDir.mkdirs();
           }
           mimagePath = String.format("%s/oss/cap.png", sdPath);
           File image = new File(mimagePath);
           if(image.exists()){
               image.delete();
           }
           Log.d(TAG, "capture to - " + mimagePath);
       }
   }

   public static void captureImage(){
       minstance.initCaptureImagePath();
       File imageFile = new File(minstance.mimagePath);
       Uri uri = Uri.fromFile(imageFile);
       Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
       intent.putExtra(MediaStore.EXTRA_OUTPUT, uri);
       minstance.startActivityForResult(intent, CAPTURE_IMAGE_REQUEST_CODE);
   }

   public static void clickHome(){
       Intent intent= new Intent(Intent.ACTION_MAIN);
       intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
       intent.addCategory(Intent.CATEGORY_HOME);
       minstance.startActivity(intent);
   }

    public static int getAndroidVersion(){
        //在使用非标准版本号时会奔溃
        try{
            return android.os.Build.VERSION.SDK_INT;
        }
        catch (Exception e){
            int ver = 0;
            if(android.os.Build.VERSION.RELEASE.startsWith("1"))
            {
                ver = 1;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("1.1"))
            {
                ver = 2;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("1.5"))
            {
                ver = 3;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("1.6"))
            {
                ver = 4;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("2"))
            {
                ver = 5;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("2.0.1"))
            {
                ver = 6;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("2.1"))
            {
                ver = 7;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("2.2"))
            {
                ver = 8;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("2.3"))
            {
                ver = 9;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("2.3.3"))
            {
                ver = 10;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("2.3.4"))
            {
                ver = 10;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("3"))
            {
                ver = 11;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("3.1"))
            {
                ver = 12;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("3.2"))
            {
                ver = 13;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("4"))
            {
                ver = 14;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("4.0.3"))
            {
                ver = 15;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("4.0.4"))
            {
                ver = 15;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("4.1"))
            {
                ver = 16;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("4.2"))
            {
                ver = 17;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("4.3"))
            {
                ver = 18;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("4.4"))
            {
                ver = 19;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("4.4W"))
            {
                ver = 20;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("5"))
            {
                ver = 21;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("5.1"))
            {
                ver = 22;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("6"))
            {
                ver = 23;
            }
            if(android.os.Build.VERSION.RELEASE.startsWith("7"))
            {
                ver = 24;
            }
            if(ver == 0)
            {
                ver = 24;
            }
            return ver;
        }
    }
}
