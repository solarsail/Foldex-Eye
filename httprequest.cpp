#include "httprequest.h"


QNetworkAccessManager* HTTPRequest::_netman = new QNetworkAccessManager();

HTTPRequest::HTTPRequest()
{
}

HTTPRequest::~HTTPRequest()
{
}

void HTTPRequest::sendJson()
{
    qDebug() << "to URL: " << url();
    qDebug() << "sending data: " << jsonData();
    QNetworkRequest request;
    request.setUrl(QUrl(url()));
    request.setRawHeader("Content-Type", "application/json;charset=UTF-8");

    QByteArray data;
    data.append(jsonData());
    QNetworkReply *reply = _netman->post(request, data); // reply 在处理函数中被删除

    connect(reply, SIGNAL(finished()), this, SLOT(onFinished()));
    connect(reply, SIGNAL(error(QNetworkReply::NetworkError)),
            this, SLOT(onError(QNetworkReply::NetworkError)));
    connect(reply, SIGNAL(sslErrors(QList<QSslError>)),
            this, SLOT(onSslErrors(QList<QSslError>)));
}

void HTTPRequest::onFinished()
{
    QNetworkReply* reply = static_cast<QNetworkReply*>(sender());
    auto byte_array = reply->readAll();
    QVariant code = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);

    _code = code.toInt();
    emit codeChanged(_code);
    _response = QString(byte_array);
    emit responseChanged(_response);

    qDebug() << "code: " << _code << ", reply: " << _response;

    reply->deleteLater();
}

QString HTTPRequest::url() const
{
    return _url;
}

QString HTTPRequest::jsonData() const
{
    return _data;
}

QString HTTPRequest::response() const
{
    return _response;
}

int HTTPRequest::code() const
{
    return _code;
}

void HTTPRequest::setUrl(const QString &url)
{
    _url = url;
    emit urlChanged(_url);
}

void HTTPRequest::setJsonData(const QString &data)
{
    _data = data;
    emit jsonDataChanged(_data);
}

void HTTPRequest::onError(const QNetworkReply::NetworkError &e)
{
    qDebug() << "error: " << e;
    emit error(e);
}

void HTTPRequest::onSslErrors(const QList<QSslError> &e)
{
    Q_UNUSED(e)
    emit sslError();
}
