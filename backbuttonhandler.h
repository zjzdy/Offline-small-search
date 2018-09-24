#ifndef BACKBUTTONHANDLER_H
#define BACKBUTTONHANDLER_H

#include <QObject>
#include "offline_small_search.h"

class BackButtonHandler : public QObject
{
    Q_OBJECT

public:
    explicit BackButtonHandler(Offline_small_search *parent = nullptr);

private:
    bool eventFilter(QObject *watched, QEvent *event) override;
    Offline_small_search *oss;
};

#endif // BACKBUTTONHANDLER_H
