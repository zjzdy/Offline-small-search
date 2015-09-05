#include "offline_small_search.h"
#include "ui_offline_small_search.h"
#include "QDebug"

Offline_small_search::Offline_small_search(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::Offline_small_search)
{
    ui->setupUi(this);
    if (!QFile::exists("hmm_model.utf8"))
    {
        QFile::copy(":/hmm_model.utf8","hmm_model.utf8");
    }
    if (!QFile::exists("dict.utf8"))
    {
        QFile::copy(":/dict.utf8","dict.utf8");
    }
    remove_name_reg.setPattern(":/.*$");
    remove_name_reg.setMinimal(false);
    QObject::connect(&search_thread,SIGNAL(init_finish(int)),this,SLOT(on_init_finish(int)));
    QObject::connect(&search_thread,SIGNAL(search_result(QStringList,int)),this,SLOT(on_search_result(QStringList,int)));
    QObject::connect(this,SIGNAL(lucene_search(QString,int,QStringList)),&search_thread,SIGNAL(search(QString,int,QStringList)));
    QObject::connect(this,SIGNAL(init_search(QStringList,int)),&search_thread,SIGNAL(init(QStringList,int)));
    QObject::connect(&search_thread,SIGNAL(init_obj_finish()),this,SLOT(init_search_from_offline_pkg_list()));
    search_thread.start();
    //search_thread.wait();
    custom1.read_custom();
    ui->main_qml->rootContext()->setContextProperty("custom1", &custom1);
    ui->custom_qml->rootContext()->setContextProperty("custom1", &custom1);
    ui->main_qml->rootContext()->setContextProperty("main_widget", this);
    ui->more_qml->rootContext()->setContextProperty("main_widget", this);
    ui->more_search_qml->rootContext()->setContextProperty("main_widget", this);
    ui->custom_qml->rootContext()->setContextProperty("main_widget", this);
    ui->history_qml->rootContext()->setContextProperty("main_widget", this);
    ui->about_qml->rootContext()->setContextProperty("main_widget", this);
    ui->search_qml->rootContext()->setContextProperty("main_widget", this);
    ui->search_result_qml->rootContext()->setContextProperty("main_widget", this);
    ui->pkg_qml->rootContext()->setContextProperty("main_widget", this);
    ui->result_qml->rootContext()->setContextProperty("main_widget", this);
    result_obj = ui->result_qml->rootObject()->findChild<QObject*>("text");
    search_result_wait_obj = ui->search_result_qml->rootObject()->findChild<QObject*>("wait_image");
    search_batch = 0;
    init_search_batch = 0;
    cache_dir = QDir::currentPath()+"/tmp/";
    data_file_to_offline_pkg_list();
    data_file_to_history_list();
    file_dialog.setViewMode(QFileDialog::List);
}

void Offline_small_search::close_app()
{
    QCoreApplication::quit();
}

Offline_small_search::~Offline_small_search()
{
    search_thread.quit();
    offline_pkg_list_to_data_file();
    history_list_to_data_file();
    custom1.write_custom();
    clean_cache();
    delete ui;
}

void Offline_small_search::clean_cache()
{
    QString dirName = cache_dir;
    static QVector<QString> dirNames;
    QDir dir;
    QFileInfoList filst;
    QFileInfoList::iterator curFi;
    dirNames.clear();
    if(dir.exists())
    {
        dirNames<<dirName;
    }
        for(int i=0;i<dirNames.size();++i)
        {
            dir.setPath(dirNames[i]);
            filst=dir.entryInfoList(QDir::Dirs|QDir::Files|QDir::Readable|QDir::Writable|QDir::Hidden|QDir::NoDotAndDotDot,QDir::Name);
            if(filst.size()>0){
                curFi=filst.begin();
                while(curFi!=filst.end()){
                    if(curFi->isDir()){
                        dirNames.push_back(curFi->filePath());
                    }else if(curFi->isFile()){
                        dir.remove(curFi->fileName());
                    }
                    curFi++;
                }
            }
        }
        for(int i=dirNames.size()-1;i>=0;--i)
        {
            dir.setPath(dirNames[i]);
            dir.rmdir(".");
        }
    return;
}

void Offline_small_search::show_main()
{
    ui->stackedWidget->setCurrentIndex(0);
}

void Offline_small_search::show_more()
{
    ui->stackedWidget->setCurrentIndex(1);
}

