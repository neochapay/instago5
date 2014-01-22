// *************************************************** //
// User Feed Page
//
// The page shows th personal feed of the user. It
// contains images and content from the people the
// user currently follows.
// *************************************************** //

import QtQuick 2.0
import com.nokia.meego 1.0
import QtMobility.gallery 1.1

import "../components"
import "../global/globals.js" as Globals
import "../classes/authenticationhandler.js" as Authentication
import "../models/userfeed.js" as Userfeed

Page {
    // use the main navigation toolbar
    tools: mainNavigationToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // load the gallery content as soon as the page is ready
    Component.onCompleted: {
        Userfeed.loadUserFeed();

        iconHome.visible = true;
        iconPopular.visible = true;
        // iconNews.visible = true;
        iconSearch.visible = true;
        iconNone.visible = false;
    }

    // standard header for the current page
    Header {
        id: pageHeader
        text: "Your Feed"
        reloadButtonVisible: true

        onReloadButtonClicked: {
            // console.log("Refresh clicked");
            userImageFeed.visible = false;
            errorMessage.visible = false;

            loadingIndicator.running = true;
            loadingIndicator.visible = true;

            Userfeed.loadUserFeed();
        }

        onHeaderBarClicked: {
            // console.log("Jump to top clicked");
            userImageFeed.jumpToTop();
        }
    }


    // standard notification area
    NotificationArea {
        id: notification

        visibilitytime: 1500

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
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
            loadingIndicator.running = true;
            loadingIndicator.visible = true;
            Userfeed.loadUserFeed();
        }
    }


    // the actual user image feed
    ImageFeed {
        id: userImageFeed

        anchors {
            top: pageHeader.bottom;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false

        onFeedRequiresUpdate: {
            userImageFeed.visible = false;
            errorMessage.visible = false;

            loadingIndicator.running = true;
            loadingIndicator.visible = true;
            Userfeed.loadUserFeed();
        }
    }
}
