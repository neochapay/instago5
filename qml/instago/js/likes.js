// *************************************************** //
// Likes Script
//
// This script handles the adding / removal of likes
// for a given image.
// Note that only authenticated users can like images.
// It's used by the ImageDetailPage, UserFeedPage
// and ImageLikesPage.
// *************************************************** //


// include other scripts used here
Qt.include("authenticationhandler.js");
Qt.include("helpermethods.js");
Qt.include("networkhandler.js");


// like a given image
// second parameter is true if the associated components should be updated
function likeImage(imageId, updateComponents)
{
    // console.log("Liking image " + imageId);

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                // this handles the result for each ready state
                var jsonObject = network.handleHttpResult(req);

                // jsonObject contains either false or the http result as object
                if (jsonObject)
                {
                    if (updateComponents)
                    {
                        // console.log("Updating components");

                        var numberOfLikes = parseInt(imageData.likes);
                        numberOfLikes += 1;
                        imageData.likes = numberOfLikes + " people liked this";

                        iconUnliked.visible = false;
                        iconLiked.visible = true;
                    }

                    // console.log("Done liking image");
                }
            }

    var instagramUserdata = auth.getStoredInstagramData();
    var params = "access_token=" + instagramUserdata["access_token"];

    var url = instagramkeys.instagramAPIUrl + "/v1/media/" + imageId + "/likes";
    req.open("POST", url, true);
    req.send(params);
}


// unlike a given image
// second parameter is true if the associated components should be updated
function unlikeImage(imageId, updateComponents)
{
    // console.log("Unliking image " + imageId);

    var instagramUserdata = auth.getStoredInstagramData();
    networkHelper.sendDeleteRequest(instagramkeys.instagramAPIUrl + "/v1/media/" + imageId + "/likes?access_token=" + instagramUserdata["access_token"]);

    if (updateComponents)
    {
        var numberOfLikes = parseInt(imageData.likes);
        numberOfLikes -= 1;
        imageData.likes = numberOfLikes + " people liked this";

        iconLiked.visible = false;
        iconUnliked.visible = true;
    }
    // console.log("Done unliking image");
}


// get all likes for a given image
// likes will be used to fill a UserList component
function getLikes(imageId)
{
    // console.log("Getting likes for image " + imageId);

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
                    imageLikesUserlist.clearList();

                    var userCache = new Array();
                    for ( var index in jsonObject.data )
                    {
                        userCache = [];

                        userCache["username"] = jsonObject.data[index].username;
                        userCache["fullname"] = jsonObject.data[index].full_name;
                        if (userCache["fullname"] === "") userCache["fullname"] = userCache["username"];
                        userCache["profilepicture"] = jsonObject.data[index].profile_picture;
                        userCache["userid"] = jsonObject.data[index].id;
                        userCache["bio"] = jsonObject.data[index].bio;

                        imageLikesUserlist.addToList({
                                                         "d_username": userCache["username"],
                                                         "d_fullname": userCache["fullname"],
                                                         "d_profilepicture": userCache["profilepicture"],
                                                         "d_userid": userCache["userid"],
                                                         "d_index": index
                                                     });
                    }

                    // check if list is empty and show message
                    if (imageLikesUserlist.numberOfItems < 1)
                    {
                        imageLikesEmptyList.visible = true;
                    }

                    loadingIndicator.running = false;
                    loadingIndicator.visible = false;

                    // console.log("Done loading like list");
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
    var url = instagramkeys.instagramAPIUrl + "/v1/media/" + imageId + "/likes/?access_token=" + instagramUserdata["access_token"];

    req.open("GET", url, true);
    req.send();
}


// get all likes for the currently authenticated user
// likes will be used to fill a gallery component
function getCurrentUserLikes()
{
    // console.log("Getting likes for current user");

    // clear likes list
    likesGallery.clearGallery();

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
                    var imageCache = new Array();
                    for ( var index in jsonObject.data )
                    {
                        // get image object
                        imageCache = getImageDataFromObject(jsonObject.data[index]);
                        // cacheImage(imageCache);

                        // add image object to gallery list
                        likesGallery.addToGallery({
                                                      "url":imageCache["thumbnail"],
                                                      "index":imageCache["imageid"]
                                                  });

                        // console.log("Appended list with URL: " + imageCache["thumbnail"] + " and ID: " + imageCache["imageid"]);
                    }

                    loadingIndicator.running = false;
                    loadingIndicator.visible = false;
                    likesGallery.visible = true;

                    // console.log("Done loading likes for user");
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
    var url = instagramkeys.instagramAPIUrl + "/v1/users/self/media/liked?access_token=" + instagramUserdata["access_token"];

    req.open("GET", url, true);
    req.send();
}