void Offline_small_search::show_more_search()
{
    ui->stackedWidget->setCurrentIndex(2);
}

void Offline_small_search::show_history()
{
    ui->stackedWidget->setCurrentIndex(3);
}

void Offline_small_search::show_search()
{
    ui->stackedWidget->setCurrentIndex(7);
}

void Offline_small_search::show_search_result(QString str)
{
    if(!(str == ""||str.isEmpty()||str.isNull()))
    {
        search_str = str;
        search(search_type,search_str);
    }
    ui->stackedWidget->setCurrentIndex(8);
}

void Offline_small_search::show_pkg()
{
    ui->stackedWidget->setCurrentIndex(4);
}

void Offline_small_search::show_about()
{
    ui->stackedWidget->setCurrentIndex(6);
}

void Offline_small_search::show_custom()
{
    ui->stackedWidget->setCurrentIndex(5);
}

void Offline_small_search::hide_wait()
{
    search_result_wait_obj->setProperty("visible",false);
}

void Offline_small_search::show_wait()
{
    search_result_wait_obj->setProperty("visible",true);
}

void Offline_small_search::show_result(QString url)
{
    search_url = url;
    bool a = QMetaObject::invokeMethod(result_obj, "loadHtml", Q_ARG(QString, get_text_with_other_from_url(get_search_url())),Q_ARG(QUrl, QUrl("file:///"+get_cache_dir())));
    qDebug()<< "loadHtml:" << a <<url;
    //result_obj->setProperty("baseUrl","file:///"+get_cache_dir());
    //result_obj->setProperty("text",get_text_with_other_from_url(get_search_url()));
    ui->stackedWidget->setCurrentIndex(9);
}

QString Offline_small_search::get_dir_file_dialog()
{
    file_dialog.setOption(QFileDialog::ReadOnly);
    file_dialog.setFileMode(QFileDialog::Directory);
    file_dialog.setDirectory("/mnt/");
    if (file_dialog.exec())
        return file_dialog.directory().absolutePath();
    else return "";
}

QStringList Offline_small_search::get_search_type()
{
    return search_type;
}

QString Offline_small_search::get_search_str()
{
    return search_str;
}

QString Offline_small_search::get_search_url()
{
    qDebug()<< search_url;
    return search_url;
}

void Offline_small_search::search_type_add(QString type)
{
    if(type == "ALL")
    {
        for(int i = 0; i < offline_pkg_list.size(); ++i)
        {
            offline_pkg1 = qobject_cast<offline_pkg*>(offline_pkg_list.at(i));
            if(offline_pkg1->enable())
                search_type.append(offline_pkg1->name_code());
        }
    }
    search_type.append(type);
}

void Offline_small_search::search_type_clear()
{
    search_type.clear();
}

QString Offline_small_search::get_text_from_url(QString url)
{
    url_name_code = url;
    url_name_code.remove(remove_name_reg);
    url.remove(0,url_name_code.size()+2);
    QString text;
    QRegExp tag;
    tag.setMinimal(true);
    tag.setPattern("<.*>");
    for(int i = 0; i < offline_pkg_list.size(); ++i)
    {
        offline_pkg1 = qobject_cast<offline_pkg*>(offline_pkg_list.at(i));
        if(offline_pkg1->enable() && offline_pkg1->name_code() == url_name_code)
        {
            text = offline_pkg1->get_text_from_url(url);
            if(!(text == ""||text.isNull()||text.isEmpty()))
            {
                if(offline_pkg1->type() == "ST")
                    return text.remove(tag).remove("&nbsp;").remove("&quot;").remove("&amp;").remove("&lt;").remove("&gt;").remove("题文").remove("属性").remove("答案").remove("\n").remove("  ").remove("  ");
            }
        }
    }
    return "";
}

QString Offline_small_search::get_text_with_other_from_url(QString url)
{
    url_name_code = url;
    qDebug()<<url;
    url_name_code.remove(remove_name_reg);
    url.remove(0,url_name_code.size()+2);
    QString text;
    qDebug()<<url;
    for(int i = 0; i < offline_pkg_list.size(); ++i)
    {
        offline_pkg1 = qobject_cast<offline_pkg*>(offline_pkg_list.at(i));
        if(offline_pkg1->enable() && offline_pkg1->name_code() == url_name_code)
        {
            text = offline_pkg1->get_text_with_other_from_url(url,cache_dir);
            if(!(text == ""||text.isNull()||text.isEmpty()))
            {
                if(offline_pkg1->type() == "ST")
                    return text;
                qDebug()<<text;
            }
        }
    }
    return "";
}

