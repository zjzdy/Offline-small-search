#include "offline_small_search.h"
#include "QDebug"
extern QObject *g_listener;

Offline_small_search::Offline_small_search(QObject *parent) :
    QObject(parent),init_data_finish(false),init_search_obj_finish(false)
{
    if(!QFile::exists(QDir::currentPath()+"/tmp/"))
    {
        QDir tmp;
        tmp.mkpath(QDir::currentPath()+"/tmp/");
    }
    remove_name_reg.setPattern(":/.*$");
    remove_name_reg.setMinimal(false);
    only_file_name.setPattern(".*[/\\\\]");
    only_file_name.setMinimal(false);
    QObject::connect(&search_thread,SIGNAL(init_finish(int)),this,SLOT(on_search_init_finish(int)));
    QObject::connect(&search_thread,SIGNAL(search_result(QStringList,QStringList,int)),this,SLOT(on_search_result(QStringList,QStringList,int)));
    QObject::connect(this,SIGNAL(xapian_search(QString,int,QStringList)),&search_thread,SIGNAL(search(QString,int,QStringList)));
    QObject::connect(this,SIGNAL(init_search(QStringList,int)),&search_thread,SIGNAL(init(QStringList,int)));
    QObject::connect(&search_thread,SIGNAL(init_obj_finish()),this,SLOT(on_init_search_obj_finish()));
    search_thread.start();// init_search_from_offline_pkg_list

    QObject::connect(&crop_thread_obj,SIGNAL(init_finish(int)),this,SLOT(on_crop_ocr_init_finish(int)));
    QObject::connect(&crop_thread_obj,SIGNAL(ocr_result(QString,int)),this,SLOT(on_crop_ocr_result(QString,int)));
    QObject::connect(&crop_thread_obj,SIGNAL(rotate_finish(QString,int)),this,SLOT(on_crop_ocr_rotate_finish(QString,int)));
    QObject::connect(this,SIGNAL(rotate(QString,int,int)),&crop_thread_obj,SIGNAL(rotate(QString,int,int)));
    QObject::connect(this,SIGNAL(crop_ocr(QString,QVariant,QString,int)),&crop_thread_obj,SIGNAL(crop_ocr(QString,QVariant,QString,int)));
    QObject::connect(this,SIGNAL(init_ocr(QString,QString,int)),&crop_thread_obj,SIGNAL(init(QString,QString,int)));
    //QObject::connect(&crop_thread_obj,SIGNAL(init_obj_finish()),this,SLOT(init_search_from_offline_pkg_list()));
    crop_thread_obj.start();

    QObject::connect(&unzip_thread_obj,SIGNAL(unzip_finish(int,QString)),this,SLOT(on_unzip_finish(int,QString)));
    QObject::connect(this,SIGNAL(unzip(QString,QString,int)),&unzip_thread_obj,SIGNAL(unzip(QString,QString,int)));
    unzip_thread_obj.start();
    //search_thread.wait();
    custom1.read_custom();
    search_batch = 0;
    crop_batch = 0;
    unzip_batch = 0;
    init_search_batch = 0;
    cache_dir = QDir::currentPath()+"/tmp/";
    clean_cache();
    view.append(0);
    if(is_exist("/ocr/zh_cn.zip",1))
        Q_EMIT init_ocr(get_data_dir()+"/zh_cn","zh_cn",++crop_batch);
    if(is_exist("/ocr/eng.zip",1))
        Q_EMIT init_ocr(get_data_dir()+"/eng","eng",++crop_batch);
    if(is_exist("/ocr/cht.zip",1))
        Q_EMIT init_ocr(get_data_dir()+"/cht","cht",++crop_batch);
    loadPlugins();
    #ifdef Q_OS_ANDROID
    androidVersion = getAndroidVersion();
    #endif
}
void Offline_small_search::init_con(QQmlContext *rootcon)
{
    rootcon->setContextProperty("custom1", &custom1);
    rootContext = rootcon;
}

void Offline_small_search::init_obj(QObject *rootobj)
{
    rootObject = rootobj;
    tabView_obj = rootobj->findChild<QObject*>("tabView");
    swipeView_obj = rootobj->findChild<QObject*>("swipeView");
    setCurrentIndex(4);
    setCurrentIndex(7);
    setCurrentIndex(8);
    setCurrentIndex(9);
    setCurrentIndex(11);
    setCurrentIndex(5);
    setCurrentIndex(14);
    setCurrentIndex(0);
    result_obj = rootobj->findChild<QObject*>("text");
    mark_img_obj = rootobj->findChild<QObject*>("mark_img");
    search_result_wait_obj = rootobj->findChild<QObject*>("wait_image");
    enable_pkg_img_obj = rootobj->findChild<QObject*>("enable_pkg_img");
    search_top_bar_obj = rootobj->findChild<QObject*>("search_top_bar");
    cropView_obj = rootobj->findChild<QObject*>("cropView");
    search_text_obj = rootobj->findChild<QObject*>("search_text");
    home_img_obj = rootobj->findChild<QObject*>("home_img");
    result_search_img_obj = rootobj->findChild<QObject*>("result_search_img");
    result_search_light_img_obj = rootobj->findChild<QObject*>("result_search_light_img");
    update_dialog_obj = rootobj->findChild<QObject*>("update_dialog");
    pluginPages_obj = rootobj->findChild<QObject*>("pluginPages");
    if(!(result_obj)) qDebug()<<"result_obj not find";
    if(!(tabView_obj)) qDebug()<<"tabView_obj not find";
    if(!(swipeView_obj)) qDebug()<<"swipeView_obj not find";
    init_plugin_library(pluginPages_obj);
}

void Offline_small_search::init_obj()
{
    result_obj = rootObject->findChild<QObject*>("text");
    mark_img_obj = rootObject->findChild<QObject*>("mark_img");
    search_result_wait_obj = rootObject->findChild<QObject*>("wait_image");
    enable_pkg_img_obj = rootObject->findChild<QObject*>("enable_pkg_img");
    search_top_bar_obj = rootObject->findChild<QObject*>("search_top_bar");
    cropView_obj = rootObject->findChild<QObject*>("cropView");
    search_text_obj = rootObject->findChild<QObject*>("search_text");
    home_img_obj = rootObject->findChild<QObject*>("home_img");
    result_search_img_obj = rootObject->findChild<QObject*>("result_search_img");
    result_search_light_img_obj = rootObject->findChild<QObject*>("result_search_light_img");
    update_dialog_obj = rootObject->findChild<QObject*>("update_dialog");
    pluginPages_obj = rootObject->findChild<QObject*>("pluginPages");
    if(!(result_obj)) qDebug()<<"result_obj not find";
    if(!(search_text_obj)) qDebug()<<"search_text_obj not find";
}

void Offline_small_search::init_plugin_library(QObject *obj)
{
    QMapIterator<QString,PageInterface*> pagePluginInterfacsListIterator(pagePluginInterfacsList);
    QMap<QString,QVariant> parm;
    parm["tempDir"] = get_cache_dir()+"/plugin/temp/";
    parm["cacheDir"] = get_cache_dir()+"/plugin/cache/";
    parm["dataDir"] = get_data_dir()+"/plugin/data/";
    while (pagePluginInterfacsListIterator.hasNext()) {
        pagePluginInterfacsListIterator.next();
        qDebug()<<obj;
        for(int i = 0; i < pagePluginEntrysList.size(); ++i)
        {
            if(std::get<0>(pagePluginEntrysList.at(i)) == pagePluginInterfacsListIterator.key())
                parm["pluginInstallDir"] = std::get<1>(pagePluginEntrysList.at(i))+"/";
        }
        rootContext->setContextProperty(pagePluginInterfacsListIterator.key(),pagePluginInterfacsListIterator.value()->init(obj,parm));
    }
}

void Offline_small_search::init_data()
{
    data_file_to_offline_pkg_list();
    data_file_to_history_list();
    data_file_to_mark_list();
    refresh_search_result_for_search_result_qml();
    check_data_pkgs();
    if(init_search_obj_finish)
        init_search_from_offline_pkg_list();
    init_data_finish = true;
}

void Offline_small_search::setCurrentIndex(int index)
{
    if(index <4)
    {
        tabView_obj->setProperty("currentIndex",0);
        //swipeView_obj->setProperty("currentIndex",index);
    }
    else
    {
        tabView_obj->setProperty("currentIndex",index-3);
    }
}

void Offline_small_search::show_back()
{
    if(view.isEmpty()) return;
    view.removeLast();
    setCurrentIndex(view.last());
}

void Offline_small_search::close_app()
{
    show_result("Bye");
    QCoreApplication::exit();
#ifdef Q_OS_ANDROID
    clickHome(); //exit is too slow.
#endif
    //QCoreApplication::quit();
}

