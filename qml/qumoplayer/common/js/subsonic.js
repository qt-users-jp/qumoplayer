.pragma library
Qt.include("base64.js")

var clientname = "qumoplayer"
var api_version = "1.6.0"

var currentServer
var widebitrate = "128"

function getserverinfo() {
    console.debug(serverUrl(), currentServer.username, currentServer.password)
}

function serverUrl() {
    return currentServer ? currentServer.url + "rest/" : ""
}

function generateParameters(parameters)
{
    var arr = []
    for (var i in parameters) {
        arr.push(i.concat("=").concat(parameters[i]))
    }
    arr.push("v=".concat(api_version))
    arr.push("c=".concat(clientname))
    return '?'.concat(arr.join("&"))
}

function toHex(str) {
    var hex = '';
    for(var i=0;i<str.length;i++) {
    hex += ''+str.charCodeAt(i).toString(16);
    }
    return hex;
}

function make_base_auth(u, p) {
  var tok = u + ':' + p;
  var hash = Base64.encode(tok);
  //console.debug("Basic " + hash );
  return "Basic " + hash;
}

/*############
  SubSonic APIs
  ############*/

function createXMLHttpRequest(method, url, callback) {
    var auth = make_base_auth(currentServer.username, currentServer.password);
    var request = new XMLHttpRequest();
    request.open(method, url);
    request.setRequestHeader("Authorization", auth );
    request.onreadystatechange = function() { onXmlReadyStateChange(request, callback); }

    request.send();
}

function onXmlReadyStateChange(request, callback) {

    console.debug(request.readyState);
    console.debug(request.status);
    if ( request.readyState === XMLHttpRequest.HEADERS_RECEIVED) {
        console.debug(request.getAllResponseHeaders());
    } else if ( request.readyState === 4 && request.status === 200 ) {
        console.debug(request.responseText);
        callback(request.responseText);
    } else {
//        callback("Loading...");
    }
}

function ping(callback) {
    var url = serverUrl().concat("ping.view").concat(generateParameters())
    console.debug(url)
    createXMLHttpRequest('GET', url, callback);
}

function getIndexes(callback) {
    var url = serverUrl().concat("getIndexes.view").concat(generateParameters())
    createXMLHttpRequest('GET', url, callback);
}

function getMusicDirectory(id, callback) {
    var url = serverUrl().concat("getMusicDirectory.view").concat(generateParameters({id: id}))
    createXMLHttpRequest('GET', url, callback);
}

function getPlayLists(callback) {
    var url = serverUrl().concat("getPlaylists.view").concat(generateParameters())
    createXMLHttpRequest('GET', url, callback);
}

function getPlayList(id, callback) {
    var url = serverUrl().concat("getPlaylist.view").concat(generateParameters({id: id}))
    createXMLHttpRequest('GET', url, callback);
}

function getCoverArtUrl(coverartid, size) {
    var encpass = toHex(currentServer.password)
    var url = serverUrl().concat("getCoverArt.view").concat(generateParameters({u: currentServer.username, p: "enc:".concat(encpass), id: coverartid, size: size}))
    console.debug(url);
    return url;
}

//function getStreamSongUrl(songid, maxBitrate, format, timeoffset) {
function getStreamSongUrl(id, maxBitrate, format, offsetseconds) {
    var maxbitrate = widebitrate
    var encpass = toHex(currentServer.password)
    var url = serverUrl().concat("stream.view").concat(generateParameters({u: currentServer.username, p: "enc:".concat(encpass), id: id, maxBitRate: maxbitrate, format: format, offsetSeconds: offsetseconds}))
    return url
}

function search2(query, callback) {
    var url = serverUrl().concat("search2.view").concat(generateParameters({query: query}))
    //var url = baseurl + "search2.view?query=" + query + "&v=" + api_version + "&c=" + clientname + "&f=json";
    createXMLHttpRequest('GET', url, callback)

}

function createSongList(listmodel) {
    var songlist = "";
    for (var i = 0; i < listmodel.count; i++ ) {
        songlist = songlist + "&songId=" + listmodel.get(i).id;
    }
    return songlist;
}

/*function updatePlayList(playlistid, listmodel, callback) {
    var songlist = createSongList(listmodel);
    var url = baseurl + "createPlaylist.view?playlistId=" + playlistid + songlist + "&v=" + api_version + "&c=" + clientname;
    createXMLHttpRequest('GET', url, callback);
}*/

function createPlayList(name, listmodel, callback) {
    var songlist = createSongList(listmodel);
    var url = serverUrl().concat("createPlaylist.view").concat(generateParameters({name: name.concat(songlist)}))
    console.debug(url);
    createXMLHttpRequest('GET', url, callback);
}