void Offline_small_search::search(QStringList type, QString str)
{
    show_wait();
    Q_EMIT lucene_search(str,search_batch,type);
    clean_cache();
    for(int i = 0; i < search_result_list.size(); ++i)
    {
        search_result_list.at(i)->deleteLater();
    }
    search_result_list.clear();
    refresh_search_result_for_search_result_qml();
}

void Offline_small_search::add_offline_pkg(QString path,bool enable)
{
    if(path.isEmpty()||path.isNull()) return;
    offline_pkg1 = new offline_pkg(this);
    //path
    path.remove(QRegExp("[/\\\\]$"));
    if(path.indexOf("file://") != -1)
    {
        path.remove("file:///");
        int a = path.indexOf(QRegExp(":[/\\\\]"));
        if(a == -1 || a > path.indexOf(QRegExp("[/\\\\]")))
            path.prepend("/");
    }
    else
    {
        if(path.indexOf(QRegExp("^[/\\\\]")) == -1 && path.indexOf(QRegExp("^[^:/\\\\]*:[/\\\\]")) == -1)
            path.prepend(QDir::currentPath()+"/");
    }
    offline_pkg1->setPath(path);
    //name_code
    QRegExp name_code_reg("^.*[/\\\\]");
    name_code_reg.setMinimal(false);
    QString name_code = path;
    //name_code = name_code.remove(name_code_reg);
    offline_pkg1->setName_code(name_code.remove(name_code_reg));
    //read info
    QString pkg_str;
    quint64 pkg_count;
    QDataStream pkg_info;
    QFile pkg;
    bool good = enable;
    //name
    pkg.setFileName(path+"/name");
    if(pkg.exists() && pkg.open(QFile::ReadOnly))
    {
        pkg_info.resetStatus();
        pkg_info.setDevice(&pkg);
        pkg_str.clear();
        if(!pkg_info.atEnd())
        {
            pkg_info >> pkg_str;
            if(pkg_str.isEmpty()||pkg_str.isNull())
            {
                offline_pkg1->setName("NULL");
                good = false;
            }
            else offline_pkg1->setName(pkg_str);
        }
        else
        {
            offline_pkg1->setName("NULL");
            good = false;
        }
        pkg.close();
    }
    else
    {
        offline_pkg1->setName("NULL");
        good = false;
    }
    //type
    pkg.setFileName(path+"/type");
    if(pkg.exists() && pkg.open(QFile::ReadOnly))
    {
        pkg_info.resetStatus();
        pkg_info.setDevice(&pkg);
        pkg_str.clear();
        if(!pkg_info.atEnd())
        {
            pkg_info >> pkg_str;
            if(pkg_str.isEmpty()||pkg_str.isNull())
            {
                offline_pkg1->setType("NULL");
                good = false;
            }
            else offline_pkg1->setType(pkg_str);
        }
        else
        {
            offline_pkg1->setType("NULL");
            good = false;
        }
        pkg.close();
    }
    else
    {
        offline_pkg1->setType("NULL");
        good = false;
    }
    //count
    pkg.setFileName(path+"/count");
    if(pkg.exists() && pkg.open(QFile::ReadOnly))
    {
        //pkg.open(QFile::ReadOnly);
        pkg_info.resetStatus();
        pkg_info.setDevice(&pkg);
        pkg_str.clear();
        if(!pkg_info.atEnd())
        {
            pkg_info >> pkg_count;
            pkg_str = QString::number(pkg_count);
            if(pkg_str.isEmpty()||pkg_str.isNull())
            {
                offline_pkg1->setCount("NULL");
                good = false;
            }
            else offline_pkg1->setCount(pkg_str);
        }
        else
        {
            offline_pkg1->setCount("NULL");
            good = false;
        }
        pkg.close();
    }
    else
    {
        offline_pkg1->setCount("NULL");
        good = false;
    }
    //enable
    pkg.setFileName(path+"/data.zim");
    if(pkg.exists() && pkg.open(QFile::ReadOnly) && good)
    {
        offline_pkg1->setEnable(true);
        pkg.close();
    }
    else
    {
        offline_pkg1->setEnable(false);
    }

    offline_pkg_list.append(offline_pkg1);
    refresh_offline_pkg_list_for_pkg_qml();
}

