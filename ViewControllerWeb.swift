//
//  ViewControllerWeb.swift
//  MapGD
//
//  Created by Mozzos on 16/1/14.
//  Copyright © 2016年 Mozzos. All rights reserved.
//

import UIKit

class ViewControllerWeb: UIViewController,UIWebViewDelegate{
    var string: String = String()
    var active = UIActivityIndicatorView ()
    var name = String()
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = false
        let webView = UIWebView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        
        let url = NSURL(string: string)
        webView.delegate = self
        webView.loadRequest(NSURLRequest(URL: url!))
        
        self.view.addSubview(webView)
        
        let rightbut : UIBarButtonItem = UIBarButtonItem.init(title: "分享", style:.Plain, target: self, action: #selector(ViewControllerWeb.shareMozzos))
        self.navigationItem.rightBarButtonItem = rightbut
        
        active = UIActivityIndicatorView.init(frame: CGRectMake(self.view.bounds.size.width / 2 - 10, self.view.bounds.size.height / 2 - 10, 30, 30))
        
        active.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        
        self.view .addSubview(active)
        active.startAnimating()
    }
//MARK : - 执行分享
    func shareMozzos (){
        //1.创建分享参数
        let shareParames = NSMutableDictionary()
        
        let imageArray : [UIImage] = [ UIImage.init(named: "shareImage")! ]
        shareParames.SSDKSetupShareParamsByText("即刻找到属于你的联合办公空间",
            images : imageArray,
            url : NSURL.init(string:string ),
            title : name,
            type : SSDKContentType.Auto)
        
        
        //2.进行分享
        let sheet : SSUIShareActionSheetController  =  ShareSDK.showShareActionSheet(self.view, items:nil, shareParams: shareParames) { (state : SSDKResponseState, platformType : SSDKPlatformType, userdata : [NSObject : AnyObject]!, contentEnity : SSDKContentEntity!, error : NSError!, end) -> Void in
            
            switch state{
                
            case SSDKResponseState.Success:
                self.showText("分享成功")
                print("分享成功klahsduivan;bdfnaiofdbnfpuiebrajv;jdfh;")
            case SSDKResponseState.Fail:
                self.showText("分享失败")
                print("分享失败,错误描述:\(error)")
            case SSDKResponseState.Cancel:  print("分享取消")
                
            default:
                break
            }
        }
    sheet.directSharePlatforms.addObject(SSDKPlatformType.TypeSinaWeibo.rawValue)
 
        
    }
//MARK : -  提示框
    func showText(titiletext : String){
        
        let alertController = UIAlertController(title: "提示", message: titiletext, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func webViewDidFinishLoad(webView: UIWebView) {
        active.stopAnimating()
        active.hidesWhenStopped = true 
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
