//
//  MPDSong.swift
//  mpd-ios
//
//  Created by Julius Paffrath on 17.12.16.
//  Copyright © 2016 Julius Paffrath. All rights reserved.
//

import Foundation

class MPDSong: NSObject {
    private(set) var artist: String = "No Artist"
    private(set) var title:  String = "No Title"
    private(set) var album:  String = "No Album"
    private(set) var genre:  String = "No Genre"
    private(set) var track:  Int    = -1
    private(set) var time:   Int    = -1
    
    init(input: String) {
        for line in input.characters.split(separator: "\n").map(String.init) {
            
            if let sub = line.characters.index(of: ":") {
                switch (line.substring(to: sub)) {
                case "Artist":
                    self.artist = line.substring(from: "Artist: ".endIndex)
                    break
                case "Title":
                    self.title = line.substring(from: "Title: ".endIndex)
                    break
                case "Album":
                    self.album = line.substring(from: "Album: ".endIndex)
                    break
                case "Genre":
                    self.genre = line.substring(from: "Genre: ".endIndex)
                    break
                case "Track":
                    var track = line.substring(from: "Track: ".endIndex)
                    
                    // parse tracks with
                    if track.contains("/") {
                        track = track.substring(to: "/".endIndex)
                    }

                    if let trackNr = Int(track) {
                        self.track = trackNr
                    }
                    break
                case "Time":
                    let time = line.substring(from: "Time: ".endIndex)
                    if let timeInt = Int(time) {
                        self.time = timeInt
                    }
                    break
                default:
                    break
                }
            }
        }
    }
    
    /// Returns the length of the song as a formatted string
    ///
    /// This will parse the seconds in MINUTES:SECONDS
    /// - returns: length of the song as a string
    func getSecondsString() -> String {
        if self.time == -1 {
            return "00:00"
        }
        
        let remain = self.time % 60
        let seconds = self.time / 60
        
        if remain / 10 == 0 {
            return "\(seconds):0\(remain)"
        }
        
        return "\(seconds):\(remain)"
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let obj = object as? MPDSong {
            if self === obj {
                return true
            }
            
            if self.title == obj.title && self.artist == obj.artist &&
                self.album == obj.album && self.track == obj.track {
                return true
            }
        }
        
        return false
    }
}
