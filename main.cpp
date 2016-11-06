#include "offline_small_search.h"
#include <QApplication>
/*
#ifndef Q_OS_ANDROID
#include <QSplashScreen>
#endif
*/
#include <QStyleHints>
#include <QScreen>
#include <QQmlApplicationEngine>
#include <QtQml/QQmlContext>
#include "capcustomevent.h"
#ifdef Q_OS_ANDROID
#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#include <jni.h>
#endif

#ifdef QT_WEBVIEW_WEBENGINE_BACKEND
#include <QtWebEngine>
#endif // QT_WEBVIEW_WEBENGINE_BACKEND

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
        {"onImageCaptured", "(ILjava/lang/String;)V", (void*)onImageCaptured}
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
    a.setOrganizationName("zjzdy");
    a.setOrganizationDomain("zjzdy.offline.small.search");
    QRect geometry = QGuiApplication::primaryScreen()->availableGeometry();
    if (!QGuiApplication::styleHints()->showIsFullScreen()) {
        const QSize size = geometry.size() * 4 / 5;
        const QSize offset = (geometry.size() - size) / 2;
        const QPoint pos = geometry.topLeft() + QPoint(offset.width(), offset.height());
        geometry = QRect(pos, size);
    }
    /*
#ifndef Q_OS_ANDROID
    QString splash_path;
    if(geometry.width()*1.3 < geometry.height())
        splash_path = ":/image/splash.png";
    else
    {
        if(geometry.width() > geometry.height()*1.3)
            splash_path = ":/image/splash2.png";
        else splash_path = ":/image/splash3.png";
    }
    QPixmap pixmap(splash_path);
    QSplashScreen splash(pixmap);
    splash.setGeometry(geometry);
    //splash.resize(geometry.size());
    //splash.setDisabled(true);
    splash.show();
#endif
*/

#ifdef Q_OS_ANDROID
    registerNativeMethods();
#endif
    Offline_small_search w;
    a.setApplicationVersion(w.get_version());
#ifdef Q_OS_ANDROID
    g_listener = (QObject*)&w;
#endif

#ifdef QT_WEBVIEW_WEBENGINE_BACKEND
    QtWebEngine::initialize();
#endif // QT_WEBVIEW_WEBENGINE_BACKEND

    QQmlApplicationEngine engine;
    QQmlContext *context = engine.rootContext();
    context->setContextProperty(QStringLiteral("initialX"), geometry.x());
    context->setContextProperty(QStringLiteral("initialY"), geometry.y());
    context->setContextProperty(QStringLiteral("initialWidth"), geometry.width());
    context->setContextProperty(QStringLiteral("initialHeight"), geometry.height());
    context->setContextProperty("main_widget", &w);
    context->setContextProperty("MainProgram", &w);
    w.init_con(context);
    w.init_data();
    /*
#ifndef Q_OS_ANDROID
    splash.close();
#endif
*/
    engine.load(QUrl(QStringLiteral("qrc:/all.qml")));
    w.init_obj(engine.rootObjects().first());
    engine.rootObjects().first()->findChild<QObject*>("splash")->setProperty("visible",false);
    //w.rootContext = engine.rootContext();
    return a.exec();
}
