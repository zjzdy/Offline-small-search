#include "offline_small_search.h"
#include <QApplication>
//#include <QSplashScreen>
//#include <QScreen>
#include <QQmlApplicationEngine>
#include "capcustomevent.h"
#ifdef Q_OS_ANDROID
#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#include <jni.h>
#endif

#ifdef Q_OS_ANDROID
QObject *g_listener = 0;
static void onImageCaptured(JNIEnv *env, jobject thiz,int result, jstring imageFile)
{
    QString image;
    const char *nativeString = env->GetStringUTFChars(imageFile, 0);
    image = nativeString;
    env->ReleaseStringUTFChars(imageFile, nativeString);
    qDebug() << "onImageCaptured, result - " << result << " image - " << image;
    int ret = result;
    if(result == -1 && QFile::exists(image))
    {
        ret = 2;
    }
    else
    {
        ret = -2;
        qDebug() << "could not read the captured image!";
    }
    QCoreApplication::postEvent(g_listener, new capCustomEvent(ret, image));
}

static bool registerNativeMethods()
{
    JNINativeMethod methods[] {
        {"OnImageCaptured", "(ILjava/lang/String;)V", (void*)onImageCaptured}
    };

    const char *classname = "qt/oss/OfflineSmallSearchNative";
    jclass clazz;
    QAndroidJniEnvironment env;

    QAndroidJniObject javaClass(classname);
    clazz = env->GetObjectClass(javaClass.object<jobject>());
    //clazz = env->FindClass(classname);
    qDebug() << "find ImageCaptureNative - " << clazz;
    bool result = false;
    if(clazz)
    {
        jint ret = env->RegisterNatives(clazz,
                                        methods,
                                        sizeof(methods) / sizeof(methods[0]));
        env->DeleteLocalRef(clazz);
        qDebug() << "RegisterNatives return - " << ret;
        result = ret >= 0;
    }
    if(env->ExceptionCheck()) env->ExceptionClear();
    return result;
}

#endif

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
    a.setApplicationName(QObject::tr("离线小搜"));
    a.setApplicationVersion("1.8.15.12");
    a.setOrganizationName("zjzdy");
    a.setOrganizationDomain("zjzdy.offline.small.search");
    /*QScreen *screen = a.primaryScreen();

#ifdef Q_OS_ANDROID
    registerNativeMethods();
#endif

#ifdef Q_OS_ANDROID
    QSplashScreen splash(QPixmap(":/image/splash.png"));
    splash.resize(screen->size());
#else
    QSplashScreen splash(QPixmap(":/image/splash.png"));
    splash.resize(screen->size());
#endif
    splash.setDisabled(true);
    splash.show();
    Offline_small_search w;
#ifdef Q_OS_ANDROID
    g_listener = (QObject*)&w;
#endif
    w.show();
    splash.finish(&w);
    */

#ifdef Q_OS_ANDROID
    registerNativeMethods();
#endif
    Offline_small_search w;
#ifdef Q_OS_ANDROID
    g_listener = (QObject*)&w;
#endif
    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/all.qml")));
    //qDebug()<<"Count obj:"<<engine.rootObjects().count();
    engine.rootContext()->setContextProperty("main_widget", &w);
    //qDebug()<<"Count obj:"<<engine.rootObjects().count();
    w.init_obj(engine.rootObjects().first());
    w.init_con(engine.rootContext());
    w.init_data();
    //w.rootContext = engine.rootContext();
    return a.exec();
}
