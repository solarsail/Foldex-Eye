#include <bitset>
#include <QDebug>
#include <QFile>
#include "rdpprocess.h"
#ifdef Q_OS_WIN
#include <fileapi.h>
#include <intrin.h>
#endif

#define UNUSED(v) v

RDPProcess::RDPProcess(QObject *parent) :
    QProcess(parent)
{

}

void RDPProcess::start()
{
    QString program("rdpwrapper.exe ");
    program.append(username()).append(" ")
           .append(password()).append(" ")
           .append(host()).append(" ")
           .append(port());

    qDebug() << program;
    QProcess::start(program);
}

int RDPProcess::status() const
{
    return this->exitCode();
}

QString RDPProcess::errorCode() const
{
    return this->errorString();
}

void RDPProcess::kill()
{
    QProcess::kill();
}

QString RDPProcess::username() const
{
    return _username;
}

QString RDPProcess::password() const
{
    return _password;
}

QString RDPProcess::host() const
{
    return _host;
}

QString RDPProcess::port() const
{
    return _port;
}

void RDPProcess::setUsername(QString username)
{
    _username = username;
}

void RDPProcess::setPassword(QString password)
{
    _password = password;
}

void RDPProcess::setHost(QString host)
{
    _host = host;
}

void RDPProcess::setPort(QString port)
{
    _port = port;
}
