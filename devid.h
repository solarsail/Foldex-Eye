#ifndef DEVID_H
#define DEVID_H

#include <QObject>

// 设备ID类。
//
// 首次生成实例时随机生成一个设备ID和设备识别码，并保存在文件中。
// 在文件存在的情况下，后续运行所创建的实例均使用相同的ID和识别码。
// 识别码用于需要提供 device secret 的场合。
class DevId : public QObject
{
    Q_OBJECT
    QString _uid;   // 用于生成设备ID和识别码的随机串

public:
    // 构造函数，生成ID和识别码并保存到文件，或从文件中读取。
    explicit DevId(QObject *parent = 0);

    // 返回设备ID。可由QML调用。
    Q_INVOKABLE QString devId();

    // 返回设备识别码。可由QML调用。
    Q_INVOKABLE QString devSecret();

private:
    // 随机ID的生成逻辑。
    void uniqueId();
};

#endif // DEVID_H
