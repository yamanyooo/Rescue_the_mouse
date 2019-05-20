//
//  StageSelectPage.swift
//  Rescue_the_mouse
//
//  Created by yohei on 2019/05/13.
//  Copyright © 2019年 yamanyon. All rights reserved.
//

import UIKit

class StageSelectPage: UIPageViewController, UIPageViewControllerDataSource{
    var stageSelectView: [StageSelectView] = []
    var viewFrame = CGRect(x:0,y:0,width:0,height:0)
    let mapFile: [String] = [
        "map001",
        "map002"
    ]

    
    /*    private var beforeIndex: Int = 0
     private var currentIndex: Int? {
     guard let viewController = viewControllers?.first else {
     return nil
     }
     return pageViewControllers.index(of: viewController)
     }
     */
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        let t: UIPageViewController.TransitionStyle = UIPageViewController.TransitionStyle.scroll
        super.init(transitionStyle: t, navigationOrientation: navigationOrientation, options: nil)
    }
    
    convenience init(frame: CGRect){
        self.init()
        viewFrame = frame
        self.view.frame = frame
        print(self.view.frame.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初期化処理など
        
        dataSource = self as! UIPageViewControllerDataSource
        
        for fileCnt in 0..<mapFile.count{
            stageSelectView.append(StageSelectView(frame: viewFrame, mapFileName: mapFile[fileCnt]))
        }
        setViewControllers(
            [stageSelectView[0]],
            direction: .forward,
            animated: false,
            completion: nil)
    }
}

extension StageSelectPage {
    
    private func nextViewController(viewController: UIViewController, isAfter: Bool) -> UIViewController? {
        guard var index = stageSelectView.index(of: viewController as! StageSelectView) else {
            return nil
        }
        
        if isAfter {
            index += 1
        } else {
            index -= 1
        }
        
        if index < 0 {
            index = stageSelectView.count - 1
        } else if index == stageSelectView.count {
            index = 0
        }
        
        if index >= 0 && index < stageSelectView.count {
            return stageSelectView[index]
        }
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nextViewController(viewController: viewController, isAfter: true)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nextViewController(viewController: viewController, isAfter: false)
    }
    
    
}
