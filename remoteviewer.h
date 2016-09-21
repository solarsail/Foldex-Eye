#ifndef PROCESS_H
#define PROCESS_H

#include <QProcess>
#include <QVariant>


class RemoteViewer : public QProcess
{
    Q_OBJECT
    QString _uri;

public:
    explicit RemoteViewer(QObject *parent = 0);

    Q_PROPERTY(QString uri READ uri WRITE setUri)

    Q_INVOKABLE void start();
    Q_INVOKABLE QString errorDescription() const;

    QString uri() const;


public slots:
    Q_INVOKABLE void kill();
    void setUri(QString username);

};

#endif // PROCESS_H
