//
//  AppDelegate.swift
//  DotaBP
//
//  Created by 陈小奔 on 2016/12/7.
//  Copyright © 2016年 陈小奔. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //如果sandbox中有版本号或相同不显示，没有或不相同则显示
        /*
        NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *currentVersion = [[NSUserDefaults standardUserDefaults] valueForKey:@"banbenhao"];
        
        //NSLog(@"%@---%@",version,currentVersion);
        if (version != currentVersion) {
            BSTipsView *tipView = [BSTipsView tipsView];
            tipView.frame = self.window.bounds;
            [self.window addSubview:tipView];
            currentVersion = version;
            [[NSUserDefaults standardUserDefaults] setValue:currentVersion forKey:@"banbenhao"] ;
            //[[NSUserDefaults standardUserDefaults] synchronize];
        }*/
        //print("\(NSLocale.preferredLanguages[0])");//检测到你的语言设置不是中文，请设置为中文后重新打开

        let version : String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String;
        
        //print(version)
        var currentVersion : String? = UserDefaults.standard.value(forKey: "banbenhao") as! String?;
        
        //print(currentVersion)

        let curLang = NSLocale.preferredLanguages[0];
        
        if curLang.contains("zh-Hans") {
                //如果是中文就显示tips
            if currentVersion == nil || currentVersion! != version{
                //print("加载信息提示页")
                let tip = TipsView.init(frame: CGRect.init(x: 0, y: 0, width: (self.window?.bounds.width)!, height: (self.window?.bounds.height)!));
                self.window?.rootViewController?.view.addSubview(tip)
                
                currentVersion = version
                //print(currentVersion)
                UserDefaults.standard.set(currentVersion, forKey: "banbenhao");
                UserDefaults.standard.synchronize();
            } else {
            }
        
        } else {
            //如果不是中文则显示更改语言设置，提示去更改语言
            /*
            let settingUrl = NSURL(string: UIApplicationOpenSettingsURLString)!
            if UIApplication.shared.canOpenURL(settingUrl as URL)
            {
                //UIApplication.shared.openURL(settingUrl as URL)
                UIApplication.shared.open(settingUrl as URL, options: [:], completionHandler: nil)
                
            }
             */
            let setLang = SetLangView.init(frame: CGRect.init(x: 0, y: 0, width: (self.window?.bounds.width)!, height: (self.window?.bounds.height)!));
            self.window?.rootViewController?.view.addSubview(setLang)
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        //发送通知，通知语言改变，重新加载allHeroinfo
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //发送通知，通知语言改变，重新加载allHeroinfo
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

