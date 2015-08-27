#ifndef OFFLINE_SMALL_SEARCH_H
#define OFFLINE_SMALL_SEARCH_H

#include <QWidget>
#include "luceneplusplus_search_thread.h"
#include <QFile>
#include <QDir>
#include <QCoreApplication>
#include <QQmlContext>
#include <QObject>
#include <QMetaObject>
#include <QList>
#include <QRegExp>
#include <QString>
#include <QStringList>
#include <QDataStream>
#include <QQuickItem>
#include <QObjectCleanupHandler>
#include <QFileDialog>
#include "offline_pkg.h"
#include "search_result_obj.h"

namespace Ui {
class Offline_small_search;
}

class Offline_small_search : public QWidget
{
    Q_OBJECT

public:
    explicit Offline_small_search(QWidget *parent = 0);
    ~Offline_small_search();

Q_SIGNALS:
    void lucene_search(QString str, int batch, QStringList type);
    void init_search(QStringList dir, int batch);

public Q_SLOTS:
    void on_search_result(QStringList urls, int batch);
    void on_init_finish(int batch);
    Q_INVOKABLE void clean_cache();
    Q_INVOKABLE void show_more();
    Q_INVOKABLE void show_main();
    Q_INVOKABLE void show_more_search();
    Q_INVOKABLE void show_history();
    Q_INVOKABLE void show_search();
    Q_INVOKABLE void show_search_result(QString str);
    Q_INVOKABLE void show_pkg();
    Q_INVOKABLE void show_about();
    Q_INVOKABLE void show_custom();
    Q_INVOKABLE void show_wait();
    Q_INVOKABLE void hide_wait();
    Q_INVOKABLE void show_result(QString url);
    Q_INVOKABLE void close_app();
    Q_INVOKABLE void search_type_add(QString type);
    Q_INVOKABLE void search_type_clear();
    Q_INVOKABLE QStringList get_search_type();
    Q_INVOKABLE QString get_dir_file_dialog();
    Q_INVOKABLE QString get_search_str();
    Q_INVOKABLE QString get_search_url();
    Q_INVOKABLE QString get_cache_dir();
    Q_INVOKABLE QString get_text_from_url(QString url);
    Q_INVOKABLE QString get_text_with_other_from_url(QString url);
    Q_INVOKABLE void search(QStringList type, QString str);
    Q_INVOKABLE void add_offline_pkg(QString path, bool enable = true);
    Q_INVOKABLE void remove_offline_pkg(QString path);
    Q_INVOKABLE void remove_all_offline_pkg();
    Q_INVOKABLE void data_file_to_offline_pkg_list(QString file_path = "");
    Q_INVOKABLE void offline_pkg_list_to_data_file(QString file_path = "");
    Q_INVOKABLE void refresh_offline_pkg_list_for_pkg_qml();
    Q_INVOKABLE void refresh_search_result_for_search_result_qml();
    Q_INVOKABLE void init_search_from_offline_pkg_list();

private:
    Ui::Offline_small_search *ui;
    QStringList search_type;
    QString search_str;
    QString search_url;
    QList<QObject*> offline_pkg_list;
    QList<QObject*> search_result_list;
    QObjectCleanupHandler offline_pkg_list_cleanup;
    QObjectCleanupHandler search_result_list_cleanup;
    offline_pkg* offline_pkg1;
    search_result_obj* search_result;
    LucenePlusPlus_search_thread search_thread;
    int init_search_batch;
    int search_batch;
    bool init_search_finish;
    bool search_finish;
    QRegExp remove_name_reg;
    QString url_name_code;
    QString cache_dir;
    QObject* result_obj;
    QObject* search_result_wait_obj;
    QFileDialog file_dialog;
};

#endif // OFFLINE_SMALL_SEARCH_H
