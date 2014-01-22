#ifndef SHAREHELPER_H
#define SHAREHELPER_H

#include <QObject>

// sharehelper.h is based on the PhotoMosaic App
// See: http://www.developer.nokia.com/Community/Wiki/Photomosaic_App_with_Qt

// PhotoMosaic in turn based on the butaca project
// See: http://projects.developer.nokia.com/butaca/

// The article "How to Use the Harmattan’s ShareUI Framework in Qml" on linux4us.org was also helpful
// See: http://blog.linux4us.org/2012/06/14/how-to-use-the-harmattans-shareui-framework-qml/

class ShareHelper : public QObject
{
    Q_OBJECT
public:
    explicit ShareHelper(QObject *parent = 0);
    
signals:

public slots:
    //! Shares a URL with the share-ui interface
    //! \param title The title of the content to be shared
    //! \param description The description of the content to be shared
    //! \param url The URL to be shared
    void shareURL(QString title, QString description, QString url);

    //! Shares an Image with the share-ui interface
    //! \param title The title of the content to be shared
    //! \param description The description of the content to be shared
    //! \param url The URL of the image to be shared
    void shareImage(QString title, QString description, QString url);
};

#endif // SHAREHELPER_H
