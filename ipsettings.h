#ifndef IPSETTINGS_H
#define IPSETTINGS_H

#ifdef Q_OS_WIN
#include "adapter_config.h"
#endif
#include <QObject>

class IPSettings : public QObject
{
    Q_OBJECT
#ifdef Q_OS_WIN
    AdapterConfig _conf;
#endif
    QString _adapter;

public:
    explicit IPSettings(QObject *parent = 0);

    Q_PROPERTY(QString adapter READ adapter WRITE setAdapter)

    Q_INVOKABLE int selectAdapter(const QString &name);
    Q_INVOKABLE int setStaticIp(const QString &ip, const QString &netmask, const QString &gateway);
    Q_INVOKABLE int setStaticDns(const QString &primary, const QString &secondary);
    Q_INVOKABLE int setAutoIp();
    Q_INVOKABLE int setAutoDns();

    QString adapter() const;


signals:

public slots:
    void setAdapter(QString adapter);

private:
#ifdef Q_OS_WIN
    int retCode(bool success);
#endif
};

#endif // IPSETTINGS_H
