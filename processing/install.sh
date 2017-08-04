#!/bin/bash

#==============================================================================
# FILE:         install.sh
# USAGE:        install.sh [--install,--uninstall,--clear,--help]
# DESCRIPTION:  Installs / Uninstalls UDPro for Visual Recognition in Bluemix
# OPTIONS:      see function ’usage’ below
# AUTHOR:       Amit M Mangalvedkar, Hari hara prasad Viswanathan
# COMPANY:      IBM
# VERSION:      2.0
#==============================================================================
source credentials.cfg


function usage() {
  echo -e "Usage: $0 [--install,--uninstall,--clear,--help]"
}


function help() {
  echo "Installs / Uninstalls Unstructured Data Processor in/from Bluemix"
  echo "Usage: $0 [--install,--uninstall,--clear,--help]"
}


function install() {
  echo "Setting the OpenWhisk properties in a namespace"
  wsk property set --apihost ${API_HOST} --auth ${OW_AUTH_KEY} --namespace "${BLUEMIX_ORG}_${BLUEMIX_SPACE}"

  echo "Binding cloudant"
  wsk package bind /whisk.system/cloudant \
    udpro-cloudant\
    -p dbname $CLOUDANT_db\
    -p username $CLOUDANT_username\
    -p password $CLOUDANT_password\
    -p host $CLOUDANT_host

  echo "Binding IoT Gateway"
  wsk package bind /watson-iot/iot-gateway wiotp-gateway -p org $ORGID \
    -p gatewayTypeId $GATEWAYTYPEID \
    -p gatewayToken $GATEWAYTOKEN \
    -p gatewayId $GATEWAYID \
    -p eventType $EVENTTYPE

  echo "Creating actions"
  wsk action create mapper udproMapper.js #-p targetNamespace $CURRENT_NAMESPACE
  wsk action create invokeVR visual.js -p apikey $WATSON_key

  wsk action create vr-iot-sequence --sequence mapper,udpro-cloudant/read,invokeVR,wiotp-gateway/publishEvent

  echo "Creating trigger"
  #wsk trigger create udpro-cloudant/udpro-cloudant-trigger --feed udpro-cloudant/changes
  wsk trigger create udpro-cloudant-trigger --feed /whisk.system/cloudant/changes -p dbname $CLOUDANT_db\
    -p username $CLOUDANT_username\
    -p password $CLOUDANT_password\
    -p host $CLOUDANT_host

  echo "Creating rule"
  wsk rule create udpro-rule /${BLUEMIX_ORG}_${BLUEMIX_SPACE}/udpro-cloudant-trigger /${BLUEMIX_ORG}_${BLUEMIX_SPACE}/vr-iot-sequence
}


function uninstall() {
  echo "Setting the OpenWhisk properties in a namespace"
  wsk property set --apihost ${API_HOST} --auth ${OW_AUTH_KEY} --namespace "${BLUEMIX_ORG}_${BLUEMIX_SPACE}"

  echo "Deleting rule"
  wsk rule delete udpro-rule

  echo "Deleting actions"
  wsk action delete vr-iot-sequence

  wsk action delete mapper
  wsk action delete invokeVR

  echo "Deleting trigger"
  wsk trigger delete udpro-cloudant-trigger

  echo "Delete the binding"
  wsk package delete udpro-cloudant
  wsk package delete wiotp-gateway
}


function clear() {
  echo "Clearing environmental variables..."

  # Bluemix variables
  echo "Resetting Bluemix variables"
  unset BLUEMIX_ORG
  unset BLUEMIX_SPACE

  # OpenWhisk variables
  echo "Clearing OpenWhisk variables"
  unset API_HOST
  unset OW_AUTH_KEY
  unset CURRENT_NAMESPACE
  unset PACKAGE_NAME

  # Cloudant service variables
  echo "Clearing Cloudant service variables"
  unset CLOUDANT_username
  unset CLOUDANT_password
  unset CLOUDANT_host
  unset CLOUDANT_db

  # Watson Visual Recognition service variables
  echo "Clearing Watson Visual Recognition service variables"
  unset WATSON_key

  # Watson IoT Gateway variables
  echo "Clearing IoT service variables"
  unset ORGID
  unset GATEWAYTYPEID
  unset GATEWAYTOKEN
  unset GATEWAYID
  unset EVENTTYPE
}


case "$1" in
  "--install" )
      install
      clear
      ;;

  "--uninstall" )
      uninstall
      clear
      ;;

  "--help" )
      help
      ;;

  * )
      usage
      ;;
esac
