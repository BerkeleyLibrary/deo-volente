# deo-volente

`deo-volente` is a bunch of scripts and utility code for loading data into dataverse.

## large file workaround, mk ii

for files that fail because of timeouts related to size.

for each file in a batch:

* upload a placeholder file (type shouldn't matter) to the dataset with the same name that you want to use
* get the file identifier for that file
* generate a storageIdentifier for that file
* create a json blob like so:

```json
{
    "fileToReplaceId": ${fileIdentifier}, 
    "directoryLabel":"${relativePathInDatset}",
    "storageIdentifier":"file://${storageIdentifier}",
    "fileName":"${fileName.ext}",
    "mimeType":"${mime/type}",
    "forceReplace": "true",
    "description": "",
    "md5Hash": "${checksum}",
    "checksum": {"@type": "${otherType}", "@value": "${otherValue}"}
}
```

then, when you have a batch:

* make an array of all the json objects
* POST to "$SERVER_URL/api/datasets/:persistentId/replaceFiles?persistentId=$PERSISTENT_IDENTIFIER", with formdata "jsonData=$JSON_DATA"