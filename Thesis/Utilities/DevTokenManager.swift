//
//  DevTokenManager.swift
//  Thesis
//
//  Created by Christopher  on 5/11/20.
//  Copyright © 2020 Christopher . All rights reserved.
//

import Foundation
// DECLARATIONS

import SwiftUI
import SwiftJWT
import StoreKit
import MediaPlayer

//MusicKit private key
let privateKey = "-----BEGIN PRIVATE KEY-----MIGTAgEAMBMGByqGSM49AgEGCCqGSM49AwEHBHkwdwIBAQQgF3yfVZZlNVXhihHnm1i5mKz73g2UmmVk+XvyeVFfT2OgCgYIKoZIzj0DAQehRANCAAQa8IMnLfiUjPB8wDm8mB8F80VOXIV0smNJ7IEomMlkJo9JQ5YhKakeZ/ueLg311+5qTv8pRR3C+mcDY1fvDi5Y-----END PRIVATE KEY-----"

let myHeader = Header(kid: "842UD7277D")

struct MyClaims: Claims {
    let iss: String
    let iat: Int
    let exp: Int
}

let myClaims = MyClaims(iss : "R8N3T5ZB53", iat: 1584014700, exp: 1599912240)

var myJWT = JWT(header: myHeader, claims: myClaims)

let jwtSigner = JWTSigner.es256(privateKey: Data(privateKey.utf8))

let signedJWT = try! myJWT.sign(using: jwtSigner)

let controller = SKCloudServiceController()
let developerToken = signedJWT


// Building URL for API request
let searchTerm  = "workouts"
// Defaulting the country storefront to US (does not need to be dynamic at the moment)
let countryCode = "us"








struct ContentView: View {
    var body: some View {
        Text(signedJWT)
    }
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// FUNCTIONS



// Request access to the users apple music library
func appleMusicRequestPermission() {
    
    SKCloudServiceController.requestAuthorization { (status:SKCloudServiceAuthorizationStatus) in
        
        switch status {
            
        case .authorized:
            
            print("All good - the user tapped 'OK', so you're clear to move forward and start playing.")
            
        case .denied:
            
            print("The user tapped 'Don't allow'. Read on about that below...")
            
        case .notDetermined:
            
            print("The user hasn't decided or it's not clear whether they've confirmed or denied.")
            
        case .restricted:
            
            print("User may be restricted; for example, if the device is in Education mode, it limits external Apple Music usage. This is similar behaviour to Denied.")
            
       
        @unknown default:
            print("Unknown Error")
        }
        
    }
    
}