Offline_small_search::~Offline_small_search()
{
    custom1.write_custom();
    offline_pkg_list_to_data_file();
    mark_list_to_data_file();
    history_list_to_data_file();
    search_thread.quit();
    clean_cache();
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
    if(view.last() != 0)
        view.append(0);
    setCurrentIndex(0);
}

void Offline_small_search::show_more()
{
    if(view.last() != 3)
        view.append(3);
    setCurrentIndex(3);
}

void Offline_small_search::show_more_search()
{
    if(view.last() != 1)
        view.append(1);
    setCurrentIndex(1);
}

void Offline_small_search::show_history()
{
    if(view.last() != 2)
        view.append(2);
    setCurrentIndex(2);
}

void Offline_small_search::show_search(QString str)
{
    if(view.last() == 9)
    {
        view.removeLast();
        if(view.last() == 8)
        {
            view.removeLast();
        }
    }
    if(view.last() != 7)
        view.append(7);
    if(str != " ")
        search_text_obj->setProperty("text",str);
    search_text_obj->setProperty("focus",true);
    home_img_obj->setProperty("have_home",have_home());
    setCurrentIndex(7);
}

void Offline_small_search::show_search_result(QString str,bool highter)
{
    if(!(str == ""||str.isEmpty()||str.isNull()))
    {
        search_str = str;
        search(search_type,search_str,highter);
    }
    result_search_light_img_obj->setProperty("source","");
    if(view.last() != 8)
        view.append(8);
    setCurrentIndex(8);
}

void Offline_small_search::re_search(bool highter)
{
    show_search_result(search_str,highter);
}

void Offline_small_search::show_pkg()
{
    refresh_offline_pkg_list_for_pkg_qml();
    if(view.last() != 4)
        view.append(4);
    setCurrentIndex(4);
}

void Offline_small_search::show_mark()
{
    if(view.last() != 10)
        view.append(10);
    setCurrentIndex(10);
}

void Offline_small_search::show_about()
{
    if(view.last() != 6)
        view.append(6);
    setCurrentIndex(6);
}

void Offline_small_search::show_custom()
{
    if(view.last() != 5)
        view.append(5);
    setCurrentIndex(5);
}

void Offline_small_search::show_crop(QString source)
{
    if(view.last() != 11)
        view.append(11);
    cropView_obj->setProperty("source"," ");
    cropView_obj->setProperty("source","");
    if(source != "")
        cropView_obj->setProperty("source",source);
    setCurrentIndex(11);
}

void Offline_small_search::show_online_download()
{
    if(view.last() != 12)
        view.append(12);
    setCurrentIndex(12);
}

void Offline_small_search::hide_wait()
{
    search_result_wait_obj->setProperty("visible",false);
}

void Offline_small_search::show_wait()
{
    search_result_wait_obj->setProperty("visible",true);
}

void Offline_small_search::show_pkg_home()
{
    if(search_type.count() != 1) return;
    QString pkg = search_type.first();
    for(int i = 0; i < offline_pkg_list.size(); ++i)
    {
        offline_pkg1 = qobject_cast<offline_pkg*>(offline_pkg_list.at(i));
        if(offline_pkg1->name_code() == pkg)
        {
            show_result(pkg+":/"+offline_pkg1->home_url());
        }
    }
}

bool Offline_small_search::have_home(QString pkg)
{
    if(pkg == "")
    {
        if(search_type.count() == 1)
            pkg = search_type.first();
        else return false;
    }

    for(int i = 0; i < offline_pkg_list.size(); ++i)
    {
        offline_pkg1 = qobject_cast<offline_pkg*>(offline_pkg_list.at(i));
        if(offline_pkg1->name_code() == pkg)
        {
            return offline_pkg1->home_enable();
        }
    }
    return false;
}

bool Offline_small_search::have_home_def(QString pkg)
{
    if(pkg == "")
    {
        if(search_type.count() == 1)
            pkg = search_type.first();
        else return false;
    }

    for(int i = 0; i < offline_pkg_list.size(); ++i)
    {
        offline_pkg1 = qobject_cast<offline_pkg*>(offline_pkg_list.at(i));
        if((offline_pkg1->name_code() == pkg)&&offline_pkg1->home_enable())
        {
            return offline_pkg1->home_def();
        }
    }
    return false;
}

void Offline_small_search::show_result(QString url)
{
    result_search_img_obj->setProperty("visible",((view.last() != 10)&&(search_type.count() > 0)));
    if(view.last() != 9)
        view.append(9);
    load_html("");
    webview_history.clear();
    setCurrentIndex(9);
    load_html(url);
}

void Offline_small_search::load_html(QString url)
{
    if(url == "Bye")
    {
        mark_img_obj->setProperty("source","");
        QMetaObject::invokeMethod(result_obj, "loadHtml",Qt::QueuedConnection,Q_ARG(QString, "<center><h1>Bye<h1></center>"),Q_ARG(QUrl, QUrl("")));
        return;
    }
    qDebug()<<"load_html:"<<url;
    if((url.indexOf("http://") == 0)||(url.indexOf("https://") == 0)) return;
    if(url.isEmpty()||url.isNull()||url.indexOf(QRegExp("[/\\\\]$")) != -1) return;
    QString search_url2;
    url.remove(QRegExp("#.*$"));
    url.remove(QRegExp("^file:/*"+get_cache_dir())).remove(get_cache_dir()).replace(QRegExp("[/\\\\]{2,}"),"/");
    url_name_code = url;
    url_name_code.remove(remove_name_reg);
    if(url_name_code != url)
        search_url2 = url;
    else
    {
        url_name_code = search_url;
        url_name_code.remove(remove_name_reg);
        url = url_name_code+":/"+url;
        search_url2 = url;
    }
    if(search_url2 == search_url && view.last() == 9)
        return;
    else
    {
        search_url = search_url2;
        //QMetaObject::invokeMethod(result_obj, "stop");
    }
    if(is_mark(search_url))
    {
        mark_img_obj->setProperty("source","qrc:/image/icon_mark_on.png");
    }
    else
    {
        mark_img_obj->setProperty("source","qrc:/image/icon_mark_off.png");
    }
    url.remove(0,url_name_code.size()+2);
    QString baseurl = "file:///"+get_cache_dir()+"/"+url;
    baseurl.replace(QRegExp("[/\\\\]{2,}"),"/").replace("file:/","file:///");
    QString localurl = baseurl;
    baseurl.remove(QRegExp("[^/]*$"));
    //result_obj->setProperty("url","");
    //qDebug()<<"load_html2"<<baseurl;
    if(webview_history.empty()||webview_history.count() < 1)
        webview_history.append(search_url);
    else if(webview_history.last() != search_url)
        webview_history.append(search_url);
    result_obj->setProperty("docurl",search_url);
    //处理没有头数据的html
    QString html_data = get_text_with_other_from_url(search_url);
    if(html_data.indexOf("<!DOCTYPE html>") == -1)
    {
        html_data = "<!DOCTYPE html>\n<html>\n<head>\n<meta http-equiv=Content-Type content=\"text/html;charset=utf-8\">\n<meta charset=\"utf-8\"/>\n<meta http-equiv=X-UA-Compatible content=\"IE=edge,chrome=1\">\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">\n</head>\n<body>\n"+html_data+"\n</body>\n</html>";
    }
    //处理低于Android4.4的网页显示不正常
    if(!QFile::exists(baseurl))
    {
        QDir tmp;
        tmp.mkpath(baseurl);
    }
#ifndef USE_WEBKIT //QtWebkit 载入非html,htm结尾的文件会有问题
    QFile html_file(get_cache_dir()+"/"+url);
    if(html_file.open(QFile::WriteOnly|QFile::Text|QFile::Truncate))
    {
        QTextStream html_stream(&html_file);
        html_stream.setCodec(QTextCodec::codecForHtml(html_data.toLocal8Bit(),QTextCodec::codecForName("UTF-8")));
        html_stream << html_data;
        html_file.close();
        result_obj->setProperty("url",localurl);
    }
    else
#else
    html_data.remove(" target=\"_blank\"");//QtWebkit处理target="_blank"有问题
#endif
        QMetaObject::invokeMethod(result_obj, "loadHtml",Qt::QueuedConnection,Q_ARG(QString, html_data),Q_ARG(QUrl, QUrl(baseurl)));
    result_obj->setProperty("count",webview_history.count());
    qDebug()<<"load_html3"<<search_url;
    //qDebug()<<"file:///"+get_cache_dir();
}

void Offline_small_search::webview_goback()
{
    if(webview_history.count() > 1)
    {
        webview_history.removeLast();
        load_html(webview_history.last());
    }
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
    //qDebug()<< search_url;
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
    for(int i = 0; i < offline_pkg_list.size(); ++i)
    {
        offline_pkg1 = qobject_cast<offline_pkg*>(offline_pkg_list.at(i));
        if(offline_pkg1->enable() && offline_pkg1->type() == type)
            search_type.append(offline_pkg1->name_code());
    }
    search_type.append(type);
    std::stable_sort(search_type.begin(),search_type.end());
    search_type.erase(std::unique(search_type.begin(),search_type.end()),search_type.end());
}

