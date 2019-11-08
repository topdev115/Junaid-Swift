//
//  iApp.swift
//  junaid
//
//  Created by Administrator on 2019/10/22.
//  Copyright © 2019 Zemin Li. All rights reserved.
//

import Foundation

class iApp {
    
    static let sharedInstance = iApp();
    
    //var msg = Message()
    
    var categories = [String]()
    
    private var currentChatId = 0;
    
    private var id: Int = 0;
    
    private var access_token: String = "";
    
    // Upgrades
    
    private var admob: Int = 0;
    
    // Notifications
    
    private var allowCommentsGCM: Int = 0;
    private var allowCommentsReplyGCM: Int = 0;
    private var allowMessagesGCM: Int = 0;
    
    private var ios_fcm_regid = "";
    
    private var username: String = "";
    private var fullname: String = "";
    private var email: String = "";
    private var location: String = "";
    private var photoUrl: String = "";
    private var coverUrl: String = "";
    
    private var facebookPage: String = "";
    private var instagramPage: String = "";
    
    private var phone: String = "";
    
    private var state: Int = 0;
    private var sex: Int = 0;
    private var verified: Int = 0;
    private var balance: Int = 0;
    private var email_verified: Int = 0;
    
    private var year: Int = 0
    private var month: Int = 0
    private var day: Int = 0
    
    // Privacy settings
    
    private var allowMessages: Int = 0;
    
    // For bages
    
    private var messagesCount: Int = 0;
    private var notificationsCount: Int = 0;
    
    private var bio: String = "";

    
    private var cache: NSCache<AnyObject, AnyObject>!
    
    private init() {
        
        self.cache = NSCache()
    }
    
    public func getCache() -> NSCache<AnyObject, AnyObject> {
    
        return self.cache
    }
    
    // Categories
    
    func getCategories() -> Array<String> {
        
        return self.categories;
    }
    
    // Upgrades
    
    public func setAdmob(admob: Int) {
        
        self.admob = admob;
    }
    
    func getAdmob() -> Int {
        
        return self.admob;
    }
    
    // Notifications
    
    public func setAllowMessagesGCM(allowMessagesGCM: Int) {
        
        self.allowMessagesGCM = allowMessagesGCM;
    }
    
    func getAllowMessagesGCM() -> Int {
        
        return self.allowMessagesGCM;
    }
    
    public func setAllowCommentsGCM(allowCommentsGCM: Int) {
        
        self.allowCommentsGCM = allowCommentsGCM;
    }
    
    func getAllowCommentsGCM() -> Int {
        
        return self.allowCommentsGCM;
    }
    
    public func setAllowCommentsReplyGCM(allowCommentsReplyGCM: Int) {
        
        self.allowCommentsReplyGCM = allowCommentsReplyGCM;
    }
    
    func getAllowCommentsReplyGCM() -> Int {
        
        return self.allowCommentsReplyGCM;
    }
    
    // For bages
    
    public func setMessagesCount(messagesCount: Int) {
        
        self.messagesCount = messagesCount;
    }
    
    func getMessagesCount() -> Int {
        
        return self.messagesCount;
    }
    
    public func setNotificationsCount(notificationsCount: Int) {
        
        self.notificationsCount = notificationsCount;
    }
    
    func getNotificationsCount() -> Int {
        
        return self.notificationsCount;
    }
    
    public func setBio(bio: String) {
        
        self.bio = bio;
    }
    
    func getBio() -> String {
        
        return self.bio;
    }
    
    
    public func setCurrentChatId(chatId: Int) {
        
        self.currentChatId = chatId;
    }
    
    public func getCurrentChatId()->Int {
        
        return self.currentChatId;
    }
    
    public func setId(id: Int) {
        
        self.id = id;
    }
    
    func getId() -> Int {
        
        return self.id;
    }
    
    public func setAccessToken(accessToken: String) {
        
        self.access_token = accessToken;
    }
    
    func getAccessToken() -> String {
        
        return self.access_token;
    }
    
