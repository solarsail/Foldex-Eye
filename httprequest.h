#ifndef HTTPREQUEST_H
#define HTTPREQUEST_H

#include <QQuickItem>
#include <QNetworkAccessManager>
#include <QNetworkReply>

class HTTPRequest : public QObject
{
    Q_OBJECT
    Q_DISABLE_COPY(HTTPRequest)

    // QML 可访问属性
    Q_PROPERTY(QString url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(QString jsonData READ jsonData WRITE setJsonData NOTIFY jsonDataChanged)
    Q_PROPERTY(QString response READ response NOTIFY responseChanged)
    Q_PROPERTY(int code READ code NOTIFY codeChanged)

public:
    HTTPRequest();
    ~HTTPRequest();

    // QML 可访问函数
    Q_INVOKABLE void sendJson();

    QString url() const;
    QString jsonData() const;

    QString response() const;
    int code() const;

    void setUrl(const QString& url);
    void setJsonData(const QString& data);

signals: // 信号在 QML 中体现为 onXxx 事件
    void urlChanged(const QString& url);
    void jsonDataChanged(const QString& data);
    void responseChanged(const QString& resp);
    void codeChanged(int code);
    void error(QNetworkReply::NetworkError e);
    void sslError();

public slots:
    void onFinished();
    void onError(const QNetworkReply::NetworkError &e);
    void onSslErrors(const QList<QSslError> &e);

private:
    static QNetworkAccessManager *_netman;

    int _code;
    QString _response;
    QString _data;
    QString _url;

};

#endif // HTTPREQUEST_H