void Offline_small_search::search_type_add(QStringList type)
{
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
    for(int i = 0; i < offline_pkg_list.size(); ++i)
    {
        offline_pkg1 = qobject_cast<offline_pkg*>(offline_pkg_list.at(i));
        if(offline_pkg1->enable() && offline_pkg1->name_code() == url_name_code)
        {
            text = offline_pkg1->get_text_from_url(url);
            //qDebug()<<url<<" "<<text;
            if(!(text == ""||text.isNull()||text.isEmpty()))
            {
                htmlparser.reset();
                htmlparser.parse_html(text.toStdString(),"utf-8",true);
                return QString::fromStdString(htmlparser.dump);
            }
        }
    }
    return "";
}

QString Offline_small_search::get_text_with_other_from_url(QString url)
{
    url_name_code = url;
    //qDebug()<<url;
    url_name_code.remove(remove_name_reg);
    url.remove(0,url_name_code.size()+2);
    QString text;
    //qDebug()<<url;
    for(int i = 0; i < offline_pkg_list.size(); ++i)
    {
        offline_pkg1 = qobject_cast<offline_pkg*>(offline_pkg_list.at(i));
        if(offline_pkg1->enable() && offline_pkg1->name_code() == url_name_code)
        {
            text = offline_pkg1->get_text_with_other_from_url(url,cache_dir);
            if(!(text == ""||text.isNull()||text.isEmpty()))
            {
                return text;
            }
        }
    }
    return "";
}

void Offline_small_search::search(QStringList type, QString str, bool highter)
{
    if(offline_pkg_list.count() == 0)
    {
        qDebug()<<"offline_pkg_list count = 0";
        search_result_list.clear();
        search_result = new search_result_obj();
        search_result->setUrl("");
        search_result->setStr("请添加离线包再进行搜索");
        search_result_list.append(search_result);
        refresh_search_result_for_search_result_qml();
        return;
    }
    show_wait();
    ++search_batch;
    search_batch_highter[search_batch] = highter;
    //qDebug()<<str<<search_batch<<type;
    Q_EMIT xapian_search(str,search_batch,type);
    for(int i = 0; i < search_result_list.size(); ++i)
    {
        search_result_list.at(i)->deleteLater();
    }
    search_result_list.clear();
    refresh_search_result_for_search_result_qml();
}

void Offline_small_search::check_data_pkgs(bool enable)
{
    QDirIterator dir_it(get_data_dir(),QStringList(QString("data.zim")),QDir::Files,QDirIterator::Subdirectories|QDirIterator::FollowSymlinks);
    while(dir_it.hasNext())
    {
        dir_it.next();
        add_offline_pkg(dir_it.fileInfo().absolutePath(),enable);
    }
    QDirIterator dir_it2("data",QStringList(QString("data.zim")),QDir::Files,QDirIterator::Subdirectories|QDirIterator::FollowSymlinks);
    while(dir_it2.hasNext())
    {
        dir_it2.next();
        add_offline_pkg(dir_it2.fileInfo().absolutePath(),enable);
    }
}

void Offline_small_search::add_offline_pkg(QString path,bool enable)
{
    if(path.isEmpty()||path.isNull()) return;
    //path
    path.remove(QRegExp("[/\\\\]$"));
    if(path.indexOf(QRegExp("^file:/")) >= 0)
    {
        path.replace(QRegExp("^file:/*"), "");
#ifndef _WIN32
        path = "/"+path;
#endif
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
            return;
        }
    }
    offline_pkg1 = new offline_pkg(this);
    offline_pkg1->setPath(path);
    //name_code
    QRegExp name_code_reg("^.*[/\\\\]");
    name_code_reg.setMinimal(false);
    QString name_code = path;
    offline_pkg1->setName_code(name_code.remove(name_code_reg));
    //read info
    QString pkg_str;
    quint64 pkg_count;
    QDataStream pkg_info;
    QFile pkg;
    bool good = enable;
    QString home_url;
    bool home_def = false;
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
    //home
    pkg.setFileName(path+"/home");
    if(pkg.exists() && pkg.open(QFile::ReadOnly))
    {
        pkg_info.resetStatus();
        pkg_info.setDevice(&pkg);
        home_url.clear();
        if(!pkg_info.atEnd())
        {
            pkg_info >> home_url >> home_def;
            if(home_url.isEmpty()||home_url.isNull())
            {
                offline_pkg1->setHome_url("NULL");
                offline_pkg1->setHome_def(false);
                offline_pkg1->setHome_enable(false);
            }
            else
            {
                offline_pkg1->setHome_url(home_url);
                offline_pkg1->setHome_def(home_def);
                offline_pkg1->setHome_enable(true);
            }
        }
        else
        {
            offline_pkg1->setHome_url("NULL");
            offline_pkg1->setHome_def(false);
            offline_pkg1->setHome_enable(false);
        }
        pkg.close();
    }
    else
    {
        offline_pkg1->setHome_url("NULL");
        offline_pkg1->setHome_def(false);
        offline_pkg1->setHome_enable(false);
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
    if(path.indexOf(QRegExp("^file:/")) >= 0)
    {
        path.replace(QRegExp("^file:/*"), "");
#ifndef _WIN32
        path = "/"+path;
#endif
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
    else
    {
        offline_pkg_list.clear();
        refresh_offline_pkg_list_for_pkg_qml();
    }
}

void Offline_small_search::remove_all_offline_pkg()
{
    for(int i = 0; i < offline_pkg_list.size(); ++i)
    {
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
        if(offline_pkg1->path().indexOf(QRegExp("^"+get_data_dir())) == -1)
            pkg_stream << offline_pkg1->path() <<offline_pkg1->enable();
    }
    pkg.close();
}

void Offline_small_search::refresh_offline_pkg_list_for_pkg_qml()
{
    rootContext->setContextProperty("offline_pkg_list", QVariant::fromValue(offline_pkg_list));
    refresh_more_search_list_for_more_search_qml();
}

void Offline_small_search::add_history(QString str,bool img,QString time,QStringList type)
{
    if(str.isEmpty()||str.isNull()) return;
    history = new history_obj(this);
    history->setStr(str);
    history->setImg(img);
    history->setTime(time);
    history->setSearch_type(type);
    history_list.prepend(history);
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
        QStringList history_type;
        QDataStream history_file_stream(&history_file);
        int a = -1;
        while((!history_file_stream.atEnd())&&(++a)<custom1.max_history())
        {
            history_file_stream >> history_str >> history_img >> history_time >> history_type;
            history = new history_obj(this);
            history->setSearch_type(history_type);
            history->setStr(history_str);
            history->setImg(history_img);
            history->setTime(history_time);
            history_list.append(history);
            refresh_history_list_for_history_qml();
        }
        history_file.close();
        refresh_history_list_for_history_qml();
    }
    else
    {
        history_list.clear();
        refresh_history_list_for_history_qml();
    }
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
        history_file_stream << history->str() << history->img() << history->time() << history->search_type();
    }
    history_file.close();
}

void Offline_small_search::refresh_history_list_for_history_qml()
{
    rootContext->setContextProperty("history_list", QVariant::fromValue(history_list));
}

