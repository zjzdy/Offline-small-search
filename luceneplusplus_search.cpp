#include "luceneplusplus_search.h"
#include <QDebug>

LucenePlusPlus_search::LucenePlusPlus_search(QObject *parent) : QObject(parent)
{
    zw.setMinimal(true);
    zw.setPattern("<.*>");
    //init friso
    friso = friso_new();
    config = friso_new_config();
    task = friso_new_task();
    friso->dic = friso_dic_new();
    config->max_len = 8;
    config->add_syn = 1;//search use 1
    config->keep_urec = 1;
    friso->charset = (friso_charset_t) 0;
    config->st_minl = 2;
    memcpy(config->kpuncs, "@%.#&+", 6);
    config->mode = (friso_mode_t) 2;
    friso_set_mode(config, config->mode);
    //config->kpuncs = "@%.#&+";
    friso_dic_load_from_ifile( friso, config,
            (fstring)"./dict/", config->max_len * (friso->charset == FRISO_UTF8 ? 3 : 2) );

    try{
        term_N = newLucene<Term>(StringUtils::toUnicode("N"));
        analyzer = newLucene<WhitespaceAnalyzer>();
        parser = newLucene<QueryParser>(LuceneVersion::LUCENE_CURRENT, StringUtils::toUnicode("C"), analyzer);
        parser->setDefaultOperator(QueryParser::OR_OPERATOR);
    }
    catch(...){Q_EMIT init_finish(-3);}
}

void LucenePlusPlus_search::on_init(QStringList dir, int batch)
{
    try{
        indexReaders = Collection<IndexReaderPtr>::newInstance(dir.size());
        for(int i = 0; i < dir.size(); ++i)
        {
            indexReaders[i] = IndexReader::open(FSDirectory::open(dir.at(i).toStdWString()), true);
        }
        reader = newLucene<MultiReader>(indexReaders);
        searcher = newLucene<IndexSearcher>(reader);
        Q_EMIT init_finish(batch);
    }
    catch(exception& e)
    {
        stringstream e2;
        e2<<e.what();
        Q_EMIT init_finish(-1);
    }
    catch(...){Q_EMIT init_finish(-2);}
}

void LucenePlusPlus_search::on_search(QString str, int batch, QStringList type)
{
    QStringList urls;
    words.clear();
    str2.clear();
    str.remove("\n").remove("\t").remove("\r");
    in_str_c = str.toStdString().c_str();
    in_str = new char[str.toStdString().length()+1];
    strcpy(in_str,in_str_c);
    friso_set_text( task, in_str );
    while ( ( config->next_token( friso, config, task ) ) != NULL )
    {
        str2.append(task->token->word);
        str2.append(" ");
    }

    if(str2.isEmpty()||str2.isNull()||str2 == " "||str2.indexOf(QRegExp("[A-Za-z0-9\\x31C0-\\x9FCC]")) == -1)
    {
        int try_count = 0;
        QString str3 = str;
        string str_c = str3.toStdString();
        while((str2.isEmpty()||str2.isNull()||str2 == " "||str2.indexOf(QRegExp("[A-Za-z0-9\\x31C0-\\x9FCC]")) == -1 )&& try_count < FRISO_MAX_TRY_COUNT)
        {
            delete[] in_str;
            in_str_c = str_c.c_str();
            in_str = new char[str_c.length()+1];
            strcpy(in_str,in_str_c);
            friso_set_text( task, in_str );
            while ( ( config->next_token( friso, config, task ) ) != NULL )
            {
                str2.append(task->token->word);
                str2.append(" ");
            }
            ++try_count;
        }
    }


    if((str2.isEmpty()||str2.isNull()||str2 == " "||str2.indexOf(QRegExp("[A-Za-z0-9\\x31C0-\\x9FCC]")) == -1)&&str != str2)
    {
        QString d2 = str;
        d2.replace(QRegExp("[\\x31C0-\\x9FCC]")," ");
        d2.remove(QRegExp("[^A-Za-z0-9 ]"));
        d2.replace(QRegExp(" {2,}")," ");
        str2.append(" "+d2.toLower());
    }

    str2.append(segment_2(str));
    str2.replace("  "," ");
    qDebug()<<str2;
    delete[] in_str;

    try{
        BooleanQueryPtr query_N = newLucene<BooleanQuery>();
        QList<TermQueryPtr> query_Ns;
        BooleanQueryPtr query = newLucene<BooleanQuery>();
        //type->query_Ns
        for(int i1 = 0; i1 < type.size(); ++i1)
        {
            query_Ns.append(newLucene<TermQuery>(term_N->createTerm(type.at(i1).toStdWString())));
        }
        //query_Ns->query_N
        for(int i2 = 0; i2 < query_Ns.size(); ++i2)
        {
            query_N->add(query_Ns.at(i2),BooleanClause::Occur::SHOULD);
        }
        //query&str->query
        query->add(query_N,BooleanClause::Occur::MUST);
        query->add(parser->parse(str2.toStdWString()),BooleanClause::Occur::MUST);
        //search
        Collection<ScoreDocPtr> hits = searcher->search(query, 15)->scoreDocs;
        int32_t end = hits.size();
        for (int32_t i = 0; i < end; ++i)
        {
            urls.append(QString::fromStdWString(searcher->doc(hits[i]->doc)->get(L"N"))+":/"+QString::fromStdWString(searcher->doc(hits[i]->doc)->get(L"P")));
        }
        Q_EMIT search_result(urls,batch);
    }
    catch(exception& e)
    {
        stringstream e2;
        e2<<e.what();
        urls.append(QString::fromStdString(e2.str()));
        Q_EMIT search_result(urls,-1);
        qDebug()<<"search3"<<batch<<str<<type<<urls;
    }
    catch(...)
    {
        urls.append("Unknow Error");
        Q_EMIT search_result(urls,-2);
        qDebug()<<"search4"<<batch<<str<<type;
    }
}

QString LucenePlusPlus_search::segment_2(QString src)
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
