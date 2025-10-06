# expo-device-check

Expo module that exposes the native [DeviceCheck](https://developer.apple.com/documentation/devicecheck) API on iOS. It mirrors the simple API of [`react-native-device-check`](https://github.com/aco/react-native-device-check) while integrating with Expo's module system.

> DeviceCheck is available only on physical iOS devices running iOS 11 or later. Calls made from a simulator will fail.

## Installation

```sh
npx expo install expo-device-check
```

If your project uses the Expo prebuild workflow, remember to run `expo prebuild` (or `npx pod-install` inside the `ios` directory) after installing the package.

## Usage

```ts
import DeviceCheck from 'expo-device-check';
// or: import { getDeviceToken, isSupported } from 'expo-device-check';

async function loadToken() {
  if (!DeviceCheck.isSupported) {
    throw new Error('DeviceCheck is not supported on this device.');
  }

  try {
    const token = await DeviceCheck.getDeviceToken();
    // send token to your backend for attestation
  } catch (error) {
    console.error('Failed to fetch DeviceCheck token', error);
  }
}
```

### API

| Method | Description |
| --- | --- |
| `DeviceCheck.getDeviceToken(): Promise<string>` | Generates a base64-encoded DeviceCheck token. |
| `DeviceCheck.isSupported: boolean` | Indicates whether the current device can use DeviceCheck. |

### Error handling

`getDeviceToken` throws an `ERR_EXPO_DEVICE_CHECK_*` error when the API is unavailable (e.g. simulator, iOS version < 11) or when token generation fails.

### Apple privacy manifest

Because this module calls `DCDevice`, your app must declare the appropriate usage reason codes in its `PrivacyInfo.xcprivacy`. Expo does not automatically add these declarations, so update your app's privacy manifest accordingly before submitting to the App Store.

## Development

```sh
npm install
npm run build
```

This repository intentionally only implements the iOS DeviceCheck API. Calls on other platforms will throw an `UnavailabilityError`.

## License

MIT
