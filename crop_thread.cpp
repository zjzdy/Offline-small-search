#include "crop_thread.h"

crop_thread::crop_thread()
{

}

void crop_thread::run()
{
    crop crop_ocr_obj;
    QObject::connect(&crop_ocr_obj,SIGNAL(ocr_result(QString,int)),this,SIGNAL(ocr_result(QString,int)));
    QObject::connect(&crop_ocr_obj,SIGNAL(rotate_finish(QString,int)),this,SIGNAL(rotate_finish(QString,int)));
    QObject::connect(&crop_ocr_obj,SIGNAL(init_finish(int)),this,SIGNAL(init_finish(int)));
    QObject::connect(this,SIGNAL(init(QString,QString,int)),&crop_ocr_obj,SLOT(on_init(QString,QString,int)));
    QObject::connect(this,SIGNAL(rotate(QString,int,int)),&crop_ocr_obj,SLOT(on_rotate(QString,int,int)));
    QObject::connect(this,SIGNAL(crop_ocr(QString,QVariant,QString,int)),&crop_ocr_obj,SLOT(on_crop_ocr(QString,QVariant,QString,int)));
    Q_EMIT init_obj_finish();
    exec();
}
