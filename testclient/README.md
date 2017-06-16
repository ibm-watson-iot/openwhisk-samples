# Running the Application #
This folder contains the artifacts that emulate a client.   

As explained in the [Unstructured Data Processor Workflow](/documentation/udproflow.md),the workflow is triggered when a Camera posts an image to the Cloudant database. The image is accompanied by the camera's Device Id. When the Unstructured Data Processor has analyed the image, it posts an event to the Watson IoT Platform for further processing. The first time each camera posts an image, it is auto-registered as a device to the Watson IoT Platform.

To avoid the need for a real camera, a test client  is provided to emulate this behavior. This emulated client, like a real physical device, uploads an image to the Cloudant Database

## Pre-requisites ##

* [nodejs](https://nodejs.org/en/download/)

To verify you have nodejs installed run `node -v` at a command prompt/terminal.

## Client code execution ##

* Change Directory to testclient
* Edit the `config.json`(as described)
  *  "iotconfig" element that is used for identifying itself to Watson IoT   
  * "cloudantConfig" element is used to story the Cloudant credentials.   
<pre><code>{
  "iotconfig" : {
    "typeId" : "MY_DEVICE_TYPE_ID",
    "deviceId" : "MY_DEVICE_ID"
 },
 "cloudantConfig" : {
  "user" : "CLOUDANT_USER",
  "password" : "CLOUDANT_PASSWORD",
  "dbName" : "CLOUDANT_DB"
 }
}</code></pre>
The above values need to be modified based on your credentials and requirements. For e.g. the "MY_DEVICE_TYPE_ID" could be "Camera".

* To run this code, execute the following command.

  ```
  $ npm install
  $ node upload.js images/machine.jpeg

  ```

The first command installs the dependencies and the second code uploads an image from the samples provided in the [images](/testclient/images) folder.

* Go the Watson IoT Platform and check for the processed image data as an event with the document id as stored in the Cloudant DB.    

## Documentation Links ##
* [Main Page](/README.md)  
* [Installation and Uninstallation steps](/documentation/deployment.md)  
* [Unstructured Data and Watson IoT Platform](/documentation/needforudpro.md)  
* [Unstructured Data Processor Workflow](/documentation/udproflow.md)  
* [Running the Application](/testclient/README.md)  
