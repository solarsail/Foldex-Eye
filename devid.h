#ifndef DEVID_H
#define DEVID_H

#include <QObject>

class DevId : public QObject
{
    Q_OBJECT
    QString _uid;

public:
    explicit DevId(QObject *parent = 0);

    Q_INVOKABLE QString devId();
    Q_INVOKABLE QString devSecret();

private:
    void uniqueId();
};

#endif // DEVID_H
