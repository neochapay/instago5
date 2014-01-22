#include "networkhelper.h"

// networkhelper.cpp is a simple wrapper for http network stuff
// It's main use is to wrap the http delete method in a convenient package
// that can be used from QML

#include <QDeclarativeContext>

NetworkHelper::NetworkHelper(QObject *parent) : QObject(parent)
{
    // qDebug("NetworkHelper active");

    nam = new QNetworkAccessManager(this);
    connect(nam, SIGNAL(finished(QNetworkReply*)), this, SLOT(handleHttpResult(QNetworkReply*)));
}


void NetworkHelper::sendDeleteRequest(QString url)
{
    // qDebug("Sending request");

    nam->deleteResource(QNetworkRequest(QUrl(url)));

    // qDebug("Request done");
}


void NetworkHelper::handleHttpResult(QNetworkReply *reply)
{
    // qDebug("Result received");

    // no error received?
    if (reply->error() == QNetworkReply::NoError)
    {
        // read data from QNetworkReply here
    }
    // Some http error received
    else
    {
        // handle errors here
    }

    // We receive ownership of the reply object
    // and therefore need to handle deletion.
    delete reply;

    // qDebug("Result done");
}
