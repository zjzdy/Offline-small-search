package qt.oss;
import android.content.Intent;
import android.app.PendingIntent;
import android.util.Log;
import android.net.Uri;
import android.os.Environment;
import java.io.File;
import android.provider.MediaStore;

public class OfflineSmallSearchActivity extends org.qtproject.qt5.android.bindings.QtActivity {
    private static final int CAPTURE_IMAGE_REQUEST_CODE = 2;
    private static OfflineSmallSearchActivity m_instance;
    private static final String TAG = "OfflineSmallSearchActivity";
    private String mimagePath;

    public OfflineSmallSearchActivity(){
        m_instance = this;
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
       File sdDir = null;
       boolean sdCardExist = Environment.getExternalStorageState()
                       .equals(android.os.Environment.MEDIA_MOUNTED);
       if(sdCardExist) {
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
           mimagePath = String.format("%s/oss/cap.jpg", sdPath);
           File image = new File(mimagePath);
           if(image.exists()){
               image.delete();
           }
           Log.d(TAG, "capture to - " + mimagePath);
       }
   }

   public static void captureImage(){
       m_instance.initCaptureImagePath();
       File imageFile = new File(m_instance.mimagePath);
       Uri uri = Uri.fromFile(imageFile);
       Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
       intent.putExtra(MediaStore.EXTRA_OUTPUT, uri);
       m_instance.startActivityForResult(intent, CAPTURE_IMAGE_REQUEST_CODE);
   }

   public static void clickHome(){
       Intent intent= new Intent(Intent.ACTION_MAIN);
       intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
       intent.addCategory(Intent.CATEGORY_HOME);
       m_instance.startActivity(intent);
   }
}
