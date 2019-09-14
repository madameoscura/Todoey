//
//  AppDelegate.swift
//  Todoey
//
//  Created by Annekatrin Dunkel on 9/11/19.
//  Copyright © 2019 Annekatrin Dunkel. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

//gets called when app gets loaded up
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
 
        return true

    }

    func applicationWillTerminate(_ application: UIApplication) {

        self.saveContext()
    }
    
    // MARK: - Core Data stack
   
    // in NSPersistentContainer (that we create using our CoreDataModel) we will store all of our data --> for default it is SQLite Database
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    // support in saving our data once app gets terminated
    // context is an area where you can change and update your data so you can undo and redo until you're happy with your data and then you can save the data that's in your context or your temporary area to the container which is for permanent storage.
    //context is similar to github staging area
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {

                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

