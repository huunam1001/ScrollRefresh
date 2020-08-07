//
//  ViewController.swift
//  ScrollRefresh
//
//  Created by admin on 8/7/20.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UIScrollViewDelegate
{
    
     @IBOutlet weak var tblData:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblData.addRefreshView()
        
        tblData.delegate = self
    }
    
    @IBAction func endLoading(_ sender: Any)
    {
        tblData.finishRefreshData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        tblData.unfoldHeader()
    }
      
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if(scrollView.checkRefreshFlag())
        {
            tblData.freezeRefreshHeader()
        }
    }


}

