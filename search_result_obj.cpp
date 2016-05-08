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

QString search_result_obj::title() const
{
    return m_title;
}

void search_result_obj::setTitle(const QString & title)
{
    m_title = title;
    Q_EMIT titleChanged(m_title);
}

bool search_result_obj::haveTitle() const
{
    return m_haveTitle;
}

void search_result_obj::setHaveTitle(const bool & haveTitle)
{
    m_haveTitle = haveTitle;
    Q_EMIT haveTitleChanged(m_haveTitle);
}
