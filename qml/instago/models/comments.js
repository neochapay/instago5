// *************************************************** //
// Comments Script
//
// This script handles the adding / removal of comments
// for a given image.
// Note that only authenticated users can comment images.
// It's used by the ImageDetailPage, UserFeedPage
// and ImageCommentPage.
// *************************************************** //


// include other scripts used here
Qt.include("../global/globals.js")
Qt.include("../classes/helpermethods.js");
Qt.include("../classes/authenticationhandler.js");
Qt.include("../classes/networkhandler.js");


// add a comment to a given image
function addComment(imageId, commentText)
{
    // console.log("Adding comment for " + imageId);

    imageComments.visible = false;
    errorMessage.visible = false;
    loadingIndicator.running = true;
    loadingIndicator.visible = true;
    imageCommentEmptyList.visible = false;

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                // this handles the result for each ready state
                var jsonObject = network.handleHttpResult(req);

                // jsonObject contains either false or the http result as object
                if (jsonObject)
                {
                    // console.log("Done adding comment");

                    notification.text = "Added comment for this image";
                    notification.show();

                    // done, reload comment list now
                    imageCommentReloadTimer.start();
                    // getComments(imageId);
                }
                else
                {
                    // either the request is not done yet or an error occured
                    // check for both and act accordingly
                    if ( (network.requestIsFinished) && (network.errorData['code'] != null) )
                    {
                        // console.log("error found: " + network.errorData['error_message']);

                        // hide messages and notifications
                        loadingIndicator.running = false;
                        loadingIndicator.visible = false;

                        // show the stored error
                        errorMessage.showErrorMessage({
                                                          "d_code":network.errorData['code'],
                                                          "d_error_type":network.errorData['error_type'],
                                                          "d_error_message":network.errorData['error_message']
                                                      });

                        // clear error message objects again
                        network.clearErrors();
                    }
                }
            }

    var instagramUserdata = auth.getStoredInstagramData();
    var params = "access_token=" + instagramUserdata["access_token"] + "&text=" + commentText;

    var url = instagramkeys.instagramAPIUrl + "/v1/media/" + imageId + "/comments/";

    req.open("POST", url, true);
    req.send(params);
}


// get all comments for a given image
// comments will be used to fill a UserList component
function getComments(imageId)
{
    // console.log("Getting comments for image " + imageId);

    errorMessage.visible = false;
    loadingIndicator.running = true;
    loadingIndicator.visible = true;

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                // this handles the result for each ready state
                var jsonObject = network.handleHttpResult(req);

                // jsonObject contains either false or the http result as object
                if (jsonObject)
                {
                    imageComments.clearList();

                    var commentCache = new Array();
                    for ( var index in jsonObject.data )
                    {
                        commentCache = [];

                        commentCache["username"] = jsonObject.data[index].from["username"];
                        commentCache["fullname"] = jsonObject.data[index].from["full_name"];
                        if (commentCache["fullname"] === "") commentCache["fullname"] = commentCache["username"];
                        commentCache["profilepicture"] = jsonObject.data[index].from["profile_picture"];
                        commentCache["userid"] = jsonObject.data[index].from["id"];

                        // set style definitions
                        var commentText = instagoDefaultRichTextStyle;

                        // add actual text content
                        commentText = jsonObject.data[index].text;

                        // convert user names and hashtags to links
                        commentText = addHashtagLinksToText(commentText);
                        commentText = addUserLinksToText(commentText);

                        // replace \n breaks with html breaks and close html
                        commentText = replaceLineBreaks(commentText);
                        commentText += instagoRichTextClosure;

                        commentCache["comment"] = commentText;

                        imageComments.addToList({
                                                    "d_username": commentCache["username"],
                                                    "d_fullname": commentCache["fullname"],
                                                    "d_profilepicture": commentCache["profilepicture"],
                                                    "d_userid": commentCache["userid"],
                                                    "d_comment": commentCache["comment"],
                                                    "d_index": index
                                                });
                    }

                    // check if list is empty and show message
                    if (imageComments.numberOfItems < 1)
                    {
                        imageCommentEmptyList.visible = true;
                    }

                    loadingIndicator.running = false;
                    loadingIndicator.visible = false;

                    imageComments.visible = true;
                    imageComments.jumpToBottom();
                    imageComments.focus = true;

                    // console.log("Done loading comment list");
                }
                else
                {
                    // either the request is not done yet or an error occured
                    // check for both and act accordingly
                    if ( (network.requestIsFinished) && (network.errorData['code'] != null) )
                    {
                        // console.log("error found: " + network.errorData['error_message']);

                        // hide messages and notifications
                        loadingIndicator.running = false;
                        loadingIndicator.visible = false;

                        // show the stored error
                        errorMessage.showErrorMessage({
                                                          "d_code":network.errorData['code'],
                                                          "d_error_type":network.errorData['error_type'],
                                                          "d_error_message":network.errorData['error_message']
                                                      });

                        // clear error message objects again
                        network.clearErrors();
                    }
                }
            }

    var instagramUserdata = auth.getStoredInstagramData();
    var url = instagramkeys.instagramAPIUrl + "/v1/media/" + imageId + "/comments/?access_token=" + instagramUserdata["access_token"];

    req.open("GET", url, true);
    req.send();
}
