var VisualRecognitionV3 = require('watson-developer-cloud/visual-recognition/v3');


/**
 * @author jeffdare
 * @param {Object} params
 * @param {String} [params.apikey] The API-Key of the Watson Visual Recognition Service
 * @param {Array} [params.classifiers] Array of Classifier IDs for the Watson Visual Recognition Service
 *
 * Below are the data read from Cloudant
 * @param {ReadStream|Buffer|Object} [params.payload] Buffer of the Image to be analyzed
 * @param {String} [params.typeId] Type ID of the device
 * @param {String} [params.deviceId] Device ID of the device
 *
 * @return {Object}
 */
function main(params) {
    // Data from Cloudant Document
    var data = params.payload;
    var typeId = params.typeId;
    var deviceId = params.deviceId;
    // id of cloudant document
    var docId = params._id;

    // Data from Credentials
    var classifiers = params.classifiers;
    var apiKey = params.apikey;

    if(!apiKey) {
        return Promise.reject('apiKey for the Watson Visual Recognition is required.');
    }

    var visual_recognition = new VisualRecognitionV3({
        api_key: apiKey,
        version_date: "2016-05-20"
    });

    var promise = new Promise(function(resolve, reject) {

        var params = {
          images_file: Buffer(data)
        };

        if(classifiers) {
            params.classifier_ids = classifiers;
        }

        visual_recognition.classify(params, function(err, res) {
          if (err) {
            console.log(err);
            reject(err);
          }
          else {
            console.log(JSON.stringify(res, null, 2));
            resolve({payload : res, docId : docId, typeId : typeId, deviceId : deviceId});
          }
        });
      });

    return promise;
}
