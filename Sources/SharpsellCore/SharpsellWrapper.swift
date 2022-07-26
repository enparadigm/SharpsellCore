//
//  SharpsellWrapper.swift
//  SharpsellCore
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
            NSLog("SharpsellCore Error: Flutter Engine is nil.")
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
            NSLog("SharpsellCore: Creating Flutter Engine....")
//            os_log(.info, log: Log.tracking, "Creating Flutter Engine...")
        self.flutterEngine = FlutterEngine(name: flutterEngineIdentifer)
        guard let myengine = self.flutterEngine else {
            NSLog("SharpsellCore Error: Flutter Engine not assigned")
            return
        }
        myengine.run()
        NSLog("SharpsellCore: Flutter Engine Sucessfully Created!")
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
                options:.prettyPrinted),
               //Convert json to String
               let theJSONText = String(data: theJSONData,
                                        encoding: String.Encoding.ascii) {
                NSLog("SharpsellCore: Calling initialize flutter invoke method.")
                flutterMethodChannel.invokeMethod(FlutterMethods.initialize.rawValue,
                                                  arguments: theJSONText) { (flutterResult) in
                    if flutterResult is FlutterError {
                        if let res = flutterResult as? FlutterError{
                            NSLog("SharpsellCore Error: Initialize - Error Code : \(String(describing: res.code))")
                            NSLog("SharpsellCore Error: Initialize - Error Messaoge : \(String(describing: res.message))")
//                            os_log(.error, log: Log.flutterError, "initialize: Error Code : %d", res.code)
//                            os_log(.error, log: Log.flutterError, "initialize: Error Messaoge : %{public}s", res.message ?? "")
                            onFailure(res.message ?? "Flutter Error", SharpSellError.flutterError)
                        }else {
                            NSLog("SharpsellCore Error: Initialize - Flutter Error: UnKnown")
                        }

                    }
                    if FlutterMethodNotImplemented.isEqual(flutterResult){
                        NSLog("SharpsellCore Error: Initialize - Method \(FlutterMethods.open.rawValue) is not implemented in Flutter SDK")
                        onFailure("Flutter method not implemented", SharpSellError.flutterMethodNotImplemented)
                        return
                    } else {
                        onSucces()
                    }
                }

            } else {
                NSLog("SharpsellCore Error: Initialize - JSON Parsing failure")
            }
        } catch (SharpSellError.flutterEngineFailure){
            NSLog("SharpsellCore Error: Initialize - Flutter Engine Not Available")
        } catch {
            NSLog("SharpsellCore Error: Initialize - Flutter Engine Not Available")
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
            NSLog("SharpsellCore : Calling Open flutter invoke method")

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
                            NSLog("SharpsellCore Error: Initialize - Error Code : \(String(describing: res.code))")
                            NSLog("SharpsellCore Error: Initialize - Error Messaoge : \(String(describing: res.message))")
                            onFailure(res.message ?? "Flutter Error", SharpSellError.flutterError)
                        }else {
                            NSLog("SharpsellCore Error: open - Flutter Error: UnKnown")
                        }
                    }

                    if FlutterMethodNotImplemented.isEqual(flutterResult){
                        NSLog("SharpsellCore Error: open - Method \(FlutterMethods.open.rawValue) is not implemented in Flutter SDK")
                        onFailure("Flutter method not implemented", SharpSellError.flutterMethodNotImplemented)
                        return
                    } else {
                        do {
                            //Success
                            let flutterViewController = try getFlutterViewController()
                            onSucess(flutterViewController)
                        } catch (SharpSellError.flutterEngineFailure){
                            NSLog("SharpsellCore Error: Open - Failed to get the FlutterVC due to flutterEngineFailure")
                        } catch {
                            NSLog("SharpsellCore Error: Open - Failed to get the FlutterVC")
                        }

                    }
                }
            }

        } catch (SharpSellError.flutterEngineFailure){
            NSLog("SharpsellCore Error: Open - Flutter Engine Not Available")
        } catch {
            NSLog("SharpsellCore Error: Open - Flutter Engine Not Available")
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
            NSLog("SharpsellCore: showNotification - Calling showNotification flutter invoke method")
            flutterMethodChannel.invokeMethod(FlutterMethods.showNotification.rawValue,
                                              arguments: nil) {  (flutterResult) in

                if (flutterResult is FlutterError) {
                    if let res = flutterResult as? FlutterError{
                        NSLog("SharpsellCore Error: Initialize - Error Code : \(String(describing: res.code))")
                        NSLog("SharpsellCore Error: Initialize - Error Messaoge : \(String(describing: res.message))")

                        onFailure(res.message ?? "Flutter Error", SharpSellError.flutterError)

                    }else {
                        debugPrint("Error:\(flutterResult ?? "")")
                    }
                }

                if FlutterMethodNotImplemented.isEqual(flutterResult){

                    NSLog("SharpsellCore Error: Initialize - Method \(FlutterMethods.open.rawValue) is not implemented in Flutter SDK")

                    onFailure("Flutter method not implemented", SharpSellError.flutterMethodNotImplemented)
                    return
                } else {
                    onSucess()
                }
            }
        }catch (SharpSellError.flutterEngineFailure){
            NSLog("SharpsellCore Error: showNotification - Flutter Engine Not Available")
        } catch {
            NSLog("SharpsellCore Error: showNotification - Flutter Engine Not Available")
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
            NSLog("SharpsellCore: clearData - Calling ClearData flutter invoke method")
            flutterMethodChannel.invokeMethod(FlutterMethods.clearData.rawValue,
                                              arguments: nil) {  (flutterResult) in

                if (flutterResult is FlutterError) {
                    if let res = flutterResult as? FlutterError{
                        NSLog("SharpsellCore Error: Initialize - Error Code : \(String(describing: res.code))")
                        NSLog("SharpsellCore Error: Initialize - Error Messaoge : \(String(describing: res.message))")

                        onFailure(res.message ?? "Flutter Error", SharpSellError.flutterError)

                    }else {
                        debugPrint("Error:\(flutterResult ?? "")")
                    }
                }

                if FlutterMethodNotImplemented.isEqual(flutterResult){

                    NSLog("SharpsellCore Error: Initialize - Method \(FlutterMethods.open.rawValue) is not implemented in Flutter SDK")

                    onFailure("Flutter method not implemented", SharpSellError.flutterMethodNotImplemented)
                    return
                } else {
                    onSucess()
                }
            }
        }catch (SharpSellError.flutterEngineFailure){
            NSLog("SharpsellCore Error: clearData - Flutter Engine Not Available")
        } catch {
            NSLog("SharpsellCore Error: clearData - Flutter Engine Not Available")
        }
    }
}

