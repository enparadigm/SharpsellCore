//
//  SharpsellWrapper.swift
//  Sharpsell
//
//  Created by Surya on 19/12/21.
//

import Foundation
import Flutter
import FlutterPluginRegistrant
import os

//MARK: - Enum Declaration
fileprivate enum FlutterMethods: String{
    case initialize = "initialize"
    case open = "open"
    case showNotification = "show_notification"
    case clearData = "clear_data"
    case enableLogs = "enable_logs_in_production_sdk"
}

public enum SharpSellError: Error{
    case flutterEngineFailure
    case flutterError
    case flutterMethodNotImplemented
}

public struct SharpSellWrapper{
    
    //MARK: - Property Declaration
    var flutterEngine: FlutterEngine?
    var isFlutterEngineCreated = false
    private let flutterMethodChannelName = "sharpsell_flutter_channel"
    private let flutterEngineIdentifer = "sharpsell_flutter_engine"

    //MARK: - Init Declaration
    public init (){}

    //MARK: - Private Methods
    private func getFlutterViewController() throws -> FlutterViewController {
        guard let flutterEngine = self.flutterEngine else {
            NSLog("Sharpsell Error: Flutter Engine is nil.")
            throw SharpSellError.flutterEngineFailure
        }
        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        return flutterViewController
    }

    /// Creating Flutter method channel.
    private func getFlutterMethodChannel() throws -> FlutterMethodChannel{
        let methodChannel = FlutterMethodChannel(name: flutterMethodChannelName, binaryMessenger: try getFlutterViewController().binaryMessenger)
        return methodChannel
    }

    //MARK: - Public Methods
    /// Creating Flutter Engine to use the flutter screens in native.
    ///- Note: Try to avoid calling this function multiple times because creating the flutter engine again and again will cause an memory issue and you may face some lag in the UI.
    ///- Recommeded: Call this method in App delegatge if you using native iOS or call this in app landing function which will be called only once in the app life cycle
    public mutating func createFlutterEngine(){
            NSLog("Sharpsell: Creating Flutter Engine....")
//            os_log(.info, log: Log.tracking, "Creating Flutter Engine...")
        self.flutterEngine = FlutterEngine(name: flutterEngineIdentifer)
        guard let myengine = self.flutterEngine else {
            NSLog("Sharpsell Error: Flutter Engine not assigned")
            return
        }
        myengine.run()
        NSLog("Sharpsell: Flutter Engine Sucessfully Created!")
        GeneratedPluginRegistrant.register(with: myengine)
        isFlutterEngineCreated = true
    }

    /// initialize the flutter communication between native and flutter code
    /// - Parameters:
    ///   - data: Pass the smart sell credentaials with the need params
    ///   - onSuccess: Success colsure will be called on succful initialization
    ///   - onFailure: Failure closure will be called incase of any failure
    public func initialize(smartsellParameters: [String:Any],
                           onSucces: @escaping () -> (),
                           onFailure: @escaping (_ message: String,_ errorType: SharpSellError) -> ()){

        do {
            let flutterMethodChannel = try getFlutterMethodChannel()

            //Convert Dict to json
            if let theJSONData = try?  JSONSerialization.data(
                withJSONObject: smartsellParameters,
                options: .prettyPrinted),
               //Convert json to String
               let theJSONText = String(data: theJSONData,
                                        encoding: String.Encoding.ascii) {
                NSLog("Sharpsell: Calling initialize flutter invoke method.")
                flutterMethodChannel.invokeMethod(FlutterMethods.initialize.rawValue,
                                                  arguments: theJSONText) { (flutterResult) in
                    if flutterResult is FlutterError {
                        if let res = flutterResult as? FlutterError{
                            NSLog("Sharpsell Error: Initialize - Error Code : \(String(describing: res.code))")
                            NSLog("Sharpsell Error: Initialize - Error Messaoge : \(String(describing: res.message))")
//                            os_log(.error, log: Log.flutterError, "initialize: Error Code : %d", res.code)
//                            os_log(.error, log: Log.flutterError, "initialize: Error Messaoge : %{public}s", res.message ?? "")
                            onFailure(res.message ?? "Flutter Error", SharpSellError.flutterError)
                        }else {
                            NSLog("Sharpsell Error: Initialize - Flutter Error: UnKnown")
                        }

                    }
                    if FlutterMethodNotImplemented.isEqual(flutterResult){
                        NSLog("Sharpsell Error: Initialize - Method \(FlutterMethods.open.rawValue) is not implemented in Flutter SDK")
                        onFailure("Flutter method not implemented", SharpSellError.flutterMethodNotImplemented)
                        return
                    } else {
                        onSucces()
                    }
                }

            } else {
                NSLog("Sharpsell Error: Initialize - JSON Parsing failure")
            }
        } catch (SharpSellError.flutterEngineFailure){
            NSLog("Sharpsell Error: Initialize - Flutter Engine Not Available")
        } catch {
            NSLog("Sharpsell Error: Initialize - Flutter Engine Not Available")
        }
    }

