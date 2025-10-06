import ExpoModulesCore
#if canImport(DeviceCheck)
import DeviceCheck
#endif

public class DeviceCheckModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ExpoDeviceCheck")

    Constant("isSupported") {
      DeviceCheckModule.isDeviceCheckSupported
    }

    AsyncFunction("getDeviceToken") { () throws -> String in
      guard DeviceCheckModule.isDeviceCheckSupported else {
        throw DeviceCheckError.unsupportedPlatform
      }

      return try await DeviceCheckModule.generateToken()
    }
  }

  private static var isDeviceCheckSupported: Bool {
    #if canImport(DeviceCheck)
    if #available(iOS 11.0, *) {
      return DCDevice.current.isSupported
    }
    #endif
    return false
  }

  private static func generateToken() async throws -> String {
    #if canImport(DeviceCheck)
    guard #available(iOS 11.0, *) else {
      throw DeviceCheckError.unsupportedPlatform
    }

    return try await withCheckedThrowingContinuation { continuation in
      DCDevice.current.generateToken { token, error in
        if let error {
          continuation.resume(throwing: DeviceCheckError.tokenFailed(reason: error.localizedDescription))
          return
        }

        guard let token, !token.isEmpty else {
          continuation.resume(throwing: DeviceCheckError.tokenFailed(reason: "Token creation failure"))
          return
        }

        continuation.resume(returning: token.base64EncodedString())
      }
    }
    #else
    throw DeviceCheckError.unsupportedPlatform
    #endif
  }
}

private enum DeviceCheckError: Error, CodedError, LocalizedError {
  case unsupportedPlatform
  case tokenFailed(reason: String)

  var code: String {
    switch self {
    case .unsupportedPlatform:
      return "ERR_EXPO_DEVICE_CHECK_UNAVAILABLE"
    case .tokenFailed:
      return "ERR_EXPO_DEVICE_CHECK_TOKEN_FAILED"
    }
  }

  var errorDescription: String? {
    switch self {
    case .unsupportedPlatform:
      return DeviceCheckError.decorate("DeviceCheck API is not available on this device.")
    case let .tokenFailed(reason):
      return DeviceCheckError.decorate(reason)
    }
  }

  private static func decorate(_ message: String) -> String {
    #if targetEnvironment(simulator)
    return "\(message) (DeviceCheck API unsupported in simulator)"
    #else
    return message
    #endif
  }
}
