TEMPLATE = app

QT += qml quick

SOURCES += main.cpp \
    networkhelper.cpp \
    sharehelper.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    networkhelper.h \
    sharehelper.h

OTHER_FILES += \
    qml/instago/models/comments.js \
    qml/instago/models/imagedetail.js \
    qml/instago/models/likes.js \
    qml/instago/models/locations.js \
    qml/instago/models/newsfeed.js \
    qml/instago/models/popularphotos.js \
    qml/instago/models/relationships.js \
    qml/instago/models/search.js \
    qml/instago/models/userdata.js \
    qml/instago/models/userfeed.js
