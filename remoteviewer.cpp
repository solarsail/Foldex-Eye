#include <bitset>
#include <QDebug>
#include "remoteviewer.h"

RemoteViewer::RemoteViewer(QObject *parent) : QProcess(parent)
{

}

void RemoteViewer::start()
{
    QString program("remote-viewer.exe");
    program.append(" --spice-color-depth=32")
           //.append(" -k") // Enable Kiosk mode
           .append(" ").append(uri());

    qDebug() << program;

    QProcess::start(program);
}

QString RemoteViewer::errorDescription() const
{
    return this->errorString();
}

void RemoteViewer::kill()
{
    QProcess::kill();
}

QString RemoteViewer::uri() const
{
    return _uri;
}

void RemoteViewer::setUri(QString uri)
{
    _uri = uri;
}

