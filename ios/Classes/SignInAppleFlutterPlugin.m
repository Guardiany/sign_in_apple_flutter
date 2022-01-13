#import "SignInAppleFlutterPlugin.h"
#import <AuthenticationServices/AuthenticationServices.h>



@interface SignInAppleFlutterPlugin () <ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>

@end

FlutterMethodChannel *flutterChannel;

@implementation SignInAppleFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"sign_in_apple_flutter"
            binaryMessenger:[registrar messenger]];
  flutterChannel = channel;
  SignInAppleFlutterPlugin* instance = [[SignInAppleFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else if ([@"sign_in_apple" isEqualToString:call.method]) {
    [self signInApple: result];
  } {
    result(FlutterMethodNotImplemented);
  }
}

- (void)signInApple: (FlutterResult)result {
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDProvider *appleIDProvider = [[ASAuthorizationAppleIDProvider alloc]init];
        ASAuthorizationAppleIDRequest *request = [appleIDProvider createRequest];
        request.requestedScopes = @[ASAuthorizationScopeFullName,ASAuthorizationScopeEmail];
        ASAuthorizationController *auth = [[ASAuthorizationController alloc]initWithAuthorizationRequests:@[request]];
        auth.delegate = self;
        auth.presentationContextProvider = self;
        [auth performRequests];
        result([NSNumber numberWithBool:true]);
    } else {
        NSDictionary *resultDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"error", @"result", @"您的设备不支持苹果登录，请将iOS升级到13.0以上", @"message", nil];
        [flutterChannel invokeMethod:@"error" arguments:resultDic];
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)){
    if([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]){
        ASAuthorizationAppleIDCredential *apple = authorization.credential;
        NSString *userIdentifier = apple.user;
//        NSPersonNameComponents *fullName = apple.fullName;
        NSString *email = apple.email;
        NSData *identityToken = apple.identityToken;
        NSDictionary *resultDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"success", @"result", userIdentifier, @"userId", email, @"email", identityToken, @"identityToken", nil];
        [flutterChannel invokeMethod:@"success" arguments:resultDic];
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        ASPasswordCredential *pass = authorization.credential;
        NSString *username = pass.user;
        NSString *passw = pass.password;
        NSDictionary *resultDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"success", @"result", username, @"userId", passw, @"password", nil];
        [flutterChannel invokeMethod:@"success" arguments:resultDic];
    }
}

- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  API_AVAILABLE(ios(13.0)){
    
    NSString *msg = @"未知错误";
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            msg = @"用户取消";
            break;
        case ASAuthorizationErrorFailed:
            msg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            msg = @"授权请求无响应";
            break;
        case ASAuthorizationErrorNotHandled:
            msg = @"授权请求未处理";
            break;
        case ASAuthorizationErrorUnknown:
            msg = @"授权失败，原因未知";
            break;
        default:
            break;
    }
    
    NSDictionary *resultDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"error", @"result", msg, @"message", nil];
    [flutterChannel invokeMethod:@"error" arguments:resultDic];
}

- (nonnull ASPresentationAnchor)presentationAnchorForAuthorizationController:(nonnull ASAuthorizationController *)controller  API_AVAILABLE(ios(13.0)){
    return [[UIApplication sharedApplication] keyWindow];
}

@end
