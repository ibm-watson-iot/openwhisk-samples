::==============================================================================
:: FILE:         install.sh
:: USAGE:        install.sh [--install,--uninstall,--help]
:: DESCRIPTION:  Installs / Uninstalls UDPro for Visual Recognition in Bluemix
:: OPTIONS:      see :CASE--help below
:: AUTHOR:       Hari hara prasad Viswanthan
:: COMPANY:      IBM
:: VERSION:      1.0
::==============================================================================
@ECHO OFF
SET EXIT_CODE=0
IF NOT "%1"== "--install"  IF NOT "%1"== "--uninstall" IF NOT "%1"== "--help" ( SET  EXIT_CODE=1 && GOTO:CASE--help) 

GOTO:CASE%1 

:CASE--install
SETLOCAL
FOR /f "delims=" %%x IN (credentials.cfg) DO ( ECHO %%x|findstr "=" > NUL &&(set %%x))

ECHO Setting the OpenWhisk properties in a namespace
wsk property set --apihost %API_HOST% --auth %OW_AUTH_KEY% --namespace "%BLUEMIX_ORG%_%BLUEMIX_SPACE%"

ECHO Binding cloudant
wsk package bind /whisk.system/cloudant udpro-cloudant -p dbname %CLOUDANT_db% -p username %CLOUDANT_username% -p password %CLOUDANT_password% -p host %CLOUDANT_host%

ECHO Creating actions
wsk action create mapper udproMapper.js 
wsk action create invokeVR visual.js -p apikey %WATSON_key%
wsk action create wiotpGateway whiskgateway.js -p orgId %ORGID% -p gatewayTypeId %GATEWAYTYPEID% -p gatewayToken %GATEWAYTOKEN% -p gatewayId %GATEWAYID% -p eventType %EVENTTYPE%
wsk action create vr-iot-sequence --sequence mapper,udpro-cloudant/read,invokeVR,wiotpGateway

ECHO Creating trigger
wsk trigger create udpro-cloudant-trigger --feed /whisk.system/cloudant/changes -p dbname %CLOUDANT_db% -p username %CLOUDANT_username% -p password %CLOUDANT_password% -p host %CLOUDANT_host%

ECHO Creating rule
wsk rule create udpro-rule udpro-cloudant-trigger vr-iot-sequence
ENDLOCAL
GOTO:endall

:CASE--uninstall
SETLOCAL
FOR /f "delims=" %%x IN (credentials.cfg) DO ( ECHO %%x|findstr "=" > NUL &&(set %%x))

ECHO Setting the OpenWhisk properties in a namespace
wsk property set --apihost %API_HOST% --auth %OW_AUTH_KEY% --namespace "%BLUEMIX_ORG%_%BLUEMIX_SPACE%"

ECHO Deleting rule
wsk rule delete udpro-rule

ECHO Deleting actions
wsk action delete vr-iot-sequence

wsk action delete mapper
wsk action delete invokeVR
wsk action delete wiotpGateway

ECHO Deleting trigger
wsk trigger delete udpro-cloudant-trigger

ECHO Delete the binding
wsk package delete udpro-cloudant
ENDLOCAL
GOTO:endall

:CASE--help
ECHO Installs / Uninstalls Unstructured Data Processor in/from Bluemix
ECHO Usage: %0 [--install,--uninstall,--clear,--help]
GOTO:endall

:endall
EXIT /B %EXIT_CODE% 