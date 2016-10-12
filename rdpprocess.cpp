#include <bitset>
#include <QDebug>
#include <QFile>
#include "rdpprocess.h"
#ifdef Q_OS_WIN
#include <fileapi.h>
#include <intrin.h>
#endif

RDPProcess::RDPProcess(QObject *parent) : QProcess(parent)
{

}

QString generate_connnection_file(QString &host, QString &port, bool redir)
{
    QString redirstr;
    if (redir) redirstr = "DynamicDrives";
    QString content;
    content.append("screen mode id:i:2\n")
           .append("use multimon:i:0\n")
           .append("desktopwidth:i:1920\n")
           .append("desktopheight:i:1200\n")
           .append("session bpp:i:24\n")
           .append("winposstr:s:0,1,0,0,1920,1200\n")
           .append("compression:i:1\n")
           .append("keyboardhook:i:2\n")
           .append("audiocapturemode:i:0\n")
           .append("videoplaybackmode:i:1\n")
           .append("connection type:i:6\n")
           .append("networkautodetect:i:0\n")
           .append("bandwidthautodetect:i:1\n")
           .append("displayconnectionbar:i:0\n")
           .append("enableworkspacereconnect:i:0\n")
           .append("disable wallpaper:i:0\n")
           .append("allow font smoothing:i:1\n")
           .append("allow desktop composition:i:1\n")
           .append("disable full window drag:i:1\n")
           .append("disable menu anims:i:1\n")
           .append("disable themes:i:0\n")
           .append("disable cursor setting:i:0\n")
           .append("bitmapcachepersistenable:i:1\n")
           .append("full address:s:").append(host).append(":").append(port).append("\n")
           .append("audiomode:i:0\n")
           .append("redirectprinters:i:0\n")
           .append("redirectcomports:i:0\n")
           .append("redirectsmartcards:i:0\n")
           .append("redirectclipboard:i:0\n")
           .append("redirectposdevices:i:0\n")
           .append("drivestoredirect:s:").append(redirstr).append("\n")
           .append("autoreconnection enabled:i:1\n")
           .append("authentication level:i:0\n")
           .append("prompt for credentials:i:0\n")
           .append("negotiate security layer:i:1\n")
           .append("remoteapplicationmode:i:0\n")
           .append("gatewayusagemethod:i:4\n")
           .append("gatewaycredentialssource:i:4\n")
           .append("gatewayprofileusagemethod:i:0\n")
           .append("promptcredentialonce:i:0\n");

    qDebug() << content;
    QFile connfile("rdp_conn.rdp");
    if (connfile.open(QIODevice::WriteOnly)) {
        QTextStream fs(&connfile);
        fs << content;
        connfile.close();
    }
    return QString("rdp_conn.rdp");
}

void RDPProcess::start()
{
    std::bitset<32> policy_bits(policy());
    QString connfile = generate_connnection_file(host(), port(), policy_bits[Enable_Drive_Redir]);

    QString key("cmdkey");
    key.append(" /add:TERMSRV/").append(host())
       .append(" /user:").append(username())
       .append(" /pass:").append(password());
    qDebug() << key;
    QProcess::execute(key);

    QString program("mstsc ");
    program.append(connfile)
           .append(" /f");

    qDebug() << program;
    QProcess::start(program);
}

void RDPProcess::cleanup()
{
    QString key("cmdkey /delete:TERMSRV/");
    key.append(host());
    qDebug() << key;
    QProcess::execute(key);
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

bool RDPProcess::smoothFont() const
{
    return _smoothFont;
}

bool RDPProcess::dragFullWindow() const
{
    return _dragFullWindow;
}

int RDPProcess::policy() const
{
    return _policy;
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

void RDPProcess::setSmoothFont(bool smoothFont)
{
    _smoothFont = smoothFont;
}

void RDPProcess::setDragFullWindow(bool dragFullWindow)
{
    _dragFullWindow = dragFullWindow;
}

void RDPProcess::setPolicy(int policy)
{
    _policy = policy;
}

void RDPProcess::setPort(QString port)
{
    _port = port;
}
