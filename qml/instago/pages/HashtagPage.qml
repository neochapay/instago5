// *************************************************** //
// Hashtag Page
//
// This page displays results for a hashtag search in a
// simple image gallery.
// *************************************************** //

import QtQuick 2.0
import com.nokia.meego 1.1
import com.nokia.extras 1.1

import "../components"
import "../global/globals.js" as Globals
import "../models/search.js" as SearchScript

Page {
    // use the detail view toolbar
    tools: hashtagToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // this holds the hashtag to load data for
    // the property will be filled by the calling page
    property string hashtagName: "";

    Component.onCompleted: {
        pageHeader.text = "#" + hashtagName;
        SearchScript.loadHashtagImages(hashtagName, 0);
    }

    // standard header for the current page
    Header {
        id: pageHeader
        text: ""

        imageViewButtonVisible: true

        onImageViewButtonClicked: {
            SearchScript.changeSearchImageView(hashtagName);
        }
    }

    // standard notification area
    NotificationArea {
        id: notification

        visibilitytime: 1500

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
    }


    // list of search results for hashtag search
    // container is only visible if hashtag search has completed
    ImageGallery {
        id: imageGallery;

        anchors {
            top: pageHeader.bottom
            topMargin: 10;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false

        onItemClicked: {
            // console.log("Image tapped: " + imageId);
            pageStack.push(Qt.resolvedUrl("ImageDetailPage.qml"), {imageId: imageId});
        }

        onListBottomReached: {
            if (paginationNextMaxId !== "")
            {
                SearchScript.loadHashtagImages(hashtagName, paginationNextMaxId);
            }
        }
    }


    // list of search results for hashtag search
    // container is only visible if hashtag search has completed
    ImageFeed {
        id: imageFeed;

        anchors {
            top: pageHeader.bottom
            topMargin: 10;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false

        onFeedRequiresUpdate: {
            SearchScript.loadHashtagImages(hashtagName, 0);
        }

        onFeedBottomReached: {
            if (paginationNextMaxId !== "")
            {
                SearchScript.loadHashtagImages(hashtagName, paginationNextMaxId);
            }
        }
    }


    // text shown if search results have been found
    Text {
        id: searchNoResultsFound

        anchors.centerIn: parent

        font.family: "Nokia Pure Text Light"
        font.pixelSize: 45
        wrapMode: Text.Wrap
        color: "darkgray"
        horizontalAlignment: Text.AlignHCenter

        visible: false;

        text: "Can't find<br />search results"
    }


    // show the loading indicator as long as the page is not ready
    BusyIndicator {
        id: loadingIndicator

        anchors.centerIn: parent
        platformStyle: BusyIndicatorStyle { size: "large" }

        running:  false
        visible: false
    }

    Rectangle {
        id: searchUserResults;
        visible: false;
    }


    // error indicator that is shown when a network error occured
    ErrorMessage {
        id: errorMessage

        anchors {
            top: pageHeader.bottom;
            topMargin: 5;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false

        onVisibleChanged: {
        }

        onErrorMessageClicked: {
            // console.log("Refresh clicked")
            SearchScript.loadHashtagImages(hashtagName, 0);
            errorMessage.visible = false;
        }
    }


    // page specific toolbar
    ToolBarLayout {
        id: hashtagToolbar

        // jump back to the previous page
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                pageStack.pop();
            }
        }
    }
}
