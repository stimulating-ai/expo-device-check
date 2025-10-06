import { UnavailabilityError } from 'expo-modules-core';

export async function getDeviceToken(): Promise<string> {
  throw new UnavailabilityError('ExpoDeviceCheck', 'getDeviceToken');
}

export function isSupported(): boolean {
  return false;
}

const DeviceCheck = {
  getDeviceToken,
  get isSupported(): boolean {
    return isSupported();
  },
};

export default DeviceCheck;
