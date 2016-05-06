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
    QString cmd("shutdown");
    cmd.append(" /r")
       .append(" /f")
       .append(" /t 0");
#ifndef QT_DEBUG
    QProcess::startDetached(cmd);
#else
    qDebug() << "REBOOT: in debug mode, just quit";
    QGuiApplication::quit();
#endif
}

void SystemPower::shutdown()
{
    QString cmd("shutdown");
    cmd.append(" /s")
       .append(" /f")
       .append(" /t 0");
#ifndef QT_DEBUG
    QProcess::startDetached(cmd);
#else
    qDebug() << "SHUTDOWN: in debug mode: just quit";
    QGuiApplication::quit();
#endif
}
