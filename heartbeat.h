#ifndef HEARTBEAT_H
#define HEARTBEAT_H

#include <QObject>
#include <QTimer>
#include "httprequest.h"

class HeartBeat : public QObject
{
    Q_OBJECT

    HTTPRequest _req;
    int _interval;

    QTimer *_timer;
    QString _json;

public:
    explicit HeartBeat(QObject *parent = 0);

    // 服务器地址
    Q_PROPERTY(QString url READ url WRITE setUrl)
    // 发送间隔（秒）
    Q_PROPERTY(int interval READ interval WRITE setInterval)

    Q_INVOKABLE void startSending(const QString &token, const QString &vm_id);
    Q_INVOKABLE void startSending(const QString &token);
    Q_INVOKABLE void stop();

    QString url() const;
    int interval() const;

signals:
    void error();

public slots:
    void setUrl(QString url);
    void setInterval(int interval);
    void handleResponse(int code);
    void handleError();
    void heartbeat();

};

#endif // HEARTBEAT_H
