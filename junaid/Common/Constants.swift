//
//  Constants.swift
//  junaid
//
//  Created by Administrator on 2019/10/22.
//  Copyright © 2019 Zemin Li. All rights reserved.
//
import UIKit

let APP_NAME = "Junaid Perfumes".localizedString

struct Constants {
    
    static let PRODUCT_VIEW_HIEGHT = CGFloat(250.0)
    
    static let REQUEST_TIMEOUT = TimeInterval(60)
    
    struct API {
        static let MAIN_URL = "http://junaidperfume.accentrs.com"
        static let API_URL = MAIN_URL + "/api"
        static let LOGIN = API_URL + "/login"
        static let REGISTER = API_URL + "/reg"
        static let FORGOT_PASSWORD = API_URL + "/forgotpassword"
        static let FETCH_COUNTRIES_STORES = API_URL + "/country"
        
        static let GET_POST = API_URL + "/post"
        static let GET_POST_DETAIL = API_URL + "/post/"
        static let ADD_COMMENT = API_URL + "/post-comment"
        static let EDIT_COMMENT = API_URL + "/post-comment/"
        static let DELETE_COMMENT = API_URL + "/post-comment/"
        
        static let FETCH_PRODUCT = API_URL + "/product"
        static let FETCH_PRODUCT_HOME = API_URL + "/product-home"
        static let FETCH_PRODUCT_DETAIL = API_URL + "/product/"
        static let SEARCH_PRODUCT = API_URL + "/search-product"
        
        static let FETCH_NOTIFICATIONS = API_URL + "/notification"
        
        static let GET_USERS_SCORECARD = API_URL + "/prev-month-users-scorecard"
        static let GET_MY_SCORECARD = API_URL + "/prev-month-my-scorecard"
        
        static let FETCH_STORE_LIST = API_URL + "/store-list/"
        
        static let CUSTOMER_FEEDBACK = API_URL + "/customer-feedback"
    }
    
    static let DATE_FORMAT = "MM-dd-yyyy"
    
    static let PAGE_SIZE = 10
    
    /*
    static let CLIENT_ID: Int = 1;
    
    static let API_DOMAIN: String = "http://marketplace.ifsoft.ru/";
    
    
    // Don't modify next constants!!!
    
    static let SERVER_ENGINE_VERSION: Float = 1.0;
    
    static let API_FILE_EXTENSION: String = ".inc.php";
    
    static let API_VERSION: String = "v1";
    
    // Api URLs
    
    static let METHOD_APP_TERMS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/app.terms" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_APP_THANKS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/app.thanks" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_AUTHORIZE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.authorize" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SIGNIN: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.signIn" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SIGNUP: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.signUp" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_RECOVERY: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.recovery" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_LOGOUT: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.logOut" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SAVE_SETTINGS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.saveSettings" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SETPASSWORD: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setPassword" + Constants.API_FILE_EXTENSION;
    
        static let METHOD_ACCOUNT_SET_DEVICE_TOKEN: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setGcmToken" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_GET_SETTINGS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.getSettings" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SET_MESSAGES_GCM: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setAllowMessagesGCM" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SET_COMMENTS_GCM: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setAllowCommentsGCM" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SET_REPLY_GCM: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setAllowCommentReplyGCM" + Constants.API_FILE_EXTENSION;
    
    // Account Privacy Settings
    
    static let METHOD_ACCOUNT_SET_ALLOW_MESSAGES: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setAllowMessages" + Constants.API_FILE_EXTENSION;
    
    // Messages
    
    static let METHOD_DIALOGS_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/dialogs.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_DIALOG_REMOVE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/chat.remove" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_CHAT_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/chat.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_CHAT_GET_PREVIOUS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/chat.getPrevious" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_CHAT_UPDATE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/chat.update" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_MESSAGE_NEW: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/msg.new" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_MESSAGE_UPLOAD_IMAGE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/msg.uploadImg" + Constants.API_FILE_EXTENSION;
    
    // Notifications
    
    static let METHOD_NOTIFICATIONS_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/notifications.get" + Constants.API_FILE_EXTENSION;
    
    // Upgrades
    
    static let METHOD_ACCOUNT_SET_VERIFIED_BADGE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setVerifiedBadge" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_SET_GHOST_MODE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.setGhostMode" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ACCOUNT_DISABLE_ADS: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/account.disableAds" + Constants.API_FILE_EXTENSION;
    
    // Nearby
    
    static let METHOD_PEOPLE_NEARBY_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/profile.getPeopleNearby" + Constants.API_FILE_EXTENSION;
    
    // Profile
    
    static let METHOD_PROFILE_UPLOAD_PHOTO: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/profile.uploadPhoto" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_PROFILE_UPLOAD_COVER: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/profile.uploadCover" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_PROFILE_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/profile.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_PROFILE_GET_LIKES: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/profile.getFans" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_PROFILE_LIKE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/profile.like" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_PROFILE_REPORT: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/profile.report" + Constants.API_FILE_EXTENSION;
    
    // Categories
    
    static let METHOD_CATEGORIES_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/categories.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_CATEGORY_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/category.get" + Constants.API_FILE_EXTENSION;

    
    // Items
    
    static let METHOD_ITEMS_COMMENT_ADD: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/comments.new" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ITEMS_COMMENT_REMOVE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/comments.remove" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ITEMS_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/wall.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ITEMS_GET_ITEM: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/item.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ITEMS_GET_STREAM: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/stream.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ITEMS_GET_FAVORITES: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/favorites.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ITEMS_GET_NEARBY: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/nearby.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ITEMS_ADD_ITEM: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/items.new" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ITEMS_REPORT_ITEM: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/items.report" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ITEMS_REMOVE_ITEM: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/items.remove" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ITEMS_LIKE_ITEM: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/items.like" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_ITEMS_UPLOAD_IMAGE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/items.uploadImg" + Constants.API_FILE_EXTENSION;
    
    // Blacklist
    
    static let METHOD_BLACKLIST_GET: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/blacklist.get" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_BLACKLIST_ADD: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/blacklist.add" + Constants.API_FILE_EXTENSION;
    
    static let METHOD_BLACKLIST_REMOVE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/blacklist.remove" + Constants.API_FILE_EXTENSION;
    
    // Search
    
    static let METHOD_SEARCH: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/app.search" + Constants.API_FILE_EXTENSION;
    
    // Search fo new server version
    
    // static let METHOD_SEARCH_PROFILE: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/search.profile" + Constants.API_FILE_EXTENSION;
    
    // static let METHOD_SEARCH_PROFILE_PRELOAD: String = Constants.API_DOMAIN + "api/" + Constants.API_VERSION + "/method/search.profilePreload" + Constants.API_FILE_EXTENSION;
    
    */
    
    
    
