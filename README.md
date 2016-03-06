#Offline-small-search  (离线小搜)
离线搜索软件,现支持离线搜题,搜古诗文,搜开发文档,等待.可自行打包离线包.
------------
声明:所有离线包版权归其所有者所有,与本软件及软件开发人员无关,本软件仅提供搜索功能.

本软件采用GPL协议发布,希望所有人都能一起来改进本软件.

###项目地址:
Git@OSC:[http://git.oschina.net/zjzdy/Offline-small-search](http://git.oschina.net/zjzdy/Offline-small-search)

GitHub Mirror:[https://github.com/zjzdy/Offline-small-search](https://github.com/zjzengdongyang/Offline-small-search)

主页: [http://zjzdy.github.io/oss/](http://zjzdy.github.io/oss/)

当前版本: v2.0.0

##功能及特点
* 离线全文检索,采用高度压缩打包的ZIM文件存储数据
* 主页模式
* 网址自定义,支持外部链接
* 收藏夹,历史纪录
* 搜索单一离线包,一键搜索所有离线包
* 拍照搜索(需下载相关模块)
* 在线翻译(使用有道翻译)
* 更多功能等待发现

##下载
####Git@OSC
* Android: [http://git.oschina.net/zjzdy/Offline-small-search/tree/master/bin/Android](http://git.oschina.net/zjzdy/Offline-small-search/tree/master/bin/Android)
* Windows: [http://git.oschina.net/zjzdy/Offline-small-search/tree/master/bin/Windows](http://git.oschina.net/zjzdy/Offline-small-search/tree/master/bin/Windows)

####GitHub
* Android: [https://github.com/zjzdy/Offline-small-search/tree/master/bin/Android](https://github.com/zjzdy/Offline-small-search/tree/master/bin/Android)
* Windows: [https://github.com/zjzdy/Offline-small-search/tree/master/bin/Windows](https://github.com/zjzdy/Offline-small-search/tree/master/bin/Windows)
* All: [https://github.com/zjzdy/Offline-small-search/releases](https://github.com/zjzdy/Offline-small-search/releases)

####网盘
* 百度网盘: [http://pan.baidu.com/s/1mhnmlEK](http://pan.baidu.com/s/1mhnmlEK) 密码: 396f
* 360云盘: [https://yunpan.cn/cx8yUeFyJypM5](https://yunpan.cn/cx8yUeFyJypM5) 密码: 0205

##共享的离线包地址
注意：离线包版本请用最新版,程序不保证兼容旧版本的离线包.
* 高中试题离线包 [http://pan.baidu.com/s/1qXmynFm](http://pan.baidu.com/s/1qXmynFm) 密码: 6w8i
* 初中试题离线包 [http://pan.baidu.com/s/1jHi6Ham](http://pan.baidu.com/s/1jHi6Ham) 密码: b3k9
* 小学试题离线包 [http://pan.baidu.com/s/1nuyFCKD](http://pan.baidu.com/s/1nuyFCKD) 密码: 1sqi
* 古诗文离线包 [http://pan.baidu.com/s/1nu4LqdF](http://pan.baidu.com/s/1nu4LqdF) 密码: xq5b
* 开发文档离线包 [http://pan.baidu.com/s/1bn7an8](http://pan.baidu.com/s/1bn7an8) 密码: 52v5
* 开发文档离线包(360云盘分流) [https://yunpan.cn/cYj7v3VfEBc9E](https://yunpan.cn/cYj7v3VfEBc9E) 密码: 237d
* 离线包打包器 [http://git.oschina.net/zjzdy/Offline_Small_Search_pkg_build](http://git.oschina.net/zjzdy/Offline_Small_Search_pkg_build)
* 如果需要分享离线包,可联系我在此页面添加下载链接
* 因服务器资源有限,程序内的在线下载模块暂不开放离线包的下载,请自行下载添加
* 申明：离线包的内容版权归用原所有者所有,未申明相关版权的请在下载后24小时内删除,产生的后果程序开发者不负任何责任

##软件主要开发者:
* zjzdy(zjzengdongyang@163.com)

##截图
![Main](Screenshots/main.png)

![More_search](Screenshots/more_search.png)

##编译
##Windows版本编译
本过程基于Qt 5.5.1 for Windows(msys2 mingw32), OpenCV 3.1.0, Xapian 1.2.22, xz 5.2.2, Leptonica 1.73, tess-two 5.4.1编写,Windows x86(win7及以上)环境运行.
所有代码均在msys2的mingw32_shell中运行.
###0.准备项目
安装必须的软件,下载或克隆项目.
```
pacman -Syu
pacman -S --noconfirm --needed mingw-w64-i686-tesseract-ocr mingw-w64-i686-qt-creator mingw-w64-i686-qt5-static mingw-w64-i686-leptonica mingw-w64-i686-opencv mingw-w64-i686-xz mingw-w64-i686-zlib mingw-w64-i686-toolchain base-devel git unzip p7zip xz tar wget zip
git clone http://git.oschina.net/zjzdy/Offline-small-search
cd Offline-small-search/
export ossbuild=$PWD
```
###1.编译 Xapian
到Xapian的官网去下载最新版本的Xapian core
下载地址:[http://xapian.org/download](http://xapian.org/download)
以下使用xapian-core-1.2.22.tar.xz
```
wget http://oligarchy.co.uk/xapian/1.2.22/xapian-core-1.2.22.tar.xz
tar -xf xapian-core-1.2.22.tar.xz
cd xapian-core-1.2.22/
./configure --prefix="${ossbuild}/build-bin/" --enable-backend-inmemory=no
make
make install
cd ../
```
###2.编译 zimlib
```
cd zimlib/
./autogen.sh
./configure --prefix="${ossbuild}/build-bin/"
make
make install
cd ../
```
###3.编译 离线小搜
0.对部分头文件进行处理
```
cp /mingw32/include/tesseract/tesscallback.h /mingw32/include/tesseract/tesscallback.h.bak
sed -i 's/template <class T> struct remove_reference;//g' /mingw32/include/tesseract/tesscallback.h
sed -i 's/template<typename T> struct remove_reference { typedef T type; };//g' /mingw32/include/tesseract/tesscallback.h
sed -i 's/template<typename T> struct remove_reference<T&> { typedef T type; };//g' /mingw32/include/tesseract/tesscallback.h
qtcreator Offline_small_search.pro
```
如果Qt库没有带webengine,则改用QtWebKit,且"有道翻译"这个功能无效.
```
sed -i 's/QtWebView 1.0/QtWebKit 3.0/g' Result.qml
```
1.打开Qt Creator
2.打开Offline_small_search.pro
3.选择配置Desktop Qt (static) MinGW-w64 32bit (MSYS2)
4.选择Release
5.点击构建

###4.安装 离线小搜
```
rm /mingw32/include/tesseract/tesscallback.h
mv /mingw32/include/tesseract/tesscallback.h.bak /mingw32/include/tesseract/tesscallback.h
mkdir oss_bin
cp ../build-Offline_small_search-Desktop_Qt_MinGW_w64_32bit_MSYS2-Release/release/Offline_small_search.exe oss_bin/
cp -r /mingw32/share/qt5/plugins/bearer oss_bin/
cp -r /mingw32/share/qt5/plugins/imageformats oss_bin/
cp -r /mingw32/share/qt5/plugins/mediaservice oss_bin/
cp -r /mingw32/share/qt5/plugins/platforms oss_bin/
cp -r /mingw32/share/qt5/qml/QtMultimedia oss_bin/
cp -r /mingw32/share/qt5/qml/QtQuick oss_bin/
cp -r /mingw32/share/qt5/qml/QtQuick.2 oss_bin/
cp -r /mingw32/share/qt5/qml/QtWebKit oss_bin/
cp -r /mingw32/share/qt5/qml/Qt oss_bin/
cp /mingw32/bin/libbz2-1.dll oss_bin/
cp /mingw32/bin/libeay32.dll oss_bin/
cp /mingw32/bin/libfreetype-6.dll oss_bin/
cp /mingw32/bin/libgcc_s_dw2-1.dll oss_bin/
cp /mingw32/bin/libglib-2.0-0.dll oss_bin/
cp /mingw32/bin/libHalf-2_2.dll oss_bin/
cp /mingw32/bin/libharfbuzz-0.dll oss_bin/
cp /mingw32/bin/libiconv-2.dll oss_bin/
cp /mingw32/bin/libicudt56.dll oss_bin/
cp /mingw32/bin/libicuin56.dll oss_bin/
cp /mingw32/bin/libicuuc56.dll oss_bin/
cp /mingw32/bin/libIex-2_2.dll oss_bin/
cp /mingw32/bin/libIlmImf-2_2.dll oss_bin/
cp /mingw32/bin/libIlmThread-2_2.dll oss_bin/
cp /mingw32/bin/libImath-2_2.dll oss_bin/
cp /mingw32/bin/libintl-8.dll oss_bin/
cp /mingw32/bin/libjasper-1.dll oss_bin/
cp /mingw32/bin/libjpeg-8.dll oss_bin/
cp /mingw32/bin/liblzma-5.dll oss_bin/
cp /mingw32/bin/libopencv_core310.dll oss_bin/
cp /mingw32/bin/libopencv_imgcodecs310.dll oss_bin/
cp /mingw32/bin/libopencv_imgproc310.dll oss_bin/
cp /mingw32/bin/libopencv_videoio310.dll oss_bin/
cp /mingw32/bin/libpcre16-0.dll oss_bin/
cp /mingw32/bin/libpng16-16.dll oss_bin/
cp /mingw32/bin/libsqlite3-0.dll oss_bin/
cp /mingw32/bin/libstdc++-6.dll oss_bin/
cp /mingw32/bin/libtiff-5.dll oss_bin/
cp /mingw32/bin/libwebp-6.dll oss_bin/
cp /mingw32/bin/libwinpthread-1.dll oss_bin/
cp /mingw32/bin/libxml2-2.dll oss_bin/
cp /mingw32/bin/libxslt-1.dll oss_bin/
cp /mingw32/bin/Qt5Core.dll oss_bin/
cp /mingw32/bin/Qt5Gui.dll oss_bin/
cp /mingw32/bin/Qt5Multimedia.dll oss_bin/
cp /mingw32/bin/Qt5MultimediaQuick_p.dll oss_bin/
cp /mingw32/bin/Qt5MultimediaWidgets.dll oss_bin/
cp /mingw32/bin/Qt5Network.dll oss_bin/
cp /mingw32/bin/Qt5OpenGL.dll oss_bin/
cp /mingw32/bin/Qt5Positioning.dll oss_bin/
cp /mingw32/bin/Qt5PrintSupport.dll oss_bin/
cp /mingw32/bin/Qt5Qml.dll oss_bin/
cp /mingw32/bin/Qt5Quick.dll oss_bin/
cp /mingw32/bin/Qt5Sensors.dll oss_bin/
cp /mingw32/bin/Qt5Sql.dll oss_bin/
cp /mingw32/bin/Qt5Svg.dll oss_bin/
cp /mingw32/bin/Qt5WebChannel.dll oss_bin/
cp /mingw32/bin/Qt5WebKit.dll oss_bin/
cp /mingw32/bin/Qt5WebKitWidgets.dll oss_bin/
cp /mingw32/bin/Qt5Widgets.dll oss_bin/
cp /mingw32/bin/Qt5XmlPatterns.dll oss_bin/
cp /mingw32/bin/ssleay32.dll oss_bin/
cp /mingw32/bin/tbb.dll oss_bin/
cp /mingw32/bin/tbbmalloc.dll oss_bin/
cp /mingw32/bin/zlib1.dll oss_bin/
```
已经安装离线小搜在oss_bin/
------
##Android版本编译
以下内容可以根据最新版本自行修改
本过程基于Qt 5.5.1 for Android, OpenCV 3.1.0, Xapian 1.2.22, xz 5.2.2, Leptonica 1.73, tess-two 5.4.1编写,Windows x86(win7及以上)环境运行.
所有代码均在msys2中运行.
msys2下载地址:[http://msys2.github.io/](http://msys2.github.io/)
###0.准备项目
安装必须的软件,下载或克隆项目.
Qt下载地址:[http://www.qt.io/download-open-source/#section-2](http://www.qt.io/download-open-source/#section-2)
下载并安装Qt for Android以及Qt Creator
```
pacman -S --noconfirm --needed base-devel git unzip p7zip xz tar wget
git clone http://git.oschina.net/zjzdy/Offline-small-search
cd Offline-small-search/
export ossbuild=$PWD
```
###1.Android NDK
到Android NDK的官网去下载对应系统版本的Android NDK到本目录($PWD)下并运行 (注意把windows改成对应的系统)
下载地址:[http://developer.android.com/intl/zh-cn/ndk/downloads/index.html](http://developer.android.com/intl/zh-cn/ndk/downloads/index.html)
以下使用android-ndk-r10e-windows-x86.exe
```
./android-ndk-r10e-windows-x86.exe
cd android-ndk-r10e/
export NDK_ROOT=$PWD
export PATH=$PWD:$PATH
./build/tools/make-standalone-toolchain.sh --toolchain=arm-linux-androideabi-4.9 --stl=gnustl --system=windows --platform=android-9 --install-dir=../arm-linux-androideabi-4.9
cd ../
mkdir build-bin
mkdir build-bin/lib
mkdir build-bin/include
unzip img_include.zip -d build-bin/include/
```
###2.安装 OpenCV
到OpenCV的官网去下载最新版本的OpenCV android sdk
下载地址:[http://opencv.org/downloads.html](http://opencv.org/downloads.html)
以下使用OpenCV-3.1.0-android-sdk.zip
```
unzip OpenCV-3.1.0-android-sdk.zip OpenCV-android-sdk/sdk/native/libs/armeabi-v7a/* OpenCV-android-sdk/sdk/native/3rdparty/libs/armeabi-v7a/* -d ./build-bin/lib
cp build-bin/lib/OpenCV-android-sdk/sdk/native/libs/armeabi-v7a/* build-bin/lib/OpenCV-android-sdk/sdk/native/3rdparty/libs/armeabi-v7a/*  ./build-bin/lib
rm -rf build-bin/lib/OpenCV-android-sdk
mv ./build-bin/lib/liblibjasper.a ./build-bin/lib/libjasper.a
mv ./build-bin/lib/liblibjpeg.a ./build-bin/lib/libjpeg.a
mv ./build-bin/lib/liblibpng.a ./build-bin/lib/libpng.a
mv ./build-bin/lib/liblibtiff.a ./build-bin/lib/libtiff.a
mv ./build-bin/lib/liblibwebp.a ./build-bin/lib/libwebp.a
unzip OpenCV-3.1.0-android-sdk.zip OpenCV-android-sdk/sdk/native/jni/include/** -d ./build-bin/include/
cp -rf ./build-bin/include/OpenCV-android-sdk/sdk/native/jni/include/* ./build-bin/include/
rm -rf build-bin/include/OpenCV-android-sdk
```
###3.编译 liblzma
到XZ Utils的官网去下载最新版本的XZ Utils
下载地址:[http://tukaani.org/xz/](http://tukaani.org/xz/)
以下使用xz-5.2.2.tar.xz
```
wget http://tukaani.org/xz/xz-5.2.2.tar.xz
tar -xf xz-5.2.2.tar.xz
cd xz-5.2.2/
./configure --prefix="${ossbuild}/build-bin/" --host=arm-linux-androideabi CC="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-gcc.exe" CPP="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-cpp.exe" CXX="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-g++.exe" CXXCPP="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-cpp.exe" LDFLAGS=" -L${ossbuild}/arm-linux-androideabi-4.9/arm-linux-androideabi/lib -L${ossbuild}/build-bin/lib  -Wl,--fix-cortex-a8 -Wl,--gc-sections" CPPFLAGS=" -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3  -Wl,--fix-cortex-a8 -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC  -I${ossbuild}/build-bin/include -DANDROID_BUILD -DANDROID" CFLAGS=" -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3  -Wl,--fix-cortex-a8 -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC  -I${ossbuild}/build-bin/include -std=gnu11 -DANDROID_BUILD -DANDROID" CXXFLAGS="  -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3 -ffunction-sections -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC -I${ossbuild}/build-bin/include -std=gnu++11 -DANDROID_BUILD -DANDROID" --disable-xz --disable-xzdec --disable-lzmadec --disable-lzmainfo --disable-lzma-links --disable-scripts --disable-doc 
make
make install
cd ../
```
###4.编译 libuuid
```
cd libuuid
autoreconf -ivf
./configure --prefix="${ossbuild}/build-bin/" --host=arm-linux-androideabi CC="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-gcc.exe" CPP="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-cpp.exe" CXX="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-g++.exe" CXXCPP="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-cpp.exe" LDFLAGS=" -L${ossbuild}/arm-linux-androideabi-4.9/arm-linux-androideabi/lib -L${ossbuild}/build-bin/lib  -Wl,--fix-cortex-a8 -Wl,--gc-sections" CPPFLAGS=" -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3  -Wl,--fix-cortex-a8 -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC  -I${ossbuild}/build-bin/include -DANDROID_BUILD -DANDROID" CFLAGS=" -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3  -Wl,--fix-cortex-a8 -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC  -I${ossbuild}/build-bin/include -std=gnu11 -DANDROID_BUILD -DANDROID" CXXFLAGS="  -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3 -ffunction-sections -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC -I${ossbuild}/build-bin/include -std=gnu++11 -DANDROID_BUILD -DANDROID"
make
make install
cd ../
```
###5.编译 Xapian
到Xapian的官网去下载最新版本的Xapian core
下载地址:[http://xapian.org/download](http://xapian.org/download)
以下使用xapian-core-1.2.22.tar.xz
```
wget http://oligarchy.co.uk/xapian/1.2.22/xapian-core-1.2.22.tar.xz
tar -xf xapian-core-1.2.22.tar.xz
cd xapian-core-1.2.22/
./configure --prefix="${ossbuild}/build-bin/" --host=arm-linux-androideabi CC="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-gcc.exe" CPP="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-cpp.exe" CXX="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-g++.exe" CXXCPP="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-cpp.exe" LDFLAGS=" -L${ossbuild}/arm-linux-androideabi-4.9/arm-linux-androideabi/lib -L${ossbuild}/build-bin/lib  -Wl,--fix-cortex-a8 -Wl,--gc-sections" CPPFLAGS=" -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3  -Wl,--fix-cortex-a8 -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC  -I${ossbuild}/build-bin/include -DANDROID_BUILD -DANDROID" CFLAGS=" -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3  -Wl,--fix-cortex-a8 -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC  -I${ossbuild}/build-bin/include -std=gnu11 -DANDROID_BUILD -DANDROID" CXXFLAGS="  -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3 -ffunction-sections -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC -I${ossbuild}/build-bin/include -std=gnu++11 -DANDROID_BUILD -DANDROID" --enable-backend-inmemory=no
sed -i 's/HAVE_DECL_SYS_ERRLIST 1/HAVE_DECL_SYS_ERRLIST 0/g' config.h
sed -i 's/HAVE_DECL_SYS_NERR 1/HAVE_DECL_SYS_NERR 0/g' config.h
make
make install
cd ../
```
###6.编译 Leptonica
到Leptonica的官网去下载最新版本的Leptonica
下载地址:[http://www.leptonica.com/download.html](http://www.leptonica.com/download.html)
以下使用leptonica-1.73.tar.gz
```
wget http://www.leptonica.com/source/leptonica-1.73.tar.gz
tar -xf leptonica-1.73.tar.gz
cd leptonica-1.73/
./configure --prefix="${ossbuild}/build-bin/" --host=arm-linux-androideabi CC="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-gcc.exe" CPP="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-cpp.exe" CXX="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-g++.exe" CXXCPP="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-cpp.exe" LDFLAGS=" -L${ossbuild}/arm-linux-androideabi-4.9/arm-linux-androideabi/lib -L${ossbuild}/build-bin/lib  -Wl,--fix-cortex-a8 -Wl,--gc-sections" CPPFLAGS=" -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3  -Wl,--fix-cortex-a8 -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC  -I${ossbuild}/build-bin/include -DANDROID_BUILD -DANDROID" CFLAGS=" -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3  -Wl,--fix-cortex-a8 -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC  -I${ossbuild}/build-bin/include -std=gnu11 -DANDROID_BUILD -DANDROID" CXXFLAGS="  -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3 -ffunction-sections -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC -I${ossbuild}/build-bin/include -std=gnu++11 -DANDROID_BUILD -DANDROID" 
make
make install
cd ../
```
###7.编译 tess-two
到tess-two的releases去下载最新版本的tess-two
下载地址:[https://github.com/rmtheis/tess-two/releases](https://github.com/rmtheis/tess-two/releases)
```
wget https://github.com/rmtheis/tess-two/archive/5.4.1.tar.gz
tar -xf 5.4.1.tar.gz
cd tess-two-5.4.1/
sed -i 's/android-8/android-9/g' tess-two/project.properties
sed -i 's/android:minSdkVersion="8"/android:minSdkVersion="9"/g' tess-two/AndroidManifest.xml
sed -i 's/android:targetSdkVersion="22"/android:targetSdkVersion="18"/g' tess-two/AndroidManifest.xml
sed -i 's/LOCAL_SHARED_LIBRARIES/LOCAL_STATIC_LIBRARIES/g' tess-two/jni/com_googlecode_tesseract_android/Android.mk
sed -i 's/BUILD_SHARED_LIBRARY/BUILD_STATIC_LIBRARY/g' tess-two/jni/com_googlecode_tesseract_android/Android.mk
sed -i 's/LEPTONICA_PATH/#LEPTONICA_PATH/g' tess-two/jni/Android.mk
sed -i 's/LIBPNG_PATH/#LIBPNG_PATH/g' tess-two/jni/Android.mk
sed -i 's/NDK_TOOLCHAIN_VERSION := 4.8/NDK_TOOLCHAIN_VERSION := 4.9/g' tess-two/jni/Application.mk
sed -i 's/APP_ABI/APP_ABI := armeabi-v7a #/g' tess-two/jni/Application.mk
sed -i 's/APP_PLATFORM/APP_PLATFORM := android-9 #/g' tess-two/jni/Application.mk
echo "APP_CPPFLAGS += -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3 -Wl,--fix-cortex-a8 -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -fPIC  -I${ossbuild}/build-bin/include -I${ossbuild}/build-bin/include/leptonica -L${ossbuild}/build-bin/lib -Wl,--gc-sections" >> tess-two/jni/Application.mk
echo "APP_CFLAGS += -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3 -Wl,--fix-cortex-a8 -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -fPIC  -I${ossbuild}/build-bin/include -I${ossbuild}/build-bin/include/leptonica -L${ossbuild}/build-bin/lib -Wl,--gc-sections" >> tess-two/jni/Application.mk
echo "APP_LFLAGS += -Wl,--fix-cortex-a8 -fPIC -L${ossbuild}/build-bin/lib -Wl,--gc-sections" >> tess-two/jni/Application.mk
echo "APP_LDFLAGS += -Wl,--fix-cortex-a8 -fPIC -L${ossbuild}/build-bin/lib -Wl,--gc-sections" >> tess-two/jni/Application.mk
rm -rf tess-two/jni/com_googlecode_leptonica_android
rm -rf tess-two/jni/libpng
cd tess-two/
ndk-build
cp obj/local/armeabi-v7a/libtess.a ../../build-bin/lib/
mkdir ../../build-bin/include/tesseract
find . -name "*.h" -exec cp {} ../../build-bin/include/tesseract \;
cd ../../
sed -i 's/template <class T> struct remove_reference;//g' build-bin/include/tesseract/tesscallback.h
sed -i 's/template<typename T> struct remove_reference { typedef T type; };//g' build-bin/include/tesseract/tesscallback.h
sed -i 's/template<typename T> struct remove_reference<T&> { typedef T type; };//g' build-bin/include/tesseract/tesscallback.h
```
###8.编译 zimlib
```
cd zimlib/
./autogen.sh
./configure --prefix="${ossbuild}/build-bin/" --host=arm-linux-androideabi CC="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-gcc.exe" CPP="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-cpp.exe" CXX="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-g++.exe" CXXCPP="${ossbuild}/arm-linux-androideabi-4.9/bin/arm-linux-androideabi-cpp.exe" LDFLAGS=" -L${ossbuild}/arm-linux-androideabi-4.9/arm-linux-androideabi/lib -L${ossbuild}/build-bin/lib  -Wl,--fix-cortex-a8 -Wl,--gc-sections" CPPFLAGS=" -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3  -Wl,--fix-cortex-a8 -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC  -I${ossbuild}/build-bin/include -DANDROID_BUILD -DANDROID" CFLAGS=" -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3  -Wl,--fix-cortex-a8 -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC  -I${ossbuild}/build-bin/include -std=gnu11 -DANDROID_BUILD -DANDROID" CXXFLAGS="  -Wno-psabi -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3 -ffunction-sections -DNDEBUG -funwind-tables -fstack-protector -fno-short-enums -DANDROID -Wa,--noexecstack -fno-builtin-memmove -O2 -Os -fomit-frame-pointer -fno-strict-aliasing -mthumb -D_REENTRANT -fPIC -I${ossbuild}/build-bin/include -std=gnu++11 -DANDROID_BUILD -DANDROID" 
make
make install
cd ../
```
###9.编译 离线小搜
1.配置好Android (armeabi-v7a) for Qt的环境(包括SDK,NDK,ant,Java)
2.打开Qt Creator
3.打开Offline_small_search.pro
4.选择配置Android for armeabi-v7a (GCC 4.9)
5.选择Release
6.在"项目"选项的"构建步骤"里的"Build Android APK"中的"Android build SDK"选择android-18
7.点击构建

##感谢以下的项目,排名不分先后:
* Qt: [http://www.qt.io/](http://www.qt.io/)
* Zimlib: [http://www.openzim.org/wiki/Zimlib](http://www.openzim.org/wiki/Zimlib) [https://git.wikimedia.org/summary/openzim](https://git.wikimedia.org/summary/openzim)
* Xpian: [http://xapian.org](http://xapian.org)
* libuuid: [http://sourceforge.net/projects/libuuid](http://sourceforge.net/projects/libuuid)
* OpenCV: [http://www.opencv.org](http://www.opencv.org)
* Tesseract: [https://github.com/tesseract-ocr/tesseract](https://github.com/tesseract-ocr/tesseract)
* Zeal: [https://zealdocs.org](https://zealdocs.org)
* Dash: [https://kapeli.com](https://kapeli.com)


##已知问题
1. 离线包目录不可以包含中文.
2. 打开文件对话框后返回键失效
3. 部分js或css及嵌套html会加载失败(将在3.0版修复)
4. 用QtWebKit替换QtWebView会造成runJavaScript函数不存在,导致翻译功能失效

##TODO
1. 插件功能,自定义一个qml文件和动态链接库,动态加载链接库和qml文件实现扩展功能(3.1)
2. 在线更新功能(3.0)
+ 3. 进行3.0版的重构(此项将于2017年高考完成后进行)
	+ 3.1 采用网页服务器方式进行内容浏览(预计使用Tufao)
	+ 3.2 整理界面代码和业务逻辑
		+ 3.2.1 使用QHash或QMap存储设置以及除离线包外的数据(历史纪录,收藏夹,离线包的部分元数据)
	+ 3.3 支持对docset的索引(SQLite)进行查询(Dash及Zeal)
4. 索引改用Xapian的glassify格式,使用单一文件"data.idx"(Xapian 1.3.4及以上)
```
Xapian::WritableDatabase db_out(dest, Xapian::DB_CREATE|Xapian::DB_BACKEND_GLASS);
db_out.compact("data.idx",Xapian::DBCOMPACT_SINGLE_FILE)
```
转换到glassify格式的单一文件的参考代码:[glassify.cc](https://github.com/kiwix/kiwix/blob/master/android/glassify.cc)
5. 终极目标:对Kiwix及Zeal的功能进行整合,能做为一个帮助服务器使用,支持自定义插件(包括在线检索,语音搜索,对显示的内容的操作:如翻译)