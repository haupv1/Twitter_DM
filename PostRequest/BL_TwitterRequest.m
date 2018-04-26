//
//  BL_TwitterRequest.m
//  PostRequest
//
//  Created by Pham Van Hau on 4/24/18.
//  Copyright © 2018 Pham Van Hau. All rights reserved.
//

#import "BL_TwitterRequest.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
#include <sys/types.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#import "Base64.h"
#import <UIKit/UIKit.h>
@implementation NSString (NSString_Extended)
- (NSString *)urlencode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            NSLog(@"error here");
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

@end
@implementation BL_TwitterRequest
@synthesize followersList;
-(NSString*) generateRandomStringOfLength:(int)length {
    
    NSString *letters = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ123456";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: length];
    for (int i = 0; i < length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}
- (NSString *)hmacsha1:(NSString *)data secret:(NSString *)key {
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSString *hash = [HMAC base64EncodedString];
    
    return hash;
     
  /*
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
  const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
 unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
 CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
 NSData *hmac = [[NSData alloc] initWithBytes:cHMAC
                                       length:sizeof(cHMAC)];
 NSMutableString* hash = [[NSMutableString alloc]init];
const char* bytes = [hmac bytes];
    for (int i = 0; i < [hmac length]; i++) {
        [hash appendFormat:@"%02.2hhx", bytes[i]];
    }
    
    return [hash base64EncodedString];
   */
}
-(void) makeRequest {
    
    _webData = [[NSMutableData alloc]init]; // WILL BE USED BY NSURLConnection
    
    NSString *httpMethod = @"POST";
    NSString *baseURL = @"https://api.twitter.com/oauth/request_token";
    NSString *oauthConsumerKey = @"cj2x3KBVptKbGQnFe413Ku5Mb";
    NSString *oauthConsumerSecret = @"n1avlHQa2UCcIvKSVJo1N9CXaZm15rceHKTBes4cqL0mm9OSK3";
    NSString *oauth_timestamp = [NSString stringWithFormat:@"%.f", [[NSDate date]timeIntervalSince1970]];
    NSString *oauthNonce = [self generateRandomStringOfLength:32];
    NSString *oauthSignatureMethod = @"HMAC-SHA1";
    NSString *oauthVersion = @"1.0";
    NSString *oauthCallback = @"oob";
    
    //1. PERCENT CODE EVERY KEY AND VALUE THAT WILL BE SIGNED AND
    //   APPEND KEY AND VALUE WITH = AND &
    
    NSMutableString *parameterString = [[NSMutableString alloc]initWithFormat:@""];
    
    [parameterString appendFormat:@"oauth_callback=%@", [oauthCallback urlencode]];
    [parameterString appendFormat:@"&oauth_consumer_key=%@", [oauthConsumerKey urlencode]];
    [parameterString appendFormat:@"&oauth_nonce=%@", [oauthNonce urlencode]];
    [parameterString appendFormat:@"&oauth_signature_method=%@", [oauthSignatureMethod urlencode]];
    [parameterString appendFormat:@"&oauth_timestamp=%@", [oauth_timestamp urlencode]];
    [parameterString appendFormat:@"&oauth_version=%@", [oauthVersion urlencode]];
    
    //2. CREATE SIGNATURE STRING WITH HTTP METHOD AND ENCODED BASE URL AND PARAMETER STRING
    
    NSString *signatureBaseString = [NSString stringWithFormat:@"%@&%@&%@", httpMethod, [baseURL urlencode], [parameterString urlencode]];
    
    //3. GET THE SIGNING KEY NOW FROM CONSUMER SECRET
    
    NSString *signingKey = [NSString stringWithFormat:@"%@&", [oauthConsumerSecret urlencode]];
    //4. GET THE OUTPUT OF THE HMAC ALOGRITHM
    
    NSString *oauthSignature = [self hmacsha1:signatureBaseString secret:signingKey];
    
    // TIME TO MAKE THE CALL NOW
    
    NSMutableString *urlString = [[NSMutableString alloc]initWithFormat:@""];
    
    [urlString appendFormat:@"%@", baseURL];
    
    // INITIALIZE AUTHORIZATION HEADER
    
    NSMutableString *authHeader = [[NSMutableString alloc]initWithFormat:@""];
    
    [authHeader appendFormat:@"OAuth "]; // MIND THE SPACE AFTER 'OAuth'
    
    [authHeader appendFormat:@"oauth_nonce=\"%@\",", [oauthNonce urlencode]];
    [authHeader appendFormat:@"oauth_callback=\"%@\",", [oauthCallback urlencode]];
    [authHeader appendFormat:@"oauth_signature_method=\"%@\",", [oauthSignatureMethod urlencode]];
    [authHeader appendFormat:@"oauth_timestamp=\"%@\",", [oauth_timestamp urlencode]];
    [authHeader appendFormat:@"oauth_consumer_key=\"%@\",", [oauthConsumerKey urlencode]];
    [authHeader appendFormat:@"oauth_signature=\"%@\",", [oauthSignature urlencode]];
    [authHeader appendFormat:@"oauth_version=\"%@\"", [oauthVersion urlencode]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlString]] ;
    
    [request setHTTPMethod:httpMethod];
    
    [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
    /*
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection start];*/
    NSURLSession *mySession = [NSURLSession sharedSession];
    [[mySession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        } else {
            NSLog(@"Data has loaded successfully.");
            [self.webData appendData:data];
            NSString *resultString = [[NSString alloc]initWithData:self.webData encoding:NSUTF8StringEncoding];
            [self setOauthValueWithHTTPResponseBody:resultString];
            [self requestAuthentication];
            NSLog(@"OAUTH is: %@",self.oauth_token);
            NSLog(@"OAUTH secret is: %@",self.oauth_token_secret);
            NSLog(@"RESULT STRING : %@", resultString);
        }
    }]resume];
}
-(void) getAccessToken {
    
    _webData = [[NSMutableData alloc]init]; // WILL BE USED BY NSURLConnection
    
    NSString *httpMethod = @"POST";
    NSString *baseURL = @"https://api.twitter.com/oauth/access_token";
    NSString *oauthConsumerKey = @"cj2x3KBVptKbGQnFe413Ku5Mb";
    NSString *oauthConsumerSecret = @"n1avlHQa2UCcIvKSVJo1N9CXaZm15rceHKTBes4cqL0mm9OSK3";
    NSString *oauthToken = self.oauth_token;
    NSString *oauthVerifier = self.pinCode;
    NSString *oauth_timestamp = [NSString stringWithFormat:@"%.f", [[NSDate date]timeIntervalSince1970]];
    NSString *oauthNonce = [self generateRandomStringOfLength:32];
    NSString *oauthSignatureMethod = @"HMAC-SHA1";
    NSString *oauthVersion = @"1.0";
//    NSString *oauthCallback = @"oob";
    
    //1. PERCENT CODE EVERY KEY AND VALUE THAT WILL BE SIGNED AND
    //   APPEND KEY AND VALUE WITH = AND &
    
    NSMutableString *parameterString = [[NSMutableString alloc]initWithFormat:@""];
    
//    [parameterString appendFormat:@"oauth_callback=%@", [oauthCallback urlencode]];
    [parameterString appendFormat:@"oauth_consumer_key=%@", [oauthConsumerKey urlencode]];
    [parameterString appendFormat:@"&oauth_token=%@", [oauthToken urlencode]];
    [parameterString appendFormat:@"&oauth_verifier=%@", [oauthVerifier urlencode]];
    [parameterString appendFormat:@"&oauth_nonce=%@", [oauthNonce urlencode]];
    [parameterString appendFormat:@"&oauth_signature_method=%@", [oauthSignatureMethod urlencode]];
    [parameterString appendFormat:@"&oauth_timestamp=%@", [oauth_timestamp urlencode]];
    [parameterString appendFormat:@"&oauth_version=%@", [oauthVersion urlencode]];
    
    //2. CREATE SIGNATURE STRING WITH HTTP METHOD AND ENCODED BASE URL AND PARAMETER STRING
    
    NSString *signatureBaseString = [NSString stringWithFormat:@"%@&%@&%@", httpMethod, [baseURL urlencode], [parameterString urlencode]];
    
    //3. GET THE SIGNING KEY NOW FROM CONSUMER SECRET
    
    NSString *signingKey = [NSString stringWithFormat:@"%@&", [oauthConsumerSecret urlencode]];
    //4. GET THE OUTPUT OF THE HMAC ALOGRITHM
    
    NSString *oauthSignature = [self hmacsha1:signatureBaseString secret:signingKey];
    
    // TIME TO MAKE THE CALL NOW
    
    NSMutableString *urlString = [[NSMutableString alloc]initWithFormat:@""];
    
    [urlString appendFormat:@"%@", baseURL];
    
    // INITIALIZE AUTHORIZATION HEADER
    
    NSMutableString *authHeader = [[NSMutableString alloc]initWithFormat:@""];
    
    [authHeader appendFormat:@"OAuth "]; // MIND THE SPACE AFTER 'OAuth'
    
    [authHeader appendFormat:@"oauth_nonce=\"%@\",", [oauthNonce urlencode]];
//    [authHeader appendFormat:@"oauth_callback=\"%@\",", [oauthCallback urlencode]];
    [authHeader appendFormat:@"oauth_signature_method=\"%@\",", [oauthSignatureMethod urlencode]];
    [authHeader appendFormat:@"oauth_timestamp=\"%@\",", [oauth_timestamp urlencode]];
    [authHeader appendFormat:@"oauth_consumer_key=\"%@\",", [oauthConsumerKey urlencode]];
    [authHeader appendFormat:@"oauth_token=\"%@\",", [oauthToken urlencode]];
    [authHeader appendFormat:@"oauth_verifier=\"%@\",", [oauthVerifier urlencode]];
    [authHeader appendFormat:@"oauth_signature=\"%@\",", [oauthSignature urlencode]];
    [authHeader appendFormat:@"oauth_version=\"%@\"", [oauthVersion urlencode]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlString]] ;
    
    [request setHTTPMethod:httpMethod];
    
    [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
    /*
     NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
     [connection start];*/
    NSURLSession *mySession = [NSURLSession sharedSession];
    [[mySession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        } else {
            NSLog(@"Access Data has loaded successfully.");
            [self.webData appendData:data];
            NSString *resultString = [[NSString alloc]initWithData:self.webData encoding:NSUTF8StringEncoding];
            [self setOauthValueWithHTTPResponseBody:resultString];
            NSLog(@"OAUTH is: %@",self.oauth_token);
            NSLog(@"OAUTH secret is: %@",self.oauth_token_secret);
            NSLog(@"RESULT STRING : %@", resultString);
            [self getFollower];
        }
    }]resume];
}
-(void) getFollower {
    
    _webData = [[NSMutableData alloc]init]; // WILL BE USED BY NSURLConnection
    
    NSString *httpMethod = @"GET";
    NSString *baseURL = @"https://api.twitter.com/1.1/followers/list.json";
    NSString *oauthConsumerKey = @"cj2x3KBVptKbGQnFe413Ku5Mb";
    NSString *oauthConsumerSecret = @"n1avlHQa2UCcIvKSVJo1N9CXaZm15rceHKTBes4cqL0mm9OSK3";
    NSString *oauthToken = self.oauth_token;
    NSString *oauthTokenSecret = self.oauth_token_secret;
    NSString *oauth_timestamp = [NSString stringWithFormat:@"%.f", [[NSDate date]timeIntervalSince1970]];//@"1524633901";//
    NSString *oauthNonce = [self generateRandomStringOfLength:32];//@"ABCDEFGHIJKLMNOPQRSTUVWXYZ123456";//
    NSString *oauthSignatureMethod = @"HMAC-SHA1";
    NSString *oauthVersion = @"1.0";
    //1. PERCENT CODE EVERY KEY AND VALUE THAT WILL BE SIGNED AND
    //   APPEND KEY AND VALUE WITH = AND &
    
    NSMutableString *parameterString = [[NSMutableString alloc]initWithFormat:@""];
    [parameterString appendFormat:@"oauth_consumer_key=%@", [oauthConsumerKey urlencode]];
    [parameterString appendFormat:@"&oauth_nonce=%@", [oauthNonce urlencode]];
    [parameterString appendFormat:@"&oauth_signature_method=%@", [oauthSignatureMethod urlencode]];
    [parameterString appendFormat:@"&oauth_timestamp=%@", [oauth_timestamp urlencode]];
    [parameterString appendFormat:@"&oauth_token=%@", [oauthToken urlencode]];
    [parameterString appendFormat:@"&oauth_version=%@", [oauthVersion urlencode]];
    NSLog(@"parameter string: %@",parameterString);
    //2. CREATE SIGNATURE STRING WITH HTTP METHOD AND ENCODED BASE URL AND PARAMETER STRING
    
    NSString *signatureBaseString = [NSString stringWithFormat:@"%@&%@&%@", httpMethod, [baseURL urlencode], [parameterString urlencode]];
    NSLog(@"base string is: %@",signatureBaseString);
    //3. GET THE SIGNING KEY NOW FROM CONSUMER SECRET and
    
    NSString *signingKey = [NSString stringWithFormat:@"%@&%@", [oauthConsumerSecret urlencode],[oauthTokenSecret urlencode]];
    NSLog(@"signing key: %@",signingKey);
    //4. GET THE OUTPUT OF THE HMAC ALOGRITHM
    
    NSString *oauthSignature = [self hmacsha1:signatureBaseString secret:signingKey];
    NSLog(@"author signature %@",oauthSignature);
    // TIME TO MAKE THE CALL NOW
    
    NSMutableString *urlString = [[NSMutableString alloc]initWithFormat:@""];
    
    [urlString appendFormat:@"%@", baseURL];
    NSLog(@"url string is: %@",urlString);
    // INITIALIZE AUTHORIZATION HEADER
    
    NSMutableString *authHeader = [[NSMutableString alloc]initWithFormat:@""];
    
    [authHeader appendFormat:@"OAuth "]; // MIND THE SPACE AFTER 'OAuth'
    
    [authHeader appendFormat:@"oauth_nonce=\"%@\",", [oauthNonce urlencode]];
    [authHeader appendFormat:@"oauth_signature_method=\"%@\",", [oauthSignatureMethod urlencode]];
    [authHeader appendFormat:@"oauth_timestamp=\"%@\",", [oauth_timestamp urlencode]];
    [authHeader appendFormat:@"oauth_consumer_key=\"%@\",", [oauthConsumerKey urlencode]];
//    [authHeader appendFormat:@"oauth_token=\"%@\",", [oauthToken urlencode]];
    [authHeader appendFormat:@"oauth_token=\"%@\",", [oauthToken urlencode]];
//    [authHeader appendFormat:@"oauth_token_secret=\"%@\",", [oauthToken urlencode]];

    [authHeader appendFormat:@"oauth_signature=\"%@\",", [oauthSignature urlencode]];
    [authHeader appendFormat:@"oauth_version=\"%@\"", [oauthVersion urlencode]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlString]] ;
    [request setHTTPMethod:httpMethod];
    NSLog(@"header is: %@",authHeader);
    [request setValue:authHeader forHTTPHeaderField:@"Authorization"];
    NSURLSession *mySession = [NSURLSession sharedSession];
    [[mySession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@", [error localizedDescription]);
        } else {
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSDictionary *followers = [jsonObject objectForKey:@"users"];
            NSEnumerator *enumerator = [followers objectEnumerator];
            id value;
            self.followersList = [[NSMutableArray alloc] init];
            while ((value = [enumerator nextObject])) {
                NSString* fol = [value objectForKey:@"name"];
                [self.followersList addObject:fol];
            }
            [self.delegate completeLoaded];
            [self.webData appendData:data];
        }
    }]resume];
}

