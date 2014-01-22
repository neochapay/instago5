// *************************************************** //
// Image Liked Page
//
// This page shows the list of users that liked a given
// image.
// *************************************************** //

import QtQuick 2.0
import com.nokia.meego 1.1
import com.nokia.extras 1.1

import "../components"
import "../global/globals.js" as Globals
import "../models/likes.js" as Likes

Page {
    // use the detail view toolbar
    tools: profileToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // the image id that the likes are pulled for
    // the property will be filled by the calling page
    property string imageId: "";

    Component.onCompleted: {
        Likes.getLikes(imageId);
    }

    // standard header for the current page
    Header {
        id: pageHeader
        text: "Liked it"

        onHeaderBarClicked: {
            // console.log("Jump to top clicked");
            imageLikesUserlist.jumpToTop();
        }
    }

    // standard notification area
    NotificationArea {
        id: notification

        visibilitytime: 1500

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
    }


    // list of the followers
    // container is only visible if user is authenticated
    UserList {
        id: imageLikesUserlist;

        anchors {
            top: pageHeader.bottom
            topMargin: 10;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: true
    }


    // text shown if no likes added yet
    Text {
        id: imageLikesEmptyList

        anchors.centerIn: parent

        font.family: "Nokia Pure Text Light"
        font.pixelSize: 45
        wrapMode: Text.Wrap
        color: "darkgray"
        horizontalAlignment: Text.AlignHCenter

        visible: false;

        text: "No likes yet"
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
            Likes.getLikes(imageId);
        }
    }


    // page specific toolbar
    ToolBarLayout {
        id: profileToolbar

        // jump back to the detail image
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                pageStack.pop();
            }
        }
    }
}
