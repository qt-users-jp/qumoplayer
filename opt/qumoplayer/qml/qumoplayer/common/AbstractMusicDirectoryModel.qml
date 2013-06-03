/* Copyright (c) 2012 QumoPlayer Project.
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the QumoPlayer nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL QUMOPLAYER BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import QtQuick 1.1

AbstractSubsonicListModel {
    id: root

    XmlRole { name: "id"; query: "@id/string()" }
    XmlRole { name: "parent"; query: "@parent/string()" }
    XmlRole { name: "title"; query: "@title/string()" }
    XmlRole { name: "isDir"; query: "@isDir/string()" }
    XmlRole { name: "album"; query: "@album/string()" }
    XmlRole { name: "artist"; query: "@artist/string()" }
    XmlRole { name: "track"; query: "@track/string()" }
    XmlRole { name: "year"; query: "@year/string()" }
    XmlRole { name: "genre"; query: "@genre/string()" }
    XmlRole { name: "coverArt"; query: "@coverArt/string()" }
    XmlRole { name: "size"; query: "@size/string()" }
    XmlRole { name: "contentType"; query: "@contentType/string()" }
    XmlRole { name: "suffix"; query: "@suffix/string()" }
    XmlRole { name: "path"; query: "@path/string()" }
    XmlRole { name: "duration"; query: "@duration/string()" }
    XmlRole { name: "bitRate"; query: "@bitRate/string()" }

    //for Search function
    XmlRole { name: "name"; query: "@name/string()" }
    XmlRole { name: "type"; query: "name()" }

    //for Podcasts
    XmlRole { name: "streamId"; query: "@streamId/string()" }
    XmlRole { name: "publishDate"; query: "@publishDate/string()" }
}
