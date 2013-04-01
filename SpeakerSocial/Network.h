@interface Network 
-(NSString*)httpGet: (NSString*)url;
-(NSString*)httpPost: (NSString*)url :(NSString*)data;
@end