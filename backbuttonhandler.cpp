#include "backbuttonhandler.h"

#include <QKeyEvent>
#include <QCoreApplication>

BackButtonHandler::BackButtonHandler(Offline_small_search *parent): QObject(parent), oss(parent)
{
    qApp->installEventFilter(this);
}

bool BackButtonHandler::eventFilter(QObject *watched, QEvent *event)
{
    if (event->type() == QEvent::KeyPress)
    {
        QKeyEvent *keyEvent = static_cast<QKeyEvent *>(event);
        if (keyEvent->key() == Qt::Key_Back)
        {
            if(oss != nullptr && oss->tabView_obj != nullptr && watched != oss->tabView_obj)
            {
                QCoreApplication::postEvent(oss->tabView_obj, new QKeyEvent(*keyEvent));
                return true;
            }
        }
    }
    return false;
}
