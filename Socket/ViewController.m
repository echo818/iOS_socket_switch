//
//  ViewController.m
//  Socket
//
//  Created by ZRC on 16/5/22.
//  Copyright © 2016年 ZRC. All rights reserved.
//

#import "ViewController.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    link = false;
    
    UIButton *on = [UIButton buttonWithType:UIButtonTypeCustom];
    on.frame = CGRectMake(50, 50, 200, 36);
    on.backgroundColor = [UIColor blueColor];
    [on setTitle:@"ON" forState:UIControlStateNormal];
    [on addTarget:self action:@selector(turnON) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:on];
    
    UIButton *off = [UIButton buttonWithType:UIButtonTypeCustom];
    off.frame = CGRectMake(50, 100, 200, 36);
    off.backgroundColor = [UIColor blueColor];
    [off setTitle:@"OFF" forState:UIControlStateNormal];
    [off addTarget:self action:@selector(turnOFF) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:off];
}

-(void) openSocket{
    struct sockaddr_in addr;
    if ((fd=socket(AF_INET, SOCK_STREAM, 0))!=-1) {
        NSLog(@"socket success");
        memset(&addr, 0, sizeof(addr));
        addr.sin_len=sizeof(addr);
        addr.sin_family=AF_INET;
        addr.sin_addr.s_addr=INADDR_ANY;
        if (bind(fd, (const struct sockaddr *)&addr, sizeof(addr))==0) {
            struct sockaddr_in peeraddr;
            memset(&peeraddr, 0, sizeof(peeraddr));
            peeraddr.sin_len=sizeof(peeraddr);
            peeraddr.sin_family=AF_INET;
            peeraddr.sin_port=htons(9999);
            peeraddr.sin_addr.s_addr=inet_addr("192.168.2.6");
            socklen_t addrLen;
            addrLen =sizeof(peeraddr);
            conn = (connect(fd, (struct sockaddr *)&peeraddr, addrLen)==0);
        }
    }
}

-(void)turnON{
    [self linkSocket];
    if (conn) {
        const char str[] = "on";
        send(fd, str,sizeof(str)-1,0);
    }else{
        NSLog(@"connect failed");
    }
}

-(void)turnOFF{
    [self linkSocket];
    if (conn) {
        const char str[] = "off";
        send(fd, str,sizeof(str)-1,0);
    }else{
        NSLog(@"connect failed");
    }
}

-(void)linkSocket{
    if (!link) {
        [self openSocket];
        link = true;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
