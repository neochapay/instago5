// *************************************************** //
// Splash Screen Page
//
// This page shows the splash screen while preloading
// some data from Instagram in the background.
// *************************************************** //

import QtQuick 2.0
import Ubuntu.Components 1.1

import "../components"
import "../global/globals.js" as Globals
import "../classes/authenticationhandler.js" as Authentication

Page {
    // lock orientation to portrait mode

    // this is the splash image, shown in fullscreen
    Image {
        id: splashImage
        source: "../img/instago_splashscreen.png"
        anchors.fill: parent
    }


    // version information, pulled from the globals.js
    Text {
        id : splashVersionInformation

        y: 560
        width: 480
        horizontalAlignment: Text.AlignHCenter

        font.family: "Nokia Pure Text"
        font.pixelSize: 20
        wrapMode: Text.WordWrap
        textFormat: Text.RichText

        color: "white"
        text: Globals.currentApplicationVersion;
    }


    // wait for 2 seconds while the PopularPhotosPage is loading data
    // this is triggerd by the PageStackWindow which already registered
    // the page, thus activating it in the background
    Timer {
        id: splashTimer
        interval: 2000
        running: true
        repeat:  false

        // when done, replace the splash page with the popular photos page
        onTriggered: {
            // console.log("Closing splash screen");
            if (Authentication.auth.isAuthenticated())
            {
                pageStack.push(Qt.resolvedUrl("UserFeedPage.qml"));
            }
            else
            {
                pageStack.replace(popularPhotosPage);
            }
        }
    }
}
