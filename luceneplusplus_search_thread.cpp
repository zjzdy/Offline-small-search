#include "luceneplusplus_search_thread.h"

LucenePlusPlus_search_thread::LucenePlusPlus_search_thread()
{

}

void LucenePlusPlus_search_thread::run()
{
    LucenePlusPlus_search search;
    QObject::connect(&search,SIGNAL(search_result(QStringList,int)),this,SIGNAL(search_result(QStringList,int)));
    QObject::connect(&search,SIGNAL(init_finish(int)),this,SIGNAL(init_finish(int)));
    QObject::connect(this,SIGNAL(init(QStringList,int)),&search,SLOT(on_init(QStringList,int)));
    QObject::connect(this,SIGNAL(search(QString,int,QStringList)),&search,SLOT(on_search(QString,int,QStringList)));
    Q_EMIT init_obj_finish();
    exec();
}
