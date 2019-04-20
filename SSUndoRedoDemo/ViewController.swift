//
//  ViewController.swift
//  SSUndoRedoDemo
//
//  Created by Sweta on 19/04/19.
//  Copyright © 2019 Sweta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: ------  IBOutlet ------
    
    @IBOutlet weak var btnUndo:UIBarButtonItem!
    @IBOutlet weak var btnRedo:UIBarButtonItem!
    @IBOutlet weak var btnAdd:UIBarButtonItem!
    @IBOutlet weak var lbl:UILabel!
    
    //MARK: ------  Variables ------
    
    var object: Any = "None"
    var array = ["1. Java", "2. Android", "3. Swift", "4. Objective C", "5. Kotlin", "6. PHP", "7. .NET", "8. Python", "9. Ruby", "10. React Native"]
    var undoMng = UndoManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController
{
    func enableDisableUIControl() {
        self.btnUndo.isEnabled = self.undoMng.canUndo
        self.btnRedo.isEnabled = self.undoMng.canRedo
    }
    
    func resetData()
    {
        btnAdd.tag = -1
        object = "None"
        lbl.text = object as! String
        undoMng = UndoManager()
        self.enableDisableUIControl()
    }
}

//MARK: ------  UIButton Actions ------

extension ViewController
{
    //TODO: - Add
    @IBAction func btnAddAction(_ sender:UIBarButtonItem) {
        if btnAdd.tag < self.array.count - 1 {
            btnAdd.tag += 1
            self.setObject(array[btnAdd.tag])
        }
    }
    
    //TODO: - Undo
    @IBAction func btnUndoAction(_ sender:UIBarButtonItem) {
        if self.undoMng.canUndo {
            self.undoMng.undo()
        }
        self.enableDisableUIControl()
    }
    
    //TODO: - Redo
    @IBAction func btnRedoAction(_ sender:UIBarButtonItem) {
        if self.undoMng.canRedo {
            self.undoMng.redo()
        }
        self.enableDisableUIControl()
    }
    
    //TODO: - Group Created Done
    @IBAction func btnGroupAction(_ sender:UIButton) {
        if sender.title(for: .normal) == "Create Group" {
            sender.setTitle("Group Set", for: .normal)
            
            self.resetData()
            
            self.undoMng.groupsByEvent = false
            self.undoMng.beginUndoGrouping()
            
        }else if (sender.title(for: .normal) == "Group Set") {
            sender.setTitle("Create Group", for: .normal)
            
            self.undoMng.endUndoGrouping()
            self.undoMng.groupsByEvent = true
        }
    }
    
    //TODO: - SetObject
    @objc func setObject(_ newObject: Any) {
        
        let oldObject = object
        object = newObject
        
        // 1. First way to register Undo
        self.undoMng.registerUndo(withTarget: self, selector:
            #selector(self.setObject(_:)), object: oldObject)
        
        //        //2. Second way to register undo
        //        self.undoMng.registerUndo(withTarget: self, handler: { (targetSelf) in
        //            targetSelf.setObject(oldObject)
        //        })
        
        lbl.text = object as! String
        self.enableDisableUIControl()
    }
}
