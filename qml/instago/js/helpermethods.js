// *************************************************** //
// Helpermethod Script
//
// This script contains methods that are generally
// useful and are used throughout the application.
// *************************************************** //

// include other scripts used here
Qt.include("globals.js");
Qt.include("authenticationhandler.js");


// format an Instagram time stamp into readable format
// return format will be mm/dd/yy, HH:MM
function formatInstagramTime(instagramTime)
{
    var time = new Date(instagramTime * 1000);
    var timeStr = (time.getMonth()+1) +
            "/" + time.getDate() +
            "/" + time.getFullYear() + ", ";

    // make sure hours have 2 digits
    if (time.getHours() < 10) { timeStr += "0" + time.getHours() }
    else { timeStr += time.getHours() }

    timeStr += ":";

    // make sure minutes have 2 digits
    if (time.getMinutes() < 10) { timeStr += "0" + time.getMinutes() }
    else { timeStr += time.getMinutes() }

    return timeStr;
}


// calculate the elapsed time for a timestamp until now
// return format will be XX seconds / minutes / days / months / years ago
function calculateElapsedTime(instagramTime)
{
    var msPerMinute = 60 * 1000;
    var msPerHour = msPerMinute * 60;
    var msPerDay = msPerHour * 24;
    var msPerMonth = msPerDay * 30;
    var msPerYear = msPerDay * 365;

    var currentTime = new Date().getTime();
    var time = new Date(instagramTime * 1000);
    var elapsed = currentTime - time;

    if (elapsed < msPerMinute) {
        return Math.round(elapsed/1000) + 's';
    }

    else if (elapsed < msPerHour) {
        return Math.round(elapsed/msPerMinute) + 'm';
    }

    else if (elapsed < msPerDay ) {
        return Math.round(elapsed/msPerHour ) + 'h';
    }

    else if (elapsed < msPerMonth) {
        return Math.round(elapsed/msPerDay) + 'd';
    }

    else if (elapsed < msPerYear) {
        return (Math.round(elapsed/msPerMonth)*4) + 'w';
    }

    else {
        return Math.round(elapsed/msPerYear ) + 'y';
    }
}


function analyzeLink(linkString)
{
    var linkData = linkString.split(":");

    if (linkData[0] === "hashtag")
    {
        //        console.log("hashtag found: " + linkData[1]);
        pageStack.push(Qt.resolvedUrl("../pages/HashtagPage.qml"), {hashtagName: linkData[1]});
    }

    if (linkData[0] === "user")
    {
        //        console.log("user found: " + linkData[1]);
        pageStack.push(Qt.resolvedUrl("../pages/UserDetailPage.qml"), {userName: linkData[1]});
    }
}


// analyze text and add links to hashtags
// hashtags start with # followed by the actual tag
function addHashtagLinksToText(originalText)
{
    var parsedText = "";

    var regexp = new RegExp('#([^\\s]*)','g');
    parsedText = originalText.replace(regexp, function(u) {
                                          var hashtag = u.replace("#","");
                                          var hashtaglink = "<a href=\"hashtag:" + hashtag + "\">" + u + "</a>";
                                          return hashtaglink;
                                      });

    return parsedText;
}


// analyze text and add links to user names
// user names start with @ followed by the actual name
function addUserLinksToText(originalText)
{
    var parsedText = "";

    var regexp = new RegExp('[@]+[A-Za-z0-9-_]+','g');
    parsedText = originalText.replace(regexp, function(u) {
                                          var username = u.replace("@","");
                                          var userlink = "<a href=\"user:" + username + "\">" + u + "</a>";
                                          return userlink;
                                      });

    return parsedText;
}


// replace line breaks with <br /> for use with rich text fields
function replaceLineBreaks(originalText)
{
    var parsedText = "";

    parsedText = originalText.replace("\n", "<br />");

    return parsedText;
}


// extract all image data from an image object
// return unified image array
function getImageDataFromObject(imageObject)
{
    var imageReturnArray = new Array();

    // extract the standard data
    imageReturnArray["username"] = imageObject.user["username"];
    imageReturnArray["userid"] = imageObject.user["id"];
    imageReturnArray["profilepicture"] = imageObject.user["profile_picture"];
    imageReturnArray["thumbnail"] = imageObject.images["thumbnail"]["url"];
    imageReturnArray["originalimage"] = imageObject.images["standard_resolution"]["url"];
    imageReturnArray["imageid"] = imageObject.id;
    imageReturnArray["likes"] = imageObject.likes["count"];

    // don't trust imageObject.comments["count"] as it will be wrong for some users
    // however this call just returns a maximum of 8 comments so we can only fact up to 8
    imageReturnArray["comments"] = imageObject.comments["count"];
    if (imageReturnArray["comments"] <= 8)
    {
        imageReturnArray["comments"] = imageObject.comments["data"];
        imageReturnArray["comments"] = imageReturnArray["comments"].length;
    }

    // get and format date
    imageReturnArray["createdtime"] = formatInstagramTime(imageObject.created_time);
    imageReturnArray["elapsedtime"] = calculateElapsedTime(imageObject.created_time);
    imageReturnArray["timeandlocation"] = imageReturnArray["createdtime"];

    // image may have no location
    // note that if this is the case the whole location node is missing
    // however if the location has no name the node is there but not the name node inside it
    if ( (imageObject.location !== null) && (imageObject.location["name"] !== undefined) )
    {
        imageReturnArray["location"] = imageObject.location["name"];
        imageReturnArray["locationId"] = imageObject.location["id"];
        imageReturnArray["locationLatitude"] = imageObject.location["latitude"];
        imageReturnArray["locationLongitude"] = imageObject.location["longitude"];
        imageReturnArray["timeandlocation"] += ", " + imageReturnArray["location"];
    }
    else
    {
        imageReturnArray["location"] = "";
        imageReturnArray["locationId"] = "";
    }

    // image may be liked by user
    // this node is only in the result set if the user is logged in
    if (imageObject.user_has_liked !== null)
    {
        imageReturnArray["userhasliked"] = imageObject.user_has_liked;
    }
    else
    {
        imageReturnArray["userhasliked"] = "false";
    }

    // images that are new and just updated may not have an Instagram page yet
    // their link will thus be null
    if (imageObject.link !== null)
    {
        imageReturnArray["linktoinstagram"] = imageObject.link;
    }
    else
    {
        imageReturnArray["linktoinstagram"] = "";
    }

    // caption node may not exist if empty
    if (imageObject.caption !== null)
    {
        // set style definitions
        var imageCaption = instagoDefaultRichTextStyle;

        // add actual text content
        imageCaption += imageObject.caption["text"];

        if (auth.isAuthenticated())
        {
            // convert user names and hashtags to links
            imageCaption = addHashtagLinksToText(imageCaption);
            imageCaption = addUserLinksToText(imageCaption);
        }

        // replace \n breaks with html breaks and close html
        imageCaption = replaceLineBreaks(imageCaption);
        imageCaption += instagoRichTextClosure;

        imageReturnArray["caption"] = imageCaption;
    }
    else
    {
        imageReturnArray["caption"] = "";
    }

    return imageReturnArray;
}
