@interface Network 
-(NSData*)httpGet: (NSString*)url;
-(void)httpPost: (NSString*)url :(NSString*)data;
-(void)httpASyncPost: (NSString*)url :(NSString*)data;
@end

