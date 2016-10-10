#include <bitset>
#include <QDebug>
#include "rdpprocess.h"
#ifdef Q_OS_WIN
#include <fileapi.h>
#include <intrin.h>
#endif

QString usbRedirArgument()
{
    QString arg;
#ifdef Q_OS_WIN
    // FIXME: 使用路径映射，为了支持尚未插入的u盘需要将下一个或
    //        多个空盘符映射过去，虚拟机中能看到无内容的空盘符。
    //        考虑改为usb设备映射。
    static LPCTSTR letters = L"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    unsigned long index = 0;
    LPTSTR drive = new TCHAR[4] {L'C', L':', L'\\', L'\0'};
    for (index = 3; index < 25; ++index) {
        TCHAR letter = letters[index];
        drive[0] = letter;
        UINT type = GetDriveType(drive);
        qDebug() << QString::fromUtf16((ushort*)drive) << type;
        if (type <= 2/*DRIVE_REMOVABLE*/) {
            // 映射当前已插入的u盘，以及之后可能插入的u盘
            arg.append(" /a:drive,").append(letter).append(",").append(letter).append(":\\");
            if (type < 2) // DRIVE_NO_ROOT_DIR or DRIVE_UNKNOWN
                // 只映射一个未插入的u盘
                break;
        }
    }
    delete[] drive;
#else
#endif
    return arg;
}

RDPProcess::RDPProcess(QObject *parent) : QProcess(parent)
{

}

void RDPProcess::start()
{
    QString program("wfreerdp.bin");
    program.append(" /f")
           .append(" /bpp:32")
           //.append(" /rfx")
           .append(" /gdi:sw")
           //.append(" /compression")
           .append(" /sound")
           .append(" /u:").append(username())
           .append(" /p:").append(password())
           .append(" /v:").append(host())
           .append(" /port:").append(port());
    if (smoothFont())
        program.append(" /fonts");
    if (dragFullWindow())
        program.append(" /window-drag");
    std::bitset<32> policy_bits(policy());
    if (policy_bits[Enable_Drive_Redir])
        program.append(usbRedirArgument());

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
