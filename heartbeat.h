#ifndef HEARTBEAT_H
#define HEARTBEAT_H

#include <QObject>
#include <QTimer>
#include "httprequest.h"

// 心跳连接类。
//
//
class HeartBeat : public QObject
{
    Q_OBJECT

    HTTPRequest _req;   // 心跳发送器
    int _interval;      // 心跳间隔

    QTimer *_timer;     // 心跳定时器
    QString _json;      // 心跳发送内容

public:
    // 构造函数，初始化定时器
    explicit HeartBeat(QObject *parent = 0);


    // 虚拟桌面服务器地址属性，可由QML使用
    Q_PROPERTY(QString url READ url WRITE setUrl)

    // 发送间隔（秒）属性，可由QML使用
    Q_PROPERTY(int interval READ interval WRITE setInterval)


    // 开始发送包含用户和已连接桌面信息的心跳，可由QML使用
    Q_INVOKABLE void startSending(const QString &token, const QString &vm_id);

    // 开始发送只包含用户信息的心跳，可由QML使用
    Q_INVOKABLE void startSending(const QString &token);

    // 停止发送心跳，可由QML使用
    Q_INVOKABLE void stop();

    QString url() const;
    int interval() const;

signals:
    void error();

public slots:
    // 属性实现
    void setUrl(QString url);
    void setInterval(int interval);

    // 处理心跳返回内容，如不符合预期（HTTP 204）则发送错误信号，由QML处理
    void handleResponse(int code);

    // 处理连接错误，发送错误信号，由QML处理
    void handleError();

    // 发送心跳
    void heartbeat();

};

#endif // HEARTBEAT_H