void Offline_small_search::refresh_search_result_for_search_result_qml()
{
    rootContext->setContextProperty("search_result_obj", QVariant::fromValue(search_result_list));
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

void Offline_small_search::on_search_result(QStringList urls, QStringList key_words, int batch)
{
    if(batch == search_batch)
    {
        search_result_list.clear();
        for(int i = 0; i < urls.size(); ++i)
        {
            search_result = new search_result_obj();
            search_result->setUrl(urls.at(i));
            //search_result->setStr(get_text_from_url(urls.at(i)));
            //qDebug()<<"Light xxx:"<<get_text_from_url(urls.at(i))<<" hh "<<key_words;
            if(urls.at(i).indexOf(":/") > 0)
            {
                search_result->setStr(search_batch_highter.value(search_batch,true) ? highlight_str(get_text_from_url(urls.at(i)),key_words,100) : get_text_from_url(urls.at(i)));
                QString title = get_title(urls.at(i),search_batch_highter.value(search_batch,true),key_words);
                if(!(title == ""||title.isNull()||title.isEmpty()))
                {
                    search_result->setHaveTitle(true);
                    search_result->setTitle(title);
                }
                else search_result->setHaveTitle(false);
            }
            if(search_result->str().isEmpty()||search_result->str().isNull())
                search_result->setStr(search_result->url());
            search_result_list.append(search_result);
        }
        refresh_search_result_for_search_result_qml();
        result_search_light_img_obj->setProperty("source",search_batch_highter.value(search_batch,true) ? "qrc:/image/icon_light.png" : "qrc:/image/icon_no_light.png");
        hide_wait();
    }
    if(batch < 0)
    {
        search_result_list.clear();
        for(int i = 0; i < urls.size(); ++i)
        {
            search_result = new search_result_obj();
            search_result->setUrl("");
            search_result->setStr("对不起,程序有问题咯: "+QString::number(batch)+" : "+urls.at(i));
            search_result_list.append(search_result);
        }
        refresh_search_result_for_search_result_qml();
        hide_wait();
    }
}

QString Offline_small_search::highlight_str(QString str,QStringList &key_words,int max_char)
{
    //str.replace("<","&lt;");
    //str.replace(">","&gt;");
    //str.replace("&","&amp;");
    //str.replace("\"","&quot;");
    str.remove('<').remove('>');
    str.replace(QRegExp(" +")," ");
    QVector<bool> word_highter(str.size(),false);
    QString stopword(" a about above after again against all am an and any are aren't as at be because been before being below between both but by can't cannot could couldn't did didn't do does doesn't doing don't down during each few for from further had hadn't has hasn't have haven't having he he'd he'll he's her here here's hers herself him himself his how how's i i'd i'll i'm i've if in into is isn't it it's its itself let's me more most mustn't my myself no nor not of off on once only or other ought our ours ourselves out over own same shan't she she'd she'll she's should shouldn't so some such than that that's the their theirs them themselves then there there's these they they'd they'll they're they've this those through to too under until up very was wasn't we we'd we'll we're we've were weren't what what's when when's where where's which while who who's whom why why's with won't would wouldn't you you'd you'll you're you've your yours yourself yourselves ");
    int more_index = 0;
    QList<QString> have_stopwords;
    for(auto key_it = key_words.begin(); key_it != key_words.end(); ++key_it)
    {
        int key_size = (*key_it).size();
        if((key_size < 2)&&((*key_it).indexOf(QRegExp("[0-9]")) == -1)) continue;
        if(stopword.indexOf(" "+(*key_it)+" ") > -1)
        {
            have_stopwords.append(*key_it);
            continue;
        }
        int idx = 0-key_size;
        bool en_key = ((*key_it).indexOf(QRegExp("[A-Za-z]")) >= 0);
        bool number_key = ((*key_it).indexOf(QRegExp("[0-9]")) >= 0);
        int sc;
        if(en_key)
            sc = str.count(QRegExp("\\b"+(*key_it)+"\\b",Qt::CaseInsensitive));
        else
        {
            if(number_key)
                sc = str.count(QRegExp("(?=[^0-9])(*key_it)(?=[^0-9])"));
            else
                sc = str.count(*key_it,Qt::CaseInsensitive);
        }
        more_index += sc;
        for(int a = 0; a < sc; ++a)
        {
            if(en_key)
                idx = str.indexOf(QRegExp("\\b"+(*key_it)+"\\b",Qt::CaseInsensitive),idx+key_size);
            else
            {
                if(number_key)
                    idx = str.indexOf(QRegExp("(?=[^0-9])(*key_it)(?=[^0-9])"),idx+key_size);
                else
                    idx = str.indexOf(*key_it,idx+key_size,Qt::CaseInsensitive);
            }
            for(int b = 0; b < key_size; ++b)
            {
                word_highter[idx+b] = true;
            }
        }
    }
    for(auto key_it = have_stopwords.begin(); key_it != have_stopwords.end(); ++key_it)
    {
        int key_size = (*key_it).size();
        int idx = 0-key_size;
        bool en_key = ((*key_it).indexOf(QRegExp("[A-Za-z]")) >= 0);
        int sc;
        if(en_key)
            sc = str.count(QRegExp("\\b"+(*key_it)+"\\b",Qt::CaseInsensitive));
        else
            sc = str.count(*key_it,Qt::CaseInsensitive);
        for(int a = 0; a < sc; ++a)
        {
            if(en_key)
            {
                idx = str.indexOf(QRegExp("\\b"+(*key_it)+"\\b",Qt::CaseInsensitive),idx+key_size);
                if((idx < 2)&&(word_highter.at(idx+key_size+1) == false))
                    continue;
                if(((idx+key_size+2) > word_highter.size())&&(word_highter.at(idx-2) == false))
                    continue;
                if((word_highter.at(idx-2) == false)||(word_highter.at(idx+key_size+1) == false))
                    continue;
            }
            else
            {
                idx = str.indexOf(*key_it,idx+key_size,Qt::CaseInsensitive);
                if((idx < 1)&&(word_highter.at(idx+key_size) == false))
                    continue;
                if(((idx+key_size+1) > word_highter.size())&&(word_highter.at(idx-1) == false))
                    continue;
                if((word_highter.at(idx-1) == false)||(word_highter.at(idx+key_size) == false))
                    continue;
            }
            ++more_index;
            for(int b = 0; b < key_size; ++b)
            {
                word_highter[idx+b] = true;
            }
        }
    }
    //qDebug()<<"more_index"<<more_index;
    if(more_index < 6)
    {
        for(auto key_it = key_words.begin(); key_it != key_words.end(); ++key_it)
        {
            int key_size = (*key_it).size();
            int idx = 0-key_size;
            int sc = str.count(*key_it,Qt::CaseInsensitive);
            for(int a = 0; a < sc; ++a)
            {
                ++more_index;
                idx = str.indexOf(*key_it,idx+key_size,Qt::CaseInsensitive);
                for(int b = 0; b < key_size; ++b)
                {
                    word_highter[idx+b] = true;
                }
            }
        }
    }
    QString hight_str;
    for(int a = 0; a < word_highter.size(); ++a)
    {
        if((a == 0)&&word_highter.at(a))
        {
            hight_str.append("<font color=\"#FF0000\">");
        }
        else
        {
            if((a == str.size()-1)&&word_highter.at(a))
            {
                hight_str.append("</font>");
            }
            else
            {
                if(word_highter.at(a))
                {
                    if((!word_highter.at(a-1))&&!((str.at(a-1).isSpace()||str.at(a-1).isSymbol())&&word_highter.at(a-2)))
                        hight_str.append("<font color=\"#FF0000\">");
                }
                else
                {
                    if(word_highter.at(a-1)&&!((str.at(a-1).isSpace()||str.at(a-1).isSymbol())&&word_highter.at(a+1)))
                    {
                        hight_str.append("</font>");
                    }
                }
            }
        }
        hight_str.append(str.at(a));
    }
    if((max_char != 0)&&(str.length() > max_char))
    {
        int first = hight_str.indexOf("<");
        if(first < (str.length() - max_char))
        {
            QString hight_str_left = "";
            if(first > 0 )
            {
                hight_str_left = hight_str.left(first);
                int two_en = hight_str_left.lastIndexOf(QRegExp("\\b[A-Za-z_]\\b[A-Za-z_]\\b"));
                if(two_en == -1)
                    two_en = hight_str_left.lastIndexOf(QRegExp("\\b[A-Za-z_]\\b"));
                int two_cn = hight_str_left.lastIndexOf(QRegExp("[^A-Za-z_.,。，；：‘’“”《》？、][^A-Za-z_.,。，；：‘’“”《》？、]"));
                if(two_cn == -1)
                    two_cn = hight_str_left.lastIndexOf(QRegExp("[^A-Za-z_.,。，；：‘’“”《》？、]"));
                int two = -1;
                if(two_cn > two_en)
                    two = two_cn;
                else
                    two = two_en;
                if(two > 0)
                    hight_str_left.remove(0,two-1);
            }
            hight_str.replace(QRegExp("^[^<]*<font color=\"#FF0000\">"),"<font color=\"#FF0000\">");
            hight_str = hight_str_left+hight_str;
        }
        else hight_str.replace(QRegExp("^[^<]{0,"+QString::number(str.length() - max_char)+"}"),"");
    }
    return hight_str;
}

void Offline_small_search::on_init_search_obj_finish()
{
    init_search_obj_finish = true;
    if(init_data_finish)
        init_search_from_offline_pkg_list();
}

void Offline_small_search::on_search_init_finish(int batch)
{
    if(batch == init_search_batch)
    {
        init_search_finish = true;
        qDebug()<<"init_search_finish:"<<init_search_finish;
    }
}

QString Offline_small_search::get_title(QString url,bool highter,QStringList key_words)
{
    url_name_code = url;
    //qDebug()<<url;
    url_name_code.remove(remove_name_reg);
    url.remove(0,url_name_code.size()+2);
    QString text;
    //qDebug()<<url;
    for(int i = 0; i < offline_pkg_list.size(); ++i)
    {
        offline_pkg1 = qobject_cast<offline_pkg*>(offline_pkg_list.at(i));
        if(offline_pkg1->enable() && offline_pkg1->name_code() == url_name_code)
        {
            text = offline_pkg1->get_text_from_url(url);
            if(!(text == ""||text.isNull()||text.isEmpty()))
            {
                htmlparser.reset();
                htmlparser.parse_html(text.toStdString(),"utf-8",true);
                QString title = QString::fromStdString(htmlparser.title);
                if(!(title == ""||title.isNull()||title.isEmpty()))
                {
                    return highter ? highlight_str(title,key_words,100) : title;
                }
            }
        }
    }
    return QString();
}

QString Offline_small_search::get_cache_dir()
{
    return cache_dir;
}

void Offline_small_search::remove_mark(QString url)
{
    if(url.isEmpty()||url.isNull()) return;

    for(int i = 0; i < mark_list.size(); ++i)
    {
        mark = qobject_cast<mark_obj*>(mark_list.at(i));
        if(mark->url() == url)
        {
            mark->deleteLater();
            mark_list.removeAt(i);
        }
    }
    refresh_mark_list_for_mark_qml();
}

void Offline_small_search::remove_all_mark()
{
    for(int i = 0; i < mark_list.size(); ++i)
    {
        mark = qobject_cast<mark_obj*>(mark_list.at(i));
        mark_list.at(i)->deleteLater();
    }
    mark_list.clear();
    refresh_mark_list_for_mark_qml();
}

void Offline_small_search::data_file_to_mark_list(QString file_path)
{
    QString path;
    if(file_path == "" || file_path.isEmpty() || file_path.isNull()) path = QDir::currentPath()+"/mark.dat";
    else
    {
        if(file_path.indexOf(QRegExp("[/\\\\]")) == -1)
            path = QDir::currentPath()+file_path;
        else
        {
            if(file_path.indexOf(QRegExp("[/\\\\]$")) == -1)
                path = file_path;
            else path = file_path+"mark.dat";
        }
    }
    QFile mark_file(path);
    if(mark_file.exists() && mark_file.open(QFile::ReadOnly))
    {
        remove_all_mark();
        QString mark_str;
        QString mark_url;
        QDataStream mark_file_stream(&mark_file);
        while(!mark_file_stream.atEnd())
        {
            mark_file_stream >> mark_str >> mark_url;
            mark = new mark_obj(this);
            mark->setStr(mark_str);
            mark->setUrl(mark_url);
            mark_list.append(mark);
            refresh_mark_list_for_mark_qml();
        }
        mark_file.close();
        refresh_mark_list_for_mark_qml();
    }
    else
    {
        mark_list.clear();
        refresh_mark_list_for_mark_qml();
    }
}

void Offline_small_search::mark_list_to_data_file(QString file_path)
{
    if(mark_list.empty()) return;
    QString path;
    if(file_path == "" || file_path.isEmpty() || file_path.isNull()) path = QDir::currentPath()+"/mark.dat";
    else
    {
        if(file_path.indexOf(QRegExp("[/\\\\]")) == -1)
            path = QDir::currentPath()+file_path;
        else
        {
            if(file_path.indexOf(QRegExp("[/\\\\]$")) == -1)
                path = file_path;
            else path = file_path+"mark.dat";
        }
    }
    QFile mark_file(path);
    QDir a;
    QRegExp path_dir_regexp("[/\\\\].*$");
    path_dir_regexp.setMinimal(true);
    a.mkpath(path.remove(path_dir_regexp));
    mark_file.open(QFile::WriteOnly);
    QDataStream mark_file_stream(&mark_file);
    for(int i = 0; i < mark_list.size(); ++i)
    {
        mark = qobject_cast<mark_obj*>(mark_list.at(i));
        mark_file_stream << mark->str() << mark->url();
    }
    mark_file.close();
}

void Offline_small_search::add_mark(QString str,QString url)
{
    if(url.isEmpty()||url.isNull()) return;
    mark = new mark_obj(this);
    mark->setStr(str);
    mark->setUrl(url);
    mark_list.prepend(mark);
    refresh_mark_list_for_mark_qml();
}

void Offline_small_search::refresh_mark_list_for_mark_qml()
{
    rootContext->setContextProperty("mark_obj", QVariant::fromValue(mark_list));
}

bool Offline_small_search::is_mark(QString url)
{
    for(int i = 0; i < mark_list.size(); ++i)
    {
        mark = qobject_cast<mark_obj*>(mark_list.at(i));
        if(mark->url() == url)
        {
            return true;
        }
    }
    return false;
}

void Offline_small_search::check_mark()
{
    if(is_mark(search_url))
    {
        remove_mark(search_url);
        mark_img_obj->setProperty("source","qrc:/image/icon_mark_off.png");
    }
    else
    {
        add_mark(get_text_from_url(search_url),search_url);
        mark_img_obj->setProperty("source","qrc:/image/icon_mark_on.png");
    }
}

void Offline_small_search::check_enable_pkg(QString path)
{
    if(path.isEmpty()||path.isNull()) return;
    for(int i = 0; i < offline_pkg_list.size(); ++i)
    {
        offline_pkg1 = qobject_cast<offline_pkg*>(offline_pkg_list.at(i));
        if(offline_pkg1->path() == path)
        {
            if(offline_pkg1->enable())
            {
                offline_pkg1->setEnable(false);
                enable_pkg_img_obj->setProperty("source","qrc:/image/icon_switch_off.png");
            }
            else
            {
                offline_pkg1->setEnable(true);
                enable_pkg_img_obj->setProperty("source","qrc:/image/icon_switch_on.png");
            }
        }
    }
    refresh_offline_pkg_list_for_pkg_qml();
}

void Offline_small_search::refresh_more_search_list_for_more_search_qml()
{
    QRegExp pkg_suf("离线.*包");
    for(int i = 0; i < more_search_list.size(); ++i)
    {
        more_search_list.at(i)->deleteLater();
    }
    more_search_list.clear();

    for(int i = 0; i < offline_pkg_list.size(); ++i)
    {
        offline_pkg1 = qobject_cast<offline_pkg*>(offline_pkg_list.at(i));
        if(offline_pkg1->enable())
        {
            more_search = new more_search_obj();
            more_search->setType(offline_pkg1->type());
            more_search->setName_code(offline_pkg1->name_code());
            more_search->setName(offline_pkg1->name().remove(pkg_suf));
            more_search->setIs_plugin(false);
            more_search_list.append(more_search);
        }
    }
    for(int i = 0; i < pagePluginEntrysList.size(); ++i)
    {
        more_search = new more_search_obj();
        more_search->setType("Plugin");
        more_search->setName_code(std::get<0>(pagePluginEntrysList.at(i)));
        more_search->setName(std::get<3>(pagePluginEntrysList.at(i)));
        more_search->setPluginQmlPath(std::get<2>(pagePluginEntrysList.at(i)));
        more_search->setAbsoluteQmlPath(std::get<1>(pagePluginEntrysList.at(i))+"/"+std::get<2>(pagePluginEntrysList.at(i)));
        more_search->setIs_plugin(true);
        more_search_list.append(more_search);
    }
    rootContext->setContextProperty("more_search_list", QVariant::fromValue(more_search_list));
}

int Offline_small_search::more_search_count()
{
    return more_search_list.count();
}

void Offline_small_search::set_top_bar_height(qreal top_bar_height)
{
    search_top_bar_obj->setProperty("height",top_bar_height);
}

void Offline_small_search::startCamera()
{
    startCamera(cropView_obj);
}

void Offline_small_search::startCamera(QObject *wait_camera, QString img_source_name, QString img_camer_error_name)
{
    if(!wait_camera)
    {
        qDebug()<<"wait_camera have question"<<wait_camera;
        wait_camera = cropView_obj;
    }
    wait_camera_obj = wait_camera;
    QByteArray ba1 = img_camer_error_name.toLocal8Bit();
    wait_camera_img_camer_error_name = strdup(ba1.data());
    QByteArray ba2 = img_source_name.toLocal8Bit();
    wait_camera_img_source_name = strdup(ba2.data());
#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticMethod<void>(
                "qt/oss/OfflineSmallSearchActivity",
                "captureImage");
    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        qDebug() << "onCaptureImage, got exception";
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
    if(wait_camera == cropView_obj)
        show_crop();
#else
    /*
    if(view.last() != 13)
        view.append(13);
    */
    setCurrentIndex(13);
#endif
}

