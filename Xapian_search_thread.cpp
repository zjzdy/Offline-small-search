#include "Xapian_search_thread.h"

Xapian_search_thread::Xapian_search_thread()
{

}

void Xapian_search_thread::run()
{
    Xapian_search search;
    QObject::connect(&search,SIGNAL(search_result(QStringList,QStringList,int)),this,SIGNAL(search_result(QStringList,QStringList,int)));
    QObject::connect(&search,SIGNAL(init_finish(int)),this,SIGNAL(init_finish(int)));
    QObject::connect(this,SIGNAL(init(QStringList,int)),&search,SLOT(on_init(QStringList,int)));
    QObject::connect(this,SIGNAL(search(QString,int,QStringList)),&search,SLOT(on_search(QString,int,QStringList)));
    Q_EMIT init_obj_finish();
    exec();
}
