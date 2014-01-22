// *************************************************** //
// About Page
//
// The about page contains a description for the
// application.
// *************************************************** //

import QtQuick 2.0
import com.nokia.meego 1.0

import "../components"
import "../global/globals.js" as Globals

Page {
    // use the about view toolbar
    tools: aboutToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // standard header for the current page
    Header {
        id: pageHeader
        source: "../img/top_header_logo.png"
    }


    // about headline
    Text {
        id : aboutHeadline

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: aboutMaintext.top
            bottomMargin: 20
        }

        width: 400
        visible: true

        font.family: "Nokia Pure Text Light"
        font.pixelSize: 25
        wrapMode: Text.WordWrap
        color: Globals.instagoDefaultTextColor

        text: "Instago";
    }


    // about description
    Text {
        id : aboutMaintext

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

        text: "An Instagram client for MeeGo. Browse popular photos, find interesting people and share beautiful images.<br /><br />A sideproject by Dirk Songür (dirk@songuer.de).<br /><br />Version " + Globals.currentApplicationVersion;
    }


    // page specific toolbar
    ToolBarLayout {
        id: aboutToolbar

        // jump back to the user profile page
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                pageStack.pop();
            }
        }
    }
}
