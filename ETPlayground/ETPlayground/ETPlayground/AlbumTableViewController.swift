//
//  AlbumTableViewController.swift
//  ETPlayground
//
//  Created by Dong Han Lin on 2018/11/2.
//  Copyright © 2018 Dong Han Lin. All rights reserved.
//

import UIKit

class AlbumTableViewController: UITableViewController {
    
    lazy var footerButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        footerButton.setTitle("Add Album", for: .normal)
        footerButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        footerButton.setTitleColor(UIColor.darkText, for: .normal)
        footerButton.frame = CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: 100);
        footerButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        self.tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @objc func addAction() {
        let alert = UIAlertController(title: "Add Album", message: "please input album name", preferredStyle: .alert)
        alert.addTextField { (textField : UITextField) in
            textField.placeholder = "Album Name"
        }
        alert.addAction( UIAlertAction(title: "OK", style: .default, handler: { (action) in
            if let text = alert.textFields?.first?.text {
                if text != "" {
                    PhotoCacheContoller.shared.addAlbum(albumName: text)
                }else{
                    PhotoCacheContoller.shared.addAlbum(albumName: "NO Name")
                }
                self.tableView.reloadData()
            }
        }))
        self.present(alert, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PhotoCacheContoller.shared.photoCollection.count
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerButton
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
            cell.textLabel?.text = (PhotoCacheContoller.shared.photoCollection[indexPath.row].0)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            PhotoCacheContoller.shared.removeAlbum(albumIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let photoVC = PhotoCollectionViewController(nibName: "PhotoCollectionViewController", bundle: nil)
        photoVC.albumName = PhotoCacheContoller.shared.photoCollection[indexPath.row].0
        photoVC.albumIndex = indexPath.row
        self.navigationController?.pushViewController(photoVC, animated: true)
    }
    
}
