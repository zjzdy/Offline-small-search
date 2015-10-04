#ifndef OFFLINE_SMALL_SEARCH_H
#define OFFLINE_SMALL_SEARCH_H

#include <QWidget>
#include <QtGlobal>
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
#include <QFileDialog>
#include "offline_pkg.h"
#include "history_obj.h"
#include "custom_obj.h"
#include "search_result_obj.h"
#include "mark_obj.h"
#include "more_search_obj.h"

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
    Q_INVOKABLE void show_mark();
    Q_INVOKABLE void show_about();
    Q_INVOKABLE void show_custom();
    Q_INVOKABLE void show_back();
    Q_INVOKABLE void show_wait();
    Q_INVOKABLE void hide_wait();
    Q_INVOKABLE void show_result(QString url);
    Q_INVOKABLE void load_html(QString url);
    Q_INVOKABLE void close_app();
    Q_INVOKABLE void search_type_add(QString type);
    Q_INVOKABLE void search_type_add(QStringList type);
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
    Q_INVOKABLE void add_history(QString str, bool img, QString time, QStringList type);
    //mark
    Q_INVOKABLE void check_mark();
    Q_INVOKABLE bool is_mark(QString url);
    Q_INVOKABLE void remove_mark(QString url);
    Q_INVOKABLE void remove_all_mark();
    Q_INVOKABLE void data_file_to_mark_list(QString file_path = "");
    Q_INVOKABLE void mark_list_to_data_file(QString file_path = "");
    Q_INVOKABLE void add_mark(QString str,QString url);
    Q_INVOKABLE void check_enable_pkg(QString path);
    //Q_INVOKABLE void remove_history(QString str);
    Q_INVOKABLE void set_top_bar_height(qreal top_bar_height);
    Q_INVOKABLE void remove_all_history();
    Q_INVOKABLE void data_file_to_history_list(QString file_path = "");
    Q_INVOKABLE void history_list_to_data_file(QString file_path = "");
    Q_INVOKABLE void refresh_offline_pkg_list_for_pkg_qml();
    Q_INVOKABLE void refresh_more_search_list_for_more_search_qml();
    Q_INVOKABLE void refresh_history_list_for_history_qml();
    Q_INVOKABLE void refresh_search_result_for_search_result_qml();
    Q_INVOKABLE void refresh_mark_list_for_mark_qml();
    Q_INVOKABLE void init_search_from_offline_pkg_list();

private:
    Ui::Offline_small_search *ui;
    QStringList search_type;
    QString search_str;
    QString search_url;
    QList<QObject*> more_search_list;
    QList<QObject*> offline_pkg_list;
    QList<QObject*> history_list;
    QList<QObject*> search_result_list;
    QList<QObject*> mark_list;
    more_search_obj* more_search;
    offline_pkg* offline_pkg1;
    history_obj* history;
    mark_obj* mark;
    search_result_obj* search_result;
    LucenePlusPlus_search_thread search_thread;
    int init_search_batch;
    int search_batch;
    bool init_search_finish;
    bool search_finish;
    QRegExp remove_name_reg;
    QRegExp first_body_reg;
    QString url_name_code;
    QString cache_dir;
    QObject* result_obj;
    QObject* mark_img_obj;
    QObject* enable_pkg_img_obj;
    QObject* search_result_wait_obj;
    QObject* search_top_bar_obj;
    custom_obj custom1;
    QFileDialog file_dialog;
    QList<int> view;
};

#endif // OFFLINE_SMALL_SEARCH_H
