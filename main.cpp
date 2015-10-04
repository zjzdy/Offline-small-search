#include "offline_small_search.h"
#include <QApplication>
#include <QSplashScreen>

int main(int argc, char *argv[])
{
    QApplication a(argc, argv);
#ifdef ANDROID
    QSplashScreen splash(QPixmap(":/image/splash.png"));
#else
    QSplashScreen splash(QPixmap(":/image/splash.png"));
#endif
    splash.setDisabled(true);
    splash.show();
    Offline_small_search w;
    w.show();
    splash.finish(&w);

    return a.exec();
}
