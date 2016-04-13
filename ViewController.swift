
//
//  ViewController.swift
//  ownerMAP
//
//  Created by MozzosMP4 on 16/3/1.
//  Copyright © 2016年 MozzosMP4. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class ViewController: UIViewController,MKMapViewDelegate, UIGestureRecognizerDelegate,UISearchBarDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UITextFieldDelegate {
    
    let a = getUrlFromPlist()
    var lable = UILabel ()
    var choosenumber = Int ()
    var selectNumber = Int()
    var annArray = [MKPointAnnotation]()
    var mapAnnotation = MKPointAnnotation ()
    var map_view: MKMapView!
    // 加载数据信号
    var typeNumber = Int()
    
    var lastNumber = Int ()
//    var showLblae = UILabel ()
    
   // 显示大头针序号
    var annotataiontext = Int ()
    var currentLocationSpan = MKCoordinateSpan()
    
    var searchtext = NSString ()
    var wifeArr = AnyObject!()
//MARK: - 网络解析数据
    var recommendDataArray = AnyObject!()
    var recentDataArray = AnyObject!()
    
    var lastArray = NSDictionary()
//MARK: - 两个选择按钮
    var recommendBT = UIButton ()
    var recentBT = UIButton ()
    
//MARK: - 搜索框
    var searchBar = UISearchBar ()
    var viewsearch = UIView ()
    var resultView = UIView ()
    var searchArray = NSMutableArray()
    var searchtable_view = UITableView ()
    
    var table_view:UITableView!
    //加载数据数组
    var dataArray = AnyObject!()
    
    
    // 经纬度 double 类型 变量 x y
    var x = Double()
    var y = Double()
    
    
    // 代理方法返回的用户地理位置的经纬度
    var latitude1 = AnyObject!()
    var longitude1 = AnyObject!()
    var json = AnyObject!()
    
    var buttonH = CGFloat ()
    // 代理方法大头针气泡显示变量pointAnnotation
//    var pointAnnotation =
    
    var isOK = Bool ()
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        isOK  = false
        annotataiontext = 1
        typeNumber = 0
        choosenumber = 0
         self.navigationController?.navigationBar.backgroundColor = UIColor.clearColor()
        let item = UIBarButtonItem(title: "返回", style: .Plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            
        }
        else {
            locationManager.requestWhenInUseAuthorization()
        }
       
       
        initMapView()
        addsearchbar()
        getData()
        searchArray = NSMutableArray ()
        resultView = UIView.init(frame: CGRectMake(0, 64, self.view.bounds.size.width
            ,self.view.bounds.size.height   ))
        resultView.hidden = true
        resultView.backgroundColor = UIColor.whiteColor()
        searchtable_view = UITableView.init(frame: CGRectMake(0, 0, resultView.frame.width, resultView.frame.height), style: UITableViewStyle.Plain)
        searchtable_view.delegate = self
        searchtable_view.dataSource = self
        resultView .addSubview(searchtable_view)
        self.view .addSubview(resultView)
        
       
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//MARK: - view将要出现时
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationItem.titleView
    }
//MARK: - 添加搜索框
    func addsearchbar(){
        viewsearch = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 40))
        viewsearch.backgroundColor = UIColor.clearColor()
         searchBar = UISearchBar.init(frame: CGRectMake(0, 0, viewsearch.frame.size.width-20, 40))
        searchBar.placeholder = "搜索空间"
        searchBar.backgroundColor = UIColor.clearColor()
        searchBar.searchBarStyle = UISearchBarStyle.Minimal
        //设置颜色(有可能会影响搜索框的颜色)
        searchBar.barTintColor = UIColor.clearColor()
        //设置字体颜色(有可能影响搜索框内的光标的颜色)
        searchBar.tintColor = UIColor.blackColor()
        //是否显示透明度
        searchBar.translucent = true
        searchBar.showsScopeBar = false
        searchBar.delegate = self
        viewsearch.addSubview(searchBar)
        self.navigationItem.titleView = viewsearch
    
        
    }
