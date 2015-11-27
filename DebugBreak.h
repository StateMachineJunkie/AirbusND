/*
 *  DebugBreak.h
 *  AccelerationRecorder
 *
 *  Created by Michael A. Crawford on 5/29/09.
 *  Copyright 2009 Crawford Software Design & Engineering. All rights reserved.
 *
 */

#ifdef DEBUG

#if __ppc64__ || __ppc__

#define DebugBreak()        \
if ( AmBeingDebugged() )    \
{                           \
    __asm__("li r0, 20\nsc\nnop\nli r0, 37\nli r4, 2\nsc\nnop\n" : : : "memory","r0","r3","r4" ); \
}

#else

#define DebugBreak()            \
if ( AmBeingDebugged() )        \
{                               \
    __asm__("int $3\n" : : );   \
}

#endif

#ifdef __cplusplus
extern "C" {
#endif    
    bool AmBeingDebugged(void);
#ifdef __cplusplus
};
#endif

#else
#define DebugBreak()
#endif
