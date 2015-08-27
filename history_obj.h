#ifndef HISTORY_OBJ_H
#define HISTORY_OBJ_H

#include <QObject>

class history_obj : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool img READ img WRITE setImg NOTIFY imgChanged)
    Q_PROPERTY(QString str READ str WRITE setStr NOTIFY strChanged)
    Q_PROPERTY(QString time READ time WRITE setTime NOTIFY timeChanged)

public:
    explicit history_obj(QObject *parent = 0);
    bool img() const;
    void setImg(const bool & img);
    QString str() const;
    void setStr(const QString & str);
    QString time() const;
    void setTime(const QString & time);

Q_SIGNALS:
    void imgChanged(const bool & img);
    void strChanged(const QString & str);
    void timeChanged(const QString & time);

private:
    bool m_img;
    QString m_str;
    QString m_time;
};

#endif // HISTORY_OBJ_H