//MARK: - 添加地图
    func initMapView(){
        map_view = MKMapView.init(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 150))
        self.map_view.delegate = self
        map_view.zoomEnabled = true
        map_view.scrollEnabled = true
//        let latDelta = 0.1
//        let longDelta = 0.1
//        currentLocationSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        //定义地图区域和中心坐标（
        //使用当前位置
//        let center:CLLocationCoordinate2D = locationManager.location!.coordinate
                let center:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 31.232758, longitude: 121.435756)
//        let currentRegion:MKCoordinateRegion = MKCoordinateRegion(center: center,
//            span: currentLocationSpan)
//        //
//        //        //设置显示区域

       map_view.showsUserLocation = true
       map_view.region = MKCoordinateRegionMakeWithDistance(center,500, 500)
        
        map_view.mapType = MKMapType.Standard
        map_view.userTrackingMode = MKUserTrackingMode.Follow
        self.view.addSubview(map_view)
        
        
        
    }
//MARK: - 添加选择按钮
    func addchooseBut(){
        recentBT = UIButton.init(type: UIButtonType.Custom)
        recentBT.frame = CGRect(x: self.view.frame.size.width/5*4, y:self.view.frame.size.height - buttonH - CGFloat(50), width: 40, height: 40)
        recentBT.backgroundColor = UIColor.clearColor()

        recentBT.setImage(UIImage.init(named: "image"), forState: UIControlState.Normal)
        recentBT.setImage(UIImage.init(named: "image1"), forState: UIControlState.Highlighted)
        recentBT.titleLabel?.font = UIFont.systemFontOfSize(12)
        recentBT.addTarget(self,action:Selector("tappedClosest:"),forControlEvents:.TouchUpInside)
        self.view?.addSubview(recentBT)
        
        
        recommendBT = UIButton(type: UIButtonType.Custom)
        recommendBT.frame = CGRect(x: self.view.frame.size.width/5*4, y:65, width: 40, height: 40)
        recommendBT.tag = 1000
        recommendBT.backgroundColor = UIColor.clearColor()
        recommendBT.setImage(UIImage.init(named: "recommended1"), forState: UIControlState.Normal)
        recommendBT.setImage(UIImage.init(named: "recommended2"), forState: UIControlState.Highlighted)
        recommendBT.titleLabel?.font = UIFont.systemFontOfSize(12)
        recommendBT.addTarget(self,action:Selector("tappedAccording:"),forControlEvents:.TouchUpInside)
        self.view?.addSubview(recommendBT)
        let lableranking = UILabel(frame: CGRect(x: 0, y: 25, width: 40, height: 15))
        lableranking.text = "推荐"
        lableranking.font = UIFont.systemFontOfSize(12)
        lableranking.textAlignment = NSTextAlignment.Center
        lableranking.textColor = UIColor(red:0.02, green:0.48, blue:1, alpha:1)
        recommendBT.addSubview(lableranking)
      
    }
//MARK: - 推荐
    func tappedAccording(button:UIButton){
        
        typeNumber = 0
        annotataiontext = 1
        if choosenumber != 1 {
            
            map_view.removeAnnotations(annArray)
            annArray = [MKPointAnnotation]()
        let latitude:AnyObject! = recommendDataArray.valueForKey("address")!.valueForKey("latitude")
        let longitude:AnyObject! = recommendDataArray.valueForKey("address")!.valueForKey("longitude")
        let nameArray:AnyObject! = recommendDataArray.valueForKey("name")
        let addressArray:AnyObject! = recommendDataArray.valueForKey("address")!.valueForKey("address")
        let addressArray1:AnyObject! = recommendDataArray.valueForKey("address")!.valueForKey("state")
        let addressArray2:AnyObject! = recommendDataArray.valueForKey("address")!.valueForKey("district")
//        // 定义大头针 创建本地json文件中的大头针并放在mapView上显示
        //        let arr :NSMutableArray = ["1","2","3"]
        for i in 0...latitude.count-1 {
            x = ((latitude.objectAtIndex(i).doubleValue) as Double)
            y = ((longitude.objectAtIndex(i).doubleValue) as Double)
            //初始化
            // 将本地获取的经纬度赋值给大头针
            self.x = ((latitude.objectAtIndex(i).doubleValue) as Double)
            self.y = ((longitude.objectAtIndex(i).doubleValue) as Double)
            //初始化
//            self.mapAnnotation = MKPointAnnotation ()
            self.mapAnnotation = MKPointAnnotation ()
            self.mapAnnotation.coordinate = CLLocationCoordinate2DMake(self.x, self.y);
            //大头针的标题
            self.mapAnnotation.title = (nameArray.objectAtIndex(i) as! String)
            //大头针的子标题
            self.mapAnnotation.subtitle = (addressArray1.objectAtIndex(i) as! String).stringByAppendingString(addressArray2.objectAtIndex(i) as! String).stringByAppendingString(addressArray.objectAtIndex(i) as! String)
            self.annArray.append(self.mapAnnotation)

        }
        self.map_view.addAnnotations(annArray)
        table_view .reloadData()
         choosenumber = 1
        }
    }
