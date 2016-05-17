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

int IPSettings::selectAdapter(const QString &name)
{
#ifdef Q_OS_WIN
    bool success = _conf.select_adapter(ws(name));
    return success? 0 : -1;
#endif
}

int IPSettings::setStaticIp(const QString &ip, const QString &netmask, const QString &gateway)
{
#ifdef Q_OS_WIN
    bool success = _conf.set_static_ip(ws(ip), ws(netmask), ws(gateway));
    return retCode(success);
#endif
}

int IPSettings::setStaticDns(const QString &primary, const QString &secondary)
{
#ifdef Q_OS_WIN
    bool success = _conf.set_static_dns(ws(primary), ws(secondary));
    return retCode(success);
#endif
}

int IPSettings::setAutoIp()
{
#ifdef Q_OS_WIN
    bool success = _conf.set_auto_ip();
    return retCode(success);
#endif
}

int IPSettings::setAutoDns()
{
#ifdef Q_OS_WIN
    bool success = _conf.set_auto_dns();
    return retCode(success);
#endif
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

#ifdef Q_OS_WIN
int IPSettings::retCode(bool success)
{
    if (success) {
        int wmiret = _conf.wmi_result();
        return wmiret;
    } else {
        return _conf.call_result();
    }
}
#endif
