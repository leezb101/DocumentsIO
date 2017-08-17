//
//  ViewController.swift
//  testDocuments
//
//  Created by leezb101 on 2017/8/17.
//  Copyright © 2017年 leezb101. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var fileDirPath = ""
    
    lazy var createButton: UIButton = { [unowned self] in
        let result = UIButton(type: .system)
        result.frame.size = CGSize(width: 60, height: 30)
        result.frame.origin = CGPoint(x: self.view.bounds.width / 2 - result.frame.width - 15, y: self.view.bounds.height / 2 - 15)
        result.setTitle("create", for: .normal)
        result.setTitleColor(.blue, for: .normal)
        result.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        result.addTarget(self, action: #selector(saveTextToTest), for: .touchUpInside)
        return result
        }()
    
    
    lazy var deleteButtn: UIButton = { [unowned self] in
        let result = UIButton(type: .system)
        result.frame.size = CGSize(width: 60, height: 30)
        result.frame.origin = CGPoint(x: self.createButton.frame.maxX + 30, y: self.createButton.frame.minY)
        result.setTitle("delete", for: .normal)
        result.setTitleColor(.blue, for: .normal)
        result.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        result.addTarget(self, action: #selector(removeTextToTest), for: .touchUpInside)
        return result
        }()
    
    lazy var readButton: UIButton = { [unowned self] in
        let result = UIButton(type: .system)
        result.frame.size = CGSize(width: 60, height: 30)
        result.frame.origin = CGPoint(x: self.createButton.frame.minX, y: self.createButton.frame.maxY + 10)
        result.setTitle("read", for: .normal)
        result.setTitleColor(.blue, for: .normal)
        result.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        result.addTarget(self, action: #selector(readTextToTest), for: .touchUpInside)
        return result
        }()
    
    lazy var appendButton: UIButton = { [unowned self] in
        let result = UIButton(type: .system)
        result.frame.size = CGSize(width: 60, height: 30)
        result.frame.origin = CGPoint(x: self.deleteButtn.frame.minX, y: self.readButton.frame.minY)
        result.setTitle("append", for: .normal)
        result.setTitleColor(.blue, for: .normal)
        result.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        result.addTarget(self, action: #selector(appendStringInText), for: .touchUpInside)
        return result
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(createButton)
        view.addSubview(deleteButtn)
        view.addSubview(readButton)
        view.addSubview(appendButton)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createDirectoryInDocuments()
        
    }
    func createDirectoryInDocuments() {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        fileDirPath = docPath.appending("/testOne")
        let manager = FileManager.default
        if !manager.fileExists(atPath: docPath.appending("/testOne")) {
            do { try manager.createDirectory(atPath: docPath.appending("/testOne"), withIntermediateDirectories: true, attributes: nil)

                let alertaA = UIAlertController(title: "Create!!!", message: fileDirPath, preferredStyle: .alert)
                let act1 = UIAlertAction(title: "ok", style: .default, handler: { (act) in
                })
                
                alertaA.addAction(act1)
                self.present(alertaA, animated: true, completion: nil)
                
            }catch {
                print(error.localizedDescription)
            }
        }else {
            let alertaA = UIAlertController(title: "Exsists...", message: fileDirPath, preferredStyle: .alert)
            let act1 = UIAlertAction(title: "ok", style: .default, handler: { (act) in
            })
            
            alertaA.addAction(act1)
            self.present(alertaA, animated: true, completion: nil)
        }
    }
    
    func saveTextToTest() {
        let testStr = "我的滑板鞋。。。摩擦摩擦，是魔鬼的步伐。。。哈哈哈哈哈"
        do {
            try testStr.write(toFile: fileDirPath.appending("/text.txt"), atomically: true, encoding: .utf8)
            
        }catch {
            let alert = UIAlertController(title: "Write error", message: error.localizedDescription, preferredStyle: .alert)
            let ac = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ac)
            present(alert, animated: true, completion: nil)
        }
    }

    func removeTextToTest() {
        let exsist = FileManager.default.fileExists(atPath: fileDirPath.appending("/text.txt"))
        if exsist {
            do {
                try FileManager.default.removeItem(atPath: fileDirPath.appending("/text.txt"))
            }catch {
                let alert = UIAlertController(title: "Delete error", message: error.localizedDescription, preferredStyle: .alert)
                let ac = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(ac)
                present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func readTextToTest() {
        do {
            let x = try String(contentsOfFile: fileDirPath.appending("/text.txt"), encoding: .utf8)
            let alert = UIAlertController(title: "Success", message: x, preferredStyle: .alert)
            let ac = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ac)
            present(alert, animated: true, completion: nil)
        } catch  {
            let alert = UIAlertController(title: "Delete error", message: error.localizedDescription, preferredStyle: .alert)
            let ac = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(ac)
            present(alert, animated: true, completion: nil)

        }
    }
    
    func appendStringInText() {
        let fileHandle = FileHandle(forUpdatingAtPath: fileDirPath.appending("/text.txt"))
        guard let fileHandler = fileHandle else { return }
        
        fileHandler.seekToEndOfFile()
        let appending = "这是一条追加数据。。。"
        fileHandler.write((appending.data(using: .utf8)!))
        fileHandler.closeFile()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