    /// Opens the flutter home screen
    /// - Parameters:
    ///   - onSuccess: Success colsure will be called on succesfuly launching the flutter screen
    ///   - flutterViewController: On succeful invoke call, flutter view controller will be sent back. Use this to show the flutter screen in you app
    ///   - onFailure: Failure closure will be called incase of any failure
    ///   - message: Flutter error message
    ///   - errorType: Passing the smartSellError enum by using this you check the type of error
    public func open(arguments: [String: Any],
                     onSucess: @escaping (_ flutterViewController: UIViewController) -> (),
                     onFailure: @escaping (_ message: String,_ errorType: SharpSellError) -> ()){
        do {
            let flutterMethodChannel = try getFlutterMethodChannel()
            NSLog("Sharpsell : Calling Open flutter invoke method")

            //Convert json to String
            if let theJSONData = try?  JSONSerialization.data(
                withJSONObject: arguments,
                options:.prettyPrinted),
              //Convert Dict to json
            let theJSONText = String(data: theJSONData,
                                     encoding: String.Encoding.ascii) {

                flutterMethodChannel.invokeMethod(FlutterMethods.open.rawValue,
                                                  arguments: theJSONText) {  (flutterResult) in

                    if (flutterResult is FlutterError) {
                        if let res = flutterResult as? FlutterError{
                            NSLog("Sharpsell Error: open - Error Code : \(String(describing: res.code))")
                            NSLog("Sharpsell Error: open - Error Messaoge : \(String(describing: res.message))")
                            onFailure(res.message ?? "Flutter Error", SharpSellError.flutterError)
                        }else {
                            NSLog("Sharpsell Error: open - Flutter Error: UnKnown")
                        }
                    }

                    if FlutterMethodNotImplemented.isEqual(flutterResult){
                        NSLog("Sharpsell Error: open - Method \(FlutterMethods.open.rawValue) is not implemented in Flutter SDK")
                        onFailure("Flutter method not implemented", SharpSellError.flutterMethodNotImplemented)
                        return
                    } else {
                        do {
                            //Success
                            let flutterViewController = try getFlutterViewController()
                            onSucess(flutterViewController)
                        } catch (SharpSellError.flutterEngineFailure){
                            NSLog("Sharpsell Error: Open - Failed to get the FlutterVC due to flutterEngineFailure")
                        } catch {
                            NSLog("Sharpsell Error: Open - Failed to get the FlutterVC")
                        }

                    }
                }
            }

        } catch (SharpSellError.flutterEngineFailure){
            NSLog("Sharpsell Error: Open - Flutter Engine Not Available")
        } catch {
            NSLog("Sharpsell Error: Open - Flutter Engine Not Available")
        }
    }

    /// Use this function to handle the sharpsell notification
    /// - Parameters:
    ///   - onSuccess:
    ///   - onFailure: Failure closure will be called incase of any failure
    ///   - message: Flutter error message
    ///   - errorType: Passing the smartSellError enum by using this you check the type of error
    public func showNotification(onSucess: @escaping () -> (),
                          onFailure: @escaping (_ message: String,
                                                _ errorType: SharpSellError) -> ()){
        do {
            let flutterMethodChannel = try getFlutterMethodChannel()
            NSLog("Sharpsell: showNotification - Calling showNotification flutter invoke method")
            flutterMethodChannel.invokeMethod(FlutterMethods.showNotification.rawValue,
                                              arguments: nil) {  (flutterResult) in

                if (flutterResult is FlutterError) {
                    if let res = flutterResult as? FlutterError{
                        NSLog("Sharpsell Error: showNotification - Error Code : \(String(describing: res.code))")
                        NSLog("Sharpsell Error: showNotification - Error Messaoge : \(String(describing: res.message))")

                        onFailure(res.message ?? "Flutter Error", SharpSellError.flutterError)

                    }else {
                        debugPrint("Error:\(flutterResult ?? "")")
                    }
                }

                if FlutterMethodNotImplemented.isEqual(flutterResult){

                    NSLog("Sharpsell Error: showNotification - Method \(FlutterMethods.open.rawValue) is not implemented in Flutter SDK")

                    onFailure("Flutter method not implemented", SharpSellError.flutterMethodNotImplemented)
                    return
                } else {
                    onSucess()
                }
            }
        }catch (SharpSellError.flutterEngineFailure){
            NSLog("Sharpsell Error: showNotification - Flutter Engine Not Available")
        } catch {
            NSLog("Sharpsell Error: showNotification - Flutter Engine Not Available")
        }
    }

