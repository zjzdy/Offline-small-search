#ifndef CROP_THREAD_H
#define CROP_THREAD_H

#include <QObject>
#include <QThread>
#include <QString>
#include <QVariant>
#include "crop.h"

class crop_thread : public QThread
{
    Q_OBJECT

public:
    crop_thread();
    void run();

Q_SIGNALS:
    void crop_ocr(QString imagepath, QVariant cropPoints, int batch);
    void ocr_result(QString text, int batch);
    void rotate(QString imagepath, int rotate_n, int batch);
    void rotate_finish(QString imagepath,int batch);
    void init(QString tessdata_path, int batch);
    void init_finish(int batch);
    void init_obj_finish();
};

#endif // CROP_THREAD_H
