#-------------------------------------------------
#
# Project created by QtCreator 2015-08-13T08:12:23
#
#-------------------------------------------------

lessThan(QT_VERSION, "5.6.1") {
    error("Qt 5.6.1 or above is required to build Offline_small_search.")
}

QT       += core gui widgets qml quick quickwidgets network multimedia quick-private quickcontrols2

TARGET = Offline_small_search
TEMPLATE = app
CONFIG += no_keywords

!osx:qtHaveModule(webengine) {
        QT += webengine
        DEFINES += QT_WEBVIEW_WEBENGINE_BACKEND
        DEFINES += USE_WEBENGINE
}

win32:!qtHaveModule(webengine):qtHaveModule(webkit) {
        QT += webkit webkit_private
        DEFINES += USE_WEBKIT
        RESOURCES += WebKit_qml/Webkit_qml.qrc
} else {
    RESOURCES += Result.qrc
}

QMAKE_CFLAGS += -std=gnu11
QMAKE_CXXFLAGS += -std=gnu++11

SOURCES += main.cpp \
    offline_small_search.cpp \
    offline_pkg.cpp \
    Xapian_search_thread.cpp \
    Xapian_search.cpp \
    search_result_obj.cpp \
    history_obj.cpp \
    custom_obj.cpp \
    mark_obj.cpp \
    more_search_obj.cpp \
    capcustomevent.cpp \
    crop.cpp \
    crop_thread.cpp \
    unzip_thread.cpp \
    parse/htmlparse.cc \
    parse/myhtmlparse.cc \
    parse/stringutils.cc \
    parse/utf8convert.cc

HEADERS  += \
    offline_small_search.h \
    offline_pkg.h \
    Xapian_search_thread.h \
    Xapian_search.h \
    search_result_obj.h \
    history_obj.h \
    custom_obj.h \
    mark_obj.h \
    more_search_obj.h \
    capcustomevent.h \
    crop.h \
    crop_thread.h \
    unzip_thread.h \
    parse/htmlparse.h \
    parse/myhtmlparse.h \
    parse/namedentities.h \
    parse/strcasecmp.h \
    parse/stringutils.h \
    parse/utf8convert.h \
    interfaces.h

RESOURCES += \
    qml.qrc \
    image.qrc \
    opencc.qrc

DEPENDPATH+=$$PWD/quazip
include($$PWD/quazip/quazip.pri)

DEPENDPATH+=$$PWD/opencc
include($$PWD/opencc/opencc.pri)

win32 {
    RC_ICONS = image/logo.ico
    DEPENDPATH += $$PWD/build-bin/include/
    INCLUDEPATH += $$PWD/build-bin/include/
    LIBS +=-L$$PWD/build-bin/lib/ \
           -Wl,-Bstatic \
           -ltesseract -llept -lgif -lxapian -lzim -llzma \
           -lcrypt32 -luuid -lws2_32 -lrpcrt4 \
           -Wl,-Bdynamic \
           -lopencv_photo -lopencv_highgui -lopencv_videoio -lopencv_imgcodecs -lopencv_imgproc -lopencv_core -ltiff -ljasper -lpng -ljpeg -lwebp -lz
    DEFINES += QUAZIP_STATIC
}

macx {
    ICON = image/logo.icns
}

unix:!macx:!android {
    isEmpty(PREFIX): PREFIX = /usr
    target.path = $$PREFIX/bin
    INSTALLS = target

    appicons16.files=image/appicons/16/*
    appicons24.files=image/appicons/24/*
    appicons32.files=image/appicons/32/*
    appicons48.files=image/appicons/48/*
    appicons64.files=image/appicons/64/*
    appicons96.files=image/appicons/96/*
    appicons128.files=image/appicons/128/*
    appicons256.files=image/appicons/256/*
    appicons512.files=image/appicons/512/*

    appicons16.path=$$PREFIX/share/icons/hicolor/16x16/apps
    appicons24.path=$$PREFIX/share/icons/hicolor/24x24/apps
    appicons32.path=$$PREFIX/share/icons/hicolor/32x32/apps
    appicons48.path=$$PREFIX/share/icons/hicolor/48x48/apps
    appicons64.path=$$PREFIX/share/icons/hicolor/64x64/apps
    appicons96.path=$$PREFIX/share/icons/hicolor/96x96/apps
    appicons128.path=$$PREFIX/share/icons/hicolor/128x128/apps
    appicons256.path=$$PREFIX/share/icons/hicolor/256x256/apps
    appicons512.path=$$PREFIX/share/icons/hicolor/512x512/apps

    desktop.files=Offline_small_search.desktop
    desktop.path=$$PREFIX/share/applications

    INSTALLS += appicons16 appicons24 appicons32 appicons48 appicons64 appicons96 appicons128 appicons256 appicons512 desktop
}


android {
    QMAKE_CFLAGS += -Wl,--fix-cortex-a8 -Wl,--gc-sections -Wl,-z,noexecstack
    QMAKE_CXXFLAGS += -Wl,--fix-cortex-a8 -Wl,--gc-sections -Wl,-z,noexecstack
    QMAKE_LFLAGS += -Wl,--fix-cortex-a8 -Wl,--gc-sections -Wl,-z,noexecstack
    QT += androidextras
    DEPENDPATH += $$PWD/build-bin/include/
    INCLUDEPATH += $$PWD/build-bin/include/
    LIBS +=-L$$PWD/build-bin/lib/ \
        -Wl,-Bstatic,-lcryptopp,-lopencv_photo,-lopencv_imgcodecs,-lopencv_ml,-lopencv_imgproc,-lopencv_flann,-lopencv_core,-ltess,-llept,-lIlmImf,-ltiff,-ljasper,-lpng,-ljpeg,-lwebp,-ltbb,-lxapian,-luuid,-lzim,-llzma,-Bdynamic -lz #-ltesseract


    DISTFILES += \
        android/AndroidManifest.xml \
        android/gradle/wrapper/gradle-wrapper.jar \
        android/gradlew \
        android/res/values/libs.xml \
        android/build.gradle \
        android/gradle/wrapper/gradle-wrapper.properties \
        android/gradlew.bat \
        android/res/layout/splash.xml \
        android/res/drawable-hdpi/splash.png \
        android/res/drawable-ldpi/splash.png \
        android/res/drawable-mdpi/splash.png \
        android/res/drawable/splash.png \
        image/logo.png \
        android/src/qt/oss/OfflineSmallSearchActivity.java \
        android/src/qt/oss/OfflineSmallSearchNative.java

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
}
