#include "unzip_thread.h"

unzip_o::unzip_o()
{

}

void unzip_o::on_unzip(QString zipfile, QString dir, int batch)
{
    JlCompress::extractDir(zipfile, dir);
    QFile::remove(zipfile);
    Q_EMIT unzip_finish(batch,dir);
}

unzip_thread::unzip_thread()
{

}

void unzip_thread::run()
{
    unzip_o unzip_obj;
    QObject::connect(&unzip_obj,SIGNAL(unzip_finish(int,QString)),this,SIGNAL(unzip_finish(int,QString)));
    QObject::connect(this,SIGNAL(unzip(QString,QString,int)),&unzip_obj,SLOT(on_unzip(QString,QString,int)));
    exec();
}
