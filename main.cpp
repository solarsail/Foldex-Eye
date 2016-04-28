#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QWindow>
#include <QtQml>
#include <QSslSocket>
#include "httprequest.h"
#include "rdpprocess.h"

void test_ssl()
{
    QSslSocket::supportsSsl();
}

static QJSValue conn_singleton_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    static QString username, password, info, host;

    QJSValue profile = scriptEngine->newObject();
    profile.setProperty("username", username);
    profile.setProperty("password", password);
    profile.setProperty("info", info);
    profile.setProperty("currentHost", host);
    return profile;
}

int main(int argc, char *argv[])
{
    // 第一次发送 HTTP 请求时会测试对 SSL 的支持，导致短暂的无响应（因为 Windows 默认不支持）。
    // 将测试提前到程序初始化时，以避免首次登录时卡顿。
    // 将 OpenSSL 的 dll 随程序发布可以缩短测试时间。
    test_ssl();

    // 注册 C++ 插件类
    qmlRegisterType<HTTPRequest>("com.evercloud.http", 0, 1, "Request");
    qmlRegisterType<RDPProcess>("com.evercloud.rdp", 0, 1, "RDPProcess");
    qmlRegisterSingletonType("com.evercloud.conn", 0, 1, "UserConnection", conn_singleton_provider);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    //QWindowList windows = QGuiApplication::topLevelWindows();
    //QWindow *main_window = windows[0];
    //main_window->showFullScreen();

    return app.exec();
}
