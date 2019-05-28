//
//  UDPListener.swift
//  AirbusNavDisplay
//
//  Created by Michael A. Crawford on 5/12/19.
//  Copyright © 2019 Crawford Design Engineering, LLC. All rights reserved.
//

import Network

class UDPListener {
    
    private let xPlanePort = 49000
    
    private let queue = DispatchQueue(label: "com.cdellc.udplistener")
    
    private var connection: NWConnection?
    
    private let stateUpdateHandler: (NWConnection.State) -> Void = { newState in
        switch newState {
        case .cancelled:
            break
        case .failed(let error):
            break
        case .ready:
            // Ready to read/write data on connection/port.
            break
        case .waiting(let error):
            // No network available.
            break
        case .preparing:
            fallthrough
        case .setup:
            fallthrough
        @unknown default:
            break
        }
    }
    
    private let viabilityUpdateHandler: (Bool) -> Void = { isViable in
        if isViable {
            // TODO: Notify user that connection is stable
        } else {
            // TODO: Notify user of connection issues.
        }
    }
    
    var isConnected: Bool {
        return connection != nil
    }
    
    func start() throws {
        do {
            // setup listener
            let listener = try NWListener(using: .udp)
            // setup Bonjour asvertisement
            listener.service = NWListener.Service(type: "_airbusnavdisplay._udp")
            
            listener.newConnectionHandler = { newConnection in
                self.connection = newConnection
                newConnection.viabilityUpdateHandler = self.viabilityUpdateHandler
                newConnection.start(queue: self.queue)
            }
            
            listener.start(queue: queue)
        } catch {
            throw error
        }
    }
}
