#include "luceneplusplus_search.h"
#include <QDebug>

LucenePlusPlus_search::LucenePlusPlus_search(QObject *parent) : QObject(parent)
{
    zw.setMinimal(true);
    zw.setPattern("<.*>");
    segment = new QuerySegment("dict.utf8","hmm_model.utf8","",3);
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
    str.remove("题文<p>").remove("<hr><p>属性").remove("<hr><p>答案").remove("题型").remove("难度").remove("科目").remove("来源").remove("知识点").remove(zw).remove(";").remove("[").remove("]").remove("，").remove("。").remove("_").remove("：").remove("；").remove(":").remove("．").remove("？").remove("?").remove("&nbsp").remove("&quot").remove(" ").remove("\n").remove("\n ").remove("\t").remove("\r");
    segment->cut(str.toStdString(), words);
    for (auto g = words.begin();g != words.end();++g)
    {
        word2 = QString::fromStdString(*g).toLower();
        if(word2 == "℃"||word2 == "℉"||word2 == "%"||word2 == "‰"||word2 == "％"||word2 == "％"||word2 == "％"||word2 == "°"
                ||word2 == "㎎"||word2 == "㎏"||word2 == "㎜"||word2 == "㎝"||word2 == "㎞"||word2 == "㏄"||word2 == "㏕"
                ||word2 == "mg"||word2 == "kg"||word2 == "mm"||word2 == "cm"||word2 == "km"||word2 == "cc"||word2 == "mil"
                ||word2 == "′"||word2 == "″"||word2 == "㎡"||word2 == "㎥"||word2 == "ml"||word2 == "mol"||word2 == "μm")
        {
            str2.append(word2);
        }
        else
        {
            str2.append(" "+word2);
        }
    }
    str2.append(segment_2(str));
    str2.replace("  "," ");

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
