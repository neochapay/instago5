// *************************************************** //
// Search Page
//
// This page provides search and displays the results.
// *************************************************** //

import QtQuick 2.0
import com.nokia.meego 1.1
import com.nokia.extras 1.1

import "../components"
import "../global/globals.js" as Globals
import "../models/search.js" as SearchScript

Page {
    // use the detail view toolbar
    tools: mainNavigationToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    Component.onCompleted: {
    }

    // standard header for the current page
    Header {
        id: pageHeader
        text: "Search"

        onImageViewButtonClicked: {
            SearchScript.changeSearchImageView(searchInput.text);
        }
    }

    // standard notification area
    NotificationArea {
        id: notification

        visibilitytime: 1500

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
    }


    // search entry field
    TextField {
        id: searchInput

        anchors {
            top: pageHeader.bottom;
            topMargin: 15;
            left: parent.left;
            leftMargin: 10;
        }

        width: 400

        onAccepted: {
            // console.log("Input received: " + searchInput.text);

            if (searchUserButton.checked)
            {
                pageHeader.imageViewButtonVisible = false;
                SearchScript.searchUser(searchInput.text);
            }
            else
            {
                pageHeader.imageViewButtonVisible = true;
                SearchScript.loadHashtagImages(searchInput.text, 0);
            }

            searchInput.platformCloseSoftwareInputPanel();
        }

        placeholderText: "Enter user name"
        text: ""
    }


    // search button
    Button {
        id: searchButton

        anchors {
            top: pageHeader.bottom;
            topMargin: 16;
            left: searchInput.right;
            leftMargin: 5;
        }

        width: 50
        height: 50

        iconSource: "image://theme/icon-m-toolbar-search-dimmed"

        onClicked: {
            // console.log("Input received: " + searchInput.text);

            if (searchUserButton.checked)
            {
                pageHeader.imageViewButtonVisible = false;
                SearchScript.searchUser(searchInput.text);
            }
            else
            {
                pageHeader.imageViewButtonVisible = true;
                SearchScript.loadHashtagImages(searchInput.text, 0);
            }

            searchInput.platformCloseSoftwareInputPanel();
        }
    }


    // user search button
    Button {
        id: searchUserButton

        anchors {
            top: searchInput.bottom;
            topMargin: 15;
            left: parent.left;
            leftMargin: 13;
        }

        width: 220

        checkable: false
        checked: true

        onClicked: {
            // do search if input field is not empty
            if (searchInput.text.length > 0)
            {
                pageHeader.imageViewButtonVisible = false;
                SearchScript.searchUser(searchInput.text);
            }

            // set checked state and placeholder text
            if (!searchUserButton.checked)
            {
                pageHeader.imageViewButtonVisible = false;
                searchUserButton.checked = true;
                searchHashtagButton.checked = false;
                searchInput.placeholderText = "Enter user name"
            }
        }

        text: "Search user"
    }


    // hastags search button
    Button {
        id: searchHashtagButton

        anchors {
            top: searchInput.bottom;
            topMargin: 15;
            left: searchUserButton.right;
            leftMargin: 15;
        }

        width: 220

        checkable: false
        checked: false

        onClicked: {
            // do search if input field is not empty
            if (searchInput.text.length > 0)
            {
                pageHeader.imageViewButtonVisible = true;
                SearchScript.loadHashtagImages(searchInput.text, 0);
            }

            // set checked state and placeholder text
            if (!searchHashtagButton.checked)
            {
                pageHeader.imageViewButtonVisible = false;
                searchUserButton.checked = false;
                searchHashtagButton.checked = true;
                searchInput.placeholderText = "Enter hashtag"
            }
        }

        text: "Search hashtag"
    }


    // list of search results for user search
    // container is only visible if user search has completed
    UserList {
        id: searchUserResults;

        anchors {
            top: searchUserButton.bottom
            topMargin: 10;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false
    }


    // list of search results for hashtag search
    // container is only visible if hashtag search has completed
    ImageGallery {
        id: imageGallery;

        anchors {
            top: searchUserButton.bottom
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
                SearchScript.loadHashtagImages(searchInput.text, paginationNextMaxId);
            }
        }
    }


    // list of search results for hashtag search
    // container is only visible if hashtag search has completed
    ImageFeed {
        id: imageFeed;

        anchors {
            top: searchUserButton.bottom
            topMargin: 10;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false

        onFeedRequiresUpdate: {
            SearchScript.loadHashtagImages(searchInput.text, 0);
        }

        onFeedBottomReached: {
            if (paginationNextMaxId !== "")
            {
                SearchScript.loadHashtagImages(searchInput.text, paginationNextMaxId);
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


    // error indicator that is shown when a network error occured
    ErrorMessage {
        id: errorMessage

        anchors {
            top: searchHashtagButton.bottom;
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
            if (searchUserButton.checked)
            {
                SearchScript.searchUser(searchInput.text);
            }
            else
            {
                SearchScript.loadHashtagImages(searchInput.text, 0);
            }

            errorMessage.visible = false;
        }
    }
}
