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
    QProcess(parent),
    _domain_user(true)
{

}

QString RDPProcess::generate_connnection_file(QString &host, QString &port, bool redir)
{
    UNUSED(redir);
    QString content;
    QFile conf_in("connection.conf");
    if (conf_in.open(QIODevice::ReadOnly)) {
        QTextStream fs(&conf_in);
        content = fs.readAll();
        int start = content.indexOf("[key]")+12;
        QString mode = content.mid(start, content.indexOf('[', start)-start).trimmed();
        if (mode == "native")
            _domain_user = false;
        start = content.indexOf("[rdp]")+7;
        content = content.mid(start, content.indexOf('[', start)-start);
        conf_in.close();
    } else {
        content.append("screen mode id:i:2\n")
               .append("use multimon:i:1\n")
               .append("desktopwidth:i:1920\n")
               .append("desktopheight:i:1200\n")
               .append("session bpp:i:32\n")
               .append("winposstr:s:0,1,0,0,1920,1200\n")
               .append("compression:i:1\n")
               .append("keyboardhook:i:2\n")
               .append("audiocapturemode:i:0\n")
               .append("videoplaybackmode:i:1\n")
               .append("connection type:i:7\n")
               .append("networkautodetect:i:1\n")
               .append("bandwidthautodetect:i:1\n")
               .append("displayconnectionbar:i:0\n")
               .append("enableworkspacereconnect:i:0\n")
               .append("disable wallpaper:i:0\n")
               .append("allow font smoothing:i:0\n")
               .append("allow desktop composition:i:0\n")
               .append("disable full window drag:i:1\n")
               .append("disable menu anims:i:1\n")
               .append("disable themes:i:0\n")
               .append("disable cursor setting:i:0\n")
               .append("bitmapcachepersistenable:i:1\n")
               .append("audiomode:i:0\n")
               .append("redirectprinters:i:1\n")
               .append("redirectcomports:i:1\n")
               .append("redirectsmartcards:i:1\n")
               .append("redirectclipboard:i:1\n")
               .append("redirectposdevices:i:0\n")
               .append("drivestoredirect:s:DynamicDrives\n")
               .append("autoreconnection enabled:i:1\n")
               .append("authentication level:i:0\n")
               .append("prompt for credentials:i:0\n")
               .append("negotiate security layer:i:1\n")
               .append("remoteapplicationmode:i:0\n")
               .append("gatewayusagemethod:i:4\n")
               .append("gatewaycredentialssource:i:4\n")
               .append("gatewayprofileusagemethod:i:0\n")
               .append("promptcredentialonce:i:0\n")
               .append("devicestoredirect:s:*");
    }
    content.append("full address:s:").append(host);
    if (port != "3389")
        content.append(":").append(port);
    content.append("\n");

    qDebug() << content;
    QFile conf_out("rdp_conn.rdp");
    if (conf_out.open(QIODevice::WriteOnly)) {
        QTextStream fs(&conf_out);
        fs << content;
        conf_out.close();
    }
    return QString("rdp_conn.rdp");
}

void RDPProcess::start()
{
    std::bitset<32> policy_bits(policy());
    QString connfile = generate_connnection_file(host(), port(), policy_bits[Enable_Drive_Redir]);

    QString mode(" /add:TERMSRV/");
    if (!_domain_user)
        mode = " /generic:";
    QString key("cmdkey");
    key.append(mode).append(host())
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
    QString key("cmdkey /delete:");
    if (_domain_user)
        key.append("TERMSRV/");
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
