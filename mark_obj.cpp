#include "mark_obj.h"

mark_obj::mark_obj(QObject *parent) : QObject(parent)
{

}

QString mark_obj::url() const
{
    return m_url;
}

void mark_obj::setUrl(const QString & url)
{
    m_url = url;
    Q_EMIT urlChanged(m_url);
}

QString mark_obj::str() const
{
    return m_str;
}

void mark_obj::setStr(const QString & str)
{
    m_str = str;
    Q_EMIT strChanged(m_str);
}
