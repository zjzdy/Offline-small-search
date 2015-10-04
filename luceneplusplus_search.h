#ifndef LUCENEPLUSPLUS_SEARCH_H
#define LUCENEPLUSPLUS_SEARCH_H

//Qt
#include <QObject>
#include <QFile>
#include <QFileInfoList>
#include <QFileInfo>
#include <QDir>
#include <QFileDialog>
#include <QRegExp>
#include <QString>
#include <QByteArray>
#include <QDirIterator>
#include <QDataStream>
#include <QList>

//friso
#ifdef __cplusplus
extern "C" {
#endif
#include <string.h>
#include "friso/friso.h"
#include "friso/friso_API.h"
#include "friso/friso_ctype.h"
#ifdef __cplusplus
}
#endif

//LucenePlusPlus
#include "lucene++/targetver.h"
#include "lucene++/LuceneHeaders.h"
#include "lucene++/IndexWriter.h"
#include "lucene++/WhitespaceAnalyzer.h"
#include "lucene++/Document.h"
#include "lucene++/Field.h"
#include "lucene++/IndexSearcher.h"
#include "lucene++/FuzzyQuery.h"
#include "lucene++/Term.h"
#include "lucene++/ScoreDoc.h"
#include "lucene++/TopDocs.h"
#include "lucene++/BooleanQuery.h"
#include "lucene++/StandardAnalyzer.h"
#include "lucene++/QueryParser.h"
#include "lucene++/IndexReader.h"
#include "lucene++/DirectoryReader.h"
#include "lucene++/Directory.h"
#include "lucene++/MultiReader.h"
#include "lucene++/MultiSearcher.h"
#include "lucene++/Collection.h"
#include "lucene++/FSDirectory.h"
#include "lucene++/SimpleFSDirectory.h"
#include "lucene++/ReadOnlyDirectoryReader.h"
#include "lucene++/Collector.h"

//c++
#include <iomanip>
#include <string>
#include <fstream>
#include <iostream>
#include <sstream>
#include <vector>
#include <queue>
#include <map>
#include <ctime>
#include <cstdio>
#include <cerrno>
#include <cstdlib>
#include <stdexcept>

using namespace std;
using namespace Lucene;

#ifndef FRISO_MAX_TRY_COUNT
#define FRISO_MAX_TRY_COUNT 10
#endif

class LucenePlusPlus_search : public QObject
{
    Q_OBJECT
public:
    explicit LucenePlusPlus_search(QObject *parent = 0);

Q_SIGNALS:
    void search_result(QStringList urls, int batch);
    void init_finish(int batch);

public Q_SLOTS:
    void on_init(QStringList dir, int batch);
    void on_search(QString str, int batch, QStringList type);

private:
    //friso
    friso_t friso;
    friso_config_t config;
    friso_task_t task;
    const char* in_str_c;
    char* in_str;
    //Qt
    QString segment_2(QString src);
    QRegExp zw;
    QString str2;
    QString word2;
    vector<string> words;
    //LucenePlusPlus
    Collection<IndexReaderPtr> indexReaders;
    IndexReaderPtr reader;
    SearcherPtr searcher;
    AnalyzerPtr analyzer;
    QueryParserPtr parser;
    TermPtr term_N;
};

#endif // LUCENEPLUSPLUS_SEARCH_H
