 var request = require('request');
 var util = require('util');
/**
 * @param {Object} params
 * Details of the Gateway
 * @param {String} [params.orgId] The Organization ID
 * @param {String} [params.domain] Domain name of the messaging host
 * @param {String} [params.gatewayTypeId] Gateway Type ID
 * @param {String} [params.gatewayId] Gateway ID
 * @param {String} [params.gatewayToken] Gateway Token
 * [For advance security]
 * @param {String} [params.cert] Gateway client certificate .pem file
 * @param {String} [params.key] Gateway key for the client certrificate
 *
 * Details of the end device
 * @param {String} [params.typeId] Device Type Id
 * @param {String} [params.deviceId] Device Id
 * @param {String} [params.eventType] Event Type

 * @param {String} [params.payload] Payload of the Event
 * @param {String} [params.docId] Doc Id of the Cloudant
 *
 * @return {Promise}
 */
 function main(params){

    let errorMsg = paramsCheck(params);
    if(errorMsg) {
        return Promise.reject(errorMsg);
    }
    // Optional param. If not defined, default messaging server will be used
    if(params.domain === undefined) {
        params.domain = "messaging.internetofthings.ibmcloud.com";
    }

    return new Promise((resolve, reject) => {

      var uri = util.format(
	  "https://%s.%s:443/api/v0002/device/types/%s/devices/%s/events/%s",
	  params.orgId, params.domain, params.typeId, params.deviceId ,
	  params.eventType
	  );

    var postObj = {
        headers: {
          'content-type' : 'application/json',
          'authorization' : 'Basic ' + new Buffer('g/'+params.orgId+'/'+ params.gatewayTypeId+'/'+ params.gatewayId + ':' + params.gatewayToken).toString('base64')
        },
        url: uri,
        body: JSON.stringify(params.payload)
      };
    //Optional values no need to validate
    if(params.cert && params.key ){
        postObj.agentOptions= {
          cert: params.cert ,
          key: params.key,
          securityOptions: 'SSL_OP_NO_SSLv3'
        }
      }

    request.post(postObj, function(error, response, body){
          if(!error){
            if(response.statusCode === 200)
            {
              resolve({body})
            }else{
              reject(response)
            }
          }else{
			        reject(error);
          }
        });

    });
  }

 /**
 *  Function to check if all the params are passed properly
 */
function paramsCheck(params) {
    if (params.orgId === undefined ) {
        return ('No orgId provided');
    }
    else if (params.typeId === undefined) {
        return 'No Device type Id provided';
    }
    else if (params.deviceId === undefined) {
        return 'No device Id provided';
    }
    else if (params.eventType === undefined) {
        return 'No event Type provided';
    }
    else if (params.gatewayTypeId === undefined) {
        return 'No Gateway Type Id provided';
    }
    else if (params.gatewayId === undefined) {
        return 'No Gateway Id provided';
    }
    else if (params.gatewayToken === undefined) {
        return 'No Gateway Token provided';
    }
    else if (params.payload === undefined) {
        return 'No Payload provided';
    }
    else if (params.docId === undefined) {
        return 'No Doc ID of Cloudant provided';
    }
    else {
        return undefined;
    }
}
