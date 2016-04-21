#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QWindow>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    QWindowList windows = QGuiApplication::topLevelWindows();
    QWindow *main_window = windows[0];
    main_window->showFullScreen();

    return app.exec();
}
