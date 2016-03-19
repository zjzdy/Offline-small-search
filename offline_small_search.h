#ifndef OFFLINE_SMALL_SEARCH_H
#define OFFLINE_SMALL_SEARCH_H

#include <QtGlobal>
#include "Xapian_search_thread.h"
#include <QtNetwork>
#include <QFile>
#include <QDir>
#include <QCoreApplication>
#include <QQmlContext>
#include <QObject>
#include <QMetaObject>
#include <QList>
#include <QHash>
#include <QRegExp>
#include <QString>
#include <QStringList>
#include <QDataStream>
#include <QQuickItem>
#include <QCryptographicHash>
#include <QNetworkReply>
#include "capcustomevent.h"
#include "quazip/JlCompress.h"
#ifdef Q_OS_ANDROID
#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#include <jni.h>
#endif
//#include "crop.h"
#include "offline_pkg.h"
#include "history_obj.h"
#include "custom_obj.h"
#include "search_result_obj.h"
#include "mark_obj.h"
#include "more_search_obj.h"
#include "crop_thread.h"
#include "unzip_thread.h"
#include "parse/myhtmlparse.h"
#define VERSION_N 22

class Offline_small_search : public QObject
{
    Q_OBJECT

public:
    explicit Offline_small_search(QObject *parent = 0);
    ~Offline_small_search();
    bool event(QEvent *);
    void init_con(QQmlContext *rootcon);
    void init_obj(QObject *rootobj);
    void init_data();

Q_SIGNALS:
    void xapian_search(QString str, int batch, QStringList type);
    void init_search(QStringList dir, int batch);
    void unzip(QString zipfile, QString dir, int batch);
    void crop_ocr(QString imagepath, QVariant cropPoints, int batch);
    void rotate(QString imagepath, int rotate_n, int batch);
    void init_ocr(QString tessdata_path, int batch);

public Q_SLOTS:
    Q_INVOKABLE void init_obj();
    Q_INVOKABLE void download_data(QString url);
    Q_INVOKABLE void remove_data(QString url);
    Q_INVOKABLE void crop_ocr_Q(QString imagepath, QVariant cropPoints);
    Q_INVOKABLE void rotate_Q(QString imagepath, int rotate_n);
    void download_data_finish();
    void onReadyRead();
    void onDownloadProgress(qint64 bytesSent, qint64 bytesTotal);
    void download_version_finish();
    void download_changelog_finish();
    void on_search_result(QStringList urls, int batch);
    void on_search_init_finish(int batch);
    void on_crop_ocr_result(QString text, int batch);
    void on_crop_ocr_rotate_finish(QString imagepath,int batch);
    void on_crop_ocr_init_finish(int batch);
    void on_unzip_finish(int batch, QString dir);
    Q_INVOKABLE void obj_list_insert(QString key, QObject *obj);
    Q_INVOKABLE void clean_cache();
    Q_INVOKABLE void show_more();
    Q_INVOKABLE void show_main();
    Q_INVOKABLE void show_more_search();
    Q_INVOKABLE void show_history();
    Q_INVOKABLE void show_search(QString str = " ");
    Q_INVOKABLE void show_search_result(QString str);
    Q_INVOKABLE void show_pkg();
    Q_INVOKABLE void show_mark();
    Q_INVOKABLE void show_about();
    Q_INVOKABLE void show_custom();
    Q_INVOKABLE void show_crop(QString source = "");
    Q_INVOKABLE void show_pkg_home();
    Q_INVOKABLE void show_online_download();
    Q_INVOKABLE void show_back();
    Q_INVOKABLE void show_wait();
    Q_INVOKABLE void hide_wait();
    Q_INVOKABLE void show_result(QString url);
    Q_INVOKABLE void load_html(QString url);
    Q_INVOKABLE void close_app();
    Q_INVOKABLE void startCamera();
    Q_INVOKABLE void search_type_add(QString type);
    Q_INVOKABLE void search_type_add(QStringList type);
    Q_INVOKABLE void search_type_clear();
    Q_INVOKABLE QStringList get_search_type();
    Q_INVOKABLE QString get_search_str();
    Q_INVOKABLE QString get_search_url();
    Q_INVOKABLE QString get_cache_dir();
    Q_INVOKABLE QString get_text_from_url(QString url);
    Q_INVOKABLE QString get_text_with_other_from_url(QString url);
    Q_INVOKABLE QString get_data_dir();
    Q_INVOKABLE QString md5(QString str);
    Q_INVOKABLE void search(QStringList type, QString str);
    Q_INVOKABLE void add_offline_pkg(QString path, bool enable = true);
    Q_INVOKABLE void remove_offline_pkg(QString path);
    Q_INVOKABLE void remove_all_offline_pkg();
    Q_INVOKABLE void data_file_to_offline_pkg_list(QString file_path = "");
    Q_INVOKABLE void offline_pkg_list_to_data_file(QString file_path = "");
    Q_INVOKABLE void add_history(QString str, bool img, QString time, QStringList type);
    Q_INVOKABLE bool is_exist(QString file,int type = 0);
    Q_INVOKABLE bool have_home(QString pkg = "");
    //mark
    Q_INVOKABLE void check_mark();
    Q_INVOKABLE bool is_mark(QString url);
    Q_INVOKABLE void remove_mark(QString url);
    Q_INVOKABLE void remove_all_mark();
    Q_INVOKABLE void data_file_to_mark_list(QString file_path = "");
    Q_INVOKABLE void mark_list_to_data_file(QString file_path = "");
    Q_INVOKABLE void add_mark(QString str,QString url);
    Q_INVOKABLE void check_enable_pkg(QString path);
    Q_INVOKABLE void read_data_file(QString file_path = "");
    Q_INVOKABLE void write_data_file(QString file_path = "");
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
    Q_INVOKABLE void setCurrentIndex(int index);
    Q_INVOKABLE void webview_goback();
    Q_INVOKABLE void check_update();
    Q_INVOKABLE QColor rand_lightcolor(QString str = "");
private:
#ifdef Q_OS_ANDROID
    void clickHome();
#endif

private:
    QStringList search_type;
    QString search_str;
    QString search_url;
    QString data_dir;
    QList<QObject*> more_search_list;
    QList<QObject*> offline_pkg_list;
    QList<QObject*> history_list;
    QList<QObject*> search_result_list;
    QList<QObject*> mark_list;
    QHash<QString, QObject*> obj_list;
    more_search_obj* more_search;
    offline_pkg* offline_pkg1;
    history_obj* history;
    mark_obj* mark;
    search_result_obj* search_result;
    Xapian_search_thread search_thread;
    int init_search_batch;
    int search_batch;
    bool init_search_finish;
    bool search_finish;
    QRegExp remove_name_reg;
    QRegExp only_file_name;
    QString url_name_code;
    QString cache_dir;
    QList<int> view;
    QNetworkAccessManager m_down;
    QNetworkReply *m_reply;
    QNetworkRequest *m_request;
    QStringList webview_history;

public:
    QObject* result_obj;
    QObject* mark_img_obj;
    QObject* enable_pkg_img_obj;
    QObject* search_result_wait_obj;
    QObject* search_top_bar_obj;
    QObject* cropView_obj;
    QObject* tabView_obj;
    QObject* search_text_obj;
    QObject* home_img_obj;
    QObject* result_search_img_obj;
    QObject* update_dialog_obj;
    custom_obj custom1;
    //crop crop_obj;
    crop_thread crop_thread_obj;
    int crop_batch;
    //QString crop_filename;
    unzip_thread unzip_thread_obj;
    QHash<int,QString> unzip_url_map;
    int unzip_batch;
    QQmlContext *rootContext;
    QObject *rootObject;
    MyHtmlParser htmlparser;
    //QString unzip_url;
};

#endif // OFFLINE_SMALL_SEARCH_H
