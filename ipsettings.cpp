#include <QDebug>
#include <QProcess>
#include <QStringBuilder>
#include <QFile>
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
#else
    return 0;
#endif
}

int IPSettings::setStaticIp(const QString &ip, const QString &netmask, const QString &gateway)
{
#ifdef Q_OS_WIN
    bool success = _conf.set_static_ip(ws(ip), ws(netmask), ws(gateway));
    return retCode(success);
#else
    QString filename("/etc/network/interfaces");
    QFile script(filename);
    if (script.open(QIODevice::WriteOnly)) {
        QTextStream s(&script);
        s << "auto lo\n";
        s << "iface lo inet loopback\n\n" ;
        s << "auto " << adapter() << "\n";
        s << "iface " << adapter() << " inet static\n";
        s << "    address " << ip << "\n";
        s << "    netmask " << netmask << "\n";
        s << "    gateway " << gateway << "\n";
        script.close();
    } else {
        return 1;
    }
    return QProcess::execute("service networking restart");
#endif
}

int IPSettings::setStaticDns(const QString &primary, const QString &secondary)
{
#ifdef Q_OS_WIN
    bool success = _conf.set_static_dns(ws(primary), ws(secondary));
    return retCode(success);
#else
    int ret = 0;
    QString cmd("echo \"nameserver ");
    cmd.append(primary).append("\" > /etc/resolv.conf");
    ret = QProcess::execute(cmd);
    if (!ret && !secondary.isEmpty()) {
        cmd = QString("echo \"nameserver ").append(secondary).append("\" >> /etc/resolv.conf");
        ret = QProcess::execute(cmd);
    }
    return ret;
#endif
}

int IPSettings::setAutoIp()
{
#ifdef Q_OS_WIN
    bool success = _conf.set_auto_ip();
    return retCode(success);
#else
    QString filename("/etc/network/interfaces");
    QFile script(filename);
    if (script.open(QIODevice::WriteOnly)) {
        QTextStream s(&script);
        s << "auto lo\n";
        s << "iface lo inet loopback\n\n";
        s << "auto " << adapter() << "\n";
        s << "iface " << adapter() << " inet dhcp\n";
        script.close();
    } else {
        return 1;
    }
    return QProcess::execute("service networking restart");
#endif
}

int IPSettings::setAutoDns()
{
#ifdef Q_OS_WIN
    bool success = _conf.set_auto_dns();
    return retCode(success);
#else
    return QProcess::execute("echo > /etc/resolv.conf");
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