/*
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSLog(@"ok connect ok");
    NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    //Speed:
    NSString* oauth_token = [jsonObject valueForKey:@"oauth_token"];
    NSLog(@"%@",oauth_token);
    id vari;
    vari = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSString* tempK = vari[@"oauth_token"];
    NSLog(@"oauth is: %@",tempK);
    [_webData appendData:data];
}
 */
- (void)setOauthValueWithHTTPResponseBody:(NSString *)body
{
        NSArray *pairs = [body componentsSeparatedByString:@"&"];
        
        for (NSString *pair in pairs) {
            NSArray *elements = [pair componentsSeparatedByString:@"="];
            if ([[elements objectAtIndex:0] isEqualToString:@"oauth_token"]) {
                self.oauth_token = [[elements objectAtIndex:1] stringByRemovingPercentEncoding];
            } else if ([[elements objectAtIndex:0] isEqualToString:@"oauth_token_secret"]) {
                self.oauth_token_secret = [[elements objectAtIndex:1] stringByRemovingPercentEncoding];
            }
        }
}
- (void) requestAuthentication
{
        NSString *address = [NSString stringWithFormat:
                             @"https://api.twitter.com/oauth/authorize?oauth_token=%@",
                             self.oauth_token];
        
        NSURL *url = [NSURL URLWithString:address];
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            
        }];
    });
}

/*
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSString *resultString = [[NSString alloc]initWithData:_webData encoding:NSUTF8StringEncoding];
    [self setOauthValueWithHTTPResponseBody:resultString];
    [self requestAuthentication];
    NSLog(@"OAUTH is: %@",self.oauth_token);
    NSLog(@"RESULT STRING : %@", resultString);
}
  */
@end
