#ifndef INTERFACES_H
#define INTERFACES_H

#include <QtPlugin>
#include <QMap>
#include <QVariant>

class QString;
class QObject;

class PageInterface
{
public:
    virtual ~PageInterface() {}

    virtual QObject* init(QObject *rootObj, QMap<QString,QVariant> parm) = 0;
    virtual void initAfterLoad(QString QmlName) = 0;
};

#define PageInterfacee_iid "zjzdy.offline.small.search.PageInterface"

Q_DECLARE_INTERFACE(PageInterface, PageInterfacee_iid)

#endif // INTERFACES_H
