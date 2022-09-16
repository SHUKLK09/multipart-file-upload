//
//  URL.swift
//  FileUploadSample
//

import UniformTypeIdentifiers
import MobileCoreServices

extension URL {

    var mimeType: String {
        if #available(iOS 14.0, *) {
            return UTType(filenameExtension: self.pathExtension)?.preferredMIMEType ?? "application/octet-stream"
        } else {
            // Fallback on earlier versions
            let pathExtension = self.pathExtension
                    if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as NSString, nil)?.takeRetainedValue() {
                        if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
                            return mimetype as String
                        }
                    }
                    return "application/octet-stream"
        }
    }

    @available(iOS 14.0, *)
    func contains(_ uttype: UTType) -> Bool {
        return UTType(mimeType: self.mimeType)?.conforms(to: uttype) ?? false
    }

}
