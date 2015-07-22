// *************************************************** //
// Popular Photos Page
//
// The popular photos page is shown as default starting
// page.
// It shows a grid of the current popular photos that
// can be tapped.
// *************************************************** //

import QtQuick 2.0
import Ubuntu.Components 1.1

import "../components"
import "../global/globals.js" as Globals
import "../classes/authenticationhandler.js" as Authentication
import "../models/popularphotos.js" as PopularPhotosScript

Page {
    // use the main navigation toolbar
    tools: mainNavigationToolbar

    // flag to keep track if intro has been shown
    property bool introShown: false

    // load the gallery content as soon as the page is ready
    Component.onCompleted: {
        PopularPhotosScript.loadImages();

        // show main buttons if the user is logged in
        if (Authentication.auth.isAuthenticated())
        {
            iconHome.visible = true;
            iconPopular.visible = true;
            // iconNews.visible = true;
            iconSearch.visible = true;
            iconNone.visible = false;
            introShown = true;
        }
        else
        {
            iconHome.visible = false;
            iconPopular.visible = false;
            // iconNews.visible = false;
            iconSearch.visible = false;
            iconNone.visible = true;
        }
    }

    /*onStatusChanged: {
        if ((status == 2) && (!introShown))
        {
            introShown = true;
            pageStack.push(Qt.resolvedUrl("IntroPage.qml"));
        }
    }*/

    // standard header for the current page
    Header {
        id: pageHeader
        text: "Popular"
        reloadButtonVisible: true

        onReloadButtonClicked: {
            // console.log("Refresh clicked");
            imageGallery.visible = false;
            errorMessage.visible = false;
            loadingIndicator.running = true;
            loadingIndicator.visible = true;
            PopularPhotosScript.loadImages();
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
    ActivityIndicator {
        id: loadingIndicator
        anchors.centerIn: parent
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
            imageGallery.visible = false;
            loadingIndicator.running = true;
            loadingIndicator.visible = true;
            PopularPhotosScript.loadImages();
        }
    }


    // the actual image gallery that contains the the popular photos
    ImageGallery {
        id: imageGallery;

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
            pageStack.push(Qt.resolvedUrl("ImageDetailPage.qml"), {imageId: imageId});
        }
    }
}
