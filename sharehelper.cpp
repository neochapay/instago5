#include "sharehelper.h"
#include <QImage>

// sharehelper.cpp is based on the PhotoMosaic App
// See: http://www.developer.nokia.com/Community/Wiki/Photomosaic_App_with_Qt

// PhotoMosaic in turn is based on the butaca project
// See: http://projects.developer.nokia.com/butaca/

// The article "How to Use the Harmattan’s ShareUI Framework in Qml" on linux4us.org was also helpful
// See: http://blog.linux4us.org/2012/06/14/how-to-use-the-harmattans-shareui-framework-qml/

#include <QDeclarativeContext>


ShareHelper::ShareHelper(QObject *parent) :
    QObject(parent)
{
}


// shares a URL with the share-ui interface
void ShareHelper::shareURL(QString title, QString description, QString url)
{
    Q_UNUSED(title)
    Q_UNUSED(url)
}


// shares an image with the share-ui interface
void ShareHelper::shareImage(QString title, QString description, QString url)
{
    Q_UNUSED(title)
    Q_UNUSED(url)
}

