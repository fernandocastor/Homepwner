//
//  ImageStore.swift
//  Teste
//
//  Created by Fernando Castor on 30/01/15.
//  Copyright (c) 2015 UFPE. All rights reserved.
//

import Foundation
import UIKit

private var sharedStoreInternal: ImageStore = ImageStore();

class ImageStore : NSObject {

    var dictionary: [String: UIImage] = Dictionary()
    
    private override init() {
        super.init()
    }
    
    // In a real system, this method should be thread-safe.
    class func sharedStore() -> ImageStore {
        return sharedStoreInternal;
    }
    
    func setImage(image:UIImage?, key:NSString){
        if let imageOk = image as UIImage? {
            self.dictionary[key] = imageOk
        }
    }
    
    func imageForKey(key:NSString) -> UIImage? {
        return self.dictionary[key]
    }
    
    func deleteImageForKey(key:NSString) {
        self.dictionary.removeValueForKey(key);
    }
}
