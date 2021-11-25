/**
 *
 * main() will be run when you invoke this action
 *
 * @param Cloud Functions actions accept a single parameter, which must be a JSON object.
 *
 * @return The output of this action, which must be a JSON object.
 *
 */
function main(params) {
    return new Promise((resolve, reject) => {
        var request = require("request");
        var bearer_token = '';

        var optionstoken = { method: 'POST',
            url: 'https://iam.bluemix.net/identity/token',
            headers: 
            { Accept: 'application/json',
             'Content-Type': 'application/x-www-form-urlencoded' },
            form: 
            { grant_type: 'urn:ibm:params:oauth:grant-type:apikey',
              apikey: '<your-api-key>' } 
        };
      
        request(optionstoken, function (error, response, body) {
            if (error) throw new Error(error);
            bearer_token = body.token_type + ' ' + body.access_token;
            console.log(body);
            console.log('bearer_token', bearer_token);
        });

        var optionskube = {
            method: 'GET',
            url: 'https://eu-central.containers.bluemix.net/v1/clusters/hacluster',
            headers: {
                Authorization: 'Bearer <your-bearer-token>'
            },
            json: true
        };

        request(optionskube, function (error, response, body) {
            if (error) {
                console.log('Error', error);
                reject(error);
            } else {
                resolve({
                    ok: true,
                    ClusterState: body.state
                });
            }
        });
    });
}