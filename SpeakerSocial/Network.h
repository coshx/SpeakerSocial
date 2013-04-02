@interface Network 
-(NSData*)httpGet: (NSString*)url;
-(void)httpPost: (NSString*)url :(NSString*)data;
@end