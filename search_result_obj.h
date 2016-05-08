#ifndef SEARCH_RESULT_OBJ_H
#define SEARCH_RESULT_OBJ_H

#include <QObject>
#include <QString>

class search_result_obj : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(QString str READ str WRITE setStr NOTIFY strChanged)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(bool haveTitle READ haveTitle WRITE setHaveTitle NOTIFY haveTitleChanged)

public:
    explicit search_result_obj(QObject *parent = 0);
    QString url() const;
    void setUrl(const QString & url);
    QString str() const;
    void setStr(const QString & str);
    QString title() const;
    void setTitle(const QString & title);
    bool haveTitle() const;
    void setHaveTitle(const bool & haveTitle);

Q_SIGNALS:
    void urlChanged(const QString & url);
    void strChanged(const QString & str);
    void titleChanged(const QString & title);
    void haveTitleChanged(const bool & haveTitle);

private:
    QString m_url;
    QString m_str;
    QString m_title;
    bool m_haveTitle;
};

#endif // SEARCH_RESULT_OBJ_H
