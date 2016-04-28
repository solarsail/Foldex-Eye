#include "heartbeat.h"

HeartBeat::HeartBeat(QObject *parent) :
    QObject(parent), _interval(8000), _timer(new QTimer(this))
{
    connect(_timer, SIGNAL(timeout()), this, SLOT(heartbeat()));
    connect(&_req, SIGNAL(codeChanged(int)), this, SLOT(handleResponse(int)));
    connect(&_req, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(handleError()));
}

void HeartBeat::startSending(const QString &token, const QString &vm_id)
{
    QString json;
    json.append("{ ").append("\"token\": ").append("\"").append(token).append("\", ");
    json.append("\"vm_id\": ").append("\"").append(vm_id).append("\"").append(" }");

    _req.setJsonData(json);

    _timer->start(_interval);
}

void HeartBeat::startSending(const QString &token)
{
    QString json;
    json.append("{ ").append("\"token\": ").append("\"").append(token).append("\" }");

    _req.setJsonData(json);

    _timer->start(_interval);
}

void HeartBeat::stop()
{
    _timer->stop();
}

QString HeartBeat::url() const
{
    return _req.url();
}

int HeartBeat::interval() const
{
    return _interval / 1000;
}

void HeartBeat::setUrl(QString url)
{
    _req.setUrl(url);
}

void HeartBeat::setInterval(int interval)
{
    _interval = interval * 1000;
}

void HeartBeat::handleResponse(int code)
{
    if (code != 204) {
        emit error();
    }
}

void HeartBeat::handleError()
{
    emit error();
}

void HeartBeat::heartbeat()
{
    _req.sendJson();
}
