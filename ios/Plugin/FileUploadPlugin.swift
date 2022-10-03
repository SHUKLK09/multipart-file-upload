import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(FileUploadPlugin)
public class FileUploadPlugin: CAPPlugin {
    private let implementation = FileUpload()

    @objc func uploadFile(_ call: CAPPluginCall) {

        debugPrint(call)
       
        guard let url = call.getString("url") else { return call.reject("Must provide a URL") }
        guard let _ = call.getString("filePath") else { return call.reject("Must provide a file path to upload file") }
        guard let _ = URL(string: url) else { return call.reject("Invalid URL") }
    
        do {
            try implementation.uploadFile(call)
        } catch let error {
            call.reject(error.localizedDescription)
        }
    }

    @objc func getPath(_ call: CAPPluginCall) {
        debugPrint(call)
        call.reject({error: 'Method not implemented'})
    }
}
