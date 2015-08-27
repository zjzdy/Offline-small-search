#-------------------------------------------------
#
# Project created by QtCreator 2015-08-13T08:12:23
#
#-------------------------------------------------

QT       += core gui

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets qml quick quickwidgets network

TARGET = Offline_small_search
TEMPLATE = app
CONFIG += no_keywords c++11


SOURCES += main.cpp \
    offline_small_search.cpp \
    offline_pkg.cpp \
    Limonp/HandyMacro.hpp \
    Limonp/LocalVector.hpp \
    Limonp/Logger.hpp \
    Limonp/NonCopyable.hpp \
    Limonp/StdExtension.hpp \
    Limonp/StringUtil.hpp \
    DictTrie.hpp \
    FullSegment.hpp \
    ISegment.hpp \
    MPSegment.hpp \
    SegmentBase.hpp \
    TransCode.hpp \
    Trie.hpp \
    HMMModel.hpp \
    HMMSegment.hpp \
    MixSegment.hpp \
    QuerySegment.hpp \
    luceneplusplus_search_thread.cpp \
    luceneplusplus_search.cpp \
    search_result_obj.cpp \
    history_obj.cpp

HEADERS  += \
    offline_small_search.h \
    offline_pkg.h \
    luceneplusplus_search_thread.h \
    luceneplusplus_search.h \
    search_result_obj.h \
    history_obj.h

FORMS    += \
    offline_small_search.ui

#DEPENDPATH += H:/msys2/soft/x86_build/usr/include
#INCLUDEPATH += H:/msys2/soft/x86_build/usr/include
#LIBS+=-LH:/msys2/soft/x86_build/usr/lib -LH:/msys2/msys32/mingw32/lib -llucene++.dll -lzim -llzma -lws2_32 -lboost_system-mt

CONFIG += mobility
MOBILITY = 

RESOURCES += \
    dict.qrc \
    qml.qrc \
    image.qrc


contains(ANDROID_TARGET_ARCH,armeabi) {
    DEPENDPATH += G:/msys2/msys32/arm/include/
    INCLUDEPATH += G:/msys2/msys32/arm/include/
    LIBS+=-LG:/msys2/msys32/arm/lib/ -LH:/crystax/build/usr/lib -llucene++ -lzim -llzma #-lboost_system
    ANDROID_EXTRA_LIBS = \
        G:/msys2/msys32/arm/lib/liblzma.so \
        G:/msys2/msys32/arm/lib/libzim.so \
        G:/msys2/msys32/home/zjzdy/LucenePlusPlus/arm_build/src/core/liblucene++.so \
        H:/crystax/build/usr/lib/libboost_system.so \
        H:/crystax/build/usr/lib/libz.so \
        H:/crystax/build/usr/lib/libcrystax.so
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
    image/logo.png

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