#ifdef Q_OS_ANDROID
void Offline_small_search::clickHome()
{
    QAndroidJniObject::callStaticMethod<void>(
                "qt/oss/OfflineSmallSearchActivity",
                "clickHome");
    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        qDebug() << "onclickHome, got exception";
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}

int Offline_small_search::getAndroidVersion()
{
    int ver = 19;
    ver = QAndroidJniObject::callStaticMethod<int>(
                "qt/oss/OfflineSmallSearchActivity",
                "getSysVer");
    QAndroidJniEnvironment env;
    if (env->ExceptionCheck())
    {
        qDebug() << "getAndroidVersion, got exception";
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
    return ver;
}
#endif

int Offline_small_search::getAndroidVerCache()
{
#ifdef Q_OS_ANDROID
    return androidVersion;
#else
    return 0;
#endif
}

bool Offline_small_search::event(QEvent *e)
{
    if(e->type() == capCustomEvent::eventType())
    {
        e->accept();
        capCustomEvent *sce = (capCustomEvent*)e;
        if(!wait_camera_obj)
        {
            qDebug()<<"wait_camera_obj have question"<<wait_camera_obj;
            return true;
        }
        wait_camera_obj->setProperty(wait_camera_img_source_name,"");
        if(sce->m_arg1 == 2)
        {
            //show_crop();
            wait_camera_obj->setProperty(wait_camera_img_source_name,"file://"+cp_grayimg_to_tmp(sce->m_arg2));
        }
        else
        {
            if(sce->m_arg1 != -2)
                wait_camera_obj->setProperty(wait_camera_img_camer_error_name,true);
        }
        return true;
    }
    return QObject::event(e);
}

bool Offline_small_search::openUrl(QString url)
{
    return QDesktopServices::openUrl(QUrl(url));
}

void Offline_small_search::remove_data(QString url)
{
    QString url2 = url;
    url.remove(only_file_name);
    if(QFile::exists(get_data_dir()+"/"+url))
    {
        QFile::remove(get_data_dir()+"/"+url);
    }        
    if(QFile::exists(get_data_dir()+"/"+url.remove(".zip")))
    {
        QString dirName = get_data_dir()+"/"+url;
        QDirIterator dir_it(dirName,QDir::Dirs|QDir::NoDotAndDotDot,QDirIterator::Subdirectories|QDirIterator::FollowSymlinks);
        while (dir_it.hasNext())
        {
            dir_it.next();
            if(QFile::exists(dir_it.filePath()+"/name")&&QFile::exists(dir_it.filePath()+"/data.zim"))
                remove_offline_pkg(dir_it.filePath());
        }
        qDebug()<<"remove "<<dirName;
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
            dir.rmpath(".");
        }
        dir.mkpath(get_data_dir());
    }
    else
    {
        for(int i = 0; i < offline_pkg_list.size(); ++i)
        {
            offline_pkg1 = qobject_cast<offline_pkg*>(offline_pkg_list.at(i));
            if(offline_pkg1->name_code() == url||offline_pkg1->name_code() == url2)
            {
                QString dirName = offline_pkg1->path();
                QString dirName2 = offline_pkg1->path();
                offline_pkg1->deleteLater();
                offline_pkg_list.removeAt(i);
                qDebug()<<"remove "<<dirName;
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
                    dir.rmpath(".");
                }
                dir.mkpath(dirName2.remove(QRegExp("[^/\\\\]*[/\\\\]*$")));
            }
        }
        refresh_offline_pkg_list_for_pkg_qml();
    }
    qDebug()<<"remove dir finish"<<get_data_dir()+"/"+url;//<<get_url_objname(url2);
    QObject* wait_img_obj = obj_list.value(url2);//ui->online_download_qml->rootObject()->findChild<QObject*>(get_url_objname(url2),Qt::FindChildrenRecursively);
    if(wait_img_obj) wait_img_obj->setProperty("visible",false);
}

