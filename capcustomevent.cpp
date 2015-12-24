#include "capcustomevent.h"

QEvent::Type capCustomEvent::m_evType = (QEvent::Type)QEvent::None;

capCustomEvent::capCustomEvent(int arg1, const QString &arg2)
    : QEvent(eventType()), m_arg1(arg1), m_arg2(arg2)
{}

capCustomEvent::~capCustomEvent()
{

}

QEvent::Type capCustomEvent::eventType()
{
    if(m_evType == QEvent::None)
    {
        m_evType = (QEvent::Type)registerEventType();
    }
    return m_evType;
}
