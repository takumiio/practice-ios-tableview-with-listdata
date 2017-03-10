//
//  ViewController.swift
//  practice-ios-tableview-with-listdata
//
//  Created by Nishimura Takumi on 3/10/17.
//  Copyright © 2017 Nishimura Takumi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var myItems: [[String: Any]] = [[String: Any]]()
    private var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        
        let displayWidth: CGFloat = self.view.frame.width
        let displayHeight: CGFloat = self.view.frame.height
        
        myTableView = UITableView(frame: CGRect(
            x: 0, y: barHeight, width: displayWidth, height: displayHeight
        ))
        
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        
        Alamofire.request("https://7a97uho3bh.execute-api.ap-northeast-1.amazonaws.com/test/listdata").responseJSON(completionHandler: { rawResponse in
            
            let response = JSON(rawResponse.result.value)
            response.forEach { (_, json) in
                var data:[String: Any] = [String: Any]()
                data["id"] = json["id"].int64Value
                data["name"] = json["name"].stringValue
                self.myItems.append(data)
            }
            
            self.view.addSubview(self.myTableView)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("-----------------")
        print("Num: \(indexPath.row)")
        print("ID: \(myItems[indexPath.row]["id"])")
        print("NAME: \(myItems[indexPath.row]["name"])")
        print("-----------------")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
        cell.textLabel!.text = "\(myItems[indexPath.row]["name"] as! String)"
        return cell
    }

}

