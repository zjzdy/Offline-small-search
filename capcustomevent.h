#ifndef CAPCUSTOMEVENT_H
#define CAPCUSTOMEVENT_H
#include <QEvent>
#include <QString>


class capCustomEvent : public QEvent
{
public:
    capCustomEvent(int arg1 = 0, const QString &arg2 = QString());
    ~capCustomEvent();

    static Type eventType();

    int m_arg1;
    QString m_arg2;

private:
    static Type m_evType;
};

#endif // CAPCUSTOMEVENT_H
