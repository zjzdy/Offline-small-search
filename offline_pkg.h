#ifndef OFFLINE_PKG_H
#define OFFLINE_PKG_H

#include <QObject>
#include <QString>
#include <QFile>
#include <QDir>
#include <QFileInfo>
#include <zim/zim.h>
#include <zim/file.h>
#include <zim/fileiterator.h>

class offline_pkg : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(QString path READ path WRITE setPath NOTIFY pathChanged) //save to file
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString name_code READ name_code WRITE setName_code NOTIFY name_codeChanged)
    Q_PROPERTY(QString count READ count WRITE setCount NOTIFY countChanged)
    Q_PROPERTY(bool enable READ enable WRITE setEnable NOTIFY enableChanged) //save to file

public:
    explicit offline_pkg(QObject *parent = 0);
    ~offline_pkg();
    QString type() const;
    void setType(const QString & type);
    QString path() const;
    void setPath(const QString & path);
    QString name() const;
    void setName(const QString & name);
    QString name_code() const;
    void setName_code(const QString & name_code);
    QString count() const;
    void setCount(const QString & count);
    bool enable() const;
    void setEnable(const bool & enable);
    QString get_text_from_url(QString & url);
    QString get_text_with_other_from_url(QString & url,QString & cache_dir);


Q_SIGNALS:
    void typeChanged(const QString & type);
    void pathChanged(const QString & path);
    void nameChanged(const QString & name);
    void name_codeChanged(const QString & name_code);
    void countChanged(const QString & count);
    void enableChanged(const bool & enable);

private:
    QString m_type;
    QString m_path;
    QString m_name;
    QString m_name_code;
    QString m_count;
    bool m_enable;
    bool zim_exist;
    zim::File *zim_file;
    QString str;
    QRegExp img;
    QDir dir;
    QFileInfo fileinfo;
    QFile img_file;

//public Q_SLOTS:
};

#endif // OFFLINE_PKG_H
