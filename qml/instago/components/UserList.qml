// *************************************************** //
// User List Component
//
// The user list component is used by the application
// pages. It displays a number of given user names with
// their metadata in a list.
// The list is flickable and clips.
// *************************************************** //

import QtQuick 2.0

import "../pages"
import "../global/globals.js" as Globals

Rectangle {
    id: userList

    // signal to clear the list contents
    signal clearList()
    onClearList: {
        userListModel.clear();
    }

    // signal to add a new item
    // item is given as array:
    // "username":USER_USERNAME
    // "fullname":USER_FULLNAME
    // "profilepicture":USER_PROFILEPICTURE
    // "userid":USER_USERID
    // "index":ITEM_INDEX
    signal addToList( variant items )
    onAddToList: {
        userListModel.append(items);
    }

    // jump to the top of the gallery
    signal jumpToTop()
    onJumpToTop: {
        userListView.positionViewAtBeginning();
    }

    // general list properties
    property alias numberOfItems: userListModel.count;

    // general style definition
    color: "transparent"


    // this is the main container component
    // it contains the actual user items
    Component {
        id: userListDelegate

        // this is an individual list item
        Item {
            id: userItem
            width: userList.width
            height: 110

            Rectangle {
                id: userItemContainer
                anchors.fill: parent
                color: "transparent"


                // use the whole item as tap surface
                // all taps on the item will be handled by the itemClicked event
                MouseArea {
                    anchors.fill: parent
                    onCanceled:
                    {
                        userItemContainer.color = Globals.instagoDefaultListItemColor;
                    }

                    onPressed:
                    {
                        userItemContainer.color = Globals.instagoHighlightedListItemColor;
                    }

                    onReleased:
                    {
                        // console.log("Profile tapped. Id was: " + d_userid);
                        userItemContainer.color = Globals.instagoDefaultListItemColor;
                        pageStack.push(Qt.resolvedUrl("../pages/UserDetailPage.qml"), {userId: d_userid});
                    }
                }


                // this is the rectangle that holds the profile picture image
                // its used as an empty default rect that is filled if the image could be loaded
                Rectangle {
                    id: userListProfilepicture

                    anchors {
                        top: parent.top
                        topMargin: 15
                        left: parent.left
                        leftMargin: 10
                    }

                    width: 80
                    height: 80

                    // light gray color to mark loading image
                    color: "gainsboro"

                    // the actual profile image
                    Image {
                        anchors.fill: parent
                        source: d_profilepicture
                    }
                }


                // progress button
                Image {
                    id: userListLinkbutton

                    anchors {
                        top: parent.top
                        topMargin: 40
                        right: parent.right
                        rightMargin: 10
                    }

                    width: 30
                    height: 30
                    z: 10

                    source: "image://theme/icon-m-toolbar-next-dimmed"
                }


                // the Instagram username of the user
                Text {
                    id: userListUsername

                    anchors {
                        top: parent.top;
                        topMargin: 15;
                        left: userListProfilepicture.right;
                        leftMargin: 10;
                        right: userListLinkbutton.left;
                        rightMargin: 5;
                    }

                    height: 35

                    font.family: "Nokia Pure Text Light"
                    font.pixelSize: 30
                    wrapMode: Text.Wrap
                    color: Globals.instagoDefaultTextColor

                    text: d_username
                }


                // the full name of the Instagram user
                Text {
                    id: userListFullname

                    anchors {
                        top: userListUsername.bottom
                        topMargin: 5;
                        left: userListProfilepicture.right;
                        leftMargin: 10;
                        right: userListLinkbutton.left;
                        rightMargin: 5;
                    }

                    height: 20

                    font.family: "Nokia Pure Text"
                    font.pixelSize: 20
                    wrapMode: Text.Wrap
                    color: Globals.instagoDefaultTextColor

                    text: d_fullname
                }

                // separator
                Rectangle {
                    id: imagedetailSeparator

                    anchors {
                        top: userListProfilepicture.bottom
                        topMargin: 15
                        left: parent.left;
                        leftMargin: 5;
                        right: parent.right;
                        rightMargin: 5;
                    }

                    height: 1
                    color: Globals.instagoSeparatorColor
                }
            }
        }
    }


    // this is just an id
    // the model is defined in the array
    ListModel {
        id: userListModel
    }


    // the actual list view component
    // this will be the main component and contain all the items
    ListView {
        id: userListView

        anchors.fill: parent;
        // anchors.margins: 5

        focus: true

        // clipping needs to be true so that the size is limited to the container
        clip: true

        // define model and delegate
        model: userListModel
        delegate: userListDelegate
    }
}
