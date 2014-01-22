// *************************************************** //
// Login Page
//
// The login page shows the Instagram login page in
// a web view.
// *************************************************** //

import QtQuick 2.0
import com.nokia.meego 1.0
import QtWebKit 1.0

import "../components"
import "../global/globals.js" as Globals
import "../global/instagramkeys.js" as InstagramKeys
import "../classes/authenticationhandler.js" as Authentication

Page {
    // use the login view toolbar
    tools: loginToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // standard header for the current page
    Header {
        id: pageHeader
        source: "../img/top_header.png"
        text: "Login"
    }


    // browser window showing the Instagram authentication process
    WebView {
        id: loginInstagramWebView

        anchors {
            top: pageHeader.bottom;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        preferredWidth: parent.width
        preferredHeight: parent.height

        smooth: true
        focus: true
        contentsScale: 1

        // Instagram oauth URL
        url: InstagramKeys.instagramkeys.instagramAuthorizeUrl + "/?client_id=" + InstagramKeys.instagramkeys.instagramClientId + "&redirect_uri=" + InstagramKeys.instagramkeys.instagramRedirectUrl + "&response_type=code&scope=likes+comments+relationships";

        onStatusChanged: {
            // console.log("Status of webview request to server: " + status);
        }

        // check on every page load if the oauth token is in it
        onUrlChanged: {
            var instagramResponse = new Array();
            instagramResponse = Authentication.auth.checkInstagramAuthenticationUrl(url);

            // Show the error message if the Instagram authentication was not successfull
            if (instagramResponse["status"] === "AUTH_ERROR")
            {
                loginInstagramWebView.visible = false;
                loginErrorText.text = instagramResponse["error_description"];
                loginErrorContainer.visible = true;
            }

            // Show the success message if the Instagram authentication was ok
            if (instagramResponse["status"] === "AUTH_SUCCESS")
            {
                loginInstagramWebView.visible = false;
                loginSuccessContainer.visible = true;
            }
        }

        // activates the loading indicator when a new page is loaded
        onLoadStarted: {
            loadingIndicator.running = true;
            loadingIndicator.visible = true;
        }

        // deactivates the loading indicator when the page is done loading
        onLoadFinished: {
            loadingIndicator.running = false;
            loadingIndicator.visible = false;
        }


        // show the loading indicator as long as the page is not ready
        BusyIndicator {
            id: loadingIndicator

            anchors.centerIn: parent
            platformStyle: BusyIndicatorStyle { size: "large" }

            running:  false
            visible: false
        }
    }


    // error message that is shown when the authentication went wrong
    Rectangle {
        id: loginErrorContainer

        anchors {
            top: pageHeader.bottom;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false;

        // no background color
        color: "transparent"


        // headline
        Text {
            id : loginErrorHeadline

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: loginErrorText.top
                bottomMargin: 20
            }

            width: 400

            font.family: "Nokia Pure Text Light"
            font.pixelSize: 25
            wrapMode: Text.WordWrap
            color: Globals.instagoDefaultTextColor

            text: "Could not authenticate you";
        }


        // description
        Text {
            id : loginErrorText

            anchors {
                centerIn: parent
            }

            width: 400

            font.family: "Nokia Pure Text"
            font.pixelSize: 20
            wrapMode: Text.WordWrap
            textFormat: Text.RichText
            color: Globals.instagoDefaultTextColor

            text: "";
        }
    }


    // success message that is shown when the authentication went ok
    Rectangle {
        id: loginSuccessContainer

        anchors {
            top: pageHeader.bottom;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false;

        // no background color
        color: "transparent"


        // headline
        Text {
            id : loginSuccessHeadline

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: loginSuccessText.top
                bottomMargin: 20
            }

            width: 400

            font.family: "Nokia Pure Text Light"
            font.pixelSize: 25
            wrapMode: Text.WordWrap
            color: Globals.instagoDefaultTextColor

            text: "Thank you for authenticating";
        }


        // description
        Text {
            id : loginSuccessText

            anchors {
                centerIn: parent
            }

            width: 400

            font.family: "Nokia Pure Text"
            font.pixelSize: 20
            wrapMode: Text.WordWrap
            textFormat: Text.RichText
            color: Globals.instagoDefaultTextColor

            text: "You are authenticated with Instagram and you can now use all Instago features. Have fun!";
        }
    }


    // page specific toolbar
    ToolBarLayout {
        id: loginToolbar

        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                pageStack.clear();
                pageStack.push(Qt.resolvedUrl("PopularPhotosPage.qml"));
            }
        }
    }
}
