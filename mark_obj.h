#ifndef MARK_OBJ_H
#define MARK_OBJ_H

#include <QObject>

class mark_obj : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString str READ str WRITE setStr NOTIFY strChanged)
    Q_PROPERTY(QString url READ url WRITE setUrl NOTIFY urlChanged)

public:
    explicit mark_obj(QObject *parent = 0);
    QString str() const;
    void setStr(const QString & str);
    QString url() const;
    void setUrl(const QString & url);

Q_SIGNALS:
    void strChanged(const QString & str);
    void urlChanged(const QString & url);

private:
    QString m_str;
    QString m_url;
};

#endif // MARK_OBJ_H