QString Offline_small_search::md5(QString str)
{
    return QString(QCryptographicHash::hash(str.toLocal8Bit(),QCryptographicHash::Md5).toHex());
}

void Offline_small_search::download_data(QString url)
{
    qDebug()<<"download_data"<<url;
    QString file = url;
    file.remove(only_file_name);
    if(QFile::exists(get_data_dir()+"/"+file))
    {
        qDebug()<<"remove";
        QFile::remove(get_data_dir()+"/"+file);
    }
    m_reply = m_down.get(QNetworkRequest(QUrl(url)));
    if(!QFile::exists(get_data_dir()))
    {
        QDir a;
        a.mkpath(get_data_dir());
    }
    connect(m_reply,SIGNAL(finished()),this,SLOT(download_data_finish()));
    connect(m_reply, SIGNAL(downloadProgress(qint64,qint64)), this, SLOT(onDownloadProgress(qint64 ,qint64 )));
    connect((QObject *)m_reply, SIGNAL(readyRead()),this, SLOT(onReadyRead()));
}

void Offline_small_search::download_data_finish()
{
    m_reply=dynamic_cast<QNetworkReply*>(sender());
    if(!m_reply->isFinished())
    {
        return;
    }
    if(m_reply->error() == QNetworkReply::NoError)
    {
        QFile file(get_data_dir()+"/"+m_reply->url().toString().remove(only_file_name));
        file.open(QIODevice::WriteOnly|QIODevice::Append);
        file.write(m_reply->readAll());
        file.close();
        QDir a;
        a.mkpath(get_data_dir()+"/"+m_reply->url().toString().remove(only_file_name).remove(".zip"));
        ++unzip_batch;
        unzip_url_map[unzip_batch] = m_reply->url().toString();
		QObject* wait_img_obj = obj_list.value(m_reply->url().toString());
        if(wait_img_obj) wait_img_obj->setProperty("progress",QObject::tr("解压中"));
        Q_EMIT unzip(get_data_dir()+"/"+m_reply->url().toString().remove(only_file_name), get_data_dir()+"/"+m_reply->url().toString().remove(only_file_name).remove(".zip"),unzip_batch);
        //file.remove();
    }
}

void Offline_small_search::onDownloadProgress(qint64 bytesSent, qint64 bytesTotal)
{
	m_reply=dynamic_cast<QNetworkReply*>(sender());
    QObject* wait_img_obj = obj_list.value(m_reply->url().toString());
    //qDebug()<<bool(wait_img_obj)<<double(bytesSent)/double(bytesTotal)*100.0;
    if(wait_img_obj) wait_img_obj->setProperty("progress",QString::number(int(double(bytesSent)/double(bytesTotal)*100.0))+"%");
}

void Offline_small_search::onReadyRead()
{
    m_reply=dynamic_cast<QNetworkReply*>(sender());
    if(m_reply->error() == QNetworkReply::NoError)
    {
        QFile file(get_data_dir()+"/"+m_reply->url().toString().remove(only_file_name));
        file.open(QIODevice::WriteOnly|QIODevice::Append);
        file.write(m_reply->readAll());
        file.close();
    }
}

void Offline_small_search::obj_list_insert(QString key, QObject *obj)
{
    obj_list.insert(key,obj);
}

QString Offline_small_search::get_data_dir()
{
    if(data_dir.isNull()||data_dir.isEmpty()||data_dir.indexOf(QRegExp("[/\\\\]")) == -1)
    {
        QString sdPath;
#ifdef Q_OS_ANDROID
        QAndroidJniObject path =
            QAndroidJniObject::callStaticObjectMethod(
                "qt/oss/OfflineSmallSearchActivity",
                "getSdcardPath", "()Ljava/lang/String;");
        sdPath = path.toString();
#else
        sdPath = QDir::currentPath();
#endif
        if(!sdPath.isEmpty())
        {
            QDir dir(sdPath);
            if((dir.exists("oss") || dir.mkdir("oss")) && (dir.exists("oss/data") || dir.mkdir("oss/data")))
                data_dir = sdPath+"/oss/data";
            else
            {
                QDir dir("/sdcard");
                if((dir.exists("oss") || dir.mkdir("oss")) && (dir.exists("oss/data") || dir.mkdir("oss/data")))
                    data_dir = "/sdcard/oss/data";
                else
                {
                    QDir dir(QDir::currentPath());
                    if((dir.exists("oss") || dir.mkdir("oss")) && (dir.exists("oss/data") || dir.mkdir("oss/data")))
                        data_dir = QDir::currentPath()+"/oss/data";
                }
            }
        }
        else
        {
            QDir dir("/sdcard");
            if((dir.exists("oss") || dir.mkdir("oss")) && (dir.exists("oss/data") || dir.mkdir("oss/data")))
                data_dir = "/sdcard/oss/data";
            else
            {
                QDir dir(QDir::currentPath());
                if((dir.exists("oss") || dir.mkdir("oss")) && (dir.exists("oss/data") || dir.mkdir("oss/data")))
                    data_dir = QDir::currentPath()+"/oss/data";
            }
        }
    }
    return data_dir;
}

bool Offline_small_search::is_exist(QString file,int type)
{
    if(type == 1)
    {
        if(!QFile::exists(get_data_dir()+"/"+file.remove(only_file_name).remove(".zip")))
        {
            for(int i = 0; i < offline_pkg_list.size(); ++i)
            {
                offline_pkg1 = qobject_cast<offline_pkg*>(offline_pkg_list.at(i));
                if(offline_pkg1->name_code() == file.remove(only_file_name).remove(".zip")||offline_pkg1->name_code() == file)
                {
                    return true;
                }
            }
        }
        else return true;
    }
    if(type == 2)
    {
        if(file.indexOf(QRegExp("^file:/")) >= 0)
        {
            file.replace(QRegExp("^file:/*"), "");
#ifndef _WIN32
            file = "/"+file;
#endif
        }
        return QFile::exists(file);
    }
    return QFile::exists(file);
}

