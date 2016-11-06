#ifndef MORE_SEARCH_OBJ_H
#define MORE_SEARCH_OBJ_H

#include <QObject>
#include <QString>

class more_search_obj : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString name_code READ name_code WRITE setName_code NOTIFY name_codeChanged)
    Q_PROPERTY(bool is_plugin READ is_plugin WRITE setIs_plugin NOTIFY is_pluginChanged)
    Q_PROPERTY(QString pluginQmlPath READ pluginQmlPath WRITE setPluginQmlPath NOTIFY pluginQmlPathChanged)
    Q_PROPERTY(QString absoluteQmlPath READ absoluteQmlPath WRITE setAbsoluteQmlPath NOTIFY absoluteQmlPathChanged)

public:
    explicit more_search_obj(QObject *parent = 0);
    QString type() const;
    void setType(const QString & type);
    QString name() const;
    void setName(const QString & name);
    QString name_code() const;
    void setName_code(const QString & name_code);
    bool is_plugin() const;
    void setIs_plugin(const bool & is_plugin);
    QString pluginQmlPath() const;
    void setPluginQmlPath(const QString & pluginQmlPath);
    QString absoluteQmlPath() const;
    void setAbsoluteQmlPath(const QString & absoluteQmlPath);

Q_SIGNALS:
    void typeChanged(const QString & type);
    void nameChanged(const QString & name);
    void name_codeChanged(const QString & name_code);
    void is_pluginChanged(const bool & is_plugin);
    void pluginQmlPathChanged(const QString & pluginQmlPath);
    void absoluteQmlPathChanged(const QString & absoluteQmlPath);

private:
    QString m_type;
    QString m_name;
    QString m_name_code;
    bool m_is_plugin;
    QString m_pluginQmlPath;
    QString m_absoluteQmlPath;
};

#endif // MORE_SEARCH_OBJ_H
