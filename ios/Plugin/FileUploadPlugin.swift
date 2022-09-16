import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(FileUploadPlugin)
public class FileUploadPlugin: CAPPlugin {
    private let implementation = FileUpload()

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }

    @objc func uploadFile(_ call: CAPPluginCall) {

        debugPrint(call)
        // let url = call.getString("url") ?? ""
        // let filePath = call.getString("filePath") ?? ""
        // let fileKey = call.getString("fileKey") ?? "file"
        // let headers = (call.getObject("headers") ?? [:]) as! [String: String]
        // let params = (call.getObject("params") ?? [:]) as! [String: String]

        // guard let fileData = call.getObject("fileData") else {
        //     call.reject("Must provide an file data")
        //     return
        // }
        // call.resolve([
        //     "value": implementation.uploadFile(url: url, headers: headers, params: params, filePath: filePath, fileKey: fileKey, fileData: nil)
        // ])

        guard let url = call.getString("url") else { return call.reject("Must provide a URL") }
        guard let _ = call.getString("filePath") else { return call.reject("Must provide a file path to upload file") }
        guard let _ = URL(string: url) else { return call.reject("Invalid URL") }
        // guard let _ = FilesystemUtils.getFileUrl(fp, fd) else { return call.reject("Unable to get file URL") }
    
        do {
            try implementation.uploadFile(call)
        } catch let error {
            call.reject(error.localizedDescription)
        }
    }
}