    /// Use this function to clear the smartsell data before logout or based on your usecase
    /// - Parameters:
    ///   - onSuccess: Success colsure will be called on succesfully Clearing the smartsell data
    ///   - onFailure: Failure closure will be called incase of any failure
    ///   - message: Flutter error message
    ///   - errorType: Passing the smartSellError enum by using this you check the type of error
    public func clearData(onSucess: @escaping () -> (),
                          onFailure: @escaping (_ message: String,_ errorType: SharpSellError) -> ()){
        do {
            let flutterMethodChannel = try getFlutterMethodChannel()
            NSLog("Sharpsell: clearData - Calling ClearData flutter invoke method")
            flutterMethodChannel.invokeMethod(FlutterMethods.clearData.rawValue,
                                              arguments: nil) {  (flutterResult) in

                if (flutterResult is FlutterError) {
                    if let res = flutterResult as? FlutterError{
                        NSLog("Sharpsell Error: clearData - Error Code : \(String(describing: res.code))")
                        NSLog("Sharpsell Error: clearData - Error Messaoge : \(String(describing: res.message))")

                        onFailure(res.message ?? "Flutter Error", SharpSellError.flutterError)

                    }else {
                        debugPrint("Error:\(flutterResult ?? "")")
                    }
                }

                if FlutterMethodNotImplemented.isEqual(flutterResult){

                    NSLog("Sharpsell Error: clearData - Method \(FlutterMethods.open.rawValue) is not implemented in Flutter SDK")

                    onFailure("Flutter method not implemented", SharpSellError.flutterMethodNotImplemented)
                    return
                } else {
                    onSucess()
                }
            }
        }catch (SharpSellError.flutterEngineFailure){
            NSLog("Sharpsell Error: clearData - Flutter Engine Not Available")
        } catch {
            NSLog("Sharpsell Error: clearData - Flutter Engine Not Available")
        }
    }
    
    /// enableLogs for the sharpsell app
    /// - Parameters:
    ///   - onSuccess: Success colsure will be called on succesfuly launching the flutter screen
    ///   - flutterViewController: On succeful invoke call, flutter view controller will be sent back. Use this to show the flutter screen in you app
    ///   - onFailure: Failure closure will be called incase of any failure
    ///   - message: Flutter error message
    ///   - errorType: Passing the smartSellError enum by using this you check the type of error
    public func enableLogs(forProd: Bool,
                     onSucess: @escaping (_ flutterViewController: UIViewController) -> (),
                     onFailure: @escaping (_ message: String,_ errorType: SharpSellError) -> ()){
        do {
            let flutterMethodChannel = try getFlutterMethodChannel()
            NSLog("Sharpsell : Calling enableLogs flutter invoke method")

//            //Convert json to String
//            if let theJSONData = try?  JSONSerialization.data(
//                withJSONObject: arguments,
//                options:.prettyPrinted),
//              //Convert Dict to json
//            let theJSONText = String(data: theJSONData,
//                                     encoding: String.Encoding.ascii) {

                flutterMethodChannel.invokeMethod(FlutterMethods.enableLogs.rawValue,
                                                  arguments: forProd) {  (flutterResult) in

                    if (flutterResult is FlutterError) {
                        if let res = flutterResult as? FlutterError{
                            NSLog("Sharpsell Error: enableLogs - Error Code : \(String(describing: res.code))")
                            NSLog("Sharpsell Error: enableLogs - Error Messaoge : \(String(describing: res.message))")
                            onFailure(res.message ?? "Flutter Error", SharpSellError.flutterError)
                        }else {
                            NSLog("Sharpsell Error: enableLogs - Flutter Error: UnKnown")
                        }
                    }

                    if FlutterMethodNotImplemented.isEqual(flutterResult){
                        NSLog("Sharpsell Error: enableLogs - Method \(FlutterMethods.enableLogs.rawValue) is not implemented in Flutter SDK")
                        onFailure("Flutter method not implemented", SharpSellError.flutterMethodNotImplemented)
                        return
                    } else {
                        do {
                            //Success
                            let flutterViewController = try getFlutterViewController()
                            onSucess(flutterViewController)
                        } catch (SharpSellError.flutterEngineFailure){
                            NSLog("Sharpsell Error: enableLogs - Failed to get the FlutterVC due to flutterEngineFailure")
                        } catch {
                            NSLog("Sharpsell Error: enableLogs - Failed to get the FlutterVC")
                        }

                    }
                }
//            }

        } catch (SharpSellError.flutterEngineFailure){
            NSLog("Sharpsell Error: enableLogs - Flutter Engine Not Available")
        } catch {
            NSLog("Sharpsell Error: enableLogs - Flutter Engine Not Available")
        }
    }
}