//MARK: - 最近
    func tappedClosest(button:UIButton){
        annotataiontext = 1
        let center:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 31.232758, longitude: 121.435756)
     map_view.region = MKCoordinateRegionMakeWithDistance(center,1000, 1000)
        //
        //        //设置显示区域
//        map_view.setRegion(currentRegion, animated: true)

        
        typeNumber = 1
    
        
        if isOK == false {
            if choosenumber != 2 {
                
            
            map_view.removeAnnotations(map_view.annotations)
            getDatafromMozzos()
            }
        }
        
        
        
    }
   
//MARK: - 地图大头针代理    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKindOfClass(MKPointAnnotation) {
            let Identifier = "annotation"
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(Identifier)
            if annotationView == nil {
                annotationView = MKAnnotationView.init(annotation: annotation, reuseIdentifier: Identifier)
            }
           
            annotationView?.annotation = annotation
            annotationView?.canShowCallout = true
            let name = "location"
            let imagename = name.stringByAppendingFormat("1")
            annotationView?.image = UIImage.init(named:imagename)
            
            
            lable  =  UILabel(frame: CGRect(x: 10, y: 10, width: 10, height: 15))
            lable.textColor = UIColor.blackColor()
            annotationView?.addSubview(lable)
       
            return annotationView
        }
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        return nil
        
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if tableView == searchtable_view {
            
            return searchArray.count
        }
        
        if typeNumber == 0 {
            
            return recommendDataArray.count
            
        }else if typeNumber == 1 {
            return recentDataArray.count
        }else if typeNumber == 3 {
            return 1
        }
        
        return 0
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let idefer : String  = "mycell"
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: idefer)
        let arr :NSMutableArray = ["ranking1","ranking2","ranking3"]
        
        
        
        if tableView == table_view {
            let informaiton: UIButton = UIButton(type: UIButtonType.Custom)
            informaiton.frame = CGRectMake(self.view.frame.size.width/1.26,self.view.frame.size.height/25,self.view.frame.size.width/6.25,self.view.frame.size.height/15)
            informaiton.tag = indexPath.row+10
            informaiton.layer.borderColor = (UIColor(red:0.02, green:0.48, blue:1, alpha:0.5)).CGColor
            informaiton.layer.borderWidth = 0.5
            //        buttonKVO.layer.cornerRadius = 30
            informaiton.setTitle("查看详情", forState: UIControlState.Normal)
            informaiton.backgroundColor = UIColor.whiteColor()
            informaiton.titleLabel?.font = UIFont.systemFontOfSize(12)
            informaiton.setTitleColor(UIColor(red:0.02, green:0.48, blue:1, alpha:1),forState: .Normal) //普通状态下文字的颜色
            informaiton.setTitleColor(UIColor.lightGrayColor(),forState: .Highlighted) //触摸状态下文字的颜色
            //        button.setTitleColor(UIColor.grayColor(),forState: .Disabled) //禁用状态下文字的颜色
            
            cell.addSubview(informaiton)
            let locationImage = UIImageView(image: UIImage(named: arr.objectAtIndex(indexPath.row) as! String))
            locationImage.backgroundColor = UIColor.whiteColor()
            locationImage.frame = CGRectMake(20, 30, 15, 20)
            cell.addSubview(locationImage)
            
            
            let addressImage = UIImageView()
            addressImage.frame = CGRectMake(cell.frame.size.width/7, 15, cell.frame.size.width/7, cell.frame.size.width/7)
            addressImage.layer.cornerRadius = cell.frame.size.width/7/2
            addressImage.backgroundColor = UIColor.blueColor()
            addressImage.layer.borderColor = UIColor.whiteColor().CGColor
            addressImage.layer.masksToBounds = true
            addressImage.layer.borderWidth = 0.5
            cell.addSubview(addressImage)
            
            let cityName:UILabel = UILabel(frame: CGRect(x: cell.frame.size.width/3.15, y: 15, width: 160, height: 30))
            cityName.font = UIFont.systemFontOfSize(15)
            cell.addSubview(cityName)
            
            let addressText:UILabel = UILabel(frame: CGRect(x: cell.frame.size.width/3.15, y: 45, width: 160, height: 20))
            addressText.font = UIFont.systemFontOfSize(12)
            addressText.textColor = UIColor.lightGrayColor()
            cell.addSubview(addressText)

            
            
            if typeNumber == 3 {
                let imagestring = lastArray.objectForKey("image")
                let iamge_url: String = imagestring!.stringByAppendingString("-vw240.jpg")
                let resoulturl : NSURL? = NSURL(string: iamge_url)
                addressImage.sd_setImageWithURL(resoulturl)
                cityName.text = lastArray.objectForKey("name") as? String
                addressText.text = lastArray.objectForKey("address") as? String
                
                informaiton.addTarget(self,action:Selector("tappedRecommended:"),forControlEvents:.TouchUpInside)
                return cell
            }
            
            if typeNumber == 0 {
                dataArray = recommendDataArray
            }else if typeNumber == 1
            {
                dataArray = recentDataArray
            }
            let name: AnyObject! = dataArray.valueForKey("name")
            let addressArray:AnyObject! = dataArray.valueForKey("address")!.valueForKey("address")
            let addressArray1:AnyObject! = dataArray.valueForKey("address")!.valueForKey("state")
            let addressArray2:AnyObject! = dataArray.valueForKey("address")!.valueForKey("district")
            let imageArray2:AnyObject! = dataArray.valueForKey("cover")
            
            let image_url: String = (imageArray2.objectAtIndex(indexPath.row) as! String).stringByAppendingString("-vw240.jpg")
            let resoult : NSURL? = NSURL(string: image_url)
            addressImage.sd_setImageWithURL(resoult)
            
            cityName.text = name.objectAtIndex(indexPath.row) as? String
            
            
            addressText.text = (addressArray1.objectAtIndex(indexPath.row) as! String).stringByAppendingString(addressArray2.objectAtIndex(indexPath.row) as! String).stringByAppendingString(addressArray.objectAtIndex(indexPath.row) as! String)
            informaiton.addTarget(self,action:#selector(ViewController.tappedDetails(_:)),forControlEvents:.TouchUpInside)
            
        }
        else if tableView == searchtable_view {
            
            cell.textLabel?.text = searchArray .objectAtIndex(indexPath.row) as? String
            
        }
        
        return cell
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == searchtable_view {
            
            return 44
        }
        return 80
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        if tableView == table_view {
            selectNumber = indexPath.row
            let valueArr1: AnyObject! = dataArray.valueForKey("address")
            let value1 = valueArr1.objectAtIndex(indexPath.row)
            map_view!.centerCoordinate = CLLocationCoordinate2DMake((value1.valueForKey("latitude")?.doubleValue)!, (value1.valueForKey("longitude")!.doubleValue)!)
//
            let latitude:AnyObject! = dataArray.valueForKey("address")!.valueForKey("latitude")
            let longitude:AnyObject! = dataArray.valueForKey("address")!.valueForKey("longitude")
            let nameArray:AnyObject! = dataArray.valueForKey("name")
            let addressArray:AnyObject! = dataArray.valueForKey("address")!.valueForKey("address")
            let addressArray1:AnyObject! = dataArray.valueForKey("address")!.valueForKey("state")
            let addressArray2:AnyObject! = dataArray.valueForKey("address")!.valueForKey("district")
            x = ((latitude.objectAtIndex(indexPath.row).doubleValue) as Double)
            y = ((longitude.objectAtIndex(indexPath.row).doubleValue) as Double)
            
            if annArray.count == 0 {
                let subann = MKPointAnnotation ()
                subann.coordinate = CLLocationCoordinate2DMake(x, y);
                //大头针的标题
                subann.title = (nameArray.objectAtIndex(indexPath.row) as! String)
                //大头针的子标题
                subann.subtitle = (addressArray1.objectAtIndex(indexPath.row) as! String).stringByAppendingString(addressArray2.objectAtIndex(indexPath.row) as! String).stringByAppendingString(addressArray.objectAtIndex(indexPath.row) as! String)
                self.map_view.addAnnotation(subann)
                map_view?.selectAnnotation(subann, animated: false)
                return
            }
      
            
            let subann : MKPointAnnotation = annArray[indexPath.row]
            // 将本地获取的经纬度赋值给大头针
//            mapAnnotation.coordinate = CLLocationCoordinate2DMake(x, y);
            //大头针的标题
            subann.title = (nameArray.objectAtIndex(indexPath.row) as! String)
            //大头针的子标题
            subann.subtitle = (addressArray1.objectAtIndex(indexPath.row) as! String).stringByAppendingString(addressArray2.objectAtIndex(indexPath.row) as! String).stringByAppendingString(addressArray.objectAtIndex(indexPath.row) as! String)
            map_view?.selectAnnotation(subann, animated: false)
            
        }else if tableView == searchtable_view {
            map_view.removeAnnotations(annArray)
            annArray = [MKPointAnnotation]()
           isOK = true 
            viewsearch.frame = CGRectMake(50, 0, self.view.frame.width-50, 40)
             selectNumber = indexPath.row
            searchBar.resignFirstResponder()
            let item = UIBarButtonItem(image: UIImage.init(named: "back"), style: .Plain, target: self, action:Selector("goback"))
            self.navigationItem.leftBarButtonItem = item;
            
            let searchString = searchArray.objectAtIndex(indexPath.row)
            
            searchtext = searchString as! NSString
            searchBar.text = searchtext as String
            let addressArray:AnyObject! = json.valueForKey("address")!.valueForKey("address")
            let addressArray1:AnyObject! = json.valueForKey("address")!.valueForKey("state")
            let addressArray2:AnyObject! = json.valueForKey("address")!.valueForKey("district")
            let name_Array : AnyObject! = json.valueForKey("name")
            let address_Array : AnyObject! = json.valueForKey("address")
            for i in 0...name_Array.count-1 {
                if searchString.isEqual(name_Array.objectAtIndex(i)) {
                    
                    let value = address_Array.objectAtIndex(i)
                   map_view!.centerCoordinate = CLLocationCoordinate2DMake((value.valueForKey("latitude")?.doubleValue)!, (value.valueForKey("longitude")!.doubleValue)!)
                    x = (value.valueForKey("latitude")?.doubleValue)!
                    y = (value.valueForKey("longitude")!.doubleValue)!
                    mapAnnotation = MKPointAnnotation()
                    mapAnnotation.coordinate = CLLocationCoordinate2DMake(x, y);
                    //大头针的标题
                    mapAnnotation.title = searchString as? String
                    //大头针的子标题
                    mapAnnotation.subtitle = (addressArray1.objectAtIndex(indexPath.row) as! String).stringByAppendingString(addressArray2.objectAtIndex(indexPath.row) as! String).stringByAppendingString(addressArray.objectAtIndex(indexPath.row) as! String)
                    map_view? .addAnnotation(mapAnnotation)
                 
                    map_view?.selectAnnotation(mapAnnotation, animated: false)
                    
                    
                    resultView.hidden = true
                    map_view.hidden = false
                    
                    lastNumber = typeNumber
                    typeNumber = 3
                    let imageurl : String = (json.valueForKey("cover")?.objectAtIndex(i))! as! String
                    let subtext  =   (addressArray1.objectAtIndex(i) as! String).stringByAppendingString(addressArray2.objectAtIndex(i) as! String).stringByAppendingString(addressArray.objectAtIndex(i) as! String)
                    
                    lastArray = ["name": searchString, "address": subtext,"image":imageurl];
                    
                    
                    recommendBT.hidden = true
                    map_view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)
                    table_view .frame = CGRectMake(0,self.view.bounds.size.height - 80,self.view.bounds.size.width, 80)
                    recentBT.frame = CGRect(x: self.view.frame.size.width/5*4, y:self.view.frame.size.height - 130, width: 40, height: 40)
                    table_view.reloadData()
                }
                
            }

            
        }
    }
