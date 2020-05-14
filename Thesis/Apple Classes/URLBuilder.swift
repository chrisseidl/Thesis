//
//  URLBuilder.swift
//  Thesis
//
//  Created by Christopher  on 5/11/20.
//  Copyright © 2020 Christopher . All rights reserved.
//
// This entire module is borrowed from Apple's "Adding-Content-to-Apple-Music" example - licenses is free to use
//

import Foundation

struct URLBuilder {

    /// The base URL for all Apple Music API network calls.
   static let appleMusicAPIBaseURLString = "api.music.apple.com"
   
   /// The Apple Music API endpoint for requesting a list of recently played items.
   static let recentlyPlayedPathURLString = "/v1/me/recent/played"
   
   /// The Apple Music API endpoint for requesting a the storefront of the currently logged in iTunes Store account.
   static let userStorefrontPathURLString = "/v1/me/storefront"
   
   static func createSearchRequest(with term: String, countryCode: String, developerToken: String) -> URLRequest {
       
       // Create the URL components for the network call.
       var urlComponents = URLComponents()
       urlComponents.scheme = "https"
       urlComponents.host = URLBuilder.appleMusicAPIBaseURLString
       urlComponents.path = "/v1/catalog/\(countryCode)/search"
       
       let expectedTerms = term.replacingOccurrences(of: " ", with: "+")
       let urlParameters = ["term": expectedTerms,
                            "limit": "10",
                            "types": "songs,albums"]
       
       var queryItems = [URLQueryItem]()
       for (key, value) in urlParameters {
           queryItems.append(URLQueryItem(name: key, value: value))
       }
       
       urlComponents.queryItems = queryItems
       
       // Create and configure the `URLRequest`.
       
       var urlRequest = URLRequest(url: urlComponents.url!)
       urlRequest.httpMethod = "GET"
       
       urlRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
       
       return urlRequest
   }
   
   static func createStorefrontsRequest(regionCode: String, developerToken: String) -> URLRequest {
       var urlComponents = URLComponents()
       urlComponents.scheme = "https"
       urlComponents.host = URLBuilder.appleMusicAPIBaseURLString
       urlComponents.path = "/v1/storefronts/\(regionCode)"
       
       // Create and configure the `URLRequest`.
       
       var urlRequest = URLRequest(url: urlComponents.url!)
       urlRequest.httpMethod = "GET"
       
       urlRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
       
       return urlRequest
   }
}
