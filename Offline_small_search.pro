#-------------------------------------------------
#
# Project created by QtCreator 2015-08-13T08:12:23
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets qml quick quickwidgets network multimedia

TARGET = Offline_small_search
TEMPLATE = app
CONFIG += no_keywords

QMAKE_CFLAGS += -std=gnu11 -mfpu=neon -fdata-sections -DNDEBUG -Wl,--fix-cortex-a8 -Wl,--gc-sections -Wl,-z,noexecstack
QMAKE_CXXFLAGS += -mfpu=neon -fdata-sections -DNDEBUG -Wl,--fix-cortex-a8 -Wl,--gc-sections -Wl,-z,noexecstack  -std=gnu++11 -include ctype.h -include unistd.h
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

#FORMS    += \
#    offline_small_search.ui

#DEPENDPATH += H:/msys2/soft/x86_build/usr/include
#INCLUDEPATH += H:/msys2/soft/x86_build/usr/include
#LIBS+=-LH:/msys2/soft/x86_build/usr/lib -LH:/msys2/msys32/mingw32/lib -llucene+
#CONFIG += mobility#+.dll -lzim -llzma -lws2_32 -lboost_system-mt


RESOURCES += \
    qml.qrc \
    image.qrc

DEPENDPATH+=$$PWD/quazip
include($$PWD/quazip/quazip.pri)

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    QT += androidextras
    DEPENDPATH += G:/build/arm/include/
    INCLUDEPATH += G:/build/arm/include/
    LIBS+=-LG:/build/arm/lib/ \#-LI:/crystax/build/usr/lib \
        G:/build/arm/lib/libopencv_java3.so \
        G:/build/arm/lib/libopencv_*.a \
        -Wl,-Bstatic,-ltess,-llept,-lIlmImf,-ltiff,-ljasper,-lpng,-ljpeg,-lwebp,-ltbb,-lxapian,-luuid,-lzim,-llzma,-Bdynamic -lz #-lboost_system,-ltesseract,-llept,-llucene++

    ANDROID_EXTRA_LIBS = \
        #G:/msys2/msys32/arm/lib/liblzma.so \
        #G:/msys2/msys32/arm/lib/libzim.so \
        G:/build/arm/lib/libopencv_java3.so# \
        #I:/crystax/build/usr/lib/libcrystax.so \
        #I:/crystax/build/usr/lib/libboost_system.so \
        #H:/crystax/build/usr/lib/libz.so \
        #J:/msys2/msys32/home/zjzdy/LucenePlusPlus/arm_build/src/core/liblucene++.so
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
