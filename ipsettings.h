#ifndef IPSETTINGS_H
#define IPSETTINGS_H

#include "adapter_config.h"
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

    Q_INVOKABLE bool selectAdapter(const QString &name);
    Q_INVOKABLE bool setStaticIp(const QString &ip, const QString &netmask, const QString &gateway);
    Q_INVOKABLE bool setStaticDns(const QString &primary, const QString &secondary);
    Q_INVOKABLE bool setAutoIp();
    Q_INVOKABLE bool setAutoDns();
    Q_INVOKABLE int wmiRetCode();

    QString adapter() const;


signals:

public slots:
    void setAdapter(QString adapter);

};

#endif // IPSETTINGS_H
