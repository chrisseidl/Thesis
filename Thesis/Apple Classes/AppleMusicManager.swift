//
//  AppleMusicController.swift
//  Thesis
//
//  Created by Christopher  on 5/11/20.
//  Copyright © 2020 Christopher . All rights reserved.
// This class belongs to Apple. They have it open sourced and licenses are free to use.
//

import Foundation
import StoreKit
import UIKit

class AppleMusicManager {
    
    // MARK: Types

    /// The completion handler that is called when an Apple Music Catalog Search API call completes.
    typealias CatalogSearchCompletionHandler = (_ mediaItems: [[MediaItem]], _ error: Error?) -> Void
    
    /// The completion handler that is called when an Apple Music Get User Storefront API call completes.
    typealias GetUserStorefrontCompletionHandler = (_ storefront: String?, _ error: Error?) -> Void
    
    /// The completion handler that is called when an Apple Music Get Recently Played API call completes.
    typealias GetRecentlyPlayedCompletionHandler = (_ mediaItems: [MediaItem], _ error: Error?) -> Void
    
    // MARK: Properties
    
    /// The instance of `URLSession` that is going to be used for making network calls.
    lazy var urlSession: URLSession = {
        // Configure the `URLSession` instance that is going to be used for making network calls.
        let urlSessionConfiguration = URLSessionConfiguration.default
        
        return URLSession(configuration: urlSessionConfiguration)
    }()
    
    /// The storefront id that is used when making Apple Music API calls.
    var storefrontID: String?
    
    func fetchDeveloperToken() -> String? {
        
        // MARK: ADAPT: YOU MUST IMPLEMENT THIS METHOD
        let developerAuthenticationToken: String? = "kpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c"
        return developerAuthenticationToken
    }
    
    // MARK: General Apple Music API Methods
    
    func performAppleMusicCatalogSearch(with term: String, countryCode: String, completion: @escaping CatalogSearchCompletionHandler) {
        
        guard let developerToken = fetchDeveloperToken() else {
            fatalError("Developer Token not configured. See README for more details.")
        }

        let urlRequest = AppleMusicRequestFactory.createSearchRequest(with: term, countryCode: countryCode, developerToken: developerToken)
        
        let task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                completion([], error)
                return
            }
            
            do {
                let mediaItems = try self.processMediaItemSections(from: data!)
                completion(mediaItems, nil)
                
            } catch {
                fatalError("An error occurred: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func performAppleMusicStorefrontsLookup(regionCode: String, completion: @escaping GetUserStorefrontCompletionHandler) {
        guard let developerToken = fetchDeveloperToken() else {
            fatalError("Developer Token not configured. See README for more details.")
        }
        
        let urlRequest = AppleMusicRequestFactory.createStorefrontsRequest(regionCode: regionCode, developerToken: developerToken)
        
        let task = urlSession.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard error == nil, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                completion(nil, error)
                return
            }
            
            do {
                let identifier = try self?.processStorefront(from: data!)
                completion(identifier, nil)
            } catch {
                fatalError("An error occurred: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    // MARK: Personalized Apple Music API Methods
    
    func performAppleMusicGetRecentlyPlayed(userToken: String, completion: @escaping GetRecentlyPlayedCompletionHandler) {
        guard let developerToken = fetchDeveloperToken() else {
            fatalError("Developer Token not configured.  See README for more details.")
        }
        
        let urlRequest = AppleMusicRequestFactory.createRecentlyPlayedRequest(developerToken: developerToken, userToken: userToken)
        
        let task = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            guard error == nil, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                completion([], error)
                
                return
            }
            
            do {
                guard let jsonDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any],
                    let results = jsonDictionary[ResponseRootJSONKeys.data] as? [[String: Any]] else {
                        throw SerializationError.missing(ResponseRootJSONKeys.data)
                }
                
                let mediaItems = try self.processMediaItems(from: results)
                
                completion(mediaItems, nil)
                
            } catch {
                fatalError("An error occurred: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func performAppleMusicGetUserStorefront(userToken: String, completion: @escaping GetUserStorefrontCompletionHandler) {
        guard let developerToken = fetchDeveloperToken() else {
            fatalError("Developer Token not configured.  See README for more details.")
        }
        
        let urlRequest = AppleMusicRequestFactory.createGetUserStorefrontRequest(developerToken: developerToken, userToken: userToken)
        
        let task = urlSession.dataTask(with: urlRequest) { [weak self] (data, response, error) in
            guard error == nil, let urlResponse = response as? HTTPURLResponse, urlResponse.statusCode == 200 else {
                let error = NSError(domain: "AppleMusicManagerErrorDomain", code: -9000, userInfo: [NSUnderlyingErrorKey: error!])
                
                completion(nil, error)
                
                return
            }
            
            do {
                
                let identifier = try self?.processStorefront(from: data!)
                
                completion(identifier, nil)
            } catch {
                fatalError("An error occurred: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
    
    func processMediaItemSections(from json: Data) throws -> [[MediaItem]] {
        guard let jsonDictionary = try JSONSerialization.jsonObject(with: json, options: []) as? [String: Any],
            let results = jsonDictionary[ResponseRootJSONKeys.results] as? [String: [String: Any]] else {
                throw SerializationError.missing(ResponseRootJSONKeys.results)
        }
        
        var mediaItems = [[MediaItem]]()
        
        if let songsDictionary = results[ResourceTypeJSONKeys.songs] {
            
            if let dataArray = songsDictionary[ResponseRootJSONKeys.data] as? [[String: Any]] {
                let songMediaItems = try processMediaItems(from: dataArray)
                mediaItems.append(songMediaItems)
            }
        }
        
        if let albumsDictionary = results[ResourceTypeJSONKeys.albums] {
            
            if let dataArray = albumsDictionary[ResponseRootJSONKeys.data] as? [[String: Any]] {
                let albumMediaItems = try processMediaItems(from: dataArray)
                mediaItems.append(albumMediaItems)
            }
        }
        
        return mediaItems
    }
    
    func processMediaItems(from json: [[String: Any]]) throws -> [MediaItem] {
        let songMediaItems = try json.map { try MediaItem(json: $0) }
        return songMediaItems
    }
    
    func processStorefront(from json: Data) throws -> String {
        
        guard let jsonDictionary = try JSONSerialization.jsonObject(with: json, options: []) as? [String: Any],
            let data = jsonDictionary[ResponseRootJSONKeys.data] as? [[String: Any]] else {
                throw SerializationError.missing(ResponseRootJSONKeys.data)
        }
        
        guard let identifier = data.first?[ResourceJSONKeys.identifier] as? String else {
            throw SerializationError.missing(ResourceJSONKeys.identifier)
        }
        
        return identifier
    }
}

import Foundation

/// Keys related to the `Response Root` JSON object in the Apple Music API.
struct ResponseRootJSONKeys {
    static let data = "data"
    
    static let results = "results"
}

/// Keys related to the `Resource` JSON object in the Apple Music API.
struct ResourceJSONKeys {
    static let identifier = "id"
    
    static let attributes = "attributes"
    
    static let type = "type"
}

/// The various keys needed for parsing a JSON response from the Apple Music Web Service.
struct ResourceTypeJSONKeys {
    static let songs = "songs"
    
    static let albums = "albums"
}
enum SerializationError: Error {
    
    /// This case indicates that the expected field in the JSON object is not found.
    case missing(String)
}
