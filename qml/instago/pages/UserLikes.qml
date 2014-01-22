// *************************************************** //
// User Likes Page
//
// The popular photos page is shown as default starting
// page.
// It shows a grid of the current popular photos that
// can be tapped.
// *************************************************** //

import QtQuick 2.0
import com.nokia.meego 1.0
import QtMobility.gallery 1.1

import "../components"
import "../global/globals.js" as Globals
import "../classes/authenticationhandler.js" as Authentication
import "../models/likes.js" as LikesScript

Page {
    // use the main navigation toolbar
    tools: likesToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // load the gallery content as soon as the page is ready
    Component.onCompleted: {
        LikesScript.getCurrentUserLikes(0);
    }

    // standard header for the current page
    Header {
        id: pageHeader
        text: "Your Favourites"
    }


    // show the loading indicator as long as the page is not ready
    BusyIndicator {
        id: loadingIndicator

        anchors.centerIn: parent
        platformStyle: BusyIndicatorStyle { size: "large" }

        running:  true
        visible: true
    }


    // error indicator that is shown when a network error occured
    ErrorMessage {
        id: errorMessage

        anchors {
            top: pageHeader.bottom;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false

        onErrorMessageClicked: {
            // console.log("Refresh clicked")
            errorMessage.visible = false;
        }
    }


    // standard notification area
    NotificationArea {
        id: notification

        visibilitytime: 1500

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
    }


    // the actual image gallery that contains the the popular photos
    ImageGallery {
        id: likesGallery;

        anchors {
            top: pageHeader.bottom;
            topMargin: 3;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false

        onItemClicked: {
            // console.log("Image tapped: " + imageId);
            pageStack.push(Qt.resolvedUrl("../pages/ImageDetailPage.qml"), {imageId: imageId});
        }

        onListBottomReached: {
            if (paginationNextMaxId !== "")
            {
                console.log("Pagination ID: " + paginationNextMaxId);
                LikesScript.getCurrentUserLikes( paginationNextMaxId );
            }
        }
    }


    // page specific toolbar
    ToolBarLayout {
        id: likesToolbar

        // jump back to the detail image
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                pageStack.pop();
            }
        }
    }
}
