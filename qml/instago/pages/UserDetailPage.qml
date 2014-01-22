// *************************************************** //
// User Detail Page
//
// The user profile page shows the personal information
// about a specific user.
// Note that this is not the page that shows the
// profile of the currently logged in user.
// *************************************************** //

import QtQuick 2.0
import com.nokia.meego 1.1
import com.nokia.extras 1.1

import "../components"
import "../global/globals.js" as Globals
import "../classes/authenticationhandler.js" as Authentication
import "../models/userdata.js" as UserDataScript
import "../models/relationships.js" as UserRelationshipScript

Page {
    // use the detail view toolbar
    tools: profileToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // this holds the user id of the respective user
    // the property will be filled by the calling page
    property string userId: "";

    // this holds the user name of the respective user
    // the property will be filled by the calling page
    property string userName: "";

    Component.onCompleted: {
        // show loading indicators while loading user data
        loadingIndicator.running = true;
        loadingIndicator.visible = true;

        if (userId != "")
        {
            // load the users profile
            UserDataScript.loadUserProfile(userId);

            // show follow button if the user is logged in
            if (Authentication.auth.isAuthenticated())
            {
                UserRelationshipScript.getRelationship(userId);
            }
        }
        else
        {
            UserDataScript.loadUserProfileByName(userName);
        }
    }

    // standard header for the current page
    Header {
        id: pageHeader
        text: ""

        onImageViewButtonClicked: {
            UserDataScript.changeUserImageView(userId);
        }

        onHeaderBarClicked: {
            // console.log("Jump to top clicked");
            userprofileGallery.jumpToTop();
            userprofileFeed.jumpToTop();
            userprofileFollowers.jumpToTop();
            userprofileFollowing.jumpToTop();
        }
    }

    // standard notification area
    NotificationArea {
        id: notification

        visibilitytime: 1500

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
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
            userprofileContentHeadline.text = "Bio";
            if (userprofileBio.text == "")
            {
                userprofileContentHeadline.visible = false;
            }

            userprofileBio.visible = true;
        }

        onImagecountClicked: {
            // user photos are only available for authenticated users
            if (Authentication.auth.isAuthenticated())
            {
                userprofileBio.visible = false;
                userprofileFollowers.visible = false;
                userprofileFollowing.visible = false;
                userprofileContentHeadline.text = "Photos";
                userprofileContentHeadline.visible = true;

                UserDataScript.loadUserImages(userId, 0);

                userprofileGallery.visible = true;
                pageHeader.imageViewButtonVisible = true;
            }
        }

        onFollowersClicked: {
            // follower list only available for authenticated users
            if (Authentication.auth.isAuthenticated())
            {
                pageHeader.imageViewButtonVisible = false;
                userprofileBio.visible = false;
                userprofileGallery.visible = false;
                userprofileFeed.visible = false;
                userprofileFollowing.visible = false;
                userprofileContentHeadline.text = "Followers";
                userprofileContentHeadline.visible = true;

                UserDataScript.loadUserFollowers(userId, 0);

                userprofileFollowers.visible = true;
            }
        }

        onFollowingClicked: {
            // following list only available for authenticated users
            if (Authentication.auth.isAuthenticated())
            {
                pageHeader.imageViewButtonVisible = false;
                userprofileBio.visible = false;
                userprofileGallery.visible = false;
                userprofileFeed.visible = false;
                userprofileFollowers.visible = false;
                userprofileContentHeadline.text = "Following";
                userprofileContentHeadline.visible = true;

                UserDataScript.loadUserFollowing(userId, 0);

                userprofileFollowing.visible = true;
            }
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
        text: "Bio"
    }


    // user bio
    // this also contains the follow / unfollow functionality
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

        // follow user
        onFollowButtonClicked: {
            notification.text = "You now follow " + pageHeader.text;
            notification.show();

            UserRelationshipScript.setRelationship(userId, "follow");

            userprofileBio.followButtonVisible = false;
            userprofileBio.unfollowButtonVisible = true;
        }

        // unfollow user
        onUnfollowButtonClicked: {
            notification.text = "You unfollowed " + pageHeader.text;
            notification.show();

            UserRelationshipScript.setRelationship(userId, "unfollow");

            userprofileBio.unfollowButtonVisible = false;
            userprofileBio.followButtonVisible = true;
        }

        // request to follow user
        onRequestButtonClicked: {
            notification.text = "You requested to follow";
            notification.show();

            UserRelationshipScript.setRelationship(userId, "follow");

            userprofileBio.requestButtonVisible = false;
            userprofileBio.unrequestButtonVisible = true;
        }

        // unrequest to follow user
        onUnrequestButtonClicked: {
            notification.text = "You withdrew your request to follow";
            notification.show();

            UserRelationshipScript.setRelationship(userId, "unfollow");

            userprofileBio.unrequestButtonVisible = false;
            userprofileBio.requestButtonVisible = true;
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
                UserDataScript.loadUserImages(userId, paginationNextMaxId);
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
            UserDataScript.loadUserImages(userId, 0);
        }

        onFeedBottomReached: {
            if (paginationNextMaxId !== "")
            {
                UserDataScript.loadUserImages(userId, paginationNextMaxId);
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

        running:  true
        visible: true
    }


    // error indicator that is shown when a network error occured
    ErrorMessage {
        id: errorMessage

        anchors {
            top: userprofileContentHeadline.bottom
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

            loadingIndicator.running = true;
            loadingIndicator.visible = true;
            UserDataScript.loadUserProfile(userId);
        }
    }


    // page specific toolbar
    ToolBarLayout {
        id: profileToolbar

        // jump back to the detail image
        ToolIcon {
            iconId: "toolbar-back";
            onClicked: {
                pageStack.pop();
            }
        }
    }
}
