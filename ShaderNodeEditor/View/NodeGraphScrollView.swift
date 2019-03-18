//
//  NodeGraphScrollView.swift
//  ShaderNodeEditor
//
//  Created by Justin Fincher on 15/3/2019.
//  Copyright © 2019 ZHENG HAOTIAN. All rights reserved.
//

import UIKit

class NodeGraphScrollView: UIScrollView, UIScrollViewDelegate, UIGestureRecognizerDelegate
{
    var nodeGraphView : NodeGraphView?
    var canvasSize : CGSize = CGSize.zero
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.postInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.postInit()
    }
    
    init(frame: CGRect, canvasSize: CGSize)
    {
        super.init(frame: frame)
        self.canvasSize = canvasSize
        self.postInit()
    }
    
    func postInit() -> Void
    {
        self.backgroundColor = UIColor.init(displayP3Red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        self.isScrollEnabled = true
        self.maximumZoomScale = 1
        self.minimumZoomScale = 0.2
        nodeGraphView = NodeGraphView(frame: CGRect.init(origin: CGPoint.zero, size: canvasSize), parentScrollView: self)
        self.addSubview(nodeGraphView!)
        self.contentSize = (nodeGraphView?.frame.size)!
        self.delegate = self
        
        self.panGestureRecognizer.delegate = self
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return scrollView == self ? nodeGraphView : nil
    }
    
    // MARK: - UIGestureRecognizerDelegate
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchView = touch.view,
            touchView.isKind(of: NodeValueCustomView.self),
            let customValueView = touchView as? NodeValueCustomView,
            let nodeView = customValueView.nodeView,
            let data = nodeView.data,
            data.isSelected
        {
            return false
        }
        return true
    }
}
