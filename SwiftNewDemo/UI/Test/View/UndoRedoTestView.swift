//
//  UndoRedoTestView.swift
//  SwiftNewDemo
//
//  Created by bjhl on 2020/6/5.
//  Copyright © 2020 Albert. All rights reserved.
//

import UIKit

class UndoRedoTestView: UIView {
    
    var manager: UndoManager?
    
    // MARK: - Init & Deinit
    override init(frame: CGRect) {
        super.init(frame: frame)
        manager = UndoManager()
        manager?.registerUndo(withTarget: self, handler: { (target) in
            self.backgroundColor = .orange
        })
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Lifecyce
       
    // MARK: - UI
    private func setupUI() {
       
    }
    
    // MARK: - Public
    func setBackGroundColor(_ color: UIColor) {
        backgroundColor = color
    }
    
    func undoAction() {
        manager?.undo()
    }
    
    func redoAction() {
        manager?.redo()
    }

    // MARK: - Pravite

    // MARK: - Networks

    // MARK: - Events

    // MARK: - Notifications

    // MARK: - Lazy load
}
