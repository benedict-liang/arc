# (arc): arc reads code

(arc) is a code reader for the iPad (iOS 6 and above.)

# Cloud Integration

(arc) can connect to three cloud services to retrieve files:
* Dropbox (using the Sync API)
* SkyDrive
* Google Drive

To enable the app to do so, you must register and obtain the necessary API keys from each of these services, then enter them into the cloudKeys.plist file.

(The keys found within this repository's history have been revoked, and the cloudKeys.plist file left blank, but with placeholder values included. The app will compile and run with these values, but will not be able to authenticate with these services.)
