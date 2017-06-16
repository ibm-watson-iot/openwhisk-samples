 var request = require('request');
 var util = require('util');
 function main(params){
    console.log('[DeviceClient:publishHTTPS] Publishing event of Type: '+ params.eventType + ' with params.payload : '+JSON.stringify(params.payload));

    return new Promise((resolve, reject) => {

      var uri = util.format(
	  "https://%s.messaging.internetofthings.ibmcloud.com/api/v0002/device/types/%s/devices/%s/events/%s",
	  params.orgId, params.typeId, params.deviceId ,
	  params.eventType
	  );

        request.post({
          headers: {
              'content-type' : 'application/json',
              'authorization' : 'Basic ' + new Buffer('g/'+params.orgId+'/'+ params.gatewayTypeId+'/'+ params.gatewayId + ':' + params.gatewayToken).toString('base64')
          },
          url:     uri,
          body:   JSON.stringify({
              result : params.payload,
              docId : params.docId
          })
        }, function(error, response, body){
            //console.log(response)
            if(!error){
                resolve({body})
            }else{
                console.log("err"+error.message)
				reject(error);
            }
        });

    });
  }