void Offline_small_search::remove_offline_pkg(QString path)
{
    if(path.isEmpty()||path.isNull()) return;
    path.remove(QRegExp("[/\\\\]$"));
    if(path.indexOf("file://") != -1)
    {
        path.remove("file:///");
        int a = path.indexOf(QRegExp(":[/\\\\]"));
        if(a == -1 || a > path.indexOf(QRegExp("[/\\\\]")))
            path.prepend("/");
    }
    else
    {
        if(path.indexOf(QRegExp("^[/\\\\]")) == -1 && path.indexOf(QRegExp("^[^:/\\\\]*:[/\\\\]")) == -1)
            path.prepend(QDir::currentPath()+"/");
    }
    for(int i = 0; i < offline_pkg_list.size(); ++i)
    {
        offline_pkg1 = qobject_cast<offline_pkg*>(offline_pkg_list.at(i));
        if(offline_pkg1->path() == path)
        {
            offline_pkg1->deleteLater();
            offline_pkg_list.removeAt(i);
        }
    }
    refresh_offline_pkg_list_for_pkg_qml();
}

void Offline_small_search::data_file_to_offline_pkg_list(QString file_path)
{
    QString path;
    if(file_path == "" || file_path.isEmpty() || file_path.isNull()) path = QDir::currentPath()+"/pkg.ini";
    else
    {
        if(file_path.indexOf(QRegExp("[/\\\\]")) == -1)
            path = QDir::currentPath()+file_path;
        else
        {
            if(file_path.indexOf(QRegExp("[/\\\\]$")) == -1)
                path = file_path;
            else path = file_path+"pkg.ini";
        }
    }
    QFile pkg(path);
    if(pkg.exists() && pkg.open(QFile::ReadOnly))
    {
        remove_all_offline_pkg();
        QString pkg_path;
        bool pkg_enable;
        QDataStream pkg_stream(&pkg);
        while(!pkg_stream.atEnd())
        {
            pkg_stream >> pkg_path >> pkg_enable;
            add_offline_pkg(pkg_path,pkg_enable);
        }
        pkg.close();
        refresh_offline_pkg_list_for_pkg_qml();
    }
    //init_search_from_offline_pkg_list();
}

void Offline_small_search::remove_all_offline_pkg()
{
    for(int i = 0; i < offline_pkg_list.size(); ++i)
    {
        //offline_pkg1 = qobject_cast<offline_pkg*>(offline_pkg_list.at(i));
        offline_pkg_list.at(i)->deleteLater();
    }
    offline_pkg_list.clear();
    refresh_offline_pkg_list_for_pkg_qml();
}

void Offline_small_search::offline_pkg_list_to_data_file(QString file_path)
{
    if(offline_pkg_list.empty()) return;
    QString path;
    if(file_path == "" || file_path.isEmpty() || file_path.isNull()) path = QDir::currentPath()+"/pkg.ini";
    else
    {
        if(file_path.indexOf(QRegExp("[/\\\\]")) == -1)
            path = QDir::currentPath()+file_path;
        else
        {
            if(file_path.indexOf(QRegExp("[/\\\\]$")) == -1)
                path = file_path;
            else path = file_path+"pkg.ini";
        }
    }
    QFile pkg(path);
    QDir a;
    QRegExp path_dir_regexp("[/\\\\].*$");
    path_dir_regexp.setMinimal(true);
    a.mkpath(path.remove(path_dir_regexp));
    pkg.open(QFile::WriteOnly);
    QDataStream pkg_stream(&pkg);
    for(int i = 0; i < offline_pkg_list.size(); ++i)
    {
        offline_pkg1 = qobject_cast<offline_pkg*>(offline_pkg_list.at(i));
        pkg_stream << offline_pkg1->path() <<offline_pkg1->enable();
    }
    pkg.close();
}

void Offline_small_search::refresh_offline_pkg_list_for_pkg_qml()
{
    ui->pkg_qml->rootContext()->setContextProperty("offline_pkg_list", QVariant::fromValue(offline_pkg_list));
}

void Offline_small_search::add_history(QString str,bool img,QString time)
{
    if(str.isEmpty()||str.isNull()) return;
    history = new history_obj(this);
    history->setStr(str);
    history->setImg(img);
    history->setTime(time);
    history_list.prepend(history);
    //history_list.append(history);
    refresh_history_list_for_history_qml();
}

