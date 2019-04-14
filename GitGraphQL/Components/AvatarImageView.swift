//
//  AvatarImageView.swift
//  GitGraphQL
//
//  Created by Elex Lee on 4/10/19.
//  Copyright © 2019 Elex Lee. All rights reserved.
//

import UIKit

extension UIImageView {
    static let imageCache = NSCache<NSString, UIImage>()
}

class AvatarImageView: UIImageView {
    
    var imageUrlString: String?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureImage(from urlString: String) {
        imageUrlString = urlString
        let url = URL(string: urlString)!
        self.image = nil
        
        if let image = loadFromCache(from: urlString as NSString) {
            self.image = image
            return
        }

    
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            
            DispatchQueue.main.async() {
                let image = UIImage(data: data)
                if self.imageUrlString == urlString {
                    self.image = image
                }
                UIImageView.imageCache.setObject(image!, forKey: self.imageUrlString! as NSString)
            }
        }
    }
    
    private func loadFromCache(from key: NSString) -> UIImage? {
        if let image = UIImageView.imageCache.object(forKey: key) {
            return image
        }
        return nil
    }
    
    private func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
