#ifndef SEARCH_RESULT_OBJ_H
#define SEARCH_RESULT_OBJ_H

#include <QObject>
#include <QString>

class search_result_obj : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(QString str READ str WRITE setStr NOTIFY strChanged)

public:
    explicit search_result_obj(QObject *parent = 0);
    QString url() const;
    void setUrl(const QString & url);
    QString str() const;
    void setStr(const QString & str);

Q_SIGNALS:
    void urlChanged(const QString & url);
    void strChanged(const QString & str);

private:
    QString m_url;
    QString m_str;
};

#endif // SEARCH_RESULT_OBJ_H
