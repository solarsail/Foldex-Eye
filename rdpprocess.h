#ifndef PROCESS_H
#define PROCESS_H

#include <QProcess>
#include <QVariant>

enum Policy
{
    Enable_Drive_Redir = 0
};

class RDPProcess : public QProcess
{
    Q_OBJECT
    QString _username;
    QString _password;
    QString _host;
    QString _port;
    int _policy;
    bool _smoothFont;
    bool _dragFullWindow;

public:
    explicit RDPProcess(QObject *parent = 0);

    Q_PROPERTY(QString username READ username WRITE setUsername)
    Q_PROPERTY(QString password READ password WRITE setPassword)
    Q_PROPERTY(QString host READ host WRITE setHost)
    Q_PROPERTY(QString port READ port WRITE setPort)
    Q_PROPERTY(bool smoothFont READ smoothFont WRITE setSmoothFont)
    Q_PROPERTY(bool dragFullWindow READ dragFullWindow WRITE setDragFullWindow)
    Q_PROPERTY(int policy READ policy WRITE setPolicy)

    Q_INVOKABLE void start();
    Q_INVOKABLE int status() const;
    Q_INVOKABLE QString errorCode() const;

    QString username() const;
    QString password() const;
    QString host() const;
    QString port() const;
    bool smoothFont() const;
    bool dragFullWindow() const;
    int policy() const;


public slots:
    Q_INVOKABLE void kill();
    void setUsername(QString username);
    void setPassword(QString password);
    void setHost(QString host);
    void setPort(QString port);
    void setSmoothFont(bool smoothFont);
    void setDragFullWindow(bool dragFullWindow);
    void setPolicy(int policy);

};

#endif // PROCESS_H
