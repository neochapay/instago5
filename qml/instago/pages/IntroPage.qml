// *************************************************** //
// Intro Page
//
// The intro page contains a description for the
// application. It's only shown once at startup if
// the user is not logged in.
// *************************************************** //

import QtQuick 2.0
import com.nokia.meego 1.0

import "../components"
import "../global/globals.js" as Globals

Page {
    // use the intro view toolbar
    tools: introToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // standard header for the current page
    Header {
        id: pageHeader
        source: "../img/top_header_logo.png"
    }


    // intro headline
    Text {
        id : introHeadline

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: introMaintext.top
            bottomMargin: 20
        }

        width: 400
        visible: true

        font.family: "Nokia Pure Text Light"
        font.pixelSize: 25
        wrapMode: Text.WordWrap
        color: Globals.instagoDefaultTextColor

        text: "Welcome to Instago!";
    }


    // intro description
    Text {
        id : introMaintext

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

        text: "Browse popular photos, find interesting people and share beautiful images.<br /><br />You are not connected to Instagram. Only the public features are available at the moment. Please connect to Instagram to use features like your news stream, following other users or liking other users photos.<br /><br />Please note that Instago is only a viewer application. You can't create a new Instagram account nor can you upload photos if you have one.";
    }


    // page specific toolbar
    ToolBarLayout {
        id: introToolbar

        // jump back to the user profile page
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                pageStack.pop();
            }
        }
    }
}
