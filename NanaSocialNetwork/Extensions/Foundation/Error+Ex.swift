//
//  Error+Ex.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/21/21.
//

import Foundation

extension NSError {
    static let unknown = NSError(domain: "",
                                 code: 0,
                                 userInfo: [NSLocalizedDescriptionKey : "Unknown error"])
}