void Offline_small_search::on_crop_ocr_result(QString text, int batch)
{
    if(crop_batch == batch && view.last() == 11)
    {
        if(text == QString())
            cropView_obj->setProperty("have_ocr_init_error",true);
        else
        {
            if(text == " ")
                cropView_obj->setProperty("have_ocr_no_word_error",true);
            else
            {
                show_search_result(text,false);
            }
        }
        cropView_obj->setProperty("source"," ");
        cropView_obj->setProperty("source","");
    }
}

void Offline_small_search::on_crop_ocr_rotate_finish(QString imagepath,int batch)
{
    if(crop_batch == batch)
    {
        cropView_obj->setProperty("source",imagepath);
    }
}

void Offline_small_search::on_crop_ocr_init_finish(int batch)
{
    qDebug()<<"init crop_ocr finish"<<batch;
}

void Offline_small_search::on_unzip_finish(int batch,QString dir)
{
    if((dir.indexOf(qApp->applicationDirPath()+"/plugins") > -1)||(dir.indexOf(QDir::currentPath()+"/plugins") > -1))
    {
        QObject *pluginInstallFinsh_dialog_obj = rootObject->findChild<QObject*>("pluginInstallFinsh_messageDialog");
        pluginInstallFinsh_dialog_obj->setProperty("pluginName",QVariant(pagePluginIdAndNameMapForInstall.value(unzip_oplu_map.value(batch,"Unknown"),unzip_oplu_map.value(batch,"Unknown Plugin"))));
        QMetaObject::invokeMethod(pluginInstallFinsh_dialog_obj, "open");
        return;
    }
    QDirIterator dir_it(dir,QDir::Dirs|QDir::NoDotAndDotDot,QDirIterator::Subdirectories|QDirIterator::FollowSymlinks);
    while (dir_it.hasNext())
    {
        dir_it.next();
        if(QFile::exists(dir_it.filePath()+"/name")&&QFile::exists(dir_it.filePath()+"/data.zim"))
            add_offline_pkg(dir_it.filePath());
    }
    QObject* wait_img_obj = obj_list.value(unzip_url_map[batch]);
    if(wait_img_obj) wait_img_obj->setProperty("visible",false);
}

void Offline_small_search::crop_ocr_Q(QString imagepath, QVariant cropPoints, QString lang)
{
    Q_EMIT crop_ocr(imagepath,cropPoints,lang,++crop_batch);
}

void Offline_small_search::rotate_Q(QString imagepath, int rotate_n)
{
    Q_EMIT rotate(imagepath,rotate_n,++crop_batch);
}

void Offline_small_search::read_data_file(QString file_path)
{
    if(file_path.indexOf(QRegExp("^file:/")) >= 0)
    {
        file_path.replace(QRegExp("^file:/*"), "");
#ifndef _WIN32
        file_path = "/"+file_path;
#endif
    }
    custom1.read_custom(file_path);
    data_file_to_history_list(file_path);
    data_file_to_mark_list(file_path);
    data_file_to_offline_pkg_list(file_path);
}

void Offline_small_search::write_data_file(QString file_path)
{
    if(file_path.indexOf(QRegExp("^file:/")) >= 0)
    {
        file_path.replace(QRegExp("^file:/*"), "");
#ifndef _WIN32
        file_path = "/"+file_path;
#endif
    }
    QDir d;
    d.mkpath(file_path);
    QFile f(file_path+"ossbf");
    f.open(QFile::ReadWrite);
    custom1.write_custom(file_path);
    history_list_to_data_file(file_path);
    mark_list_to_data_file(file_path);
    offline_pkg_list_to_data_file(file_path);
    f.write("This is oss bf");
    f.close();
}

QColor Offline_small_search::rand_lightcolor(QString str)
{
    if(str == ""||str.isNull()||str.isEmpty())
        return QColor::fromHsl(qrand()%360,qrand()%165+80,qrand()%150+100);
    QString m = md5(str);
    qsrand(m.mid(0,8).toUInt(0,16));
    int h = qrand()%360;
    qsrand(m.mid(8,8).toUInt(0,16));
    int s = qrand()%165+80;
    qsrand(m.mid(16,8).toUInt(0,16));
    int l = qrand()%150+100;
    //qsrand(a.mid(24,8).toUInt(0,16));
    //int a = qrand()%256;
    return QColor::fromHsl(h,s,l);
}

void Offline_small_search::check_update()
{
    qDebug()<<"check update start";
    m_reply = m_down.get(QNetworkRequest(QUrl("http://zjzdy.oschina.io/oss/Version")));
    connect(m_reply,SIGNAL(finished()),this,SLOT(download_version_finish()));
}

void Offline_small_search::download_version_finish()
{
    m_reply=dynamic_cast<QNetworkReply*>(sender());
    if(!m_reply->isFinished())
    {
        return;
    }
    if(m_reply->error() == QNetworkReply::NoError)
    {
        int master_ver = QString(m_reply->readAll()).toInt();
        if(master_ver > OSS_VERSION_N)
        {
            qDebug()<<"download changelog";
            m_reply = m_down.get(QNetworkRequest(QUrl("http://zjzdy.oschina.io/oss/Change")));
            connect(m_reply,SIGNAL(finished()),this,SLOT(download_changelog_finish()));
        }
        else
        {
            update_dialog_obj->setProperty("text",tr("已是最新版本"));
            QMetaObject::invokeMethod(update_dialog_obj, "open");
        }
        qDebug()<<"master version"<<master_ver;
    }
}

void Offline_small_search::download_changelog_finish()
{
    m_reply=dynamic_cast<QNetworkReply*>(sender());
    if(!m_reply->isFinished())
    {
        return;
    }
    if(m_reply->error() == QNetworkReply::NoError)
    {
        QString changelog = QString::fromUtf8(m_reply->readAll());
        update_dialog_obj->setProperty("text",tr("当前版本:")+get_version()+"\n"+changelog+"\n"+tr("是否打开最新版本的下载地址?"));
        QMetaObject::invokeMethod(update_dialog_obj, "open");
    }
}

QString Offline_small_search::get_version()
{
    return OSS_VERSION;
}

QString Offline_small_search::cp_grayimg_to_tmp(QString imagepath)
{
    QString start = imagepath;
    if(imagepath.indexOf(QRegExp("^file:/")) >= 0)
    {
        imagepath.replace(QRegExp("file:/*"), "");
#ifndef _WIN32
        imagepath = "/"+imagepath;
#endif
    }
    start.remove(imagepath);
    Mat srcImg = imread(imagepath.toLocal8Bit().data(), CV_LOAD_IMAGE_GRAYSCALE);
    if(!QFile::exists(cache_dir))
    {
        QDir tmp;
        tmp.mkpath(cache_dir);
    }
    if(srcImg.rows*srcImg.cols > 1500000)
    {
        double zoom = 1.0/sqrt(srcImg.rows*srcImg.cols/1500000);
        if(zoom < 1)
            resize(srcImg,srcImg,Size(),zoom,zoom);
    }
    imwrite((cache_dir+"tmp_img.png").toLocal8Bit().data(),srcImg);
    return start+cache_dir+"tmp_img.png";
}

