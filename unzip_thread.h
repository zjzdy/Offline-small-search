#ifndef UNZIP_THREAD_H
#define UNZIP_THREAD_H

#include <QObject>
#include <QThread>
#include <QString>
#include "quazip/JlCompress.h"

class unzip_o : public QObject
{
    Q_OBJECT

public:
    unzip_o();

public Q_SLOTS:
    void on_unzip(QString zipfile, QString dir, int batch);

Q_SIGNALS:
    void unzip_finish(int batch);

};

class unzip_thread : public QThread
{
    Q_OBJECT

public:
    unzip_thread();
    void run();

Q_SIGNALS:
    void unzip(QString zipfile, QString dir, int batch);
    void unzip_finish(int batch);
};

#endif // UNZIP_THREAD_H
