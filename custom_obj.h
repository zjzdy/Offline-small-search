#ifndef CUSTOM_OBJ_H
#define CUSTOM_OBJ_H

#include <QObject>
#include <QDir>
#include <QFile>
#include <QString>
#include <QDataStream>

class custom_obj : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString bgi READ bgi WRITE setBgi NOTIFY bgiChanged)
    Q_PROPERTY(QString bgc READ bgc WRITE setBgc NOTIFY bgcChanged)
    Q_PROPERTY(int max_history READ max_history WRITE setMax_history NOTIFY max_historyChanged)

public:
    explicit custom_obj(QObject *parent = 0);
    QString bgi() const;
    void setBgi(const QString & bgi);
    QString bgc() const;
    void setBgc(const QString & bgc);
    int max_history() const;
    void setMax_history(const int & max_history);
    Q_INVOKABLE void write_custom(QString file_path = "");
    Q_INVOKABLE void read_custom(QString file_path = "");

Q_SIGNALS:
    void bgiChanged(const QString & bgi);
    void bgcChanged(const QString & bgc);
    void max_historyChanged(const int & max_history);

private:
    QString m_bgi;
    QString m_bgc;
    int m_max_history;
};

#endif // CUSTOM_OBJ_H
