//
//  ViewController.swift
//  MyTodoList
//
//  Created by 原啓介 on 2016/06/10.
//  Copyright © 2016年 mycompany. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var todoList = [MyTodo]()
    @IBOutlet weak var tabelView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    let userDefaults = NSUserDefaults.standardUserDefaults()
        if let todoListData = userDefaults.objectForKey("todoList") as? NSData{
            if let storedTodoList = NSKeyedUnarchiver.unarchiveObjectWithData(todoListData) as? [MyTodo]{
                
            todoList.appendContentsOf(storedTodoList)
            }
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapAddButton(sender: AnyObject) {
        let alertController = UIAlertController(title: "TODOの追加",
                                                message: "TODOを入力してください",
                                                preferredStyle: UIAlertControllerStyle.Alert)
       
        alertController.addTextFieldWithConfigurationHandler(nil)
        
        let okAction = UIAlertAction(title: "OK",style: UIAlertActionStyle.Default) {
            (action:UIAlertAction) -> Void in
            if let textField = alertController.textFields?.first {
                
                let myTodo = MyTodo()
                
                myTodo.todoTitle = textField.text
                
                self.todoList.insert(myTodo, atIndex: 0)
                self.tabelView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0 ,inSection: 0)], withRowAnimation: UITableViewRowAnimation.Right)
                
                let data :NSData = NSKeyedArchiver.archivedDataWithRootObject(self.todoList)
            let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setObject(data, forKey: "todoList")
                userDefaults.synchronize()
            }
        }
    alertController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title:"CANCEL",style: UIAlertActionStyle.Cancel,handler:nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return todoList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("todoCell", forIndexPath: indexPath)
        let todo = todoList[indexPath.row]
        cell.textLabel!.text = todo.todoTitle
        if todo.todoDone{
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexpath indexPath: NSIndexPath) {
        let todo = todoList[indexPath.row]
        if todo.todoDone {
            todo.todoDone = false
        } else {
            todo.todoDone = true
        }
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        let data :NSData = NSKeyedArchiver.archivedDataWithRootObject(todoList)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(data, forKey: "todoList")
        userDefaults.synchronize()
    }
    class MyTodo: NSObject, NSCoding {
        
        //Todoのタイトル
        var todoTitle :String?
        
        //Todoを完了したかどうかを表すフラグ
        var todoDone :Bool = false
        
        //コンストラクタ
        override init() {
            
        }
        
        //NSCodingプロトコルに宣言されているデシリアライズ処理。デコード処理とも呼びます。
        required init?(coder aDecoder: NSCoder) {
            todoTitle = aDecoder.decodeObjectForKey("todoTitle") as? String
            todoDone = aDecoder.decodeBoolForKey("todoDone")
        }
        
        //NSCodingプロトコルに宣言されているシリアライズ処理。エンコード処理とも呼びます。
        func encodeWithCoder(aCoder: NSCoder) {
            aCoder.encodeObject(todoTitle, forKey: "todoTitle")
            aCoder.encodeBool(todoDone, forKey: "todoDone")
        }}
}