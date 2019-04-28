//
//  UDPCode.m
//  AirbusNavDisplay
//
//  Created by Michael A. Crawford on 12/25/15.
//  Copyright © 2015 Crawford Design Engineering, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

void rev_byte_order4(char* retval)		// reverse byte-order for least/most signifigant-byte-first,
{												// which is done differently on Mac and IBM...
    char* add=retval;	char b1=*(add);	add++;	// This works as long as both platforms are IEEE, and
    char b2=*(add);	add++;	// the values passed in are FOUR BYTES (32 bits)... this
    char b3=*(add);	add++;	// includes FLOATS and LONGS, NOT SHORTS OR DOUBLEsS
    char b4=*(add);
    
    add=retval;	*add=b4; add++;
    *add=b3; add++;
    *add=b2; add++;
    *add=b1;
}

void bswapi(int *pint){
    char tmpb[4];
    
    memcpy(tmpb, pint, 4);
    rev_byte_order4(tmpb);
    memcpy(pint, tmpb, 4);
    
}

void bswapf(float *pf){
    char tmpb[4];
    
    memcpy(tmpb, pf, 4);
    rev_byte_order4(tmpb);
    memcpy(pf, tmpb, 4);
    
}

void rev_byte_order4_v2(char* retval)
{
    char Temp;
    Temp	= retval[0];
    retval[0]	= retval[3];
    retval[3]	= Temp;
    Temp	= retval[1];
    retval[1]	= retval[2];
    retval[2]	= Temp;
}

void OnReceiveCore(char *pp, uint iPacketSize){
    
    
    //dynamically adapts.
    static int iPowerPC_Host = 0;
    
    
    int iCompoundPacketCount = (iPacketSize - 5) / 36;
    
    
    //printf("rx packet size: %i - compound: %i\n", iPacketSize, iCompoundPacketCount);
    
    int     itmp=0;
    
    
    float payload[8];
    
    
    
    //if( iPacketSize == 41 ){
    //radio and nav frequency setting packets, also the ap heading packet.
    
    //we now have the packet in the packet&#91;] var
    //DATAxXXXXaaaaBBBBccccDDDDeeeeFFFFggggHHHH  <- 41 bytes.
    //XXXX      = int, packet index
    //aaaa-HHHH = data payload, floats
    
    //packet pData;
    int iPacketIndex = 0;
    int bo=5; //byte offset
    
    
    for( int iPacketX=0; iPacketX < iCompoundPacketCount; iPacketX++ ){
        
        //extrac the packet index number id int
        memcpy(&itmp, pp+bo, 4);
        bo+=4;
        
        //if the value is absurdly large we have a PPC big endian packet
        if( itmp > 1024 ){
            iPowerPC_Host = 1;
        }else{
            iPowerPC_Host = 0;
        }
        
        
        if( iPowerPC_Host ){
            iPacketIndex = ntohl(itmp);
            memcpy(payload, pp+bo, 32);
            
            for( int x=0; x<8; x++ ){
                bswapf( &(payload[x]) );
            }
            
        }else{
            iPacketIndex = (itmp);
            memcpy(payload, pp+bo, 32);
        }
        bo+=32;
        
        
        
        
        //printf("index: %i\n", iPacketIndex);
        
        
        switch(iPacketIndex){
                
                //03 - speeds
                //kias - vind
                //keas - vind
                //ktas - vtrue
                //ktgs - vtrue
                //blank
                //mph - vind
                //mphas - vtrue
                //mphgs - vtrue
                
                //04 - mach VVI g-load
                //mach - ratio
                //blank
                //vvi - fpm
                //gload - normal
                //gload - axial
                //gload - side
                
                //12 - wing sweep / thrust vec
                //sweep - 1,deg
                //sweep - 2,deg
                //sweep - h,deg
                //vect - ratio
                //sweep - ratio
                //incid - ratio
                //dihed - ratio
                //retra - ratio
                
            case 13:
                //13 - trim/flap/slat/s-brakes
                //trim - elev
                //trim - ail
                //trim - rudder
                //flap handle
                //flap position
                //slat ratio
                //spbrk handle
                //spbrk position
                
                if( payload[7] >= 0.5f ){
                    [glViewC setSpeedBrake:1.f];
                }else{
                    [glViewC setSpeedBrake:0.f];
                }
                
                break;
                
                //14 - gear and brakes
                //gear
                //wbrak - part
                //lbrak - part
                //rbrak - part
                
                //V9.21 Pitch Packet
            case 18:
                //printf("pitch: %.3f, roll: %.3f\n", payload[0], payload[1] );
                [glViewC setPitch:payload[0]];
                [glViewC setRoll:payload[1]];
                //hding true
                //hding mag
                //mag comp
                //blank
                //blank
                //mavar deg
                break;
                
            case 19:
                //19 - AoA, side slip, paths
                [glViewC setAlpha:payload[0]];//alpha
                [glViewC setBeta:payload[1]];//beta
                //hpath
                //vpath
                //blank
                //blank
                //blank
                //slip
                break;
                
                //20 - lat lon altitude
                //lat
                //log
                //alt ftmsl
                //alt ftagl
                //blank
                //alt ind
                //lat south
                //lat west
                
                //26 - throttle actual
                //throttle per engine
                
                //41 - N1
                //n1 pct per engine
                
                //62 - fuel weights
                //fuel weight per tank
                
                //63 - payload weights and cg
                //empty weight
                //payload
                //fuel
                //jettison
                //current
                //max
                //blank
                //cg ftref
                
            case 67:
                //67 - gear deployment
                //gear rat per strut
                if( payload[0] >= 1.0f ){
                    [glViewC setGear:1.f];
                }else{
                    [glViewC setGear:0.f];
                }
                break;
                
                //117 - weapon stats
                //hdng delta
                //pitch delta
                //R d/sec
                //Q d/sec
                //rudd ratio
                //elev ration
                //V kts
                //dis ft
                
                
            default:
                //unkown packet type, never expected, dont do anything. -shrug-
                break;
        } // end of switch(iPacketIndex)
        
    }//end packet loop
    
    
    
    
    
    
} // end OnReceiveCore(...)