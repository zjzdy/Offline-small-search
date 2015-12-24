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
    Q_INVOKABLE QString crop_ocr(QString imagepath, QVariant cropPoints);
    Q_INVOKABLE void rotate(QString imagepath, int rotate_n);
    Q_INVOKABLE void init(QString tessdata_path);
    bool getCropPoints(QMap<QString, QPointF> &points, QMap<QString, QVariant> cropPoints, QImage &img);

public Q_SLOTS:
    void on_crop_ocr(QString imagepath, QVariant cropPoints, int batch);
    void on_rotate(QString imagepath, int rotate_n, int batch);
    void on_init(QString tessdata_path, int batch);

Q_SIGNALS:
    void ocr_result(QString text, int batch);
    void rotate_finish(QString imagepath,int batch);
    void init_finish(int batch);

public:
    TessBaseAPI api;
    bool tess_init;
};

#endif // CROP_H
