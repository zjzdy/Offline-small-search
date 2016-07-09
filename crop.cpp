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
    if (api.Init(tessdata_path.toLocal8Bit().data(), "chi_sim"))//,OEM_DEFAULT,configs,1,NULL,NULL,false)) {
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

        Mat img = imread(imagepath.toLocal8Bit().data(),COLOR_BGR2GRAY);
        if(img.total() < 1) return "";
        int img_height = height;
        int img_width = width;
        //qDebug()<< img_height<<img_width;
        //Mat img_trans = Mat::zeros(img_height,img_width,CV_8UC1);

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
        warpPerspective(img, image, warpMatrix, Size(img_width,img_height), INTER_LINEAR, BORDER_CONSTANT);
        //imwrite("tmp/trans.jpg", img_trans);
        //cvtColor(img_trans,image,COLOR_BGR2GRAY);
    }
    else
    {
        image = cv::imread(imagepath.toLocal8Bit().data(), CV_LOAD_IMAGE_GRAYSCALE);
        //img.save("tmp/trans.jpg", "jpg", 100);
    }

    //imwrite("/sdcard/imageText.jpg",image);
    medianBlur(image,image,3);
    rotateFix(image);
    Mat local;
    adaptiveThreshold(image, local, 255, CV_ADAPTIVE_THRESH_MEAN_C, CV_THRESH_BINARY, 25, 11);

    //imwrite("local.jpg", local);

    if(!tess_init)
    {
        qDebug()<<"tesseract isn't init";
        return QString();//tr("对不起:OCR失败,OCR模块未初始化或初始化失败,请确认OCR模块是否已经成功安装.");
    }
    //api->InitLangMod(".", "chi_sim");
    IplImage iplimg(local);
    //iplimg = cvLoadImage("tmp/local.jpg");
    //api->SetPageSegMode(tesseract::PSM_AUTO_OSD);
    api.Clear();
    api.SetImage((unsigned char*)(iplimg.imageData), iplimg.width, iplimg.height, iplimg.nChannels, iplimg.widthStep);

    QString outText = " ";
    qDebug()<<"Ocr start time: "<<QDateTime::currentDateTime().toString();
    if(api.Recognize(NULL) >=0)
    {
        ResultIterator *it = api.GetIterator();
        do {
            if (it->Empty(RIL_SYMBOL)) continue;
            char *word_text = it->GetUTF8Text(RIL_SYMBOL);
            //qDebug()<<"Word: "<<word_text<<" Confidence: "<<
            if(it->Confidence(RIL_SYMBOL) > 60.0)
                outText.append(word_text);
            delete []word_text;
        } while (it->Next(RIL_SYMBOL));
        qDebug()<<"ALL Confidence: "<<api.MeanTextConf();
    }
    qDebug()<<"Ocr end time: "<<QDateTime::currentDateTime().toString();
    api.Clear();
    //qDebug()<<outText;
    outText.remove(QRegExp("[ \n\t\\\\/_.,'\"。，？、><]*"));
    if(outText.isEmpty()||outText.isNull()||outText == "")
        outText = " ";
    return outText;
}

