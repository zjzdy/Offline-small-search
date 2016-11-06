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

bool more_search_obj::is_plugin() const
{
    return m_is_plugin;
}

void more_search_obj::setIs_plugin(const bool & is_plugin)
{
    m_is_plugin = is_plugin;
    Q_EMIT is_pluginChanged(m_is_plugin);
}

QString more_search_obj::pluginQmlPath() const
{
    return m_pluginQmlPath;
}

void more_search_obj::setPluginQmlPath(const QString & pluginQmlPath)
{
    m_pluginQmlPath = pluginQmlPath;
    Q_EMIT pluginQmlPathChanged(m_pluginQmlPath);
}

QString more_search_obj::absoluteQmlPath() const
{
    return m_absoluteQmlPath;
}

void more_search_obj::setAbsoluteQmlPath(const QString & absoluteQmlPath)
{
    m_absoluteQmlPath = absoluteQmlPath;
    Q_EMIT absoluteQmlPathChanged(m_absoluteQmlPath);
}
