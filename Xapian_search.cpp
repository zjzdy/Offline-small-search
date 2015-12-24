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
		/*
        indexReaders = Collection<IndexReaderPtr>::newInstance(dir.size());
        for(int i = 0; i < dir.size(); ++i)
        {
            indexReaders[i] = IndexReader::open(FSDirectory::open(dir.at(i).toStdWString()), true);
        }
        reader = newLucene<MultiReader>(indexReaders);
        searcher = newLucene<IndexSearcher>(reader);
		*/
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
		Xapian::Query query;
        Xapian::Enquire enquire(db);
		termgen.set_document(doc);
		termgen.index_text_without_positions(str.toStdString(),1,"C");
		runing = "Add Term!";
		Xapian::TermIterator it;
		for (it = doc.termlist_begin(); it != doc.termlist_end(); ++it)
		{
			if (query.empty())
				query = Xapian::Query(*it,it.get_wdf());
			else
				query = Xapian::Query(Xapian::Query::OP_OR,query,Xapian::Query(*it,it.get_wdf()));
		}
        if (query.empty())
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
        Xapian::MSet matches = enquire.get_mset(0, 20);
		for (Xapian::MSetIterator i = matches.begin(); i != matches.end(); ++i)
		{
			urls.append(QString::fromStdString(i.get_document().get_value(1)+":/"+i.get_document().get_data()));
		}
		/*
        runing = "BooleanQueryPtr query_N = newLucene<BooleanQuery>() Error!";
        BooleanQueryPtr query_N = newLucene<BooleanQuery>();
        runing = "QList<TermQueryPtr> query_Ns Error!";
        QList<TermQueryPtr> query_Ns;
        runing = "BooleanQueryPtr query = newLucene<BooleanQuery>() Error!";
        BooleanQueryPtr query = newLucene<BooleanQuery>();
        //type->query_Ns
        runing = "query_Ns.append(newLucene<TermQuery>(term_N->createTerm(type.at(i1).toStdWString()))) for loop start Error!";
        for(int i1 = 0; i1 < type.size(); ++i1)
        {
            runing = "query_Ns.append(newLucene<TermQuery>(term_N->createTerm("+type.at(i1)+".toStdWString()))) Error!";
            query_Ns.append(newLucene<TermQuery>(term_N->createTerm(type.at(i1).toStdWString())));
        }
        //query_Ns->query_N
        runing = "query_N->add(query_Ns.at(i2),BooleanClause::Occur::SHOULD) for loop Error!";
        for(int i2 = 0; i2 < query_Ns.size(); ++i2)
        {
            query_N->add(query_Ns.at(i2),BooleanClause::Occur::SHOULD);
        }
        //query&str->query
        runing = "query->add(query_N,BooleanClause::Occur::MUST) Error!";
        query->add(query_N,BooleanClause::Occur::MUST);
        runing = "query->add(parser->parse(parser->escape(str2("+str2+").toStdWString())),BooleanClause::Occur::MUST) Error!";
        query->add(parser->parse(Lucene::QueryParser::escape(str2.toStdWString())),BooleanClause::Occur::MUST);
        //search
        runing = "Collection<ScoreDocPtr> hits = searcher->search(query, 15)->scoreDocs Error!";
        Collection<ScoreDocPtr> hits = searcher->search(query, 15)->scoreDocs;
        int32_t end = hits.size();
        for (int32_t i = 0; i < end; ++i)
        {
            runing = "urls.append(QString::fromStdWString(searcher->doc(hits[i]->doc)->get(L\"N\"))+\":/\"+QString::fromStdWString(searcher->doc(hits[i]->doc)->get(L\"P\"))) Error!";
            urls.append(QString::fromStdWString(searcher->doc(hits[i]->doc)->get(L"N"))+":/"+QString::fromStdWString(searcher->doc(hits[i]->doc)->get(L"P")));
        }
		*/
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
