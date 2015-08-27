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

QString history_obj::time() const
{
    return m_time;
}

void history_obj::setTime(const QString & time)
{
    m_time = time;
    Q_EMIT timeChanged(m_time);
}
