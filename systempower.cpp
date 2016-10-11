#include "systempower.h"
#ifndef QT_DEBUG
#include <QProcess>
#else
#include <QGuiApplication>
#include <QDebug>
#endif

SystemPower::SystemPower()
{

}

void SystemPower::reboot()
{
#ifndef QT_DEBUG
    #if defined(Q_OS_WINCE) || defined(Q_OS_WIN)
    QString cmd("shutdown");
    cmd.append(" /r")
       .append(" /f")
       .append(" /t 0");
    QProcess::startDetached(cmd);
    #elif defined(Q_OS_LINUX)
    QString cmd("reboot");
    QProcess::startDetached(cmd);
    #endif // platform
#else
    qDebug() << "REBOOT: in debug mode, just quit";
    QGuiApplication::quit();
#endif // mode
}

void SystemPower::shutdown()
{
#ifndef QT_DEBUG
    #if defined(Q_OS_WINCE) || defined(Q_OS_WIN)
    QString cmd("shutdown");
    cmd.append(" /s")
       .append(" /f")
       .append(" /t 0");
    QProcess::startDetached(cmd);
    #elif defined(Q_OS_LINUX)
    QString cmd("poweroff");
    QProcess::startDetached(cmd);
    #endif // platform
#else
    qDebug() << "SHUTDOWN: in debug mode: just quit";
    QGuiApplication::quit();
#endif
}
