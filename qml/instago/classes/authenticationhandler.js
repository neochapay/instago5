// *************************************************** //
// Authenticationhandler Script
//
// This script handles the current Instragram user that
// is authenticated for the application.
// This includes the actual authentication process as
// well as general checks if the user is already
// authenticated or not.
// The general userdata will be stored in the local
// app database (table: userdata).
// Note that it's a class that needs to be defined first:
// auth = new AuthenticationHandler();
// *************************************************** //

// mark javascript file as library
.pragma library

// include other scripts used here
Qt.include("../global/instagramkeys.js");

// singleton instance of class
var auth = new AuthenticationHandler();

// class function that gets the prototype methods
function AuthenticationHandler() { }


// this checks a given URL for oauth data
// this can either be a token if the authentication was successful
// or it can contain an error with respective message
AuthenticationHandler.prototype.checkInstagramAuthenticationUrl = function(url)
        {
            // console.log("Checking Instagram URL for authentication information: " + url.toString());

            var currentURL = url.toString();
            var returnStatus = new Array();

            // set default status
            returnStatus["status"] = "NOT_RELEVANT";

            // authentication was successful: the URL contains the redirect address as well the token code
            if ( (currentURL.indexOf(instagramkeys.instagramRedirectUrl) === 0) && (currentURL.indexOf("code=") > 0) )
            {
                // cut URL from string and extract the instagram token
                var instagramTokenCode = "";
                var tokenStartPosition = currentURL.indexOf("code=");
                instagramTokenCode = currentURL.substr((tokenStartPosition+5));

                // if there is an Instagram token, store it and set the return status
                if (instagramTokenCode.length > 0)
                {
                    // console.log("Found Instagram token code: " + instagramTokenCode);
                    this.requestPermanentToken(instagramTokenCode);
                    returnStatus["status"] = "AUTH_SUCCESS";
                }
            }

            // an error occured: the URL contains the error parameters
            if ( (currentURL.indexOf(instagramkeys.instagramRedirectUrl) === 0) && (currentURL.indexOf("error=") > 0) )
            {
                // cut URL from string so that only the error message is left
                var stringIndexPosition = currentURL.indexOf("/?");
                var errorString = "";
                errorString = currentURL.substr((stringIndexPosition+2));

                // split the error messages into an array
                var errorMessageList = new Array();
                errorMessageList = errorString.split("&");

                // go through the list of messages and put them into the return array
                for (var index in errorMessageList)
                {
                    var errorMessage = new Array();
                    errorString = errorMessageList[index];
                    errorMessage = errorString.split("=");
                    returnStatus[errorMessage[0]] = errorMessage[1].replace(/\+/g, ' ');
                }

                returnStatus["status"] = "AUTH_ERROR";
            }

            // console.log("Done checking Instagram URL for authentication information: " + returnStatus);
            return returnStatus;
        };


// this requests a permanent token based on a temp token code
// the response will be a permanent token that is stored by the application
AuthenticationHandler.prototype.requestPermanentToken = function(tokenCode)
        {
            // console.log("Requesting permanent token");

            var instagramPermanentToken = "";
            var req = new XMLHttpRequest();
            req.onreadystatechange = function()
                    {
                        if (req.readyState === XMLHttpRequest.DONE)
                        {
                            if (req.status != 200)
                            {
                                return;
                            }

                            var jsonObject = eval('(' + req.responseText + ')');
                            if (jsonObject.error == null)
                            {
                                // console.log("Response: " + req.responseText + " and object: " + jsonObject);
                                instagramPermanentToken = jsonObject.access_token;
                                // this.storeInstagramData(jsonObject);

                                var db = openDatabaseSync("Instago", "1.0", "Instago persistent data storage", 1);
                                db.transaction(function(tx) {
                                                   tx.executeSql('CREATE TABLE IF NOT EXISTS userdata(id TEXT, access_token TEXT)');
                                               });

                                var dataStr = "INSERT INTO userdata VALUES(?, ?)";
                                var data = [jsonObject["user"].id, jsonObject.access_token];
                                db.transaction(function(tx) {
                                                   tx.executeSql(dataStr, data);
                                               });
                            }
                        }
                    }

            req.open("POST", instagramkeys.instagramTokenRequestUrl, true);
            var params = "grant_type=authorization_code" +
                    "&client_id=" + instagramkeys.instagramClientId +
                    "&client_secret=" + instagramkeys.instagramClientSecret +
                    "&code=" + tokenCode + "&redirect_uri=" + instagramkeys.instagramRedirectUrl;

            // console.log("Done requesting permanent token: " + params);
            req.send(params);
        };


// stores a permanent token for a user into the database
// note that only one Instagram token can exist in the database at any given time
AuthenticationHandler.prototype.storeInstagramData = function(instagramObject)
        {
            var db = openDatabaseSync("Instago", "1.0", "Instago persistent data storage", 1);
            db.transaction(function(tx) {
                               tx.executeSql('CREATE TABLE IF NOT EXISTS userdata(id TEXT, access_token TEXT)');
                           });

            var dataStr = "INSERT INTO userdata VALUES(?, ?)";
            var data = [instagramObject["user"].id, instagramObject.access_token];
            db.transaction(function(tx) {
                               tx.executeSql(dataStr, data);
                           });
        };


// get the stored permanent token for the user
// note that only one Instagram token can exist in the database at any given time
AuthenticationHandler.prototype.getStoredInstagramData = function()
        {
            var instagramUserdata = new Array();
            var db = openDatabaseSync("Instago", "1.0", "Instago persistent data storage", 1);

            db.transaction(function(tx) {
                               tx.executeSql('CREATE TABLE IF NOT EXISTS userdata(id TEXT, access_token TEXT)');
                           });

            db.transaction(function(tx) {
                               var rs = tx.executeSql("SELECT * FROM userdata");
                               if (rs.rows.length > 0)
                               {
                                   instagramUserdata = rs.rows.item(0);
                               }
                           });

            return instagramUserdata;
        };


// check if the user is currently authenticated with Instagram
// from the application point of view this is the case if a token exists in the database
// note that the token might be invalid but this is handled by the errorhandler
AuthenticationHandler.prototype.isAuthenticated = function()
        {
            var userdata = new Array();

            // get the userdata from the persistent database
            // if data is available the user already has a token
            userdata = this.getStoredInstagramData();

            if (userdata.length == 0)
            {
                // user does not have a token
                return false;
            }

            // user already has a token
            return true;
        };


// logout user by deleting the current token
// as the isAuthenticated method relies on the database content it will return false from now on
AuthenticationHandler.prototype.deleteStoredInstagramData = function()
        {
            var instagramUserdata = new Array();
            var db = openDatabaseSync("Instago", "1.0", "Instago persistent data storage", 1);

            db.transaction(function(tx) {
                               tx.executeSql('DROP TABLE userdata');
                           });

            return true;
        };
