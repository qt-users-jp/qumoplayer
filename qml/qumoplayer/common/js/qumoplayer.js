.pragma library
//Qt.include("subsonic.js")

/*function handleIconSource(iconId) {
    var prefix = "icon-m-"
    // check if id starts with prefix and use it as is
    // otherwise append prefix and use the inverted version if required
    if (iconId.indexOf(prefix) !== 0)
    iconId =  prefix.concat(iconId).concat(theme.inverted ? "-white" : "");
    return "image://theme/" + iconId;
}*/

// Add to Playlist
/*function addToPlaylist(fromlistmodel, fromlistview, tolistmodel) {
    tolistmodel.append({ "songid": fromlistmodel.get(fromlistview.currentIndex).musicid, "songtitle": fromlistmodel.get(fromlistview.currentIndex).musictitle, "artist": fromlistmodel.get(fromlistview.currentIndex).musicartist, "coverartid": fromlistmodel.get(fromlistview.currentIndex).musiccoverart, "duration": fromlistmodel.get(fromlistview.currentIndex).musicduration });
}*/
function addToPlaylist(fromlistmodel, index, tolistmodel) {
    tolistmodel.append(fromlistmodel.get(index));
}

// Add all songs in saved playlists to current playlist
function addAllSongToPlaylist(fromlistmodel, tolistmodel) {
    for(var i = 0; i < fromlistmodel.count; i++ ) {
        addToPlaylist(fromlistmodel, i, tolistmodel)
    }
}

// Clear Xmllistmodel
function clearmodel(listmodel) {
    listmodel.xml = "";
    listmodel.reload();
}