QString Offline_small_search::systemType()
{
#ifdef _WIN32
    return "WIN32";
#endif
#ifdef Q_OS_OSX
    return "OSX";
#endif
#ifdef Q_OS_IOS
    return "IOS";
#endif
#ifdef Q_OS_WIN
    return "WIN";
#endif
#ifdef Q_OS_ANDROID
    return "ANDROID";
#endif
#ifdef Q_OS_LINUX
    return "LINUX";
#endif
#ifdef Q_OS_UNIX
    return "UNIX";
#endif
    return "Unknow System";
}
//插件为了方便他人审阅代码,使用驼峰命名法
void Offline_small_search::loadPlugins(QString pluginDir)
{
    if (pluginDir.isNull()||pluginDir.isEmpty())
#ifdef Q_OS_ANDROID
        pluginDir = QDir::currentPath()+"/plugins/";
#else
        pluginDir = qApp->applicationDirPath()+"/plugins";
#endif
    QDirIterator pluginsDir_it(pluginDir,QStringList(QString("meta.dat")),QDir::Files,QDirIterator::Subdirectories|QDirIterator::FollowSymlinks);
    while (pluginsDir_it.hasNext())
    {
        pluginsDir_it.next();
        QSettings setting(pluginsDir_it.fileInfo().absoluteFilePath(),QSettings::IniFormat);
        QString dirPath = pluginsDir_it.fileInfo().absolutePath();
        QString pluginType = setting.value("PluginType").toString();
        QMap<QString,QVariant> parm;
        parm["tempDir"] = get_cache_dir()+"/plugin/temp";
        parm["cacheDir"] = get_cache_dir()+"/plugin/cache";
        parm["dataDir"] = get_data_dir()+"/plugin/data";
        if (pluginType == "PagePlugin")
        {
            QString pluginID = setting.value("PluginID").toString();
            if (pluginID.indexOf(QRegExp("[^0-9A-Za-z_]")) > -1)
                continue;//插件标识符只能含有数字,英文字母,下划线
            QString pluginName = setting.value("PluginName").toString();
            pagePluginIdAndNameMap[pluginID] = pluginName;
            QString pluginLibrary = setting.value("PluginLibrary").toString();
            if (pluginLibrary.indexOf("../") > -1)
                continue;//为了安全考虑,不加载带返回上级目录PluginLibrary
            QPluginLoader loader(dirPath+"/"+pluginLibrary);
            QObject *plugin = loader.instance();
            if (plugin)
            {
                qDebug()<<"plugin entry"<<dirPath+"/"+pluginLibrary;
                PageInterface *Page = qobject_cast<PageInterface *>(plugin);
                if (Page)
                {
                    qDebug()<<"page entry"<<dirPath+"/"+pluginLibrary;
                    Page->init(pluginPages_obj,parm);
                    pagePluginInterfacsList[pluginID] = Page;
                }
                else
                    continue;//失败即为不兼容,跳过该插件
            }
            else
                continue;//失败即为不兼容,跳过该插件
            QMap<QString, QVariant> pluginEntryQml = setting.value("PluginEntryQml").toMap();//K:QmlPath,V:QmlTitle
            QMapIterator<QString, QVariant> pluginEntryQmlIterator(pluginEntryQml);
            while (pluginEntryQmlIterator.hasNext()) {
                pluginEntryQmlIterator.next();
                if (pluginEntryQmlIterator.key().indexOf("../") > -1)
                    continue;//为了安全考虑,不加载带返回上级目录PluginEntryQml
                pagePluginEntrysList.append(std::tuple<QString,QString,QString,QString>(pluginID,dirPath,pluginEntryQmlIterator.key(),pluginEntryQmlIterator.value().toString()));
            }
            //其他元数据:PluginVersion,MetaVersion,BuildTime,Author,Introduction,Platform,Arch,Compiler
        }
    }
}

void Offline_small_search::installPlugins(QString opluFilePath)
{
    opluFilePath.remove(QRegExp("file:/*"));
    if(opluFilePath.indexOf(QRegExp(":[/\\]")) < 0)
        opluFilePath.prepend("/");
    QFile opluFile(opluFilePath);
    if(!opluFile.open(QFile::ReadOnly))
        return;
    QDataStream opluStream(&opluFile);
    quint32 magicNumber;
    opluStream >> magicNumber;
    if(magicNumber != (quint32)0x6F706C75)//check magic number
        return;
    qint32 opluVersion;
    opluStream >> opluVersion;
    if(opluVersion == (qint32)1)//check oplu version
        opluStream.setVersion(QDataStream::Qt_5_6);
    else
        return;
    qint32 minVersion;
    opluStream >> minVersion;
    if((qint32)OSS_VERSION_N < (qint32)34)//check min oss version
        return;
    bool haveSign = false;
    opluStream >> haveSign;
    QByteArray sign;
    opluStream >> sign;
    QString opluID;
    opluStream >> opluID;
    QString opluName;
    opluStream >> opluName;
    QByteArray zip;
    opluStream >> zip;
    QString zipFilePath = get_cache_dir()+"/"+opluID+".zip";
    QFile zipFile(zipFilePath);
    if(zipFile.exists())
        zipFile.remove();
    zipFile.open(QFile::WriteOnly);
    zipFile.write(zip);
    zipFile.close();
    ++unzip_batch;
    unzip_oplu_map[unzip_batch] = opluID;
    pagePluginIdAndNameMapForInstall[opluID] = opluName;
    qDebug()<<qApp->applicationDirPath()+"/plugins/"+opluID;
#ifdef Q_OS_ANDROID
    Q_EMIT unzip(zipFilePath, QDir::currentPath()+"/plugins/"+opluID,unzip_batch);
#else
    Q_EMIT unzip(zipFilePath, qApp->applicationDirPath()+"/plugins/"+opluID,unzip_batch);
#endif
}

bool Offline_small_search::verifyData(QString publicKey,const char *data,const char *signatureData)
{
    CryptoPP::StringSource pubKey(QString::fromLatin1(QByteArray::fromBase64(publicKey.toLatin1()).toHex().toUpper()).toStdString(), true, new CryptoPP::HexDecoder);
    CryptoPP::RSASS<CryptoPP::PKCS1v15, CryptoPP::SHA>::Verifier pub(pubKey);
    CryptoPP::StringSource signatureString(signatureData, true, new CryptoPP::HexDecoder);
    if (signatureString.MaxRetrievable() != pub.SignatureLength())
        return false;
    CryptoPP::SecByteBlock signature(pub.SignatureLength());
    signatureString.Get(signature, signature.size());

    CryptoPP::VerifierFilter *verifierFilter = new CryptoPP::VerifierFilter(pub);
    verifierFilter->Put(signature, pub.SignatureLength());
    CryptoPP::StringSource dataString(data, true, verifierFilter);

    return verifierFilter->GetLastResult();
}

int Offline_small_search::checkOplu(QString opluFilePath)
{
    opluFilePath.remove(QRegExp("file:/*"));
    if(opluFilePath.indexOf(QRegExp(":[/\\]")) < 0)
        opluFilePath.prepend("/");
    QFile opluFile(opluFilePath);
    if(!opluFile.open(QFile::ReadOnly))
        return -1;//File don't exist or can't open.
    QDataStream opluStream(&opluFile);
    quint32 magicNumber;
    opluStream >> magicNumber;
    if(magicNumber != (quint32)0x6F706C75)//check magic number
        return -2;//It isn't oplu file.
    qint32 opluVersion;
    opluStream >> opluVersion;
    if(opluVersion == (qint32)1)//check oplu version
        opluStream.setVersion(QDataStream::Qt_5_6);
    else
        return -3;//Unsupported oplu version.
    qint32 minVersion;
    opluStream >> minVersion;
    if((qint32)OSS_VERSION_N < (qint32)34)//check min oss version
        return -4;//oss version too old.
    bool haveSign = false;
    opluStream >> haveSign;
    QByteArray sign;
    opluStream >> sign;
    QString opluID;
    opluStream >> opluID;
    QString opluName;
    opluStream >> opluName;
    QByteArray zip;
    opluStream >> zip;
    if(haveSign)
    {
        bool isGoodSign = verifyData("MIIBIDANBgkqhkiG9w0BAQEFAAOCAQ0AMIIBCAKCAQEAz0wjADRHZSnDqWPpIt7cY/dRqbOKrkZo8Vbm4WmjmpOzj2mUG0OzLQuy0krkWdeCGIqjYsNXo1z577w5zlm6nPHFTZigYdUXh9F1ncaZ7Wp31owenWOkzrlVID/gKWhT1LjUC7nRZAaR4W9jcUJxlh+BLELCKA8YSJjC9AaRpxotxBsXB/lt1MuMTr9UWrDNM12SU5V0/Yv3IO/hjyvTsbADAT7PMjxLYBmPs8Qm2HN7Ly/ivBV93EndyqOQIkqhSLvRWwjtaLlW9ijio91OMruj7nxdu5pkQg4gGZg9snSV2GAUVM1Nvh+jfgNHPEBXQlpfCliskSv05aBRFsCA3QIBEQ==",(opluID.toUtf8()+opluName.toUtf8()+zip).data(),sign.data());
        if(isGoodSign)
            return 5;//签名效验成功
        else
            return 0;//签名效验失败,插件包可能经过篡改或插件包受到破坏或插件包的签名不受信任
    }
    else
    {
        QString hashData = QCryptographicHash::hash(opluID.toUtf8()+opluName.toUtf8()+zip,QCryptographicHash::Md5);
        if(hashData == sign)
            return 2;//插件包数据MD5效验通过,但无签名
        else
            return 1;//MD5效验失败,插件包可能经过篡改或插件包受到破坏
    }
}

void Offline_small_search::show_plugin_pages(QString pluginID,QString pluginQmlPath,QString absoluteQmlPath)
{
    if(view.last() != 14)
        view.append(14);
    setCurrentIndex(14);
    if(!(absoluteQmlPath.isEmpty()||absoluteQmlPath.isNull()||absoluteQmlPath == ""))
    {
        if(!(pluginID.isEmpty()||pluginID.isNull()||pluginID == ""||pluginQmlPath.isEmpty()||pluginQmlPath.isNull()||pluginQmlPath == ""))
        {
            pagePluginInterfacsList[pluginID]->initAfterLoad(pluginQmlPath);
        }
        qDebug()<<absoluteQmlPath;
        pluginPages_obj->setProperty("needReplace",absoluteQmlPath);
        //QMetaObject::invokeMethod(pluginPages_obj, "replace", Q_ARG(QUrl, absoluteQmlPath));
    }
}

void Offline_small_search::addChildToPluginPagesObject(QObject *obj)
{
    obj->setParent(pluginPages_obj);
}

//插件代码结束
