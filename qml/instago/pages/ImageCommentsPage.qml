// *************************************************** //
// Image Comments Page
//
// This page shows the list of comments for a given
// image.
// *************************************************** //

import QtQuick 2.0
import com.nokia.meego 1.1
import com.nokia.extras 1.1

import "../components"
import "../global/globals.js" as Globals
import "../models/comments.js" as Comments

Page {
    // use the detail view toolbar
    tools: profileToolbar

    // lock orientation to portrait mode
    orientationLock: PageOrientation.LockPortrait

    // the image id that the likes are pulled for
    // the property will be filled by the calling page
    property string imageId: "";

    Component.onCompleted: {
        Comments.getComments(imageId);
    }

    // standard header for the current page
    Header {
        id: pageHeader
        text: "Comments"

        onHeaderBarClicked: {
            // console.log("Jump to top clicked");
            imageComments.jumpToTop();
        }
    }

    // standard notification area
    NotificationArea {
        id: notification

        visibilitytime: 1500

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
    }


    // list of the followers
    // container is only visible if user is authenticated
    CommentList {
        id: imageComments;

        anchors {
            top: pageHeader.bottom
            topMargin: 10;
            left: parent.left;
            right: parent.right;
            bottom: imageCommentInput.top;
            bottomMargin: 5;
        }

        visible: false;
    }


    // comment entry field
    TextField {
        id: imageCommentInput

        anchors {
            left: parent.left;
            leftMargin: 10;
            bottom: parent.bottom;
            bottomMargin: 15;
        }

        width: 405

        onAccepted: {
            // console.log("Input received: " + imageCommentInput.text);
            Comments.addComment(imageId, imageCommentInput.text);

            imageCommentInput.text = "";
            imageCommentInput.platformCloseSoftwareInputPanel();
        }

        placeholderText: "Add Comment"
        text: ""
    }


    // user search button
    Button {
        id: commentButton

        anchors {
            left: imageCommentInput.right;
            leftMargin: 5;
            bottom: parent.bottom;
            bottomMargin: 15;
        }

        width: 50
        height: 50

        iconSource: "image://theme/icon-m-toolbar-new-message-dimmed"

        onClicked: {
            // console.log("Input received: " + imageCommentInput.text);
            if (imageCommentInput.text.length > 0)
            {
                Comments.addComment(imageId, imageCommentInput.text);

                imageCommentInput.text = "";
                imageCommentInput.platformCloseSoftwareInputPanel();
            }
        }

    }


    // text shown if no comment entered yet
    Text {
        id: imageCommentEmptyList

        anchors.centerIn: parent

        font.family: "Nokia Pure Text Light"
        font.pixelSize: 45
        wrapMode: Text.Wrap
        color: "darkgray"
        horizontalAlignment: Text.AlignHCenter

        visible: false;

        text: "No comments yet"
    }


    // reload the comments after 1 second
    // this is triggerd by the comments.js after adding a comment
    Timer {
        id: imageCommentReloadTimer
        interval: 1000
        running: false
        repeat:  false

        // when triggered, reload the comment data
        onTriggered: {
            Comments.getComments(imageId);
        }
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
            top: pageHeader.bottom;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        visible: false

        onErrorMessageClicked: {
            // console.log("Refresh clicked")
            errorMessage.visible = false;
            Comments.getComments(imageId);
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
