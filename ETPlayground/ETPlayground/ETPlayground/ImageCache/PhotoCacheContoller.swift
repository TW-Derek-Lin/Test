//
//  PhotoCacheContoller.swift
//  ETPlayground
//
//  Created by Dong Han Lin on 2018/11/2.
//  Copyright © 2018 Dong Han Lin. All rights reserved.
//

import UIKit

class PhotoCacheContoller {
    static let shared = PhotoCacheContoller()
    var photoCollection : [(String, Array<String>)] = Array()
    var cache = NSCache<AnyObject, AnyObject>()
    init() {
    }
    
    private func setImage(image: UIImage, imageID: String) {
        self.cache.setObject(image, forKey: imageID as AnyObject)
    }
    
    private func getImage(imageID: String) -> UIImage? {
        if let image =  (self.cache.object(forKey: imageID as AnyObject) as? UIImage) {
            return image
        }else{
            return nil
        }
    }
    
    private func removeImage(imageID: String) {
        self.cache.removeObject(forKey: imageID as AnyObject)
    }
    
    func addAlbum(albumName: String) {
        photoCollection.append((albumName, Array<String>()))
    }
    
    func removeAlbum(albumIndex: Int) {
        for imageID in (photoCollection[albumIndex].1) {
            self.removeImage(imageID: imageID)
        }
        photoCollection.remove(at: albumIndex)
    }
    
    func addImageToAlbum(albumIndex: Int, albumName: String, image: UIImage) {
        let imageID = self.createImageID(AlbumIndex: albumIndex, AlbumName: albumName)
        ((photoCollection[albumIndex]).1).append(imageID)
        self.setImage(image: image, imageID: imageID)
    }
    
    func getImageFromAlbum(albumIndex: Int, photoIndex: Int) -> UIImage? {
        let imageID = ((photoCollection[albumIndex]).1)[photoIndex]
        return self.getImage(imageID: imageID) ?? nil
    }
    
    private func createImageID(AlbumIndex: Int, AlbumName: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = formatter.string(from: Date())
        let ID = AlbumName + "_" + String(AlbumIndex) + "_" + dateString
        return ID
    }
}
