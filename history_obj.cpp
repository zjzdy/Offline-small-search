#include "history_obj.h"

history_obj::history_obj(QObject *parent) : QObject(parent)
{
    m_img = false;
}

bool history_obj::img() const
{
    return m_img;
}

void history_obj::setImg(const bool & img)
{
    m_img = img;
    Q_EMIT imgChanged(m_img);
}

QString history_obj::str() const
{
    return m_str;
}

void history_obj::setStr(const QString & str)
{
    m_str = str;
    Q_EMIT strChanged(m_str);
}

QStringList history_obj::search_type() const
{
    return m_search_type;
}

void history_obj::setSearch_type(const QStringList & search_type)
{
    m_search_type = search_type;
    Q_EMIT search_typeChanged(m_search_type);
}

QString history_obj::time() const
{
    return m_time;
}

void history_obj::setTime(const QString & time)
{
    m_time = time;
    Q_EMIT timeChanged(m_time);
}
