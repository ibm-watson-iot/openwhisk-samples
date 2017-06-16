/**
  * Mapping the cloudant Document ID.
  * @returns Document ID of the Cloudant Document
  */
function main(params) {
 
    // Ignore Deleted Documents
    if(params.deleted) {
        return { "error" : "Deleted Document. Ignoring"};
    }

    params.docid = params.id;
    return params;
}
