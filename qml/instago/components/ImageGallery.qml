// *************************************************** //
// Image Gallery Component
//
// The image gallery component is used by the application
// pages. It displays a number of given images in a
// gallery grid.
// The grid is flickable and clips.
// *************************************************** //

import QtQuick 2.0

import "../pages"

Rectangle {
    id: imageGallery

    // signal to clear the gallery contents
    signal clearGallery()
    onClearGallery: {
        galleryListModel.clear();
    }

    // signal to add a new item
    // item is given as array:
    // "url":IMAGE_URL;
    // "index":IMAGE_ID
    signal addToGallery( variant items )
    onAddToGallery: {
        galleryListModel.append(items);
    }

    // jump to the top of the gallery
    signal jumpToTop()
    onJumpToTop: {
        galleryGrid.positionViewAtBeginning();
    }

    // general list properties
    property alias numberOfItems: galleryListModel.count;

    // signal if item was clicked
    signal itemClicked( string imageId );

    // signal if gallery is scrolled to the end
    signal listBottomReached();

    // property that holds the id of the next image
    // this is given by Instagram for easy pagination
    property string paginationNextMaxId: "";

    // general style definition
    color: "transparent"


    // this is the main container component
    // it contains the actual gallery items
    Component {
        id: galleryDelegate

        // this is an individual gallery item
        Item {
            id: galleryItem
            width: galleryGrid.cellWidth
            height: galleryGrid.cellHeight

            // use the whole item as tap surface
            // all taps on the item will be handled by the itemClicked event
            MouseArea {
                anchors.fill: parent
                onCanceled:
                {
                    galleryThumbnail.opacity = 1;
                }

                onPressed:
                {
                    galleryThumbnail.opacity = 0.5;
                }

                onReleased:
                {
                    galleryThumbnail.opacity = 1;
                    itemClicked(index);
                }
            }


            // this is the rectangle that holds the actual gallery image
            // its used as an empty default rect that is filled if the image could be loaded
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                width: 154
                height: 154

                // light gray color to mark loading image
                color: "gainsboro"

                // the actual gallery image
                Image {
                    id: galleryThumbnail

                    anchors
                    {
                        horizontalCenter: parent.horizontalCenter;
                        verticalCenter: parent.verticalCenter;
                    }

                    opacity: 1

                    source: url
                }
            }
        }
    }


    // this is just an id
    // the model is defined in the array
    ListModel {
        id: galleryListModel
    }


    // the actual grid view
    // this contains the individual items and shows them as a list
    GridView {
        id: galleryGrid

        anchors {
            top: parent.top;
            left: parent.left;
            right: parent.right;
            bottom: parent.bottom;
        }

        cellWidth: 160; cellHeight: 160
        focus: true

        // clipping needs to be true so that the size is limited to the container
        clip: true

        // define model and delegate
        model: galleryListModel
        delegate: galleryDelegate

        // check if list is at the bottom end
        onMovementEnded: {
            if(atYEnd) {
                listBottomReached();
            }
        }
    }
}