void crop::rotate(QString imagepath, int rotate_n)
{
    if(imagepath.indexOf(QRegExp("^file:/")) >= 0)
    {
        imagepath.replace(QRegExp("file:/*"), "");
#ifndef _WIN32
        imagepath = "/"+imagepath;
#endif
    }
    Mat srcImg = imread(imagepath.toLocal8Bit().data(), CV_LOAD_IMAGE_GRAYSCALE);
    if(rotate_n == 90)
    {
        Mat t,dst;
        transpose(srcImg,t);
        flip(t,dst,1);
        imwrite(imagepath.toLocal8Bit().data(),dst);
    }
    else
    {
        if(rotate_n == -90 || rotate_n == 270)
        {
            Mat t,dst;
            transpose(srcImg,t);
            flip(t,dst,0);
            imwrite(imagepath.toLocal8Bit().data(),dst);
        }
        else
        {
            QImage img_t(imagepath);
            QTransform transform;
            img_t = img_t.transformed(transform.rotate(rotate_n));
            img_t.save(imagepath);
        }
    }
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

void crop::rotateFix(QString imagepath)
{
    Mat srcImg = imread(imagepath.toLocal8Bit().data(), CV_LOAD_IMAGE_GRAYSCALE);
    if(srcImg.empty())
        return;
    else rotateFix(srcImg);
}

void crop::rotateFix(Mat &srcImg)
{
    Mat padded;
    int opWidth = getOptimalDFTSize(srcImg.rows);
    int opHeight = getOptimalDFTSize(srcImg.cols);
    copyMakeBorder(srcImg, padded, 0, opWidth-srcImg.rows, 0, opHeight-srcImg.cols, BORDER_CONSTANT, Scalar::all(0));

    Mat planes[] = {Mat_<float>(padded), Mat::zeros(padded.size(), CV_32F)};
    Mat comImg;
    merge(planes,2,comImg);

    dft(comImg, comImg);
    split(comImg, planes);
    magnitude(planes[0], planes[1], planes[0]);

    Mat magMat = planes[0];
    magMat += Scalar::all(1);
    log(magMat, magMat);

    magMat = magMat(Rect(0, 0, magMat.cols & -2, magMat.rows & -2));
    int cx = magMat.cols/2;
    int cy = magMat.rows/2;

    Mat q0(magMat, Rect(0, 0, cx, cy));
    Mat q1(magMat, Rect(0, cy, cx, cy));
    Mat q2(magMat, Rect(cx, cy, cx, cy));
    Mat q3(magMat, Rect(cx, 0, cx, cy));

    Mat tmp;
    q0.copyTo(tmp);
    q2.copyTo(q0);
    tmp.copyTo(q2);

    q1.copyTo(tmp);
    q3.copyTo(q1);
    tmp.copyTo(q3);

    normalize(magMat, magMat, 0, 1, CV_MINMAX);
    Mat magImg(magMat.size(), CV_8UC1);
    magMat.convertTo(magImg,CV_8UC1,255,0);
    IplImage IplmagImg(magImg);
    int thresh = otsu(&IplmagImg);
    threshold(magImg,magImg,thresh,255,CV_THRESH_BINARY);
    vector<Vec2f> lines;
    HoughLines(magImg,lines,1,CV_PI/180,60,0,0);
    int numLines = (lines.size() > 3) ? 3 : lines.size();
    if(numLines == 0)
    {
        //imwrite("/sdcard/imageText_D.jpg",srcImg);
        qDebug()<<"Not rotateFix(numLines == 0).";
        return;
    }
    for(int l=0; l<numLines; l++)
    {
        if(lines[l][1] == 0)
        {
            //imwrite("/sdcard/imageText_D.jpg",srcImg);
            qDebug()<<"Not rotateFix(lines[l][1] == 0).";
            return;
        }
    }
    //Rotate the image to recover
    double angle = atan(srcImg.rows*tan(lines[0][1])/srcImg.cols)*180/CV_PI; // 弧度
    double a = sin(angle), b = cos(angle);
    int width_rotate = int(srcImg.rows*fabs(a) + srcImg.cols*fabs(b) + 1);
    int height_rotate = int(srcImg.cols*fabs(a) + srcImg.rows*fabs(b) + 1);
    int width_border = abs(width_rotate-srcImg.cols)*2/3;
    int height_border = abs(height_rotate-srcImg.rows)*2/3;
    copyMakeBorder(srcImg, srcImg,height_border,height_border,width_border,width_border, BORDER_CONSTANT,Scalar(255,255,255));
    Point center(srcImg.cols/2, srcImg.rows/2);
    Mat rotMat = getRotationMatrix2D(center,angle,1.0);
    //rows 行数 height y , cols 列数 width x
    //Mat dstImg = Mat::ones(srcImg.size(),CV_8UC3);
    //Size(_width, _height);
    warpAffine(srcImg,srcImg,rotMat,srcImg.size(),INTER_LINEAR, BORDER_CONSTANT,Scalar(255,255,255));
    //imwrite("/sdcard/imageText_D.jpg",srcImg);
    qDebug()<<"rotateFix Finsh.";
}

int crop::otsu(IplImage *src_image)
{
    double sum = 0.0;
    int pixel_count[256]={0};
    float pixel_pro[256]={0};
    uchar* data = (uchar*)src_image->imageData;
    int halfHeight = src_image->height/2;
    int halfWidth = src_image->width/2;
    int i2,j2;
    for(int i = 0; i < src_image->height; i++)
    {
        for(int j = 0;j < src_image->width;j++)
        {
            if(i > halfHeight)
                i2 = i-halfHeight;
            else i2 = halfHeight-i;
            if(j > halfWidth)
                j2 = j-halfWidth;
            else j2 = halfWidth-j;
            if(i2 < j2) data[i * src_image->width + j] = 0;
            if(j2 == 0) data[i * src_image->width + j] = 0;
            pixel_count[(int)data[i * src_image->width + j]]++;
            sum += (int)data[i * src_image->width + j];
        }
    }
    float aaa = 0;
    for(int i = 0; i < 256; i++)
    {
        pixel_pro[i] = (float)pixel_count[i] / ( src_image->height * src_image->width );
        aaa+=pixel_pro[i];
        if(aaa>0.999)
            return i;
    }
    return 0;
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
