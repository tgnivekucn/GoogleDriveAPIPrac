//
//  ResponseStruct.swift
//  GoogleDriveAPIPrac
//
//  Created by 粘光裕 on 2023/11/16.
//

import Foundation

struct UploadFileResponse: Codable {
    let kind: String?
    let id: String?
    let name: String?
    let mimeType: String?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        kind = try container.decodeIfPresent(String.self, forKey: .kind)
        id = try container.decodeIfPresent(String.self, forKey: .id)
        name = try container.decodeIfPresent(String.self, forKey: .name)
        mimeType = try container.decodeIfPresent(String.self, forKey: .mimeType)
    }
}
