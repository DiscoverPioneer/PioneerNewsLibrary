//
//  ViewController.swift
//  News
//
//  Created by Phil Scarfi on 9/2/16.
//  Copyright © 2016 Pioneer Mobile Applications. All rights reserved.
//

import UIKit
import TabPageViewController
import SafariServices

protocol NewsContainerViewControllerDataSource {
    func newsContainerViewControllerShouldLoadStoryHTMLBody(newsContainerViewController: NewsContainerViewController) -> Bool
    func newsContainerViewControllerSectionTitles(newsContainerViewController: NewsContainerViewController) -> [String]
    func newsContainerViewController(newsContainerViewController: NewsContainerViewController, storiesAtIndex index: Int) -> [Story]
}

protocol NewsContainerViewControllerDelegate {
    func newsContainerViewController(newsContainerViewController: NewsContainerViewController, refreshStoriesForSectionIndex index:Int, completion: (updatedStories: [Story]?) -> Void)
    func newsContainerViewController(newsContainerViewController: NewsContainerViewController, didTapStory story: Story)

}

class NewsContainerViewController: UIViewController {
    var dataSource: NewsContainerViewControllerDataSource?
    var delegate: NewsContainerViewControllerDelegate?
    
    private var tabPageVC: TabPageViewController!
    var currentTabIndex: Int? {
        guard let viewController = tabPageVC?.viewControllers?.first else { return nil }
        return tabPageVC?.tabItems.map{ $0.viewController }.indexOf(viewController)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if tabPageVC == nil {
            createTabPageVC()
        }
        navigationController?.pushViewController(tabPageVC, animated: true)
        navigationController?.navigationBarHidden = true
        view.backgroundColor = UIColor.blackColor()
        navigationController?.navigationBar.translucent = false
        
        reloadData()
    }
    
    func createTabPageVC() {
        let tc = TabPageViewController.create()
        self.tabPageVC = tc
        tc.title = "News"
        tc.navigationItem.hidesBackButton = true
        
        var option = TabPageOption()
        option.defaultColor = UIColor.lightTextColor()
        option.tabBackgroundColor = UIColor.blackColor()
        option.pageBackgoundColor = UIColor.blackColor()
        option.currentColor = UIColor.whiteColor()
        tc.option = option
    }
    
    func reloadData() {
        if tabPageVC != nil {
            tabPageVC.tabItems = createViewControllers()
        } else {
            createTabPageVC()
            reloadData()
        }
    }

    func createViewControllers() -> [(viewController: UIViewController, title: String)] {
        let sections = dataSource?.newsContainerViewControllerSectionTitles(self) ?? [String]()
        return sections.map { name -> (viewController: UIViewController, title: String) in
            let viewController = SectionViewController()
            viewController.title = name
            viewController.delegate = self
            if let index = sections.indexOf(name), stories = dataSource?.newsContainerViewController(self, storiesAtIndex: index) {
                viewController.setSectionStories(stories)
            }
            return (viewController, name)
        }
    }
}

extension NewsContainerViewController: SectionViewControllerDelegate {
    func refreshStories(completion: (updatedStories: [Story]?) -> Void) {
        if let currentIndex = currentTabIndex {
            delegate?.newsContainerViewController(self, refreshStoriesForSectionIndex: currentIndex, completion: completion)
        } else {
            completion(updatedStories: nil)
        }
    }
    
    func sectionViewController(sectionViewController: SectionViewController, didTapStory story: Story) {
        delegate?.newsContainerViewController(self, didTapStory: story)
    }
    
    func loadStory(story: Story) {
        let storyboard = UIStoryboard(name: "PioneerNewsLibrary", bundle: nil)
        if let vc = storyboard.instantiateViewControllerWithIdentifier("FullStoryViewController") as? FullStoryViewController where dataSource?.newsContainerViewControllerShouldLoadStoryHTMLBody(self) == true {
            vc.story = story
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let svc = SFSafariViewController(URL: story.link)
            self.presentViewController(svc, animated: true, completion: nil)
        }
    }
}

extension NewsContainerViewController {
    func presentInViewController(vc: UIViewController, animated: Bool, completion:()->Void) {
        if let navController = navigationController {
            vc.presentViewController(navController, animated: animated, completion: completion)
        }
    }
    
    func dismissViewController(animated: Bool) {
        navigationController?.dismissViewControllerAnimated(animated, completion: nil)
    }
}

//Creation Helper
extension UIViewController {
    func createNewsContainerViewController() -> NewsContainerViewController {
        let storyBoard = UIStoryboard(name: "PioneerNewsLibrary", bundle: nil)
        let navController = storyBoard.instantiateViewControllerWithIdentifier("ContainerNavController") as! UINavigationController
        let rootVC = navController.viewControllers.first as! NewsContainerViewController
        return rootVC
    }
}



