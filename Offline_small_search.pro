#-------------------------------------------------
#
# Project created by QtCreator 2015-08-13T08:12:23
#
#-------------------------------------------------

QT       += core gui widgets qml quick quickwidgets network multimedia

TARGET = Offline_small_search
TEMPLATE = app
CONFIG += no_keywords

!osx:qtHaveModule(webengine) {
        QT += webengine
        DEFINES += QT_WEBVIEW_WEBENGINE_BACKEND
}

QMAKE_CFLAGS += -std=gnu11 -Wl,--fix-cortex-a8 -Wl,--gc-sections -Wl,-z,noexecstack
QMAKE_CXXFLAGS += -std=gnu++11 -Wl,--fix-cortex-a8 -Wl,--gc-sections -Wl,-z,noexecstack
QMAKE_LFLAGS += -Wl,--fix-cortex-a8 -Wl,--gc-sections -Wl,-z,noexecstack

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
    parse/utf8convert.h

RESOURCES += \
    qml.qrc \
    image.qrc

DEPENDPATH+=$$PWD/quazip
include($$PWD/quazip/quazip.pri)

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    QT += androidextras
    DEPENDPATH += $$PWD/build-bin/include/
    INCLUDEPATH += $$PWD/build-bin/include/
    LIBS+=-L$$PWD/build-bin/lib/ \
        $$PWD/build-bin/lib/libopencv_java3.so \
        $$PWD/build-bin/lib/libopencv_*.a \
        -Wl,-Bstatic,-ltess,-llept,-lIlmImf,-ltiff,-ljasper,-lpng,-ljpeg,-lwebp,-ltbb,-lxapian,-luuid,-lzim,-llzma,-Bdynamic -lz #-ltesseract

    ANDROID_EXTRA_LIBS = \
        $$PWD/build-bin/lib/libopencv_java3.so
}

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