//MARK: - 位置更新代理
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        map_view.centerCoordinate = (userLocation .location?.coordinate)!
            latitude1 = userLocation.location!.coordinate.latitude
            longitude1 = userLocation.location!.coordinate.longitude
        
    }
//MARK: - 获取数据cd open open o
    func getData(){
        //获取时间戳
        let string = time(nil)
        /// 获取墨社推荐空间的数据接口
        let recommendedUrl0 = String(string)
        let recommendedUrl1 = "timestamp="
        let recommendedUrl2 = recommendedUrl1.stringByAppendingString(recommendedUrl0)
        let recommendedUrl3 = recommendedUrl2.stringByAppendingString("&")
        let array = ["app_id=mozzos-ios&", recommendedUrl3]
        var languagesArr = array
        languagesArr.sortInPlace()
        let reco1 = languagesArr[0]
        let reco2 = languagesArr[1]
        let recommendedUrl4 = reco1.stringByAppendingString(reco2)
        let recommendedUrl5 =  recommendedUrl4.stringByAppendingString("secret=c9927f92742145275b680de5b487c4bb")
        let urlString1:String="https://api.mozzos.com/v1/space/promotions?"
        let urlString2 = urlString1.stringByAppendingString(recommendedUrl4)
        let urlString3 = urlString2.stringByAppendingString("token=")
        let urlString4 = urlString3.stringByAppendingString(recommendedUrl5.md5)
        let urlB:NSURL! = NSURL(string:urlString4)
        let nsDataB: NSData = NSData(contentsOfURL: urlB)!
        let jsonA = try? NSJSONSerialization.JSONObjectWithData(nsDataB, options: NSJSONReadingOptions.AllowFragments)
        recommendDataArray = jsonA?.valueForKey("data")
        
        ///  获取空间数据的借口拼接
        let stringL = String(string)
        let stringLL = "timestamp="
        let stringLLL = stringLL.stringByAppendingString(stringL)
        let stringLLLL = stringLLL.stringByAppendingString("&")
        let arr = ["app_id=mozzos-ios&", stringLLLL, "per_page=300&", "page=1&"]
        var languages = arr
        languages.sortInPlace()
        let s = languages[0]
        let s1 = languages[1]
        let s2 = languages[2]
        let s3 = languages[3]
        let s4 = s.stringByAppendingString(s1).stringByAppendingString(s2).stringByAppendingString(s3)
        let s5 = s4.stringByAppendingString("secret=c9927f92742145275b680de5b487c4bb")
        //      md5加密
        let urlString:String="http://api.mozzos.club:8080/v1/space/get?"
        let s6 = urlString.stringByAppendingString(s4)
        let s7 = s6.stringByAppendingString("token=")
        let s8 = s7.stringByAppendingString(s5.md5)
        let url:NSURL! = NSURL(string:s8)
        let nsData: NSData = NSData(contentsOfURL: url)!
        //获取本地json文件中的数据
        let JsonArr = try? NSJSONSerialization.JSONObjectWithData(nsData, options: NSJSONReadingOptions.AllowFragments)
        let JsonBrr = JsonArr?.valueForKey("data")
        json = JsonBrr?.valueForKey("spaces")
        wifeArr = json.valueForKey("name")
        
        
      //根据数据加载tablview 
        let tablviewH  = recommendDataArray.count * 80
        buttonH = CGFloat(Float(tablviewH))
        table_view = UITableView(frame: CGRectMake(0,self.view.bounds.size.height - CGFloat(Float(tablviewH)),self.view.bounds.size.width, CGFloat(Float(tablviewH))), style: UITableViewStyle.Plain)
        table_view.delegate = self
        table_view.dataSource = self
        self.view .addSubview(table_view)
        
         addchooseBut()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
         self.searchBar.resignFirstResponder()
        return true
    }
