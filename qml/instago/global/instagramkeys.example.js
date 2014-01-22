// *************************************************** //
// Instagramkeys
//
// These are the keys for the Instagram client
// You can get your own here:
// http://instagram.com/developer/clients/manage/
// (you need to be logged into Instagram to create apps)
// *************************************************** //


// singleton instance of class
var instagramkeys = new InstagramKeys();

// class function that gets the prototype methods
function InstagramKeys()
{
    // Instagram client id
    this.instagramClientId = "";

    // Instagram client secret
    this.instagramClientSecret = "";

    // Instagram API URL
    this.instagramAPIUrl = "https://api.instagram.com";
    // this.instagramAPIUrl = "http://localhost";

    // Instagram URL the user authenticates against
    this.instagramAuthorizeUrl = this.instagramAPIUrl + "/oauth/authorize";

    // Instagram URL to request a permanent token
    this.instagramTokenRequestUrl = this.instagramAPIUrl + "/oauth/access_token";

    // Instagram redirect URL
    this.instagramRedirectUrl = "http://www.instago.mobi";
}
