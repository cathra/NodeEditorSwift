//
//  NodeGraphView.swift
//  ShaderNodeEditor
//
//  Created by Justin Fincher on 12/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

import Foundation
import UIKit

public protocol NodeGraphViewDelegate: AnyObject
{
    func nodeGraphView(nodeGraphView: NodeGraphView, frameForNodeWithIndex: String) -> CGRect
    func nodeGraphView(nodeGraphView: NodeGraphView, didSelectNodeWithIndex: String)
}

public protocol NodeGraphViewDataSource: AnyObject
{
    func nodeGraphView(nodeGraphView: NodeGraphView, nodeWithIndex: String) -> NodeView?
    func numberOfNodes(in: NodeGraphView) -> Int
    func delete(node: NodeData) -> Void
    func requiredViewController() -> NodeEditorViewController
}

public class NodeGraphView: UIView, NodeGraphContainerViewDelegate
{
    var containerView : NodeGraphContainerView?
    var drawRectView : NodeGraphDrawRectView?
    weak var delegate: NodeGraphViewDelegate?
    weak var dataSource: NodeGraphViewDataSource?
    weak var parentScrollView: NodeGraphScrollView?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.postInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.postInit()
    }
    
    required init(frame: CGRect, parentScrollView: NodeGraphScrollView)
    {
        super.init(frame: frame)
        self.parentScrollView = parentScrollView
        self.postInit()
    }
    
    func postInit() -> Void
    {
        backgroundColor = UIColor.init(displayP3Red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        containerView = NodeGraphContainerView(frame: self.bounds, nodeGraphView:self)
        if let containerView = containerView
        {
            self.addSubview(containerView)
            containerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            containerView.delegate = self
        }
        
        drawRectView = NodeGraphDrawRectView(frame: self.bounds, nodeGraphView:self)
        if let drawRectView = drawRectView
        {
            self.addSubview(drawRectView)
            drawRectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        }
    }
    
    func reloadData() -> Void
    {
        guard let containerView = containerView else
        {
            return
        }
        containerView.reloadData()
        
        guard let drawRectView = drawRectView else
        {
            return
        }
        drawRectView.reloadData()
    }
    
    public func nodeMoved(nodeGraphContainerView: NodeGraphContainerView)
    {
        if nodeGraphContainerView == self.containerView
        {
            self.drawRectView!.setNeedsDisplay()
        }
    }
    
    public func showNodeList(nodeGraphContainerView: NodeGraphContainerView, location: CGPoint)
    {
        let nodeListViewController : NodeListTableViewController = NodeListTableViewController()
        nodeListViewController.delegate = self.dataSource?.requiredViewController()
        let nodeListNaviController : UINavigationController = UINavigationController(rootViewController: nodeListViewController)
        nodeListNaviController.modalPresentationStyle = .popover
        
        guard let popoverViewController : UIPopoverPresentationController = nodeListNaviController.popoverPresentationController else
        {
            return
        }
        
        popoverViewController.sourceRect = CGRect.init(origin: location, size: CGSize.init(width: 1, height: 1))
        popoverViewController.sourceView = nodeGraphContainerView
        popoverViewController.delegate = nodeListViewController as UIPopoverPresentationControllerDelegate;
        self.dataSource?.requiredViewController().present(nodeListNaviController, animated: true, completion: {})
    }
}
