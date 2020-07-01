//
//  UndoRedoTestViewController.swift
//  SwiftNewDemo
//
//  Created by bjhl on 2020/6/5.
//  Copyright © 2020 Albert. All rights reserved.
//

import UIKit

class UndoRedoTestViewController: UIViewController {
    var undoView = UndoRedoTestView()
    
    // MARK: - Init & Deinit

    // MARK: - Lifecyce
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        testUndoRedoView()
        undoView.manager?.beginUndoGrouping()
        undoView.setBackGroundColor(.blue)
        undoView.setBackGroundColor(.orange)
        undoView.setBackGroundColor(.gray)
        undoView.manager?.endUndoGrouping()
    }
    
    // MARK: - UI
    private func setupUI() {
        
    }

    // MARK: - Public

    // MARK: - Pravite
    func testUndoRedoView() {
         undoView.frame = CGRect(x: 100, y: 100, width: 200, height: 200)
         view.addSubview(undoView)
     }
    
    // MARK: - Networks
    
    // MARK: - Events
    @IBAction func undoAction() {
        undoManager?.undo()
    }
    
    @IBAction func redoAction() {
        undoManager?.redo()
    }
    // MARK: - Notifications
    
    // MARK: - Lazy load
}
