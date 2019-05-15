# expo-ci

Container image for building Expo iOS and Android applications
on a CI server and automating ipa/apk uploads to the app/play store.

- Installs ruby, headless jre, fastlane & expo.
- Downloads the ITMS Transporter tool v1.9.8 for windows.
- Extracts the jar from the windows executable.
- Sets the Fastlane Transporter PATH to the extracted folder above.

## Usage Example

In this example I will just highlight the steps required to upload an IPA
using fastlane pilot.

1. Use this container as a base for your CI builds.
2. Setup a few ENV vars for fastlane:
   - FASTLANE_USERNAME=<Your Apple ID username (required)>
   - FASTLANE_PASSWORD=<Your Apple ID password (see below if 2fa enabled)>
   - FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD=<Your app specific password(if 2fa enabled)>
   - FASTLANE_ITC_TEAM_ID=<Your apple developer team ID (if you have more than 1 team)>
   - FASTLANE_BUNDLE_ID=<Your app bundle ID (required)>
3. Execute the below command in build script, after expo builds the binary and downloads it.

```sh
  # do expo build stuff above ^^

  fastlane run pilot \
    username:$FASTLANE_USERNAME \
    app_identifier:$FASTLANE_BUNDLE_ID
```

_That's all folks!_