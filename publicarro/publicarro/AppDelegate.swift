
import UIKit
import CoreData
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    var locationManager: CLLocationManager?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        Parse.setApplicationId("DzJB0iDECJ4uHqKIxRw3jNRAjlDLD8blMINbatUS", clientKey: "t5uyClsR4eHjjN1JLHFpYgPbXiXjfeCCMmhqE2K1")
        
        
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        window?.tintColor = UIColor.blackColor()
        
        if PFUser.currentUser() != nil
        {
        
            // get your storyboard
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            // instantiate your desired ViewController
            let rootController = storyboard.instantiateViewControllerWithIdentifier("AnunciosTabBar") as! UITabBarController
            
            // Because self.window is an optional you should check it's value first and assign your rootViewController
            if self.window != nil {
                self.window!.rootViewController = rootController
            }
        }
        
        
        // permitindo permissao ao usuario para enviar notificacao
        
        let settings = UIUserNotificationSettings(forTypes: [.Alert, .Sound, .Badge], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(settings)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        if let launchOptions = launchOptions as? [String : AnyObject] {
            if let notificationDictionary = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey] as? [NSObject : AnyObject] {
                self.application(application, didReceiveRemoteNotification: notificationDictionary)
            }
        }
        
        
        


        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData)
    {
        
        if PFUser.currentUser() != nil
        {
            
            
            let installation = PFInstallation.currentInstallation()
            installation["user"] = PFUser.currentUser()
            installation.setDeviceTokenFromData(deviceToken)
            installation.saveInBackground()
            
        }
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNoticationsWithDeviceToken deviceToken: NSData) {
        print(deviceToken)
        
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
        print(error.description)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
    }
    
  
    func applicationDidBecomeActive(application: UIApplication) {
    }

    
    func applicationWillResignActive(application: UIApplication){}

    func applicationDidEnterBackground(application: UIApplication){}

    func applicationWillEnterForeground(application: UIApplication){}


    func applicationWillTerminate(application: UIApplication)
    {
        if managedObjectContext.hasChanges
        {
            do
            {
                try managedObjectContext.save()
            }
            catch
            {
                let nserror = error as NSError
                NSLog("ERRO = \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

    lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        return NSManagedObjectModel(contentsOfURL: NSBundle.mainBundle().URLForResource("publicarro", withExtension: "momd")!)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        do
        {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        }
        catch
        {
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = "There was an error creating or loading the application's saved data."
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            NSLog("ERRO = \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
}