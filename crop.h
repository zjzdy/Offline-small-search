#ifndef CROP_H
#define CROP_H

#include <QObject>
#include <QPair>
#include <QDir>
#include <QFile>
#include <QImage>
#include <QMap>
#include <QPointF>
#include <QList>
#include <QString>
#include <QStringList>
#include <QVariantList>
#include <QDateTime>
#include <QDebug>
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/photo/photo.hpp>
#include <vector>
#include <cstdio>

using namespace std;
#include <tesseract/baseapi.h>
#include <leptonica/allheaders.h>
//#include <tesseract/genericvector.h>

using namespace cv;
using namespace tesseract;

class crop : public QObject
{
    Q_OBJECT
public:
    explicit crop(QObject *parent = 0);
    Q_INVOKABLE QString crop_ocr_orig(QString imagepath, QVariant cropPoints,float min_confidence = 60.0, QString lang = "zh_cn");
    Q_INVOKABLE QString crop_ocr(QString imagepath, QVariant cropPoints, QString lang = "zh_cn");
    Q_INVOKABLE QStringList crop_ocr_list(QString imagepath, QVariant cropPoints, QString lang = "zh_cn");
    Q_INVOKABLE void rotate(QString imagepath, int rotate_n);
    Q_INVOKABLE void init(QString tessdata_path, QString lang = "zh_cn");
    Q_INVOKABLE int rotateFix(QString imagepath);
    Q_INVOKABLE int rotateFix(Mat &srcImg);
    Q_INVOKABLE void zoomFix(QString imagepath, int angle, int width, int height);
    Q_INVOKABLE void zoomFix(Mat &srcImg, int angle = 0, int width = 0, int height = 0);
    int otsu(IplImage *src_image);
    bool getCropPoints(QMap<QString, QPointF> &points, QMap<QString, QVariant> cropPoints, QImage &img);

public Q_SLOTS:
    void on_crop_ocr(QString imagepath, QVariant cropPoints, QString lang, int batch);
    void on_rotate(QString imagepath, int rotate_n, int batch);
    void on_init(QString tessdata_path, QString lang, int batch);

Q_SIGNALS:
    void ocr_result(QString text, int batch);
    void rotate_finish(QString imagepath,int batch);
    void init_finish(int batch);

public:
    TessBaseAPI api;
    TessBaseAPI api_cht;
    TessBaseAPI api_eng;
    bool tess_init;
    bool tess_eng_init;
    bool tess_cht_init;
    QRegExp bracket1;
    QRegExp bracket2;
};

#endif // CROP_H
