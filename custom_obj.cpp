#include "custom_obj.h"

custom_obj::custom_obj(QObject *parent) : QObject(parent)
{
    m_max_history = 50;
    m_bgc = "#4681bb";
    m_bgi = "";
}

void custom_obj::write_custom(QString file_path)
{
    QString path;
    if(file_path == "" || file_path.isEmpty() || file_path.isNull()) path = QDir::currentPath()+"/custom.dat";
    else
    {
        if(file_path.indexOf(QRegExp("[/\\\\]")) == -1)
            path = QDir::currentPath()+file_path;
        else
        {
            if(file_path.indexOf(QRegExp("[/\\\\]$")) == -1)
                path = file_path;
            else path = file_path+"custom.dat";
        }
    }
    QFile custom_file(path);
    QDir a;
    QRegExp path_dir_regexp("[/\\\\].*$");
    path_dir_regexp.setMinimal(true);
    a.mkpath(path.remove(path_dir_regexp));
    custom_file.open(QFile::WriteOnly);
    QDataStream custom_file_stream(&custom_file);
    custom_file_stream << m_bgc << m_bgi << m_max_history;
    custom_file.close();
}

void custom_obj::read_custom(QString file_path)
{
    QString path;
    if(file_path == "" || file_path.isEmpty() || file_path.isNull()) path = QDir::currentPath()+"/custom.dat";
    else
    {
        if(file_path.indexOf(QRegExp("[/\\\\]")) == -1)
            path = QDir::currentPath()+file_path;
        else
        {
            if(file_path.indexOf(QRegExp("[/\\\\]$")) == -1)
                path = file_path;
            else path = file_path+"custom.dat";
        }
    }
    QFile custom_file(path);
    if(custom_file.exists() && custom_file.open(QFile::ReadOnly))
    {
        QDataStream custom_file_stream(&custom_file);
        custom_file_stream >> m_bgc >> m_bgi >> m_max_history;
        custom_file.close();
    }
    Q_EMIT bgiChanged(m_bgi);
    Q_EMIT bgcChanged(m_bgc);
    Q_EMIT max_historyChanged(m_max_history);
}

QString custom_obj::bgi() const
{
    return m_bgi;
}

void custom_obj::setBgi(const QString & bgi)
{
    m_bgi = bgi;
    Q_EMIT bgiChanged(m_bgi);
}

QString custom_obj::bgc() const
{
    return m_bgc;
}

void custom_obj::setBgc(const QString & bgc)
{
    m_bgc = bgc;
    Q_EMIT bgcChanged(m_bgc);
}

int custom_obj::max_history() const
{
    return m_max_history;
}

void custom_obj::setMax_history(const int & max_history)
{
    m_max_history = max_history;
    Q_EMIT max_historyChanged(m_max_history);
}
