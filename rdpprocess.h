#ifndef PROCESS_H
#define PROCESS_H

#include <QProcess>
#include <QVariant>

class RDPProcess : public QProcess
{
    Q_OBJECT
    QString _username;
    QString _password;
    QString _host;
    bool _smoothFont;
    bool _dragFullWindow;
    QString _port;

public:
    explicit RDPProcess(QObject *parent = 0);

    Q_PROPERTY(QString username READ username WRITE setUsername)
    Q_PROPERTY(QString password READ password WRITE setPassword)
    Q_PROPERTY(QString host READ host WRITE setHost)
    Q_PROPERTY(QString port READ port WRITE setPort)
    Q_PROPERTY(bool smoothFont READ smoothFont WRITE setSmoothFont)
    Q_PROPERTY(bool dragFullWindow READ dragFullWindow WRITE setDragFullWindow)

    Q_INVOKABLE void start();
    Q_INVOKABLE int status() const;
    Q_INVOKABLE QString errorCode() const;

    QString username() const;
    QString password() const;
    QString host() const;
    bool smoothFont() const;
    bool dragFullWindow() const;
    QString port() const;


public slots:
    Q_INVOKABLE void kill();
    void setUsername(QString username);
    void setPassword(QString password);
    void setHost(QString host);
    void setSmoothFont(bool smoothFont);
    void setDragFullWindow(bool dragFullWindow);
    void setPort(QString port);

};

#endif // PROCESS_H
