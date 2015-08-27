#include "search_result_obj.h"

search_result_obj::search_result_obj(QObject *parent) : QObject(parent)
{
}

QString search_result_obj::url() const
{
    return m_url;
}

void search_result_obj::setUrl(const QString & url)
{
    m_url = url;
    Q_EMIT urlChanged(m_url);
}

QString search_result_obj::str() const
{
    return m_str;
}

void search_result_obj::setStr(const QString & str)
{
    m_str = str;
    Q_EMIT strChanged(m_str);
}