    public func setFcmRegId(ios_fcm_regid: String) {
        
        self.ios_fcm_regid = ios_fcm_regid;
    }
    
    func getFcmRegId() -> String {
        
        return self.ios_fcm_regid;
    }
    
    public func setUsername(username: String) {
        
        self.username = username;
    }
    
    func getUsername() -> String {
        
        return self.username;
    }
    
    public func setFullname(fullname: String) {
        
        self.fullname = fullname;
    }
    
    func getFullname() -> String {
        
        return self.fullname;
    }
    
    public func setEmail(email: String) {
        
        self.email = email;
    }
    
    func getEmail() -> String {
        
        return self.email;
    }
    
    public func setLocation(location: String) {
        
        self.location = location;
    }
    
    func getLocation() -> String {
        
        return self.location;
    }
    
    public func setPhotoUrl(photoUrl: String) {
        
        self.photoUrl = photoUrl.replacingOccurrences(of: "/../", with: "/");
    }
    
    func getPhotoUrl() -> String {
        
        return self.photoUrl;
    }
    
    public func setCoverUrl(coverUrl: String) {
        
        self.coverUrl = coverUrl.replacingOccurrences(of: "/../", with: "/");
    }
    
    func getCoverUrl() -> String {
        
        return self.coverUrl;
    }
    
    public func setPhone(phone: String) {
        
        self.phone = phone;
    }
    
    func getPhone() -> String {
        
        return self.phone;
    }
    
    public func setFacebookPage(facebookPage: String) {
        
        self.facebookPage = facebookPage;
    }
    
    func getFacebookPage() -> String {
        
        return self.facebookPage;
    }
    
    public func setInstagramPage(instagramPage: String) {
        
        self.instagramPage = instagramPage;
    }
    
    func getInstagramPage() -> String {
        
        return self.instagramPage;
    }
    
    public func setState(state: Int) {
        
        self.state = state;
    }
    
    func getState() -> Int {
        
        return self.state;
    }
    
    public func setSex(sex: Int) {
        
        self.sex = sex;
    }
    
    func getSex() -> Int {
        
        return self.sex;
    }
    
    public func setVerified(verified: Int) {
        
        self.verified = verified;
    }
    
    func getVerified() -> Int {
        
        return self.verified;
    }
    
    public func setBalance(balance: Int) {
        
        self.balance = balance;
    }
    
    func getBalance() -> Int {
        
        return self.balance;
    }
    
    public func setEmailVerified(emailVerified: Int) {
        
        self.email_verified = emailVerified;
    }
    
    func getEmailVerified() -> Int {
        
        return self.email_verified;
    }
    
    public func setYear(year: Int) {
        
        self.year = year;
    }
    
    func getYear() -> Int {
        
        return self.year;
    }
    
    public func setMonth(month: Int) {
        
        self.month = month;
    }
    
    func getMonth() -> Int {
        
        return self.month;
    }
    
    public func setDay(day: Int) {
        
        self.day = day;
    }
    
    func getDay() -> Int {
        
        return self.day;
    }
    
    public func setAllowMessages(allowMessages: Int) {
        
        self.allowMessages = allowMessages;
    }
    
    func getAllowMessages() -> Int {
        
        return self.allowMessages;
    }
    
    func logout() {
        
        let defaults = UserDefaults.standard
        
        defaults.setValue(0, forKey: "id");
        defaults.setValue("", forKey: "access_token");
        defaults.setValue("", forKey: "username");
        defaults.setValue("", forKey: "fullname");
        defaults.setValue("", forKey: "email");
        
        iApp.sharedInstance.setId(id: 0);
        iApp.sharedInstance.setAccessToken(accessToken: "");
        iApp.sharedInstance.setUsername(username: "");
        iApp.sharedInstance.setFullname(fullname: "");
        iApp.sharedInstance.setEmail(email: "");
        
        iApp.sharedInstance.setState(state: 0);
        
        defaults.synchronize()
    }
    
