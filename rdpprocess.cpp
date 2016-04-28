#include <QDebug>
#include "rdpprocess.h"

RDPProcess::RDPProcess(QObject *parent) : QProcess(parent)
{

}

void RDPProcess::start()
{
    QString program("wfreerdp.bin");
    //QString args;
    program.append(" /f")
           .append(" /u:").append(username())
           .append(" /p:").append(password())
           .append(" /v:").append(host());
    if (smoothFont())
        program.append(" /fonts");
    if (dragFullWindow())
        program.append(" /window-drag");

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

bool RDPProcess::smoothFont() const
{
    return _smoothFont;
}

bool RDPProcess::dragFullWindow() const
{
    return _dragFullWindow;
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

void RDPProcess::setSmoothFont(bool smoothFont)
{
    _smoothFont = smoothFont;
}

void RDPProcess::setDragFullWindow(bool dragFullWindow)
{
    _dragFullWindow = dragFullWindow;
}
