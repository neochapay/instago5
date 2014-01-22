// *************************************************** //
// News Feed Page
//
// The page shows the news feed for the user.
// *************************************************** //

import QtQuick 2.0
import com.nokia.meego 1.0
import QtWebKit 1.0

import "../components"
import "../global/globals.js" as Globals
import "../models/newsfeed.js" as Newsfeed

Page {
    // use the main navigation toolbar
    tools: mainNavigationToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // load the gallery content as soon as the page is ready
    Component.onCompleted: {
        Newsfeed.loadInboxFeed();

        iconHome.visible = true;
        iconPopular.visible = true;
        // iconNews.visible = true;
        iconSearch.visible = true;
        iconNone.visible = false;
    }

    // standard header for the current page
    Header {
        id: pageHeader
        text: "News"
    }

    // browser window showing the Instagram authentication process
    WebView {
        id: newsInstagramWebView

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
        url: "";

        onLoadFailed: {
            console.log("Load failed");
            console.log("Status: " +  statusText);
        }

        // check on every page load if the oauth token is in it
        onUrlChanged: {
            console.log("New URL: " + url);
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
}
