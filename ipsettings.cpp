#include <QDebug>
#include <iostream>
#include "ipsettings.h"

wchar_t* ws(const QString &str)
{
    if (str.isEmpty() || str.isNull())
        return nullptr;
    return (wchar_t*)str.utf16();
}

IPSettings::IPSettings(QObject *parent) : QObject(parent)
{

}

bool IPSettings::selectAdapter(const QString &name)
{
#ifdef Q_OS_WIN
    qDebug() << _conf.init_error_str();
    qDebug() << _conf.call_result();
    return _conf.select_adapter(ws(name));
#endif
}

bool IPSettings::setStaticIp(const QString &ip, const QString &netmask, const QString &gateway)
{
#ifdef Q_OS_WIN
    return _conf.set_static_ip(ws(ip), ws(netmask), ws(gateway));
#endif
}

bool IPSettings::setStaticDns(const QString &primary, const QString &secondary)
{
#ifdef Q_OS_WIN
    return _conf.set_static_dns(ws(primary), ws(secondary));
#endif
}

bool IPSettings::setAutoIp()
{
#ifdef Q_OS_WIN
    return _conf.set_auto_ip();
#endif
}

bool IPSettings::setAutoDns()
{
#ifdef Q_OS_WIN
    return _conf.set_auto_dns();
#endif
}

int IPSettings::wmiRetCode()
{
    qDebug() << "wmi: " << _conf.wmi_result();
    return _conf.wmi_result();
}

QString IPSettings::adapter() const
{
    return _adapter;
}

void IPSettings::setAdapter(QString adapter)
{
    _adapter = adapter;
    selectAdapter(_adapter);
}
