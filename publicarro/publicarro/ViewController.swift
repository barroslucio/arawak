
import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource
{
    private var pageViewController: UIPageViewController?
    private let contentImages = ["pessoaIcon.pdf", "anuncianteIcon.pdf"]
    private let contentLabelTitles = ["Para o motorista...", "Para o anunciante..."]
    private let contentTextView = [
        "É uma forma de se relacionar com anunciantes prestando serviços de divulgação, ganhando uma gratificação financeira e uma lavagem de carro.",
        "Somos uma forma de expandir sua marca ou produto abrangendo todos os segmentos e classes sociais com uma propaganda que fica sempre ao nível dos olhos de motoristas e passageiros."
    ]
    
    @IBOutlet weak var btClose: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        createPageViewController()
        setupPageViewControl()
        btClose.layer.cornerRadius = 25
    }
    
    override func viewWillAppear(animated: Bool)
    {
        navigationController?.navigationBar.hidden = true
    }
    
    @IBAction func buttonTapped(sender: AnyObject)
    {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("AnunciosNavBar") 
        presentViewController(controller, animated: true, completion: nil)
    }
    
    @IBAction func button1(sender: AnyObject)
    {
        let controller = storyboard!.instantiateViewControllerWithIdentifier("CadastroView")
        addChildViewController(controller)
        UIView.transitionWithView(view, duration: 0.5, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {self.view.addSubview(controller.view)}, completion: nil)
    }
    
    private func createPageViewController()
    {
        pageViewController = (storyboard!.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController)
        pageViewController!.dataSource = self
        if contentImages.count > 0
        {
            pageViewController!.setViewControllers([getItemController(0)!], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        }
        pageViewController?.view.frame = CGRectMake(0, view.frame.width-300, view.frame.width, view.frame.height-120)
        addChildViewController(pageViewController!)
        view.addSubview(pageViewController!.view)
    }
    
    private func setupPageViewControl()
    {
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.grayColor()
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor.whiteColor()
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
    {
        let itemController = viewController as! PageItemController
        if itemController.itemIndex > 0
        {
            return getItemController(itemController.itemIndex!-1)
        }
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
    {
        let itemController = viewController as! PageItemController
        if itemController.itemIndex!+1 < contentImages.count
        {
            return getItemController(itemController.itemIndex!+1)
        }
        return nil
    }
    
    private func getItemController(itemIndex: Int) -> PageItemController?
    {
        if itemIndex < contentImages.count
        {
            let pageItemController = storyboard!.instantiateViewControllerWithIdentifier("ContentController") as! PageItemController
            pageItemController.itemIndex = itemIndex
            pageItemController.imageName = contentImages[itemIndex]
            pageItemController.labelName = contentLabelTitles[itemIndex]
            pageItemController.textTutorial = contentTextView[itemIndex]
            return pageItemController
        }
        return nil
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return contentImages.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return 0
    }
}