//MARK: - 取消搜索键盘响应
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       
        self.searchBar.resignFirstResponder()
    }
//MARK: - 监听搜索输入框
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == "" {
           resultView .hidden = true
           map_view .hidden = false
            
            if typeNumber == 3 {
                typeNumber = lastNumber
                
                table_view.reloadData()
                
            }
           return
           
        }else{
            resultView . hidden = false
            map_view.hidden = true
            
        }
        if searchArray.count > 0 {
            searchArray.removeAllObjects()
        }
        searchtable_view.reloadData()
        for i in 0...wifeArr.count-1 {
            if (wifeArr.objectAtIndex(i) as? String)!.rangeOfString(searchBar.text!) != nil {
                searchArray.addObject((wifeArr.objectAtIndex(i) as? String)!)
            }
            
        }
        if searchArray.count>0{
            searchtable_view .reloadData()
        }

        
        
    }
//MARK: - 获取附近的数据
    func getDatafromMozzos(){
        
        map_view.removeAnnotations(map_view.annotations)
        annArray = [MKPointAnnotation]()
        
        if latitude1 == nil {
        
        let alertController = UIAlertController(title: "提示", message: "正在定位中", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(okAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
          return 

        }
        let string = time(nil)
        let nssString0 = String(stringInterpolationSegment:latitude1)
        let nssString1 = String(stringInterpolationSegment:longitude1)
        let specify0 = String(string)
        let specify1 = "timestamp="
        let specify2 = specify1.stringByAppendingString(specify0)
        let specify3 = specify2.stringByAppendingString("&")
        let specify4 = nssString0
        let specify5 = nssString1
        let specify6 = "latitude="
        let specify7 = "longitude="
        let specify8 = specify6.stringByAppendingString(specify4)
        let specify9 = specify7.stringByAppendingString(specify5)
        let specify10 = specify8.stringByAppendingString("&")
        let specify11 = specify9.stringByAppendingString("&")
        let specifyArray = ["app_id=mozzos-ios&", specify3, specify10, specify11]
        var languagesArray = specifyArray
        languagesArray.sortInPlace()
        let specifySpace0 = languagesArray[0]
        let specifySpace1 = languagesArray[1]
        let specifySpace2 = languagesArray[2]
        let specifySpace3 = languagesArray[3]
        let specifySpace4 = specifySpace0.stringByAppendingString(specifySpace1).stringByAppendingString(specifySpace2).stringByAppendingString(specifySpace3)
        let specifySpace5 = specifySpace4.stringByAppendingString("secret=c9927f92742145275b680de5b487c4bb")
        let urlStringA:String="http://api.mozzos.club:8080/v1/space/nearby_spaces?"
        let urlStringB = urlStringA.stringByAppendingString(specifySpace4)
        let urlStringC = urlStringB.stringByAppendingString("token=")
        let urlStringD = urlStringC.stringByAppendingString(specifySpace5.md5)
        let urlC:NSURL! = NSURL(string:urlStringD)
        let urlRequest = NSURLRequest(URL: urlC!)
        NSURLConnection.sendAsynchronousRequest(urlRequest,queue:NSOperationQueue.mainQueue(),completionHandler: {
            (response: NSURLResponse?,data:NSData?,error:NSError?)-> Void in
            
            if error == nil && data?.length > 0{
                
                //获取本地json文件中的数据
                let valueA = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
                self.recentDataArray = valueA?.valueForKey("data")
                self.table_view .reloadData()
                let latitude:AnyObject! = self.recentDataArray.valueForKey("address")!.valueForKey("latitude")
                let longitude:AnyObject! = self.recentDataArray.valueForKey("address")!.valueForKey("longitude")
                let nameArray:AnyObject! = self.recentDataArray.valueForKey("name")
                let addressArray:AnyObject! = self.recentDataArray.valueForKey("address")!.valueForKey("address")
                let addressArray1:AnyObject! = self.recentDataArray.valueForKey("address")!.valueForKey("state")
                let addressArray2:AnyObject! = self.recentDataArray.valueForKey("address")!.valueForKey("district")
                
                // 定义大头针 创建本地json文件中的大头针并放在mapView上显示
                for i in 0...latitude.count-1 {
                    self.x = ((latitude.objectAtIndex(i).doubleValue) as Double)
                    self.y = ((longitude.objectAtIndex(i).doubleValue) as Double)
                    //初始化
                    self.mapAnnotation = MKPointAnnotation ()
                    self.mapAnnotation.coordinate = CLLocationCoordinate2DMake(self.x, self.y);
                    //大头针的标题
                   self.mapAnnotation.title = (nameArray.objectAtIndex(i) as! String)
                    
                    //大头针的子标题
                    self.mapAnnotation.subtitle = (addressArray1.objectAtIndex(i) as! String).stringByAppendingString(addressArray2.objectAtIndex(i) as! String).stringByAppendingString(addressArray.objectAtIndex(i) as! String)
                    self.lable.text = "\(i + 1)"
//                    print(annotataiontext)
                    self.annArray.append(self.mapAnnotation)
                    self.map_view.addAnnotation(self.mapAnnotation)
                   
                    
                }
//                self.map_view.addAnnotations(self.annArray)
                self.choosenumber = 2
            }
            
        }
            
        )
    
        
    }
//MARK: - 大头针按钮点击事件
//    func mapView(mapView:MKMapView, annotationView view: MKAnnotationView,
//        calloutAccessoryControlTapped control: UIControl) {
//            if isOK == true {
//                let viewOne:  ViewControllerWeb = ViewControllerWeb()
//                let valueArr: AnyObject! = json.valueForKey("name")
//                let valueArr1: AnyObject! = json.valueForKey("view_page_url")
//                for i in 0...valueArr.count-1 {
//                    if searchtext.isEqual(valueArr.objectAtIndex(i)) {
//                        viewOne.string = valueArr1.objectAtIndex(i) as! String
//                        self.navigationController?.pushViewController(viewOne, animated: true)
//                    }
//                }
//               return
//                
//            }
//            else {
//            let viewURL: AnyObject! = dataArray.valueForKey("view_page_url")
//            let viewOne:  ViewControllerWeb = ViewControllerWeb()
//                viewOne.string = viewURL.objectAtIndex(selectNumber) as! String
//            self.navigationController?.pushViewController(viewOne, animated: true)
//    }
//    }
//
//MARK: - 详情按钮点击事件
    func tappedDetails(button:UIButton){
        
       
        let viewOne:  ViewControllerWeb = ViewControllerWeb()
        let nameArray:AnyObject! = self.dataArray.valueForKey("name")
        let name = nameArray.objectAtIndex(button.tag - 10) as! String
        let viewpageArr: AnyObject! = dataArray.valueForKey("view_page_url")
        viewOne.string = viewpageArr.objectAtIndex(button.tag-10) as! String
        viewOne.name  = name
        self.navigationController?.pushViewController(viewOne, animated: true)
    
    }
//MARK : - 释放地图内存
    func mapView(mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
//         mapView.removeFromSuperview()
//        
//        self.view.insertSubview(mapView, atIndex: 0)
    }
//MARK : - 搜索跳转
    //MARK : - 返回
    func goback() {
        isOK = false
        viewsearch.frame = CGRectMake(0, 0, self.view.frame.size.width, 40)
        
        self.navigationItem.leftBarButtonItem = nil
        resultView.hidden = false
        map_view.hidden = true
        
        
        
        recommendBT.hidden = false
        
        map_view.removeOverlays(map_view.overlays)
        for sub_annmo in map_view.annotations {
            
            map_view.removeAnnotation(sub_annmo)
        }
:qw
























q
:wq
wq
wq
q
!q

