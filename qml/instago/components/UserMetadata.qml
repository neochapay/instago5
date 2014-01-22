// *************************************************** //
// User Metadata Component
//
// The user metadata component is used by the application
// pages. It displays the user metadata: profile image,
// full name, number of images, follows and followers
// as a convinient box.
// *************************************************** //

import QtQuick 2.0

import "../pages"
import "../global/globals.js" as Globals

Rectangle {
    id: usermetadata

    // define content properties to make the data fields accessible
    property alias profilepicture: usermetadataPicture.source;
    property alias fullname: usermetadataFullname.text;
    property alias imagecount: imagecountNumber.text;
    property alias followers: followersNumber.text;
    property alias following: followingNumber.text;
    property string currentComponent: "bio";

    // define signals to make the interactions accessible
    signal profilepictureClicked();
    signal imagecountClicked();
    signal followersClicked();
    signal followingClicked();

    // general style definition
    color: "transparent"
    width: parent.width;
    height: 140


    // user profile picture (125x125)
    Rectangle {
        id: usermetadataPictureContainer

        anchors {
            top: parent.top;
            left: parent.left;
            leftMargin: 10;
        }

        width: 125
        height: 125

        // light gray color to mark loading image
        color: "gainsboro"

        // actual user image
        Image {
            id: usermetadataPicture

            anchors.fill: parent
            smooth: true
        }

        // use the whole item as tap surface
        // all taps on the item will be handled by the onclick event
        MouseArea {
            anchors.fill: parent

            onCanceled:
            {
                usermetadataPicture.opacity = 1;
            }

            onPressed:
            {
                usermetadataPicture.opacity = 0.5;
            }

            onReleased:
            {
                usermetadataPicture.opacity = 1;
                currentComponent = "bio";
                profilepictureClicked();
            }
        }
    }


    // username
    Text {
        id: usermetadataFullname

        anchors {
            top: parent.top;
            left: usermetadataPictureContainer.right;
            leftMargin: 10;
            right: parent.right;
        }

        height: 35

        font.family: "Nokia Pure Text Light"
        font.pixelSize: 30
        wrapMode: Text.Wrap
        color: Globals.instagoDefaultTextColor
    }


    // number of images
    Rectangle {
        id: usermetadataImagecount

        anchors {
            top: usermetadataFullname.bottom;
            topMargin: 10
            left: usermetadataPictureContainer.right;
            leftMargin: 10;
        }

        // light background to create boxes
        color: Globals.instagoDefaultSurfaceColor;

        width: 100
        height: 80

        // actual number is shown as big, centered text
        Text {
            id: imagecountNumber

            anchors {
                top: parent.top
                topMargin: 10
                left: parent.left
                right: parent.right;
            }

            font.family: "Nokia Pure Text Light"
            font.pixelSize: 30
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            color: Globals.instagoDefaultTextColor
        }


        // label for number of images
        Text {
            id: imagecountText

            anchors {
                top: imagecountNumber.bottom
                left: parent.left
                right: parent.right;
                bottom: parent.bottom
            }

            font.family: "Nokia Pure Text"
            font.pixelSize: 20
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            color: "darkgray"

            text: "photos"
        }


        // use the whole item as tap surface
        // all taps on the item will be handled by the onclick event
        MouseArea {
            anchors.fill: parent

            onCanceled:
            {
                usermetadataImagecount.color = Globals.instagoDefaultSurfaceColor;
            }

            onPressed:
            {
                usermetadataImagecount.color = Globals.instagoHighlightedSurfaceColor;
            }

            onReleased:
            {
                usermetadataImagecount.color = Globals.instagoDefaultSurfaceColor;
                currentComponent = "photos";
                imagecountClicked();
            }
        }
    }


    // number of followers
    Rectangle {
        id: usermetadataFollowers

        anchors {
            top: usermetadataFullname.bottom;
            topMargin: 10
            left: usermetadataImagecount.right;
            leftMargin: 10;
        }

        // light background to create boxes
        color: Globals.instagoDefaultSurfaceColor;

        width: 100
        height: 80


        // actual number is shown as big, centered text
        Text {
            id: followersNumber

            anchors {
                top: parent.top
                topMargin: 10
                left: parent.left
                right: parent.right;
            }

            font.family: "Nokia Pure Text Light"
            font.pixelSize: 30
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            color: Globals.instagoDefaultTextColor
        }


        // label for number of followers
        Text {
            id: followersText

            anchors {
                top: followersNumber.bottom
                left: parent.left
                right: parent.right;
                bottom: parent.bottom
            }

            wrapMode: Text.Wrap
            font.family: "Nokia Pure Text"
            font.pixelSize: 20
            horizontalAlignment: Text.AlignHCenter
            color: "darkgray"

            text: "followers"
        }

        // use the whole item as tap surface
        // all taps on the item will be handled by the onclick event
        MouseArea {
            anchors.fill: parent

            onCanceled:
            {
                usermetadataFollowers.color = Globals.instagoDefaultSurfaceColor;
            }

            onPressed:
            {
                usermetadataFollowers.color = Globals.instagoHighlightedSurfaceColor;
            }

            onReleased:
            {
                usermetadataFollowers.color = Globals.instagoDefaultSurfaceColor;
                currentComponent = "followers";
                followersClicked();
            }
        }
    }


    // number of users the actual user follows
    Rectangle {
        id: usermetadataFollowing

        anchors {
            top: usermetadataFullname.bottom;
            topMargin: 10
            left: usermetadataFollowers.right;
            leftMargin: 10;
        }

        // light background to create boxes
        color: Globals.instagoDefaultSurfaceColor;

        width: 100
        height: 80


        // actual number is shown as big, centered text
        Text {
            id: followingNumber

            anchors {
                top: parent.top
                topMargin: 10
                left: parent.left
                right: parent.right;
            }

            font.family: "Nokia Pure Text Light"
            font.pixelSize: 30
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            color: Globals.instagoDefaultTextColor
        }


        // label for number of followings
        Text {
            id: followingText

            anchors {
                top: followingNumber.bottom
                left: parent.left
                right: parent.right;
                bottom: parent.bottom
            }

            font.family: "Nokia Pure Text"
            font.pixelSize: 20
            horizontalAlignment: Text.AlignHCenter
            color: "darkgray"
            wrapMode: Text.Wrap

            text: "following"
        }


        // use the whole item as tap surface
        // all taps on the item will be handled by the onclick event
        MouseArea {
            anchors.fill: parent

            onCanceled:
            {
                usermetadataFollowing.color = Globals.instagoDefaultSurfaceColor;
            }

            onPressed:
            {
                usermetadataFollowing.color = Globals.instagoHighlightedSurfaceColor;
            }

            onReleased:
            {
                usermetadataFollowing.color = Globals.instagoDefaultSurfaceColor;
                currentComponent = "following";
                followingClicked();
            }
        }
    }
}