void Offline_small_search::data_file_to_history_list(QString file_path)
{
    QString path;
    if(file_path == "" || file_path.isEmpty() || file_path.isNull()) path = QDir::currentPath()+"/history.dat";
    else
    {
        if(file_path.indexOf(QRegExp("[/\\\\]")) == -1)
            path = QDir::currentPath()+file_path;
        else
        {
            if(file_path.indexOf(QRegExp("[/\\\\]$")) == -1)
                path = file_path;
            else path = file_path+"history.dat";
        }
    }
    QFile history_file(path);
    if(history_file.exists() && history_file.open(QFile::ReadOnly))
    {
        remove_all_history();
        QString history_str;
        bool history_img;
        QString history_time;
        QDataStream history_file_stream(&history_file);
        int a = -1;
        while((!history_file_stream.atEnd())&&(++a)<custom1.max_history())
        {
            history_file_stream >> history_str >> history_img >> history_time;
            history = new history_obj(this);
            history->setStr(history_str);
            history->setImg(history_img);
            history->setTime(history_time);
            history_list.append(history);
            refresh_history_list_for_history_qml();
        }
        history_file.close();
        refresh_history_list_for_history_qml();
    }
    //init_search_from_offline_pkg_list();
}

void Offline_small_search::remove_all_history()
{
    for(int i = 0; i < history_list.size(); ++i)
    {
        history = qobject_cast<history_obj*>(history_list.at(i));
        history_list.at(i)->deleteLater();
    }
    history_list.clear();
    refresh_history_list_for_history_qml();
}

void Offline_small_search::history_list_to_data_file(QString file_path)
{
    if(history_list.empty()) return;
    QString path;
    if(file_path == "" || file_path.isEmpty() || file_path.isNull()) path = QDir::currentPath()+"/history.dat";
    else
    {
        if(file_path.indexOf(QRegExp("[/\\\\]")) == -1)
            path = QDir::currentPath()+file_path;
        else
        {
            if(file_path.indexOf(QRegExp("[/\\\\]$")) == -1)
                path = file_path;
            else path = file_path+"history.dat";
        }
    }
    QFile history_file(path);
    QDir a;
    QRegExp path_dir_regexp("[/\\\\].*$");
    path_dir_regexp.setMinimal(true);
    a.mkpath(path.remove(path_dir_regexp));
    history_file.open(QFile::WriteOnly);
    QDataStream history_file_stream(&history_file);
    for(int i = 0; i < history_list.size(); ++i)
    {
        history = qobject_cast<history_obj*>(history_list.at(i));
        history_file_stream << history->str() << history->img() << history->time();
    }
    history_file.close();
}

void Offline_small_search::refresh_history_list_for_history_qml()
{
    ui->history_qml->rootContext()->setContextProperty("history_list", QVariant::fromValue(history_list));
}

void Offline_small_search::refresh_search_result_for_search_result_qml()
{
    ui->search_result_qml->rootContext()->setContextProperty("search_result_obj", QVariant::fromValue(search_result_list));
}

void Offline_small_search::init_search_from_offline_pkg_list()
{
    ++search_batch;
    QStringList dir_list;
    for(int i = 0; i < offline_pkg_list.size(); ++i)
    {
        offline_pkg1 = qobject_cast<offline_pkg*>(offline_pkg_list.at(i));
        if(offline_pkg1->enable())
            dir_list.append(offline_pkg1->path());
    }
    init_search_finish = false;
    Q_EMIT init_search(dir_list,init_search_batch);
}

void Offline_small_search::on_search_result(QStringList urls, int batch)
{
    if(batch == search_batch)
    {
        search_result_list.clear();
        for(int i = 0; i < urls.size(); ++i)
        {
            search_result = new search_result_obj();
            search_result->setUrl(urls.at(i));
            search_result->setStr(get_text_from_url(urls.at(i)));
            search_result_list.append(search_result);
        }
        refresh_search_result_for_search_result_qml();
        hide_wait();
    }
}

void Offline_small_search::on_init_finish(int batch)
{
    if(batch == init_search_batch)
    {
        init_search_finish = true;
        qDebug()<<"init_search_finish:"<<init_search_finish;
        hide_wait();
    }
}

QString Offline_small_search::get_cache_dir()
{
    return cache_dir;
}
