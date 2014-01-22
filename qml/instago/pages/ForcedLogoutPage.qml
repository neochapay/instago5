// *************************************************** //
// Forced Logout Page
//
// This page is shown when Instagram invalidated the
// user token for some reason.
// This can either happen based on user input (removed
// application rights) or based on Instagram itself
// (deleted user).
// If that happens, the user is logged out automatically
// and all his cached userdata cleared.
// Note that the application has to be closed afterwards
// as there is no greaceful way of handling this kind of
// situation.
// *************************************************** //

import QtQuick 2.0
import com.nokia.meego 1.0

import "../components"
import "../global/globals.js" as Globals
import "../classes/authenticationhandler.js" as Authentication

Page {
    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // clear the cached user data
    Component.onCompleted: {
        Authentication.auth.deleteStoredInstagramData();
    }

    // standard header for the current page
    Header {
        id: pageHeader
        source: "../img/top_header_logo.png"
    }


    // logout headline
    Text {
        id : forcedLogoutHeadline

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: forcedLogoutMaintext.top
            bottomMargin: 20
        }

        width: 400
        visible: true

        font.family: "Nokia Pure Text Light"
        font.pixelSize: 25
        wrapMode: Text.WordWrap
        color: Globals.instagoDefaultTextColor

        text: "You have been logged out";
    }


    // logout + problem description
    Text {
        id : forcedLogoutMaintext

        anchors {
            centerIn: parent
        }

        width: 400
        visible: true

        font.family: "Nokia Pure Text"
        font.pixelSize: 20
        wrapMode: Text.WordWrap
        textFormat: Text.RichText
        color: Globals.instagoDefaultTextColor

        text: "Your Instagram session is not valid anymore. This can happen if you or Instagram revoked the application access or changed your user information.<br /><br />You can authenticate again once you restart the application.";
    }
}
