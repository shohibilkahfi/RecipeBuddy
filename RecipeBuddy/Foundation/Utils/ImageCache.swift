//
//  ImageCache.swift
//  RecipeBuddy
//
//  Created by Orenda M1 on 14/08/25.
//

import UIKit

final class ImageCache {
    static let shared = NSCache<NSURL, UIImage>()
}
