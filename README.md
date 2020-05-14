# Thesis
WeDJ Real Time Music Listener

# Requirements to try and run code
- Swift compatible compiler such as xCode. xCode is included with MacOS.
- iOS > 8 Simulator or device. 


# General information 
- WeDJ is a real time music listening application; which allows users to listen to music with their friends through the Apple Music platform. The back end database is powered by Firebase's Realtime database and Authentication.
- Where the code is now the authorization through firebase and making user accounfs for WeDJ is up and running. The authorization through Apple is in the works. 
- Methods provided by Apple's Developer program such as .requestCloudServiceCapabilities() continue to respond with (Unable to connect to iTunes's Servers). Until about two weeks about my URL components were accessing the API and responding with JSon formatted Media items. 
- The authorization is a three part Json web token, with a header, a payload, and a signature. See module <DevTokenManager.swift> for example. 

