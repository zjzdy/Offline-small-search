#ifndef LUCENEPLUSPLUS_SEARCH_THREAD_H
#define LUCENEPLUSPLUS_SEARCH_THREAD_H

#include <QObject>
#include <QThread>
#include "luceneplusplus_search.h"

class LucenePlusPlus_search_thread : public QThread
{
    Q_OBJECT

public:
    LucenePlusPlus_search_thread();
    void run();

Q_SIGNALS:
    void search(QString str, int batch, QStringList type);
    void search_result(QStringList urls, int batch);
    void init(QStringList dir, int batch);
    void init_finish(int batch);
    void init_obj_finish();

};

#endif // LUCENEPLUSPLUS_SEARCH_THREAD_H
