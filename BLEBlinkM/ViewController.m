//
//  ViewController.m
//  BLEBlinkM
//
//  Created by John Brewer on 5/29/14.
//  Copyright (c) 2014-2015 Jera Design LLC. All rights reserved.
//

#import "ViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController ()<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic) CBCentralManager *central;
@property (nonatomic) CBPeripheral *peripheral;

@property (nonatomic) CBUUID *uartServiceID;
@property (nonatomic) CBService *uartService;
@property (nonatomic) CBUUID *txCharacteristicID;
@property (nonatomic) CBCharacteristic *txCharacteristic;
@property (nonatomic) NSArray *desiredServiceIDs;
@property (nonatomic) NSArray *desiredCharacteristicIDs;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.central = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    self.uartServiceID = [CBUUID UUIDWithString:@"6e400001-b5a3-f393-e0a9-e50e24dcca9e"];
    self.desiredServiceIDs = @[ self.uartServiceID ];
    self.txCharacteristicID = [CBUUID UUIDWithString:@"6e400002-b5a3-f393-e0a9-e50e24dcca9e"];
    self.desiredCharacteristicIDs = @[ self.txCharacteristicID ];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)writeData:(NSData*)data {
    [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

#pragma mark - CBCentralManagerDelegate methods

-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state == CBCentralManagerStatePoweredOn) {
        [central scanForPeripheralsWithServices:self.desiredServiceIDs options:nil];
    }
}

-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    self.peripheral = peripheral;
    peripheral.delegate = self;
    [central connectPeripheral:peripheral options:nil];
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [peripheral discoverServices:self.desiredServiceIDs];
}

#pragma mark - CBPeripheralDelegate methods

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) {
        self.uartService = service;
        [peripheral discoverCharacteristics:self.desiredCharacteristicIDs forService:service];
    }
}

-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"%@", characteristic);
        self.txCharacteristic = characteristic;
        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
    }
}

#pragma mark - IBActions

- (IBAction)redAction:(id)sender {
    char stopMessage[] = { 'o' };
    NSData *stopData = [NSData dataWithBytes:stopMessage length:1];
    [self writeData:stopData];
    
    char message[] = { 'n', 0xff, 0x00, 0x00 };
    NSData *data = [NSData dataWithBytes:message length:4];
    [self writeData:data];
}
- (IBAction)greenAction:(id)sender {
    char stopMessage[] = { 'o' };
    NSData *stopData = [NSData dataWithBytes:stopMessage length:1];
    [self writeData:stopData];
    
    char message[] = { 'n', 0x00, 0xff, 0x00 };
    NSData *data = [NSData dataWithBytes:message length:4];
    [self writeData:data];
}
- (IBAction)blueAction:(id)sender {
    char stopMessage[] = { 'o' };
    NSData *stopData = [NSData dataWithBytes:stopMessage length:1];
    [self writeData:stopData];
    
    char message[] = { 'n', 0x00, 0x00, 0xff };
    NSData *data = [NSData dataWithBytes:message length:4];
    [self writeData:data];
}
- (IBAction)whiteAction:(id)sender {
    char stopMessage[] = { 'o' };
    NSData *stopData = [NSData dataWithBytes:stopMessage length:1];
    [self writeData:stopData];

    char message[] = { 'n', 0xff, 0xff, 0xff };
    NSData *data = [NSData dataWithBytes:message length:4];
    [self writeData:data];
}
- (IBAction)offAction:(id)sender {
    char stopMessage[] = { 'o' };
    NSData *stopData = [NSData dataWithBytes:stopMessage length:1];
    [self writeData:stopData];

    char message[] = { 'n', 0x00, 0x00, 0x00 };
    NSData *data = [NSData dataWithBytes:message length:4];
    [self writeData:data];
}
- (IBAction)cycleAction:(id)sender {
    char message[] = { 'p', 0x0a, 0x00, 0x00 };
    NSData *data = [NSData dataWithBytes:message length:4];
    [self writeData:data];
}
- (IBAction)moodAction:(id)sender {
    char message[] = { 'p', 0x0b, 0x00, 0x00 };
    NSData *data = [NSData dataWithBytes:message length:4];
    [self writeData:data];
}
- (IBAction)candleAction:(id)sender {
    char message[] = { 'p', 0x0c, 0x00, 0x00 };
    NSData *data = [NSData dataWithBytes:message length:4];
    [self writeData:data];
}
- (IBAction)waterAction:(id)sender {
    char message[] = { 'p', 0x0d, 0x00, 0x00 };
    NSData *data = [NSData dataWithBytes:message length:4];
    [self writeData:data];
}
- (IBAction)neonAction:(id)sender {
    char message[] = { 'p', 0x0e, 0x00, 0x00 };
    NSData *data = [NSData dataWithBytes:message length:4];
    [self writeData:data];
}
- (IBAction)seasonsAction:(id)sender {
    char message[] = { 'p', 0x0f, 0x00, 0x00 };
    NSData *data = [NSData dataWithBytes:message length:4];
    [self writeData:data];
}
- (IBAction)stormAction:(id)sender {
    char message[] = { 'p', 0x10, 0x00, 0x00 };
    NSData *data = [NSData dataWithBytes:message length:4];
    [self writeData:data];
}
@end
