#ifndef LUCENEPLUSPLUS_SEARCH_H
#define LUCENEPLUSPLUS_SEARCH_H

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
#include "MPSegment.hpp"
#include "FullSegment.hpp"
#include "QuerySegment.hpp"
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
using namespace CppJieba;
using namespace Lucene;

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
    QString segment_2(QString src);
    QuerySegment *segment;
    QRegExp zw;
    QString str2;
    QString word2;
    vector<string> words;
    Collection<IndexReaderPtr> indexReaders;
    IndexReaderPtr reader;
    SearcherPtr searcher;
    AnalyzerPtr analyzer;
    QueryParserPtr parser;
    TermPtr term_N;
};

#endif // LUCENEPLUSPLUS_SEARCH_H
