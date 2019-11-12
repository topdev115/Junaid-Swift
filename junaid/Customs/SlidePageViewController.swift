//
//  SlidePage.swift
//  CallRecorder
//
//  Created by Liao Fang on 3/6/19.
//  Copyright © 2019 tyorex.com. All rights reserved.
//

import UIKit

class SlidePageViewController: UIPageViewController {
    private(set) var pages: [UIViewController] = []
    
    fileprivate var currentPageIndex: Int = 0
    fileprivate var nextPageIndex: Int = 0
    fileprivate var transitionInProgress: Bool = false
    
    public var pageControl: UIPageControl? {
        return UIPageControl.appearance(whenContainedInInstancesOf: [UIPageViewController.self])
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        //dataSource = self
    }
    
    public convenience init(pages: [UIViewController], transitionStyle: UIPageViewController.TransitionStyle, interPageSpacing: Float = 0.0) {
        self.init(transitionStyle: transitionStyle,
                  navigationOrientation: .horizontal,
                  options: [UIPageViewController.OptionsKey.interPageSpacing: interPageSpacing])
        
        self.pages = pages
        setupPageView()
        setupPageControl()
    }
    
    
    fileprivate func setupPageView() {
        guard let firstPage = pages.first else { return }
        currentPageIndex = 0
        setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
    }
    
    fileprivate func setupPageControl() {
        pageControl?.currentPageIndicatorTintColor = UIColor.gray
        pageControl?.pageIndicatorTintColor = UIColor.lightGray
        pageControl?.backgroundColor = UIColor.clear
    }
    
    fileprivate func viewControllerAtIndex(_ index: Int) -> UIViewController {
        guard index < pages.count else { return UIViewController() }
        currentPageIndex = index
        return pages[index]
    }
    
    func changePage() {
        if currentPageIndex < pages.count - 1 {
            currentPageIndex += 1
        } else {
            currentPageIndex = 0
        }
        guard let viewController = viewControllerAtIndex(currentPageIndex) as UIViewController? else { return }
        if !transitionInProgress {
            transitionInProgress = true
            setViewControllers([viewController], direction: .forward, animated: true, completion: { finished in
                self.transitionInProgress = !finished
            })
        }
    }
    
}

// MARK: - UIPageViewControllerDelegate
extension SlidePageViewController: UIPageViewControllerDelegate {
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let viewController = pendingViewControllers.first as UIViewController?, let index = pages.index(of: viewController) as Int? else {
            return
        }
        nextPageIndex = index
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentPageIndex = nextPageIndex
        }
        nextPageIndex = 0
    }
    
}

// MARK: - UIPageViewControllerDataSource
extension SlidePageViewController: UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard var currentIndex = pages.index(of: viewController) as Int? else { return nil }
        if currentIndex > 0 {
            currentIndex = (currentIndex - 1) % pages.count
            return pages[currentIndex]
        } else {
            return nil
        }
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard var currentIndex = pages.index(of: viewController) as Int? else { return nil }
        if currentIndex < pages.count - 1 {
            currentIndex = (currentIndex + 1) % pages.count
            return pages[currentIndex]
        } else {
            return nil
        }
    }
    
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentPageIndex
    }
}
