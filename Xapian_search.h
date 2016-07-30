#ifndef Xapian_search_H
#define Xapian_search_H

//Qt
#include <QObject>
#include <QFile>
#include <QFileInfoList>
#include <QFileInfo>
#include <QDir>
#include <QRegExp>
#include <QString>
#include <QStringList>
#include <QByteArray>
#include <QDirIterator>
#include <QDataStream>
#include <QList>

//Xapian
#include <xapian.h>
#ifndef NO_OPENCC
//OpenCC
#include <opencc/opencc.h>
#endif
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
#include <memory>
#include <stdexcept>

using namespace std;

#ifndef FRISO_MAX_TRY_COUNT
#define FRISO_MAX_TRY_COUNT 10
#endif

class Xapian_search : public QObject
{
    Q_OBJECT
public:
    explicit Xapian_search(QObject *parent = 0);

Q_SIGNALS:
    void search_result(QStringList urls, QStringList key_words, int batch);
    void init_finish(int batch);

public Q_SLOTS:
    void on_init(QStringList dir, int batch);
    void on_search(QString str, int batch, QStringList type);

private:
	//xapian
    Xapian::Database db;
    Xapian::TermGenerator termgen;
    Xapian::Stem enstem;
#ifndef NO_OPENCC
    //OpenCC
    bool enable_opencc;
    opencc::SimpleConverter *opencc_s2t;
    opencc::SimpleConverter *opencc_t2s;
#endif
};

#endif // Xapian_search_H
