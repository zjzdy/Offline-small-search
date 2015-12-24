package qt.oss;
import android.content.Context;
import android.content.Intent;
import android.app.PendingIntent;
import android.util.Log;
import android.net.Uri;
import android.provider.Settings;
import android.os.Environment;
import android.os.Bundle;
import java.io.File;
import android.provider.MediaStore;

public class OfflineSmallSearchActivity extends org.qtproject.qt5.android.bindings.QtActivity
{
    private final static int CAPTURE_IMAGE_REQUEST_CODE = 2;
    private static OfflineSmallSearchActivity m_instance;
    private final static String TAG = "OfflineSmallSearchActivity";
    public String m_imagePath;

    public OfflineSmallSearchActivity(){
        m_instance = this;
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data){
        switch(requestCode){
        case CAPTURE_IMAGE_REQUEST_CODE:
            new OfflineSmallSearchNative().OnImageCaptured(resultCode, m_imagePath);
            break;
        default:
            super.onActivityResult(requestCode, resultCode, data);
        }
    }

   public static String getSdcardPath(){
       File sdDir = null;
       boolean sdCardExist = Environment.getExternalStorageState()
                       .equals(android.os.Environment.MEDIA_MOUNTED);
       if(sdCardExist)
       {
            sdDir = Environment.getExternalStorageDirectory();
            return sdDir.toString();
       }
       return "";
   }

   public void initCaptureImagePath(){
       if( m_imagePath == null ){
           String sdPath = getSdcardPath();
           if(sdPath.isEmpty()){
               sdPath = "/sdcard";
           }
           m_imagePath = String.format("%s/oss", sdPath);
           File imageDir = new File(m_imagePath);
           if(!imageDir.exists()){
               imageDir.mkdirs();
           }
           m_imagePath = String.format("%s/oss/cap.jpg", sdPath);
           File image = new File(m_imagePath);
           if(image.exists()){
               image.delete();
           }
           Log.d(TAG, "capture to - " + m_imagePath);
       }
   }

   public static void captureImage(){
       m_instance.initCaptureImagePath();
       File imageFile = new File(m_instance.m_imagePath);
       Uri uri = Uri.fromFile(imageFile);
       Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
       intent.putExtra(MediaStore.EXTRA_OUTPUT, uri);
       m_instance.startActivityForResult(intent, CAPTURE_IMAGE_REQUEST_CODE);
   }

   public static void clickHome(){
       Intent i= new Intent(Intent.ACTION_MAIN);
       i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
       i.addCategory(Intent.CATEGORY_HOME);
       m_instance.startActivity(i);
   }
}
