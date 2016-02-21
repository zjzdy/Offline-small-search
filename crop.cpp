#include "crop.h"

crop::crop(QObject *parent) : QObject(parent)
{
    tess_init = false;
}

void crop::init(QString tessdata_path)
{
    /*
    char* configs[1];
    char config[] = "cjk.config";
    configs[0] = config;
    GenericVector<STRING> k;
    GenericVector<STRING> v;
    k.push_back("chop_enable");
    v.push_back("T");
    k.push_back("use_new_state_cost");
    v.push_back("F");
    k.push_back("segment_segcost_rating");
    v.push_back("F");
    k.push_back("enable_new_segsearch");
    v.push_back("0");
    k.push_back("language_model_ngram_on");
    v.push_back("0");
    k.push_back("textord_force_make_prop_words");
    v.push_back("F");
    k.push_back("edges_max_children_per_outline");
    v.push_back("40");
    */
    if (api.Init(tessdata_path.toLatin1().data(), "chi_sim"))//,OEM_DEFAULT,configs,1,NULL,NULL,false)) {
    {
        tess_init = false;
        qDebug()<<"Could not initialize tesseract";
    }
    else
    {
        tess_init = true;
        api.SetPageSegMode(PSM_AUTO);
        qDebug()<<"Initialize tesseract finish";
    }
}

QString crop::crop_ocr(QString imagepath, QVariant cropPoints)
{
    if(imagepath.indexOf(QRegExp("^file:/")) >= 0)
    {
        imagepath.replace(QRegExp("file:/*"), "");
#ifndef _WIN32
        imagepath = "/"+imagepath;
#endif
    }
    qDebug()<<imagepath;
    QImage img(imagepath);
    QMap<QString, QPointF> points;
    Mat image;
    qreal width = 0;
    qreal height = 0;

    if(getCropPoints(points, cropPoints.toMap(), img))
    {
        QLineF topLine(points.value("topLeft"), points.value("topRight"));
        QLineF bottomLine(points.value("bottomLeft"), points.value("bottomRight"));
        QLineF leftLine(points.value("topLeft"), points.value("bottomLeft"));
        QLineF rightLine(points.value("topRight"), points.value("bottomRight"));

        if(topLine.length() > bottomLine.length()) {
            width = topLine.length();
        } else {
            width = bottomLine.length();
        }

        if(topLine.length() > bottomLine.length()) {
            height = leftLine.length();
        } else {
            height = rightLine.length();
        }

        Mat img = imread(imagepath.toLocal8Bit().data());
        if(img.total() < 1) return "";
        int img_height = height;
        int img_width = width;
        //qDebug()<< img_height<<img_width;
        Mat img_trans = Mat::zeros(img_height,img_width,CV_8UC3);

        vector<Point2f> corners(4);
        corners[0] = Point2f(0,0);
        corners[1] = Point2f(img_width-1,0);
        corners[2] = Point2f(0,img_height-1);
        corners[3] = Point2f(img_width-1,img_height-1);
        vector<Point2f> corners_trans(4);
        corners_trans[0] = Point2f(points.value("topLeft").x(),points.value("topLeft").y());
        corners_trans[1] = Point2f(points.value("topRight").x(),points.value("topRight").y());
        corners_trans[2] = Point2f(points.value("bottomLeft").x(),points.value("bottomLeft").y());
        corners_trans[3] = Point2f(points.value("bottomRight").x(),points.value("bottomRight").y());

        //Mat transform = getPerspectiveTransform(corners,corners_trans);
        Mat warpMatrix = getPerspectiveTransform(corners_trans,corners);
        warpPerspective(img, img_trans, warpMatrix, img_trans.size(), INTER_LINEAR, BORDER_CONSTANT);
        //imwrite("tmp/trans.jpg", img_trans);
        cvtColor(img_trans,image,COLOR_BGR2GRAY);
    }
    else
    {
        image = cv::imread(imagepath.toStdString(), CV_LOAD_IMAGE_GRAYSCALE);
        //img.save("tmp/trans.jpg", "jpg", 100);
    }

    //medianBlur(image,image,3);
    Mat local;
    adaptiveThreshold(image, local, 255, CV_ADAPTIVE_THRESH_MEAN_C, CV_THRESH_BINARY, 25, 11);

    //imwrite("local.jpg", local);

    if(!tess_init)
    {
        qDebug()<<"tesseract isn't init";
        return tr("对不起:OCR失败,OCR模块未初始化或初始化失败,请确认OCR模块是否已经成功安装.");
    }
    //api->InitLangMod(".", "chi_sim");
    IplImage iplimg(local);
    //iplimg = cvLoadImage("tmp/local.jpg");
    //api->SetPageSegMode(tesseract::PSM_AUTO_OSD);
    api.Clear();
    api.SetImage((unsigned char*)(iplimg.imageData), iplimg.width, iplimg.height, iplimg.nChannels, iplimg.widthStep);

    QString outText = "";
    qDebug()<<"Ocr start time: "<<QDateTime::currentDateTime().toString();
    if(api.Recognize(NULL) >=0)
    {
        ResultIterator *it = api.GetIterator();
        do {
            if (it->Empty(RIL_SYMBOL)) continue;
            char *word_text = it->GetUTF8Text(RIL_SYMBOL);
            //qDebug()<<"Word: "<<word_text<<" Confidence: "<<
            if(it->Confidence(RIL_SYMBOL) > 65.0)
                outText.append(word_text);
            delete []word_text;
        } while (it->Next(RIL_SYMBOL));
        qDebug()<<"ALL Confidence: "<<api.MeanTextConf();
    }
    qDebug()<<"Ocr end time: "<<QDateTime::currentDateTime().toString();
    api.Clear();
    return outText.remove(QRegExp("[ \n\t]*"));
}

void crop::rotate(QString imagepath, int rotate_n)
{
    imagepath.replace("file://", "");
    QImage img_t(imagepath);
    QTransform transform;
    img_t = img_t.transformed(transform.rotate(rotate_n));
    img_t.save(imagepath);
}

bool crop::getCropPoints(QMap<QString, QPointF> &points, QMap<QString, QVariant> cropPoints, QImage &img) {

    bool cropNeeded = false;
    // check if the points were moved
    Q_FOREACH(QVariant corner, cropPoints) {

        QString key = cropPoints.key(corner);
        QPointF point = corner.toPointF();
        points.insert(key, point);

        int w = img.width() - 1;
        int h = img.height() - 1;

        if(key == "topLeft") {
            if (point.x() > 1 || point.y() > 1) {
                cropNeeded = true;
            }
        }

        if(key == "topRight") {
            if (point.x() < w || point.y() > 1) {
                cropNeeded = true;
            }
        }

        if(key == "bottomRight") {
            if (point.x() < w || point.y() < h ) {
                cropNeeded = true;
            }
        }

        if(key == "bottomLeft") {
            if (point.x() > 1 || point.y() < h) {
                cropNeeded = true;
            }
        }
    }
    return cropNeeded;
}

void crop::on_crop_ocr(QString imagepath, QVariant cropPoints, int batch)
{
    Q_EMIT ocr_result(crop_ocr(imagepath,cropPoints),batch);
}

void crop::on_rotate(QString imagepath, int rotate_n, int batch)
{
    rotate(imagepath,rotate_n);
    Q_EMIT rotate_finish(imagepath,batch);
}

void crop::on_init(QString tessdata_path, int batch)
{
    init(tessdata_path);
    Q_EMIT init_finish(batch);
}
