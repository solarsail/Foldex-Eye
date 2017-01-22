#include <QFile>
#include <QUuid>
#include <QDebug>
#include <QCryptographicHash>
#include "devid.h"

DevId::DevId(QObject *parent) : QObject(parent)
{
    uniqueId();
}

QString DevId::devId()
{
    return QString("dev-") + _uid.left(8);
}

QString DevId::devSecret()
{
    return _uid.mid(8);
}

void DevId::uniqueId()
{
    QFile f("uid");
    QByteArray hash;
    if (!f.exists()) {
        f.open(QIODevice::WriteOnly);
        auto uuid = QUuid::createUuid().toByteArray();
        hash = QCryptographicHash::hash(uuid, QCryptographicHash::Md5);
        f.write(hash);
        f.close();
    } else {
        f.open(QIODevice::ReadOnly);
        hash = f.readAll();
        f.close();
    }
    _uid = hash.toHex();
    qDebug() << _uid;
}
