package qt.oss;
import android.content.Intent;
import android.util.Log;
import android.net.Uri;
import android.os.Environment;
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
                ver = 24;
            } else if(ver == 0) {
                ver = 24;
            }
            return ver;
        }
    }
}
