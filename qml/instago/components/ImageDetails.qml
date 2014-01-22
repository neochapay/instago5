// *************************************************** //
// Image Detail Component
//
// The image detail component is used when a specific
// Instagram image should be displayed.
// The image is shown as well as userdata of the user
// that uploaded it.
// *************************************************** //

import QtQuick 2.0
import com.nokia.meego 1.1
import com.nokia.extras 1.1

import "../pages"
import "../global/globals.js" as Globals
import "../classes/authenticationhandler.js" as Authentication
import "../classes/helpermethods.js" as Helpermethods

Rectangle {
    id: imageDetail

    // userdata and image metadata
    property alias username: imagedetailUsername.text
    property alias profilePicture: imagedetailUserpicture.source
    property alias location: imagedetailLocation.text
    property alias elapsedtime: imagedetailElapsedTime.text

    // actual image
    property alias originalImage: imagedetailImage.source

    // image metadata
    property alias caption: imagedetailMetadataCaption.text
    property alias likes: imagedetailMetadataLikes.text
    property alias comments: imagedetailMetadataComments.text

    // additional data
    property string originalCaption: ""
    property string linkToInstagram: ""
    property string imageId: ""
    property string userId: ""
    property string locationId: ""
    property bool userHasLiked: false

    // interaction specific flags
    property bool interactionBlocked: false

    // define signals to make the interactions accessible
    signal detailImageDoubleClicked
    signal detailImageLongPress
    signal captionChanged( int itemheight )

    // general style definition
    color: "transparent"
    width: parent.width


    // container for the user name and data
    Rectangle {
        id: imagedetailUserprofileContainer

        anchors {
            top: parent.top;
            topMargin: 5;
            left: parent.left;
            right: parent.right;
        }

        // no background color
        color: "transparent"

        // full width, height is 60 px
        width: parent.width;
        height: 60


        // user profile picture (65x65)
        Rectangle {
            id: imagedetailUserpictureContainer

            anchors {
                top: parent.top;
                left: parent.left;
                leftMargin: 5;
            }

            // light gray color to mark loading image
            color: "gainsboro"

            width: 65
            height: 65

            // use the whole user image as tap surface
            MouseArea {
                anchors.fill: parent
                onCanceled:
                {
                    imagedetailUserpicture.opacity = 1;
                }

                onPressed:
                {
                    imagedetailUserpicture.opacity = 0.5;
                }

                onReleased:
                {
                    imagedetailUserpicture.opacity = 1;
                    pageStack.push(Qt.resolvedUrl("../pages/UserDetailPage.qml"), {userId: userId});
                }
            }

            // user profile image
            Image {
                id: imagedetailUserpicture

                anchors.fill: parent
                smooth: true
            }
        }


        // username container
        Rectangle {
            id: imagedetailUsernameContainer

            anchors {
                top: parent.top;
                left: imagedetailUserpictureContainer.right;
                leftMargin: 5;
            }

            height: 65
            width: 320

            color: "transparent"


            // username text
            Text {
                id: imagedetailUsername

                anchors.fill: parent
                anchors.leftMargin: 5;

                font.family: "Nokia Pure Text Light"
                font.pixelSize: 30
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight;

                color: Globals.instagoDefaultTextColor

                // actual user name
                text: ""
            }


            // use the whole username container as tap surface
            MouseArea {
                anchors.fill: parent
                onCanceled:
                {
                    imagedetailUsernameContainer.color = "transparent";
                }

                onPressed:
                {
                    imagedetailUsernameContainer.color = Globals.instagoHighlightedListItemColor;
                }

                onReleased:
                {
                    imagedetailUsernameContainer.color = "transparent";
                    pageStack.push(Qt.resolvedUrl("../pages/UserDetailPage.qml"), {userId: userId});
                }
            }
        }


        // elapsed timer container
        Rectangle {
            id: imagedetailElapsedTimeContainer

            anchors {
                top: parent.top;
                left: imagedetailUsernameContainer.right;
                leftMargin: 5;
                right: parent.right
                rightMargin: 5
            }

            height: 65
            color: "transparent"


            // elapsed time icon
            Image {
                id: imagedetailElapsedTimeIcon

                anchors {
                    top: parent.top;
                    topMargin: 20;
                    left: imagedetailElapsedTimeContainer.left;
                }

                width: 25
                height: 25
                z: 10

                source: "image://theme/icon-m-toolbar-clock-dimmed"
            }


            // elapsed time
            Text {
                id: imagedetailElapsedTime

                anchors {
                    top: parent.top;
                    left: imagedetailElapsedTimeIcon.right;
                    right: parent.right;
                }

                height: parent.height

                font.family: "Nokia Pure Text"
                font.pixelSize: 20
                wrapMode: Text.Wrap
                color: "gray"
                verticalAlignment: Text.AlignVCenter

                // elapsed time
                text: ""
            }
        }


        // location container
        Rectangle {
            id: imagedetailLocationContainer

            anchors {
                top: imagedetailUsernameContainer.bottom;
                topMargin: 5;
                left: imagedetailUserpictureContainer.right;
                leftMargin: 5;
            }

            height: 30
            width: 320

            color: "transparent"

            visible: false


            // location icon
            Image {
                id: imagedetailLocationIcon

                anchors {
                    top: parent.top;
                    topMargin: 2;
                    left: parent.left;
                }

                width: 25
                height: 25
                z: 10

                source: "image://theme/icon-m-toolbar-tag-dimmed"
            }


            // image location
            Text {
                id: imagedetailLocation

                anchors {
                    top: parent.top;
                    //                    topMargin: -3;
                    bottom: parent.bottom;
                    left: imagedetailLocationIcon.right;
                    right: parent.right;
                }

                font.family: "Nokia Pure Text"
                font.pixelSize: 20
                elide: Text.ElideRight;
                color: Globals.instagoDefaultTextColor

                // only show location icon if there actually is one
                onTextChanged: {
                    // change height of username container
                    imagedetailUsernameContainer.height = 32;
                    imagedetailUsername.verticalAlignment = Text.AlignTop;
                    imagedetailUsername.anchors.topMargin = -5;

                    // change height of elapsed time information
                    imagedetailElapsedTimeContainer.height = 32;
                    imagedetailElapsedTimeIcon.anchors.topMargin = 4;

                    // change width of location container
                    imagedetailLocationContainer.width = 405;

                    // show location info
                    imagedetailLocationContainer.visible = true;
                }

                // location the image was taken
                text: ""
            }


            // use the whole location container as tap surface
            MouseArea {
                anchors.fill: parent

                onCanceled:
                {
                    imagedetailLocationContainer.color = "transparent";
                }

                onPressed:
                {
                    if (Authentication.auth.isAuthenticated())
                    {
                        imagedetailLocationContainer.color = Globals.instagoHighlightedListItemColor;
                    }
                }

                onReleased:
                {
                    if (Authentication.auth.isAuthenticated())
                    {
                        imagedetailLocationContainer.color = "transparent";

                        // for some reason the N9 device does not immediately jump to a page that includes the map component.
                        // it waits a while, shows an warning message in the stdout and then jumps to the page.
                        // while waiting it allows multiple instances of the page to be created so a check is needed to call the page only once
                        if (!interactionBlocked)
                        {
                            interactionBlocked = true;
                            pageStack.push(Qt.resolvedUrl("../pages/LocationDetailPage.qml"), {locationId: locationId});
                            locationInteractionRelease.start();
                        }
                    }
                }
            }
        }
    }


    // container for the detail image and its loader
    Rectangle {
        id: imagedetailImageContainer

        anchors {
            top: imagedetailUserprofileContainer.bottom;
            topMargin: 10;
            left: parent.left;
            leftMargin: 5;
            right: parent.right;
            rightMargin: 5;
        }

        // full width, height is 470 px
        // effectively this is 470 x 470 (max width - border)
        width: parent.width;
        height: 470

        // light gray color to mark loading image
        color: "gainsboro"


        // show the loading indicator as long as the page is not ready
        BusyIndicator {
            id: imagedetailLoadingIndicator

            anchors.centerIn: parent

            platformStyle: BusyIndicatorStyle { size: "large" }
            running:  true
            visible: true
        }


        // the actual detail image
        // it's set to 470 px although the actual detail image size is 612x612
        Image {
            id: imagedetailImage

            anchors.top: imagedetailImageContainer.top
            width: parent.width
            height: parent.height
            smooth: true

            // invisible until loading is finished
            visible: false;

            // this listens to the loading progress
            // visibility properties are changed when finished
            onProgressChanged: {
                if (imagedetailImage.progress == 1.0)
                {
                    imagedetailLoadingIndicator.running = false;
                    imagedetailLoadingIndicator.visible = false;
                    imagedetailImage.visible = true;
                }
            }
        }


        // use the whole detail image as tap surface
        MouseArea {
            anchors.fill: parent

            onDoubleClicked:
            {
                detailImageDoubleClicked();
            }

            onPressAndHold:
            {
                detailImageLongPress();
            }
        }
    }


    // container for the metadata
    Rectangle {
        id: imagedetailMetadataContainer

        anchors {
            top: imagedetailImageContainer.bottom;
            topMargin: 5;
            left: parent.left;
            right: parent.right;
        }

        // full width, height is dynamic
        width: parent.width;

        // no background color
        color: "transparent"


        // caption icon
        Image {
            id: imagedetailMetadataCaptionIcon

            anchors {
                top: parent.top;
                topMargin: 2;
                left: parent.left;
            }

            width: 25
            height: 25
            z: 10

            visible: false

            source: "image://theme/icon-m-toolbar-new-message-dimmed"
        }


        // add wazzapp font
        // the font contains some glyphs for emojis, so instead of the squares
        // either alternative icons will be shown or the emoji itself
        FontLoader {
            id: wazzappPureRegular;
            source: "../fonts/WazappPureRegular.ttf"
        }


        // image caption
        Text {
            id: imagedetailMetadataCaption

            anchors {
                top: parent.top;
                left: imagedetailMetadataCaptionIcon.right;
                leftMargin: 5;
                right: parent.right;
                rightMargin: 5
            }

            textFormat: Text.RichText
            font.family: wazzappPureRegular.name
            font.pixelSize: 20
            wrapMode: Text.WordWrap
            color: Globals.instagoLightTextColor

            visible: false

            // image description
            // text will be given by the js function
            // beware that the length is not limited by Instagram
            // this might be LONG!
            text: ""

            onTextChanged: {
                // make caption icons and text visible
                imagedetailMetadataCaption.visible = true;
                imagedetailMetadataCaptionIcon.visible = true;
                imagedetailMetadataLikeContainer.anchors.top = imagedetailMetadataCaption.bottom;
                imagedetailMetadataLikeContainer.anchors.topMargin = 5;

                // calculate item height and hand it over to the signal
                var itemheight = 40;
                itemheight += imagedetailUserprofileContainer.height + imagedetailImageContainer.height;
                itemheight += imagedetailMetadataCaption.height + imagedetailMetadataComments.height + imagedetailMetadataLikes.height;
                captionChanged( itemheight );
            }

            onLinkActivated: Helpermethods.analyzeLink(link);
        }


        // likes container
        Rectangle {
            id: imagedetailMetadataLikeContainer

            anchors {
                top: parent.top;
                left: parent.left;
                right: parent.right;
            }

            height: 30
            color: "transparent"


            // likes icon
            Image {
                id: imagedetailMetadataLikeIcon

                anchors {
                    top: parent.top;
                    topMargin: 2;
                    left: parent.left;
                }

                width: 25
                height: 25
                z: 10

                source: "image://theme/icon-m-toolbar-frequent-used-dimmed"
            }


            // number of likes
            Text {
                id: imagedetailMetadataLikes

                anchors {
                    top: parent.top;
                    left: imagedetailMetadataLikeIcon.right;
                    leftMargin: 5;
                    right: parent.right;
                }

                font.family: "Nokia Pure Text"
                font.pixelSize: 20
                clip: true
                color: Globals.instagoDefaultTextColor

                // number of likes
                // text will be given by the js function
                text: ""
            }


            // use the whole likes container as tap surface
            MouseArea {
                anchors.fill: parent

                onCanceled:
                {
                    imagedetailMetadataLikeContainer.color = "transparent";
                }

                onPressed:
                {
                    if (Authentication.auth.isAuthenticated())
                    {
                        imagedetailMetadataLikeContainer.color = Globals.instagoHighlightedListItemColor;
                    }
                }

                onReleased:
                {
                    if (Authentication.auth.isAuthenticated())
                    {
                        imagedetailMetadataLikeContainer.color = "transparent";
                        pageStack.push(Qt.resolvedUrl("../pages/ImageLikesPage.qml"), {imageId: imageId});
                    }
                }
            }
        }


        // comments container
        Rectangle {
            id: imagedetailMetadataCommentContainer

            anchors {
                top: imagedetailMetadataLikeContainer.bottom;
                left: parent.left;
                right: parent.right;
            }

            height: 30
            color: "transparent"


            // comments icon
            Image {
                id: imagedetailMetadataCommentIcon

                anchors {
                    top: parent.top
                    topMargin: 2;
                    left: parent.left;
                }

                width: 25
                height: 25
                z: 10

                source: "image://theme/icon-m-toolbar-new-chat-dimmed"
            }


            // number of comments
            Text {
                id: imagedetailMetadataComments

                anchors {
                    top: parent.top;
                    left: imagedetailMetadataCommentIcon.right;
                    leftMargin: 5;
                    right: parent.right;
                }

                font.family: "Nokia Pure Text"
                font.pixelSize: 20
                wrapMode: Text.Wrap
                color: Globals.instagoDefaultTextColor

                // number of comments
                // text will be given by the js function
                text: ""
            }


            // use the whole comment container as tap surface
            MouseArea {
                anchors.fill: parent
                onCanceled:
                {
                    imagedetailMetadataCommentContainer.color = "transparent";
                }

                onPressed:
                {
                    if (Authentication.auth.isAuthenticated())
                    {
                        imagedetailMetadataCommentContainer.color = Globals.instagoHighlightedListItemColor;
                    }
                }

                onReleased:
                {
                    if (Authentication.auth.isAuthenticated())
                    {
                        imagedetailMetadataCommentContainer.color = "transparent";
                        pageStack.push(Qt.resolvedUrl("../pages/ImageCommentsPage.qml"), {imageId: imageId});
                    }
                }
            }
        }
    }


    // timer to release interaction blocker
    Timer {
        id: locationInteractionRelease
        interval: 3000
        running: false
        repeat:  false

        onTriggered: {
            interactionBlocked = false;
        }
    }
}
