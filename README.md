# Sharpsell iOS SDK

## SDK Integrations

There are 2 steps involved in adding the sharpsell SDK in your project.

1. **Add the Sharpsell Swift Package** to the parent app
2. **Add Sharpsell local XCFrameworks in Framework, Libraries and Embedded content** in the parent
   app build settings.

### 1. Add the Sharpsell Swift Package

1. Add Sharpsell package [URL](https://github.com/enparadigm/SharpsellCore.git) as package
   dependency in you parent app. 
2. Choose Branch in the Dependency Rule then click choose "UpTo Next Major" in the versions and add 2.5.1 as a major version,
   then click Add Package button.This will add the sharpsell framework as a package dependency for
   your app

### 2.Add Local XCFrameworks in Framework, Libraries and Embedded content

1. Download the XCFramework from the link which is given by Sharpsell team and unzip it.

2. You will find debug and release folders. Inside the folders you will find the below xcframeworks
        1.App.xcframework
        2.Flutter.xcframework
        3.FBLPromises.xcframework
        4.sharpsell.xcframework
        4. FMDB.xcframework

3. In order to run in iOS Simulators, we need to use debug version.So, if you are testing the app in
   simulator then use XCFramrworks which is available in Debug Folder.

4. Use XCFrameworks which is in Release folder when sharing a build or release the app to the app
   store. Debug frameworks will be slower compare with release framework.

5. Drag and drop all four XCFramework in **Framework, Libraries and Embedded content** section in
   project settings for your app target. All the frameworks will be added as **Embed & Sign**
   framework by default.

Make sure all other framework are in **Embed & Sign** .

## Testing sharpsell in iOS Simulators

**Note:** - Not supported in 2.5.1 version due to local depdency failures. We will be fixing this in the version.

In order to run in iOS Simulators, we need to use debug version.So, if you are testing the app in
simulator then use XCFramrworks which is available in Debug Folder and replace those into the
project as mentioned above.

**Note:** Make sure we are using release frameworks when sharing a build or release the app to the
app store. Debug frameworks will be slower compare with release framework.

## SDK functions

**Note:** `Import SharpsellCore` in the class or struct where ever you are trying access Sharpsell.

Make sure to call `createSmartSellEngine` and then `initialize` before calling any other SDK
functions.

### 1. createSmartSellEngine

This function used to initialise the object required by the SDK - So we its better to call this
function on app start preferably in `didFinishLaunchingWithOptions` function in `AppDelegate` class.

```Swift
 Sharpsell.services.createFlutterEngine()
```

### 2. Initializing the SDK

The SDK has to be initialized before calling any other methods of the SDK. On calling
the `Sharpsell.initialize` method, a success or failure status will be returned via a callback.
Sample code on how to initialize the SDK is given below.

```Swift
/* Initialize Sharpsell
 *
 * coreSdk -
 * country_code, user_meta, name, mobile_number, email is nullable
 * Rest of the fields are required when the app is run as a SDK
 * */
       // Note - If you don't have any of the below data then don't pass null, just pass empty strings
        let initSharpsellData: [String:Any] = [
            "company_code": "sample_sdk", // Company code given to you by sharpsell team
            "user_unique_id": "88888888888", // Mobile number of the user which you want to login into sharpsell
            "user_group_id": "1", // User Group ID given to you by sharpsell team
            "country_code": "",
            "user_meta": "", // If you have user meta, pass those as a string
            "name": "Surya", // User Name
            "mobile_number": "888888888", // User mobile number
            "email": "surya@sharpsell.ai"] // User Email Id
        
        Sharpsell.services.initialize(smartsellParameters: initSharpsellData) {
            //Flutter initialized succecfully
        } onFailure: { (errorMessage, smartsellError) in
            switch smartsellError {
            case .flutterError:
                debugPrint("Error Message: \(errorMessage)")
            case .flutterMethodNotImplemented:
                debugPrint("Error Message: Flutter Method Not Implemented")
            default:
                debugPrint("Error Message: UnKnown Error in \(#function)")
            }
        }
```

## Entry points in the SDK

#### Home Screen

```Swift
       Sharpsell.services.open(arguments: [:]){ (flutterViewController) in
            self.navigationController?.pushViewController(flutterViewController, animated: true)
        } onFailure: { (errorMessage, smartSellError) in
            switch smartSellError {
            case .flutterError:
                debugPrint("Error Message: \(errorMessage)")
            case .flutterMethodNotImplemented:
                debugPrint("")
            default:
                debugPrint("")
            }
        }
```

#### Presentation Screen

```Swift
     let presentationArgs = ["route" : "productPresentationInput",
                                "presentation_name" : presentationInputName,
                                "input_one" : presentationInputOne,
                                "input_two" : presentationInputTwo]
                                
       Sharpsell.services.open(arguments: presentationArgs){ (flutterViewController) in
            self.navigationController?.pushViewController(flutterViewController, animated: true)
        } onFailure: { (errorMessage, smartSellError) in
            switch smartSellError {
            case .flutterError:
                debugPrint("Error Message: \(errorMessage)")
            case .flutterMethodNotImplemented:
                debugPrint("")
            default:
                debugPrint("")
            }
        }
```

#### Launchpad Screen

```Swift
     let launchpadArgs = ["route" : "launchpad"]
                                
       Sharpsell.services.open(arguments: launchpadArgs){ (flutterViewController) in
            self.navigationController?.pushViewController(flutterViewController, animated: true)
        } onFailure: { (errorMessage, smartSellError) in
            switch smartSellError {
            case .flutterError:
                debugPrint("Error Message: \(errorMessage)")
            case .flutterMethodNotImplemented:
                debugPrint("")
            default:
                debugPrint("")
            }
        }
```

#### Marketing Collateral Screen

```Swift
     let mcDirArgs = ["route" : "mcDirectory"]
                                
       Sharpsell.services.open(arguments: mcDirArgs){ (flutterViewController) in
            self.navigationController?.pushViewController(flutterViewController, animated: true)
        } onFailure: { (errorMessage, smartSellError) in
            switch smartSellError {
            case .flutterError:
                debugPrint("Error Message: \(errorMessage)")
            case .flutterMethodNotImplemented:
                debugPrint("")
            default:
                debugPrint("")
            }
        }
```

#### Poster of the day Screen

```Swift
     let potdArgs = ["route" : "potd"]
                                
       Sharpsell.services.open(arguments: potdArgs){ (flutterViewController) in
            self.navigationController?.pushViewController(flutterViewController, animated: true)
        } onFailure: { (errorMessage, smartSellError) in
            switch smartSellError {
            case .flutterError:
                debugPrint("Error Message: \(errorMessage)")
            case .flutterMethodNotImplemented:
                debugPrint("")
            default:
                debugPrint("")
            }
       
```

#### Digital Visiting Card Screen

```Swift
     let dvcArgs = ["route" : "dvc"]
                                
       Sharpsell.services.open(arguments: dvcArgs){ (flutterViewController) in
            self.navigationController?.pushViewController(flutterViewController, animated: true)
        } onFailure: { (errorMessage, smartSellError) in
            switch smartSellError {
            case .flutterError:
                debugPrint("Error Message: \(errorMessage)")
            case .flutterMethodNotImplemented:
                debugPrint("")
            default:
                debugPrint("")
            }
       
```

#### Timer Challenge Home Screen

```Swift
     let tcHomeArgs = ["route" : "tcHome"]
                                
       Sharpsell.services.open(arguments: tcHomeArgs){ (flutterViewController) in
            self.navigationController?.pushViewController(flutterViewController, animated: true)
        } onFailure: { (errorMessage, smartSellError) in
            switch smartSellError {
            case .flutterError:
                debugPrint("Error Message: \(errorMessage)")
            case .flutterMethodNotImplemented:
                debugPrint("")
            default:
                debugPrint("")
            }
 ```    

#### Product Bundle Screen

```Swift
     let productBundleArgs = ["route" : "productBundle"]
                                
       Sharpsell.services.open(arguments: productBundleArgs){ (flutterViewController) in
            self.navigationController?.pushViewController(flutterViewController, animated: true)
        } onFailure: { (errorMessage, smartSellError) in
            switch smartSellError {
            case .flutterError:
                debugPrint("Error Message: \(errorMessage)")
            case .flutterMethodNotImplemented:
                debugPrint("")
            default:
                debugPrint("")
            }
 ```  

#### Quick Links Screen

```Swift
     let quickLinksArgs = ["route" : "quickLinks"]
                                
       Sharpsell.services.open(arguments: quickLinksArgs){ (flutterViewController) in
            self.navigationController?.pushViewController(flutterViewController, animated: true)
        } onFailure: { (errorMessage, smartSellError) in
            switch smartSellError {
            case .flutterError:
                debugPrint("Error Message: \(errorMessage)")
            case .flutterMethodNotImplemented:
                debugPrint("")
            default:
                debugPrint("")
            }
 ```

#### Logout and clear user data

Make sure the `Sharpsell.services.clearData` is called when the user is logging out of the
application.

```Swift
      Sharpsell.services.clearData {
                //Handle logut success
            } onFailure: { message, errorType in
                //Logut Failed
            }
```
