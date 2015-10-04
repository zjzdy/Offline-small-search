#include "more_search_obj.h"

more_search_obj::more_search_obj(QObject *parent) : QObject(parent)
{

}

QString more_search_obj::type() const
{
    return m_type;
}

void more_search_obj::setType(const QString & type)
{
    m_type = type;
    Q_EMIT typeChanged(m_type);
}

QString more_search_obj::name() const
{
    return m_name;
}

void more_search_obj::setName(const QString & name)
{
    m_name = name;
    Q_EMIT nameChanged(m_name);
}

QString more_search_obj::name_code() const
{
    return m_name_code;
}

void more_search_obj::setName_code(const QString & name_code)
{
    m_name_code = name_code;
    Q_EMIT name_codeChanged(m_name_code);
}
