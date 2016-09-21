#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QWindow>
#include <QtQml>
#include <QSslSocket>
#include <QFont>
#include "remoteviewer.h"
#include "systempower.h"
#include "ipsettings.h"

void test_ssl()
{
    QSslSocket::supportsSsl();
}

static QJSValue conn_singleton_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    static QString username, password, info, host, port, vm, token;

    QJSValue profile = scriptEngine->newObject();
    profile.setProperty("username", username);
    profile.setProperty("password", password);
    profile.setProperty("info", info);
    profile.setProperty("currentHost", host);
    profile.setProperty("currentPort", port);
    profile.setProperty("currentVm", vm);
    profile.setProperty("token", token);
    return profile;
}

int main(int argc, char *argv[])
{
    // 第一次发送 HTTP 请求时会测试对 SSL 的支持，导致短暂的无响应。
    // 将测试提前到程序初始化时，以避免首次登录时卡顿。
    // 将 OpenSSL 的 dll 随程序发布可以缩短测试时间。
    test_ssl();

    // 注册 C++ 插件类
    qmlRegisterType<RemoteViewer>("com.evercloud.viewer", 0, 1, "RemoteViewer");
    qmlRegisterType<SystemPower>("com.evercloud.sys", 0, 1, "SystemPower");
    qmlRegisterType<IPSettings>("com.evercloud.sys", 0, 1, "IPSettings");

    QGuiApplication app(argc, argv);
    QFont msyh_light("微软雅黑 Light");
    app.setFont(msyh_light);

    app.setOrganizationName("HY");
    app.setOrganizationDomain("HY.com");
    app.setApplicationName("cloud-Client");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

#ifndef QT_DEBUG
    QWindowList windows = QGuiApplication::topLevelWindows();
    QWindow *main_window = windows[0];
    main_window->showFullScreen();
#endif // QT_DEBUG

    return app.exec();
}
