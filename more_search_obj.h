#ifndef MORE_SEARCH_OBJ_H
#define MORE_SEARCH_OBJ_H

#include <QObject>
#include <QString>

class more_search_obj : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString name_code READ name_code WRITE setName_code NOTIFY name_codeChanged)

public:
    explicit more_search_obj(QObject *parent = 0);
    QString type() const;
    void setType(const QString & type);
    QString name() const;
    void setName(const QString & name);
    QString name_code() const;
    void setName_code(const QString & name_code);

Q_SIGNALS:
    void typeChanged(const QString & type);
    void nameChanged(const QString & name);
    void name_codeChanged(const QString & name_code);

private:
    QString m_type;
    QString m_name;
    QString m_name_code;
};

#endif // MORE_SEARCH_OBJ_H
