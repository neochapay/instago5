#ifndef NETWORKHELPER_H
#define NETWORKHELPER_H

#include <QtCore>
#include <QObject>
#include <QtNetwork>

// networkhelper.h is a simple wrapper for http network stuff
// It's main use is to wrap the http delete method in a convenient package
// that can be used from QML

class NetworkHelper : public QObject
{
    Q_OBJECT

public:
    explicit NetworkHelper(QObject *parent = 0);

private:
    QNetworkAccessManager *nam;

signals:

public slots:
    //! Sends a request to a given URL with the HTTP DELETE method
    //! \param url The URL to call
    void sendDeleteRequest(QString url);

    void handleHttpResult(QNetworkReply *reply);
};

#endif // NETWORKHELPER_H
