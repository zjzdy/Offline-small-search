#ifndef Xapian_search_THREAD_H
#define Xapian_search_THREAD_H

#include <QObject>
#include <QThread>
#include "Xapian_search.h"

class Xapian_search_thread : public QThread
{
    Q_OBJECT

public:
    Xapian_search_thread();
    void run();

Q_SIGNALS:
    void search(QString str, int batch, QStringList type);
    void search_result(QStringList urls, QStringList key_words, int batch);
    void init(QStringList dir, int batch);
    void init_finish(int batch);
    void init_obj_finish();

};

#endif // Xapian_search_THREAD_H
