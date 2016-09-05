# PioneerNewsLibrary
A library for implementing a simple News app with multiple sections

##Features
* Have multiple sections of your news. (ex. Latest, Startups, Mobile, Social, etc.)
* Fading Feature Images
* Pull to refresh sections
* ImageCaching

![alt text](https://github.com/DiscoverPioneer/PioneerNewsLibrary/blob/master/Resources/news.PNG "Example during fading of feature images")

##Setup
 1. Add a podfile and add:<br><ul>
    <li>pod 'TabPageViewController' <br></li>
    <li>pod 'Fuzi', '~> 0.3.0' <br></li>
    <li>pod 'Kingfisher', '~> 2.4'</li>
    </ul>
 2. Add PioneerNewsLibrary Files to xcode project
 3. Add Code
````swift
let newsVC = self.createNewsContainerViewController()
containerVC.delegate = self
containerVC.dataSource = self
newsVC.presentInViewController(self, animated: true) {}
````
###DataSource
````swift
func newsContainerViewControllerShouldLoadStoryHTMLBody(newsContainerViewController: NewsContainerViewController) -> Bool
func newsContainerViewControllerSectionTitles(newsContainerViewController: NewsContainerViewController) -> [String]
func newsContainerViewController(newsContainerViewController: NewsContainerViewController, storiesAtIndex index: Int) -> [Story]
````
###Delegate
````swift
func newsContainerViewController(newsContainerViewController: NewsContainerViewController, refreshStoriesForSectionIndex index:Int, completion: (updatedStories: [Story]?) -> Void)
func newsContainerViewController(newsContainerViewController: NewsContainerViewController, didTapStory story: Story)
````

##To be added
* Day/Night Mode
* Foldable dropdown description of articles
