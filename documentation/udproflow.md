# Unstructured Data Processor Workflow #  

<figure><img src="../resources/udprosolution.png"><figurecaption>Unstructured Data Processor in a nutshell</figurecaption></figure>   


## Cloudant DB receives binary events from Devices ##  
1. Receives input data in the form of still-camera images, as well as, metadata identifying the device that has posted the data
2. Triggers an action in OpenWhisk

#### Unstructured Data Processor transforms binary event into JSON events ####  
1. Makes ReST call to Visual Recognition service on Bluemix and gets back the response
2. Packages the response in a JSON format which is understood by Watson IoT Platform

#### Unstructured Data Processor works as a Gateway to post the processed data ####
1. Auto-registers the devices sending the images  
2. Works as a gateway to which the devices are attached
3. Posts the processed data as a gateway, on the behalf of the device which has originally posted the binary message _(This requires the gateway to be registered in WIoTP.)_


## Documentation Links ##
* [Main Page](/README.md)  
* [Installation and Uninstallation steps](/documentation/deployment.md)  
* [Unstructured Data and Watson IoT Platform](/documentation/needforudpro.md)  
* [Unstructured Data Processor Workflow](/documentation/udproflow.md)  
* [Running the Application](/testclient/README.md)  
