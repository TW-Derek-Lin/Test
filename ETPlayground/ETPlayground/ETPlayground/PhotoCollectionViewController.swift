//
//  PhotoCollectionViewController.swift
//  ETPlayground
//
//  Created by Dong Han Lin on 2018/11/2.
//  Copyright © 2018 Dong Han Lin. All rights reserved.
//

import UIKit

private let reuseIdentifier = "cellIdentifier"

class PhotoCollectionViewController: UICollectionViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    var albumIndex : Int = 0
    var albumName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = albumName
        
        self.view.backgroundColor = UIColor.white
        self.collectionView.backgroundView?.backgroundColor = UIColor.white
        
        self.collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhotoAction))
        
        let itemWidth =  ((min(self.collectionView.bounds.size.width, self.collectionView.bounds.size.height)) / 4.0)
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0);
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: itemWidth,
                                 height: itemWidth)
        self.collectionView.collectionViewLayout = layout
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    @objc func addPhotoAction() {
        
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let defaultImagePicker = UIImagePickerController()
                defaultImagePicker.delegate = self
                defaultImagePicker.sourceType = .camera
                defaultImagePicker.allowsEditing = false
                self.present(defaultImagePicker, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Albums", style: .default, handler: { (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let defaultImagePicker = UIImagePickerController()
                defaultImagePicker.delegate = self
                defaultImagePicker.sourceType = .photoLibrary
                defaultImagePicker.allowsEditing = false
                self.present(defaultImagePicker, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
        }))
        self.present(actionSheet, animated: true)
    }

    func scaleImage(image: UIImage) -> UIImage? {

        let newSize : CGFloat = 200.0
        var scaletransform : CGAffineTransform!
        var origin : CGPoint!
        
        if image.size.width > image.size.height {
            let scaleRatio = newSize / image.size.height
            scaletransform = CGAffineTransform(scaleX: scaleRatio, y: scaleRatio)
            origin = CGPoint(x: -(image.size.width - image.size.height) / 2.0, y: 0)
        }else {
            let scaleRatio = newSize / image.size.width
            scaletransform = CGAffineTransform(scaleX: scaleRatio, y: scaleRatio)
            origin = CGPoint(x: 0, y: -(image.size.height - image.size.width) / 2.0)
        }
        let size = CGSize(width: newSize, height: newSize)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        context!.concatenate(scaletransform);
        image.draw(at: origin)
        
        let returnImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return returnImage ?? nil
    }
    
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        PhotoCacheContoller.shared.addImageToAlbum(albumIndex: self.albumIndex, albumName: self.albumName, image: image)
        self.collectionView.reloadData()
        dismiss(animated:true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (PhotoCacheContoller.shared.photoCollection[albumIndex].1).count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        let image = PhotoCacheContoller.shared.getImageFromAlbum(albumIndex: self.albumIndex, photoIndex: indexPath.row)
        cell.thumbnailView.image = self.scaleImage(image: image!)
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoVC = PhotoDisplayViewController(nibName: "PhotoDisplayViewController", bundle: nil)
        photoVC.albumName = self.albumName
        photoVC.albumIndex = self.albumIndex
        photoVC.currentPageIndex = indexPath.row
        self.navigationController?.pushViewController(photoVC, animated: true)
    }
}
