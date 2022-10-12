import Foundation
import Capacitor

@objc public class FileUpload: NSObject {

    @objc func uploadFile(_ call: CAPPluginCall) throws {

        debugPrint("uploadImage");
        // your image from Image picker, as of now I am picking image from the bundle
        guard let urlString = call.getString("url"),
              let url = URL(string: urlString)
        else {
            throw URLError(.badURL)
        }

        guard let filePath = call.getString("filePath"),
              let docData = self.loadFileFromLocalPath(filePath)
        else {
            return call.reject("Must provide a file path to upload file")
        }

        var urlRequest = URLRequest(url: url)

        let fileKey = call.getString("fileKey") ?? "file"
        let headers = (call.getObject("headers") ?? [:]) as! [String: String]
        let params = (call.getObject("params") ?? [:]) as! [String: String]

        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = "post"

        let bodyBoundary = "--------------------------\(UUID().uuidString)"
        urlRequest.addValue("multipart/form-data; boundary=\(bodyBoundary)", forHTTPHeaderField: "Content-Type")

        let requestData = createBodyWithParameters(parameters: params, filePathKey: fileKey, imageDataKey: docData, boundary: bodyBoundary, filePath: filePath)
        urlRequest.addValue("\(requestData.count)", forHTTPHeaderField: "content-length")
        urlRequest.httpBody = requestData

        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in

            if error != nil {
                return
            }
            call.resolve(self.handleResponse(data, httpUrlResponse as! HTTPURLResponse))
        }.resume()
    }

    private func handleResponse(_ data: Data?, _ response: HTTPURLResponse) -> [String:Any] {
        var output = [:] as [String:Any]

        output["status"] = response.statusCode
        output["headers"] = response.allHeaderFields
        output["url"] = response.url?.absoluteString

        guard let data = data else {
            output["data"] = ""
            return output
        }

        let contentType = (response.allHeaderFields["Content-Type"] as? String ?? "application/default").lowercased();

        if (contentType.contains("application/json") ) {
            output["data"] = parseJson(data);
        }

        return output
    }

    private func parseJson(_ data: Data) -> Any {
        do {
            return try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
        } catch {
            return error.localizedDescription
        }
    }

    private func loadFileFromLocalPath(_ localFilePath: String) -> Data ? {
        // let updatedPath = localFilePath.replacingOccurrences(of: "file:///", with: "")
        guard let url = URL(string: localFilePath)else {debugPrint("Failed to get file data")
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            debugPrint(error)
            debugPrint("Failed to get file data")
            return nil
        }
    }

    private func createBodyWithParameters(parameters: [String: String], filePathKey: String?, imageDataKey: Data?, boundary: String, filePath: String) -> Data {
        var body = Data();

        for (key, value) in parameters {
            body.appendString("--\(boundary)\r\n")
            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString("\(value)\r\n")
        }

        let filename = URL(fileURLWithPath: filePath).lastPathComponent
        let mimetype = URL(string: filePath)

        body.appendString("--\(boundary)\r\n")

        if let filePath = filePathKey, let imageData = imageDataKey {
            body.appendString("Content-Disposition: form-data; name=\"\(filePath)\"; filename=\"\(filename)\"\r\n")
            body.appendString("Content-Type: \(mimetype)\r\n\r\n")
            body.append(imageData)
            body.appendString("\r\n")
            body.appendString("--\(boundary)--\r\n")
        }
        return body
    }
}

extension Data {
    mutating func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
