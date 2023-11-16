//
//  GoogleDriveAPIManager.swift
//  GoogleDriveAPIPrac
//
//  Created by 粘光裕 on 2023/11/16.
//

import Foundation

class GoogleDriveAPIManager {
    static let shared = GoogleDriveAPIManager()
    
    // URL for the Google Drive API
    private let url = URL(string: "https://www.googleapis.com/upload/drive/v3/files")!
    
    func testUploadFile(imageData: Data, callback: ((UploadFileResponse) -> Void)? = nil) {
        guard let accessToken = getCloudToken() else {
            return
        }
        guard let folderId = getCloudTestFolderID() else {
            return
        }
        // Prepare the URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/related; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // Create a multipart/form-data body
        var body = Data()
        
        // Append metadata
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Type: application/json; charset=UTF-8\r\n\r\n".data(using: .utf8)!)
        body.append("{\"name\": \"myimage_\(Int(Date().timeIntervalSince1970)).jpg\", \"parents\": [\"\(folderId)\"]}\r\n".data(using: .utf8)!)
        
        // Append image data
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)
        
        // Close the multipart body
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        // Set the HTTP body
        request.httpBody = body
        
        // Perform the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                let responseData = try JSONDecoder().decode(UploadFileResponse.self, from: data)
                // Use the parsed data
//                print("Response result: \(responseData)")
                callback?(responseData)
            } catch {
                print("Error decoding JSON response: \(error)")
            }
            
//            if let responseString = String(data: data, encoding: .utf8) {
//                print(responseString)
//            }
        }
        
        task.resume()
    }
    
    // MARK: Utilities
    private func getCloudToken() -> String? {
        // Define the name of your custom plist file
        let plistFileName = "googleCloudKey"
        
        // Access the main bundle to find the path for your plist
        if let path = Bundle.main.path(forResource: plistFileName, ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            
            // Now you can access values from the dictionary
            // Replace "YourKey" with the actual key you're interested in
            if let value = dict["googleCloudToken"] as? String {
                return value
            } else {
                print("Key not found.")
            }
        } else {
            print("Unable to locate \(plistFileName).plist file or it's not a Dictionary.")
        }
        return nil
    }

    private func getCloudTestFolderID() -> String? {
        // Define the name of your custom plist file
        let plistFileName = "googleCloudKey"
        
        // Access the main bundle to find the path for your plist
        if let path = Bundle.main.path(forResource: plistFileName, ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            
            // Now you can access values from the dictionary
            // Replace "YourKey" with the actual key you're interested in
            if let value = dict["testUploadFolderID"] as? String {
                return value
            } else {
                print("Key not found.")
            }
        } else {
            print("Unable to locate \(plistFileName).plist file or it's not a Dictionary.")
        }
        return nil
    }
}
