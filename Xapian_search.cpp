#include "Xapian_search.h"
#include <QDebug>

Xapian_search::Xapian_search(QObject *parent) : QObject(parent)
{
    qDebug()<<"start xapian";
#ifdef HAVE__PUTENV_S
    _putenv_s("XAPIAN_CJK_NGRAM", "1");
#elif defined HAVE_SETENV
    setenv("XAPIAN_CJK_NGRAM", "1", 1);
#else
    putenv(const_cast<char*>("XAPIAN_CJK_NGRAM=1"));
#endif
}

void Xapian_search::on_init(QStringList dir, int batch)
{
    qDebug()<<"init search in xapian";
    try{
        db = Xapian::Database();
		for(int i = 0; i < dir.size(); ++i)
        {
            db.add_database(Xapian::Database(dir.at(i).toStdString()));
        }
        //enquire = shared_ptr<Xapian::Enquire>(new Xapian::Enquire(db));
        Q_EMIT init_finish(batch);
    }
    catch(exception& e)
    {
        stringstream e2;
        e2<<e.what();
        qDebug()<<e.what();
        Q_EMIT init_finish(-1);
    }
    catch(...)
    {
        Q_EMIT init_finish(-2);
    }
}

void Xapian_search::on_search(QString str, int batch, QStringList type)
{
    QStringList urls;
    QString runing = "";
    runing = "Strat try!";

    try{
		Xapian::Document doc;
        //Xapian::Query query;
        Xapian::Enquire enquire(db);
		termgen.set_document(doc);
		termgen.index_text_without_positions(str.toStdString(),1,"C");
		runing = "Add Term!";
		Xapian::TermIterator it;
        QList<Xapian::Query> querys;
		for (it = doc.termlist_begin(); it != doc.termlist_end(); ++it)
		{
            querys.append(Xapian::Query(*it,it.get_wdf()));
            /*
			if (query.empty())
				query = Xapian::Query(*it,it.get_wdf());
			else
				query = Xapian::Query(Xapian::Query::OP_OR,query,Xapian::Query(*it,it.get_wdf()));
            */
		}
        Xapian::Query query(Xapian::Query::OP_ELITE_SET, querys.begin(), querys.end(), 20);
        if (query.empty() || querys.empty())
        {
            qDebug()<<"query is empty"<<str<<batch<<type;
            Q_EMIT search_result(urls,batch);
        }
        Xapian::Query name_query;
		for(int i1 = 0; i1 < type.size(); ++i1)
        {
            if (name_query.empty())
                name_query = Xapian::Query(Xapian::Query::OP_VALUE_RANGE,1,type.at(i1).toStdString(),type.at(i1).toStdString());
			else
                name_query = Xapian::Query(Xapian::Query::OP_OR,name_query,Xapian::Query(Xapian::Query::OP_VALUE_RANGE,1,type.at(i1).toStdString(),type.at(i1).toStdString()));
        }
        query = Xapian::Query(Xapian::Query::OP_AND,query,name_query);
		runing = "Strat query!";
        enquire.set_query(query);
        Xapian::MSet matches = enquire.get_mset(0, 25);
		for (Xapian::MSetIterator i = matches.begin(); i != matches.end(); ++i)
		{
			urls.append(QString::fromStdString(i.get_document().get_value(1)+":/"+i.get_document().get_data()));
        }
        //qDebug()<<"search result(url):"<<urls<<batch;
        Q_EMIT search_result(urls,batch);
    }
    catch(exception& e)
    {
        stringstream e2;
        e2<<e.what();
        urls.append(QString::fromStdString(e2.str()));
        urls.append("Happen Error:"+runing);
        Q_EMIT search_result(urls,-1);
        qDebug()<<"search3"<<batch<<str<<type<<urls<<runing;
    }
    catch(...)
    {
        urls.append("Unknow Error");
        Q_EMIT search_result(urls,-2);
        qDebug()<<"search4"<<batch<<str<<type;
    }
}
/*
QString Xapian_search::segment_2(QString src)
{
    QString a = src.remove(QRegExp("[^\\x31C0-\\x9FCC]"));
    QString c;
    int b = a.length()-1;
    for(int i = 0;i<b;++i)
    {
        c.append(" "+a.mid(i,2));
    }
    return c;
}
*/