    func saveSettings() {
        
        let defaults = UserDefaults.standard
        
        defaults.setValue(self.getId(), forKey: "id");
        defaults.setValue(self.getAccessToken(), forKey: "access_token");
        
        defaults.setValue(self.getUsername(), forKey: "username");
        defaults.setValue(self.getFullname(), forKey: "fullname");
        defaults.setValue(self.getEmail(), forKey: "email");
        
        defaults.synchronize();
    }
    
    func readSettings() {
        
        let defaults = UserDefaults.standard;
        
        if (defaults.object(forKey: "id") != nil) {
            
            self.setId(id: defaults.integer(forKey: "id"));
            self.setAccessToken(accessToken: defaults.string(forKey: "access_token")!);
            
            self.setUsername(username: defaults.string(forKey: "username")!);
            self.setFullname(fullname: defaults.string(forKey: "fullname")!);
            self.setEmail(email: defaults.string(forKey: "email")!);
            
        } else {
            
            print("No Id Key");
        }
        
        defaults.synchronize();
    }
    
    func authorize(Response : AnyObject) {
        
        self.setId(id: Int((Response["id"] as? String)!)!)
        self.setUsername(username: (Response["username"] as? String)!)
        self.setFullname(fullname: (Response["fullname"] as? String)!)
        self.setEmail(email: (Response["email"] as? String)!)
        self.setLocation(location: (Response["location"] as? String)!)
        self.setPhotoUrl(photoUrl: (Response["lowPhotoUrl"] as? String)!)
        self.setCoverUrl(coverUrl: (Response["coverUrl"] as? String)!)
        
        self.setFacebookPage(facebookPage: (Response["fb_page"] as? String)!)
        self.setInstagramPage(instagramPage: (Response["instagram_page"] as? String)!)
        
        self.setPhone(phone: (Response["phone"] as? String)!)
        
        self.setState(state: Int((Response["state"] as? String)!)!)
        self.setSex(sex: Int((Response["sex"] as? String)!)!)
        self.setVerified(verified: Int((Response["verify"] as? String)!)!)
        self.setBalance(balance: Int((Response["balance"] as? String)!)!)
        //self.setEmailVerified(emailVerified: Int((Response["emailVerify"] as? String)!)!)
        
        self.setYear(year: Int((Response["year"] as? String)!)!)
        self.setMonth(month: Int((Response["month"] as? String)!)!)
        self.setDay(day: Int((Response["day"] as? String)!)!)
        
        self.setBio(bio: (Response["status"] as? String)!)
        
        // Upgrades
        
        self.setAdmob(admob: Int((Response["admob"] as? String)!)!)
        
        // Push notifications | Notifications
        
        self.setAllowMessagesGCM(allowMessagesGCM: Int((Response["allowMessagesGCM"] as? String)!)!)
        self.setAllowCommentsGCM(allowCommentsGCM: Int((Response["allowCommentsGCM"] as? String)!)!)
        self.setAllowCommentsReplyGCM(allowCommentsReplyGCM: Int((Response["allowCommentReplyGCM"] as? String)!)!)
        
        // Privacy
        
        self.setAllowMessages(allowMessages: Int((Response["allowMessages"] as? String)!)!)
        
        // Bages
        
        self.setMessagesCount(messagesCount: (Response["messagesCount"] as? Int)!)
        self.setNotificationsCount(notificationsCount: Int((Response["notificationsCount"] as? String)!)!)
        
        // for new version
        
        // self.setPhotoUrl(photoUrl: (Response["photoUrl"] as? String)!)
        // self.setCoverUrl(coverUrl: (Response["coverUrl"] as? String)!)
        // self.setVerified(verified: Int((Response["verified"] as? String)!)!)
        // self.setState(state: Int((Response["account_state"] as? String)!)!)
        // self.setEmailVerified(emailVerified: Int((Response["email_verified"] as? String)!)!)
        
        self.saveSettings();
    }
}
