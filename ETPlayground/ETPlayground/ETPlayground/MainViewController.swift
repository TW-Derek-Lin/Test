//
//  ViewController.swift
//  ETPlayground
//
//  Created by Dong Han Lin on 2018/11/2.
//  Copyright © 2018 Dong Han Lin. All rights reserved.
//

import UIKit

class MainViewController: UIViewController{

    var sectionSource = ["Feature","ReadMe"]
    var functionSource = ["Albums","製作相簿功能，頁面共有四頁，需求如下\n \n首頁:\n使用 UITableViewController 搭配 StaticCells\n兩個 Section (Feature & ReadMe) 各一個 Cell\nReadMe 的說明訧是本段文字本人，要隨行數變換高度\n \n相簿列表:\n可以新增相簿\nAdd Album 按鈕用程式碼產生，放在 table 的 tableFooterView\n相簿列表的 Cell 左滑可以刪除，使用原生 Cell 的 EditingStyle\n新增的相簿不用存 Disk，放 Memory 跟 App 的生命週期一起共存亡\n \n相片集合列表:\nNavigationBar 右邊加上 UIBarButtonItem，用原生 add Style\n新增相片彈出 Action Sheet 可選從相機或從相簿，使用 UIImagePickerController\n新增的相片在跟著相簿走，一樣不用存 Disk，放 Memory 跟 App 的生命週期一起共存亡\n \n相片瀏覽頁:\n相片瀏覽頁使用 UIPageViewController 處理，可以左右滑動\n每個相片可以放大縮小，最小一倍，最大兩倍，有原生方法可解決\n \n備註：\n以上所列功能皆不能引用任何第三方程式庫\n所有 UI 都要使用 AutoLayout 處理\n詳細 UI Flow 請參考精美 gif 檔"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension MainViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionSource[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = functionSource[indexPath.section]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        return cell
    }
}

extension MainViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.textLabel?.text == "Albums" {
            let albumVC = AlbumTableViewController(nibName: "AlbumTableViewController", bundle: nil)
            self.navigationController?.pushViewController(albumVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
