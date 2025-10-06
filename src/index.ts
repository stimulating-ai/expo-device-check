import { NativeModulesProxy, UnavailabilityError, requireNativeModule } from 'expo-modules-core';

const MODULE_NAME = 'ExpoDeviceCheck';

type DeviceCheckNativeModule = {
  readonly isSupported: boolean;
  getDeviceToken(): Promise<string>;
};

let nativeModule: DeviceCheckNativeModule | null = (NativeModulesProxy as any)?.[MODULE_NAME] ?? null;

function resolveModule(): DeviceCheckNativeModule | null {
  if (nativeModule) {
    return nativeModule;
  }

  try {
    nativeModule = requireNativeModule<DeviceCheckNativeModule>(MODULE_NAME);
  } catch (error) {
    nativeModule = null;
  }

  return nativeModule;
}

function getModuleOrThrow(): DeviceCheckNativeModule {
  const module = resolveModule();
  if (!module) {
    throw new UnavailabilityError(MODULE_NAME, 'getDeviceToken');
  }
  return module;
}

export async function getDeviceToken(): Promise<string> {
  return getModuleOrThrow().getDeviceToken();
}

export function isSupported(): boolean {
  const module = resolveModule();
  return module?.isSupported ?? false;
}

const DeviceCheck = {
  getDeviceToken,
  get isSupported(): boolean {
    return isSupported();
  },
};

export default DeviceCheck;
