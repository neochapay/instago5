// *************************************************** //
// User Bio Component
//
// The user bio component is used by the application
// pages. It displays the user bio (text) as well as
// provides the interaction with a user (un- / follow).
// *************************************************** //

import QtQuick 2.0
import com.nokia.meego 1.1
import com.nokia.extras 1.1

import "../pages"
import "../global/globals.js" as Globals
import "../classes/authenticationhandler.js" as Authentication

Rectangle {
    id: userBio

    // define content properties to make the data fields accessible
    property alias text: userBioText.text;
    property alias followButtonVisible: userBioFollowUser.visible
    property alias unfollowButtonVisible: userBioUnfollowUser.visible
    property alias requestButtonVisible: userBioRequestFollowUser.visible
    property alias unrequestButtonVisible: userBioUnrequestFollowUser.visible
    property alias logoutButtonVisible: userBioLogoutUser.visible
    property alias likesButtonVisible: userBioUserLikes.visible
    property alias userIsPrivateMessageVisible: userBioUserIsPrivate.visible

    // define signals to make the interactions accessible
    signal followButtonClicked();
    signal unfollowButtonClicked();
    signal requestButtonClicked();
    signal unrequestButtonClicked();
    signal logoutButtonClicked();

    // no background color
    color: "transparent"

    // bio of the user
    Text {
        id: userBioText

        anchors {
            top: parent.top
            topMargin: 10
            left: parent.left
            leftMargin: 10
            right: parent.right;
            rightMargin: 10
        }

        font.family: "Nokia Pure Text"
        font.pixelSize: 20
        wrapMode: Text.Wrap
        color: Globals.instagoDefaultTextColor

        text: ""
    }


    // message that user is private
    Rectangle {
        id : userBioUserIsPrivate

        anchors {
            bottom: userBioFollowUser.top
            bottomMargin: 30
            horizontalCenter: parent.horizontalCenter
        }

        visible: false;

        // user profile image
        Image {
            id: userBioLockedIcon

            anchors {
                bottom: userBioLockedText.top
                bottomMargin: 10
                horizontalCenter: parent.horizontalCenter
            }

            smooth: true

            width: 80
            height: 80

            source: "image://theme/icon-m-common-locked"
        }


        // description for the about page
        Text {
            id: userBioLockedText

            anchors {
                bottom: userBioUserIsPrivate.bottom
                horizontalCenter: parent.horizontalCenter
            }

            font.family: "Nokia Pure Text Light"
            font.pixelSize: 25
            wrapMode: Text.WordWrap
            textFormat: Text.RichText
            color: Globals.instagoDefaultTextColor

            text: "This user is private";
        }

    }


    // follow button
    Button {
        id: userBioFollowUser

        anchors {
            left: parent.left;
            leftMargin: 30;
            right: parent.right;
            rightMargin: 30;
            top: userBioText.bottom;
            topMargin: 30;
        }

        visible: false
        text: "Follow"

        onClicked: {
            followButtonClicked();
        }
    }


    // unfollow button
    Button {
        id: userBioUnfollowUser

        anchors {
            left: parent.left;
            leftMargin: 30;
            right: parent.right;
            rightMargin: 30;
            top: userBioText.bottom;
            topMargin: 30;
        }

        visible: false
        text: "Unfollow"

        onClicked: {
            unfollowButtonClicked();
        }
    }


    // request follow button
    Button {
        id: userBioRequestFollowUser

        anchors {
            left: parent.left;
            leftMargin: 30;
            right: parent.right;
            rightMargin: 30;
            top: userBioText.bottom;
            topMargin: 30;
        }

        visible: false
        text: "Request permission"

        onClicked: {
            requestButtonClicked();
        }
    }


    // withdraw request button
    Button {
        id: userBioUnrequestFollowUser

        anchors {
            left: parent.left;
            leftMargin: 30;
            right: parent.right;
            rightMargin: 30;
            top: userBioText.bottom;
            topMargin: 30;
        }

        visible: false
        text: "Already requested"

        onClicked: {
            unrequestButtonClicked();
        }
    }


    // logout button
    Button {
        id: userBioLogoutUser

        anchors {
            left: parent.left;
            leftMargin: 30;
            right: parent.right;
            rightMargin: 30;
            top: userBioText.bottom;
            topMargin: 20;
        }

        visible: false
        text: "Logout"

        onClicked: {
            logoutButtonClicked();
        }
    }


    // user likes button
    Button {
        id: userBioUserLikes

        anchors {
            left: parent.left;
            leftMargin: 30;
            right: parent.right;
            rightMargin: 30;
            top: userBioLogoutUser.bottom;
            topMargin: 10;
        }

        visible: false
        text: "Your favourites"

        onClicked: {
            pageStack.push(Qt.resolvedUrl("../pages/UserLikes.qml"))
        }
    }
}
