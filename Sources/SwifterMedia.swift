//
//  SwifterGIF.swift
//  Swifter
//
//  Created by Justin Greenfield on 6/30/17.
//  Copyright © 2017 Matt Donnelly. All rights reserved.
//

import Foundation

internal enum MimeType: String {
    case gif = "image/gif"
    case mp4 = "video/mp4"
    case mov = "video/quicktime"
}

public extension Swifter {
    internal func prepareUpload(data: Data, mimeType: MimeType, success: JSONSuccessHandler? = nil, failure: FailureHandler? = nil) {
        let mediaCategory: String
        switch mimeType {
        case .gif:
             mediaCategory = "tweet_gif"
        case .mp4:
             mediaCategory = "tweet_video"
        case .mov:
            mediaCategory = "tweet_video"
        }
        let path = "media/upload.json"
        let parameters: [String : Any] = [ "command": "INIT", "total_bytes": data.count,
                                           "media_type": mimeType, "media_category": mediaCategory]
        self.postJSON(path: path, baseURL: .upload, parameters: parameters, success: success, failure: failure)
    }
    
    internal func finalizeUpload(mediaId: String, success: JSONSuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path = "media/upload.json"
        let parameters = ["command": "FINALIZE", "media_id" : mediaId]
        self.postJSON(path: path, baseURL: .upload, parameters: parameters, success: success, failure: failure)
    }
    
    internal func uploadStatus(mediaId: String, success: JSONSuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path = "media/upload.json"
        let parameters = ["command": "STATUS", "media_id" : mediaId]
        self.getJSON(path: path, baseURL: .upload, parameters: parameters, success: success, failure: failure)
    }
    
    internal func uploadMedia(_ mediaId: String, data: Data,  mimeType: MimeType, name: String? = nil, success: JSONSuccessHandler? = nil, failure: FailureHandler? = nil) {
        let fileExtension: String
        switch mimeType {
        case .gif:
             fileExtension = ".gif"
        case .mp4:
             fileExtension = ".mp4"
        case .mov:
             fileExtension = ".mov"
        }
        let path = "media/upload.json"
        let parameters : [String:Any] = ["command": "APPEND", "media_id": mediaId, "segment_index": "0",
                                         Swifter.DataParameters.dataKey : "media",
                                         Swifter.DataParameters.fileNameKey: name ?? "Swifter.\(fileExtension)",
                                         "media": data]
        self.jsonRequest(path: path, baseURL: .upload, method: .POST, parameters: parameters, success: success, failure: failure)
    }
    
}