    // Constants for Interface
    
    static let LIST_ITEMS = 20;
    
    static let ITEMS_STREAM_PAGE: Int = 0;
    static let ITEMS_PROFILE_PAGE: Int = 1;
    static let ITEMS_FAVORITES_PAGE: Int = 2;
    static let ITEMS_NEARBY_PAGE: Int = 4;
    static let ITEMS_CATEGORY_PAGE: Int = 5;
    
    // Api Constants
    
    static let ERROR_SUCCESS: Int = 0;
    
    static let ERROR_UNKNOWN: Int = 100;
    static let ERROR_LOGIN_TAKEN: Int = 300;
    static let ERROR_EMAIL_TAKEN: Int = 301;
    static let ERROR_PHONE_TAKEN: Int = 303;
    
    static let NOTIFY_TYPE_LIKE: Int = 0;
    static let NOTIFY_TYPE_FOLLOWER: Int = 1;
    static let NOTIFY_TYPE_MESSAGE: Int = 2;
    static let NOTIFY_TYPE_COMMENT: Int = 3;
    static let NOTIFY_TYPE_COMMENT_REPLY: Int = 4;
    static let NOTIFY_TYPE_FRIEND_REQUEST_ACCEOTED: Int = 5;
    static let NOTIFY_TYPE_GIFT: Int = 6;
    static let NOTIFY_TYPE_IMAGE_COMMENT: Int = 7;
    static let NOTIFY_TYPE_IMAGE_COMMENT_REPLY: Int = 8;
    static let NOTIFY_TYPE_IMAGE_LIKE: Int = 9;
    
    static let ACCOUNT_STATE_ENABLED: Int = 0;
    static let ACCOUNT_STATE_DISABLED: Int = 1;
    static let ACCOUNT_STATE_BLOCKED: Int = 2;
    static let ACCOUNT_STATE_DEACTIVATED: Int = 3;
    
    static let GCM_NOTIFY_CONFIG: Int = 0;
    static let GCM_NOTIFY_SYSTEM: Int = 1;
    static let GCM_NOTIFY_CUSTOM: Int = 2;
    static let GCM_NOTIFY_LIKE: Int = 3;
    static let GCM_NOTIFY_ANSWER: Int = 4;
    static let GCM_NOTIFY_QUESTION: Int = 5;
    static let GCM_NOTIFY_COMMENT: Int = 6;
    static let GCM_NOTIFY_FOLLOWER: Int = 7;
    static let GCM_NOTIFY_PERSONAL: Int = 8;
    static let GCM_NOTIFY_MESSAGE: Int = 9;
    static let GCM_NOTIFY_COMMENT_REPLY: Int = 10;
    static let GCM_NOTIFY_REQUEST_INBOX: Int = 11;
    static let GCM_NOTIFY_REQUEST_ACCEPTED: Int = 12;
    static let GCM_NOTIFY_GIFT: Int = 14;
    static let GCM_NOTIFY_SEEN: Int = 15;
    static let GCM_NOTIFY_TYPING: Int = 16;
    static let GCM_NOTIFY_URL: Int = 17;
    static let GCM_NOTIFY_IMAGE_COMMENT_REPLY: Int = 18;
    static let GCM_NOTIFY_IMAGE_COMMENT: Int = 19;
    static let GCM_NOTIFY_IMAGE_LIKE: Int = 20;
    
    static let SEX_UNKNOWN: Int = 0;
    static let SEX_MALE: Int = 1;
    static let SEX_FEMALE: Int = 2;
}
