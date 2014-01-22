// *************************************************** //
// User Profile Page
//
// The user profile page shows the personal information
// of the currently logged in user.
// If the user is not logged in, then a link to the
// login process is shown.
// *************************************************** //

import QtQuick 2.0
import com.nokia.meego 1.0

import "../components"
import "../global/globals.js" as Globals
import "../classes/authenticationhandler.js" as Authentication
import "../models/userdata.js" as UserDataScript

Page {
    // use the detail view toolbar
    tools: profileToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // check if the user is already logged in
    Component.onCompleted: {
        if (Authentication.auth.isAuthenticated())
        {
            // user is authorized with Instagram
            // console.log("User is authorized");

            // show loading indicators only if the user is logged in
            loadingIndicator.running = true;
            loadingIndicator.visible = true;

            // load profile data for user
            var instagramUserdata = Authentication.auth.getStoredInstagramData();
            UserDataScript.loadUserProfile(instagramUserdata["id"]);
        }
        else
        {
            // user is not authorized with Instagram
            // console.log("User is not authorized");

            // activate error container
            userprofileNoTokenContainer.visible = true;
        }
    }

    // standard header for the current page
    Header {
        id: pageHeader
        text: "You"

        onImageViewButtonClicked: {
            var instagramUserdata = Authentication.auth.getStoredInstagramData();
            UserDataScript.changeUserImageView(instagramUserdata["id"]);
        }

        onHeaderBarClicked: {
            // console.log("Jump to top clicked");
            userprofileGallery.jumpToTop();
            userprofileFeed.jumpToTop();
            userprofileFollowers.jumpToTop();
            userprofileFollowing.jumpToTop();
        }
    }


    // container if user is not authenticated
    Rectangle {
        id: userprofileNoTokenContainer

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
            id : userprofileNoTokenHeadline

            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: userprofileNoTokenText.top
                bottomMargin: 20
            }

            width: 400

            font.family: "Nokia Pure Text Light"
            font.pixelSize: 25
            wrapMode: Text.WordWrap
            color: Globals.instagoDefaultTextColor

            text: "Please log in";
        }


        // description
        Text {
            id : userprofileNoTokenText

            anchors {
                centerIn: parent
            }

            width: 400

            font.family: "Nokia Pure Text"
            font.pixelSize: 20
            wrapMode: Text.WordWrap
            textFormat: Text.RichText
            color: Globals.instagoDefaultTextColor

            text: "You are not connected to Instagram,<br />only the public features are available at the moment.<br /><br />Please connect to Instagram to use features like your news stream, following other users<br />or liking other users photos.";
        }


        // login button
        Button {
            id: userprofileNoTokenLogin

            anchors {
                left: parent.left;
                leftMargin: 30;
                right: parent.right;
                rightMargin: 30;
                top: userprofileNoTokenText.bottom;
                topMargin: 30;
            }

            text: "Login"

            onClicked: {
                pageStack.push(Qt.resolvedUrl("LoginPage.qml"))
            }
        }
    }


    // header with the user metadata
    UserMetadata {
        id: userprofileMetadata;

        anchors {
            top: pageHeader.bottom;
            topMargin: 10;
            left: parent.left;
            right: parent.right;
        }

        visible: false

        onProfilepictureClicked: {
            pageHeader.imageViewButtonVisible = false;
            userprofileGallery.visible = false;
            userprofileFeed.visible = false;
            userprofileFollowers.visible = false;
            userprofileFollowing.visible = false;
            userprofileContentHeadline.text = "Your bio";
            if (userprofileBio.text == "")
            {
                userprofileContentHeadline.visible = false;
            }

            userprofileBio.visible = true;
        }

        onImagecountClicked: {
            userprofileBio.visible = false;
            userprofileFollowers.visible = false;
            userprofileFollowing.visible = false;
            userprofileContentHeadline.text = "Your photos";
            userprofileContentHeadline.visible = true;

            var instagramUserdata = Authentication.auth.getStoredInstagramData();
            UserDataScript.loadUserImages(instagramUserdata["id"], 0);

            userprofileGallery.visible = true;
            pageHeader.imageViewButtonVisible = true;
        }

        onFollowersClicked: {
            pageHeader.imageViewButtonVisible = false;
            userprofileBio.visible = false;
            userprofileGallery.visible = false;
            userprofileFeed.visible = false;
            userprofileFollowing.visible = false;
            userprofileContentHeadline.text = "People that follow you";
            userprofileContentHeadline.visible = true;

            var instagramUserdata = Authentication.auth.getStoredInstagramData();
            UserDataScript.loadUserFollowers(instagramUserdata["id"], 0);

            userprofileFollowers.visible = true;
        }

        onFollowingClicked: {
            pageHeader.imageViewButtonVisible = false;
            userprofileBio.visible = false;
            userprofileGallery.visible = false;
            userprofileFeed.visible = false;
            userprofileFollowers.visible = false;
            userprofileContentHeadline.text = "People that you follow";
            userprofileContentHeadline.visible = true;

            var instagramUserdata = Authentication.auth.getStoredInstagramData();
            UserDataScript.loadUserFollowing(instagramUserdata["id"], 0);

            userprofileFollowing.visible = true;
        }
    }


    // container headline
    // container is only visible if user is authenticated
    Text {
        id: userprofileContentHeadline

        anchors {
            top: userprofileMetadata.bottom
            topMargin: 10
            left: parent.left
            leftMargin: 10
            right: parent.right;
            rightMargin: 10
        }

        height: 30
        visible: false

        font.family: "Nokia Pure Text Light"
        font.pixelSize: 25
        wrapMode: Text.Wrap
        color: Globals.instagoDefaultTextColor

        // content container headline
        // text will be given by the content switchers
        text: "Your Bio"
    }


    // user bio
    // this also contains the logout functionality
    UserBio {
        id: userprofileBio;

        anchors {
            top: userprofileContentHeadline.bottom
            topMargin: 10
            left: parent.left
            right: parent.right;
            bottom: parent.bottom
        }

        visible: false
        logoutButtonVisible: true
        likesButtonVisible: true

        onLogoutButtonClicked: {
            Authentication.auth.deleteStoredInstagramData();

            pageStack.clear();
            pageStack.push(Qt.resolvedUrl("PopularPhotosPage.qml"));
        }
    }


    // gallery of user images
    // container is only visible if user is authenticated
    ImageGallery {
        id: userprofileGallery;

        anchors {
            top: userprofileContentHeadline.bottom
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
                var instagramUserdata = Authentication.auth.getStoredInstagramData();
                UserDataScript.loadUserImages(instagramUserdata["id"], paginationNextMaxId);
            }
        }
    }


    // feed of user images
    // container is only visible if user is authenticated
    ImageFeed {
        id: userprofileFeed;

        anchors {
            top: userprofileContentHeadline.bottom
            topMargin: 10;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false

        onFeedRequiresUpdate: {
            var instagramUserdata = Authentication.auth.getStoredInstagramData();
            UserDataScript.loadUserImages(instagramUserdata["id"], 0);
        }

        onFeedBottomReached: {
            if (paginationNextMaxId !== "")
            {
                var instagramUserdata = Authentication.auth.getStoredInstagramData();
                UserDataScript.loadUserImages(instagramUserdata["id"], paginationNextMaxId);
            }
        }
    }


    // list of the followers
    // container is only visible if user is authenticated
    UserList {
        id: userprofileFollowers;

        anchors {
            top: userprofileContentHeadline.bottom
            topMargin: 10;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false
    }


    // list of the followings
    // container is only visible if user is authenticated
    UserList {
        id: userprofileFollowing;

        anchors {
            top: userprofileContentHeadline.bottom
            topMargin: 10;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false
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
            top: pageHeader.bottom;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false

        onErrorMessageClicked: {
            // console.log("Refresh clicked")
            errorMessage.visible = false;
            userprofileMetadata.visible = false;
            userprofileContentHeadline.visible = false;
            userprofileBio.visible = false;

            var instagramUserdata = Authentication.auth.getStoredInstagramData();
            UserDataScript.loadUserProfile(instagramUserdata["id"]);
        }
    }


    // page specific toolbar
    ToolBarLayout {
        id: profileToolbar

        // jump back to the popular photos page
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                pageStack.pop();
            }
        }

        // jump to the about page
        ToolIcon {
            iconId: "toolbar-settings";
            onClicked: {
                pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
        }
    }
}
