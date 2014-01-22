// *************************************************** //
// Main
//
// This is the main entry point of the application
// It provides the main menu, triggers the splash screen
// and dispatches the application to the first screen
// *************************************************** //

import QtQuick 2.1
import QtQuick.Controls 1.1
//import com.nokia.meego 1.0

import "pages"
import "components"

StackView {
    id: appWindow

    // initial page is the gallery of popular photos
    initialPage: splashScreenPage

    // register the popular photo page
    PopularPhotosPage {
        id: popularPhotosPage
    }


    // register the splash screen page
    SplashScreenPage {
        id: splashScreenPage
    }


    // page specific toolbar
    ToolBarLayout {
        id: mainNavigationToolbar
        visible: false

        // jump to the user stream
        ToolIcon {
            id: iconHome
            iconId: "toolbar-home"
            visible: false

            onClicked: {
                pageStack.replace(Qt.resolvedUrl("pages/UserFeedPage.qml"))
            }
        }


        // jump to the popular photo stream
        ToolIcon {
            id: iconPopular
            iconId: "toolbar-all-content-dimmed-white"
            visible: false

            onClicked: {
                pageStack.replace(Qt.resolvedUrl("pages/PopularPhotosPage.qml"))
            }
        }


        // jump to the news streams
        ToolIcon {
            id: iconNews
            iconId: "toolbar-new-message"
            visible: false

            onClicked: {
                pageStack.replace(Qt.resolvedUrl("pages/NewsFeedPage.qml"))
            }
        }


        // jump to the search page
        ToolIcon {
            id: iconSearch
            iconId: "toolbar-search"
            visible: false

            onClicked: {
                pageStack.replace(Qt.resolvedUrl("pages/SearchPage.qml"))
            }
        }


        // this is an "empty" icon slot
        // it's visible when the user is logged out thus keeping the user profile icon right
        // will throw an error on runtime: QML QDeclarativeImage_QML_36: Failed to get image from provider: image://theme/icon-m-
        ToolIcon {
            id: iconNone
        }


        // jump to the profile page of the current user
        ToolIcon {
            id: iconProfile
            iconId: "toolbar-contact";
            onClicked: {
                pageStack.push(Qt.resolvedUrl("pages/UserProfilePage.qml"))
            }
        }
    }
}
