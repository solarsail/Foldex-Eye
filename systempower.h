#ifndef SYSTEMPOWER_H
#define SYSTEMPOWER_H

#include <QObject>

class SystemPower : public QObject
{
    Q_OBJECT
public:
    SystemPower();

    Q_INVOKABLE void reboot();
    Q_INVOKABLE void shutdown();
};

#endif // SYSTEMPOWER_H
