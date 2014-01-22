// *************************************************** //
// Relationships Script
//
// This script handles the relationship processes
// between users.
// Note that only authenticated users can change
// relationship processes.
// It's used by the UserDetailPage.
// *************************************************** //


// include other scripts used here
Qt.include("../classes/authenticationhandler.js");
Qt.include("../classes/networkhandler.js");


// set the relationship with a given user
function setRelationship(userId, relationship)
{
    // console.log("Setting relationship fot user " + userId + " to " + relationship);

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                // this handles the result for each ready state
                var jsonObject = network.handleHttpResult(req);

                // jsonObject contains either false or the http result as object
                if (jsonObject)
                {
                    // console.log("Done changing relationship");
                }
                else
                {
                    // either the request is not done yet or an error occured
                    // check for both and act accordingly
                    if ( (network.requestIsFinished) && (network.errorData['code'] != null) )
                    {
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
    var params = "access_token=" + instagramUserdata["access_token"] + "&action=" + relationship;

    var url = instagramkeys.instagramAPIUrl + "/v1/users/" + userId + "/relationship";
    req.open("POST", url, true);
    req.send(params);
}


// get the relationship status of a given user
function getRelationship(userId)
{
    // console.log("Getting relationship for user " + userId);

    // check if the given user id is the currently logged in user
    var instagramUserdata = auth.getStoredInstagramData();
    if ( (auth.isAuthenticated()) && (instagramUserdata["id"] == userId) )
    {
        console.log("This is the current user")
        return;
    }

    var req = new XMLHttpRequest();
    req.onreadystatechange = function()
            {
                // this handles the result for each ready state
                var jsonObject = network.handleHttpResult(req);

                // jsonObject contains either false or the http result as object
                if (jsonObject)
                {
                    // check if user is already followed
                    if (jsonObject.data.outgoing_status === "follows")
                    {
                        userprofileBio.unfollowButtonVisible = true;
                    }

                    // check if user is not followed and not private
                    if ( (jsonObject.data.outgoing_status === "none") && (jsonObject.data.target_user_is_private === false) )
                    {
                        // console.log("User is not followed and not private")
                        userprofileBio.followButtonVisible = true;
                    }

                    // check if user is not followed and private
                    if ( (jsonObject.data.outgoing_status === "none") && (jsonObject.data.target_user_is_private === true) )
                    {
                        // console.log("User is not followed and private")
                        pageHeader.text = "User is private";
                        userprofileBio.userIsPrivateMessageVisible = true;
                        userprofileBio.requestButtonVisible = true;
                    }

                    // check if user is not followed but follow requested
                    if ( (jsonObject.data.outgoing_status === "requested") && (jsonObject.data.target_user_is_private === true) )
                    {
                        // console.log("User is not followed but follow requested")
                        pageHeader.text = "User is private";
                        userprofileBio.userIsPrivateMessageVisible = true;
                        userprofileBio.unrequestButtonVisible = true;
                    }

                    // hide loading indicator
                    loadingIndicator.running = false;
                    loadingIndicator.visible = false;

                    userprofileBio.visible = true;

                    // console.log("Done getting relationship");
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

    var url = instagramkeys.instagramAPIUrl + "/v1/users/" + userId + "/relationship?access_token=" + instagramUserdata["access_token"];

    req.open("GET", url, true);
    req.send();
}
