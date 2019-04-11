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
              apikey: '9XwUMh_BFaoLY8o5hi6pKevcmLSwgc-SAC4ou8OjOAzS' } 
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
                Authorization: 'Bearer eyJraWQiOiIyMDE3MTAzMC0wMDowMDowMCIsImFsZyI6IlJTMjU2In0.eyJpYW1faWQiOiJJQk1pZC0yNzAwMDJSMzBBIiwiaWQiOiJJQk1pZC0yNzAwMDJSMzBBIiwicmVhbG1pZCI6IklCTWlkIiwiaWRlbnRpZmllciI6IjI3MDAwMlIzMEEiLCJnaXZlbl9uYW1lIjoiTElPTkVMIiwiZmFtaWx5X25hbWUiOiJNQUNFIiwibmFtZSI6IkxJT05FTCBNQUNFIiwiZW1haWwiOiJsaW9uZWwubWFjZUBmci5pYm0uY29tIiwic3ViIjoibGlvbmVsLm1hY2VAZnIuaWJtLmNvbSIsImFjY291bnQiOnsiYnNzIjoiMGI1YTAwMzM0ZWFmOWViOTMzOWQyYWI0OGY3MzI2YjQiLCJpbXMiOiIxNTk0NTM0In0sImlhdCI6MTU0MzMzMDYwMCwiZXhwIjoxNTQzMzM0MjAwLCJpc3MiOiJodHRwczovL2lhbS5ibHVlbWl4Lm5ldC9pZGVudGl0eSIsImdyYW50X3R5cGUiOiJwYXNzd29yZCIsInNjb3BlIjoiaWJtIG9wZW5pZCIsImNsaWVudF9pZCI6ImJ4IiwiYWNyIjoxLCJhbXIiOlsicHdkIl19.Dg-mPxUH2h7Dst-VlJ1Y50N0VQvegMiMi_HOyw7moUYOcg4MR4KLf3qUT_5JBDMDYAIR1Msdc24uI5LZVGCkKbhiX_CU6N2uo9RsP6Tn3U0n1qBauBYhmKhXq2F-Ko_vjg2Px_gVe5Alz4_ntsNUVtBZG33jWQMVgseDtbQyRFWikCK3bfNwceysuyeHCldpJm-eGuA_nVF7bjPOGLMQO9RrZH1awPUEJ-km1td5ClgDu8PHNKhOpjvYuqSwmiQhmzD0JhXGuBmEQHZUSVR1j_UxRhvQA3lzHPTmmVfHkRVeCevu7sZ_pxzLUUxoh7s84fxCJNiI6lk0N-yi6u7qUg'
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