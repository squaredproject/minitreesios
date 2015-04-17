//
//  RPCController.swift
//  Minitrees
//
//  Created by Kyle Fleming on 10/26/14.
//  Copyright (c) 2014 Kyle Fleming. All rights reserved.
//

import UIKit

class ServerController: NSObject, PKJSONSocketDelegate {
    
    class var sharedInstance : ServerController {
        struct Static {
            static let instance = ServerController()
        }
        return Static.instance
    }
    
    override init() {
        self.socket = PKJSONSocket()
        super.init()
        self.socket.delegate = self
    }
    
    var socket: PKJSONSocket
    var timer: NSTimer? {
        willSet {
            self.timer?.invalidate()
        }
    }
    var autoconnect = false
    dynamic var connected: Bool = false {
        didSet {
            println(connected ? "Connected" : "Disconnected")
        }
    }
    
    func connect() {
        self.autoconnect = true
        self.socket.connectToHost("odroid.local", onPort: 5204, error: nil)
    }
    
    func disconnect() {
        self.autoconnect = false
        self.socket.disconnect()
        self.timer = nil
    }
    
    func socket(socket: PKJSONSocket!, didConnectToHost host: String!) {
        self.connected = true
        self.timer = nil
        ServerController.sharedInstance.loadModel()
    }
    
    func socket(socket: PKJSONSocket!, didDisconnectWithError error: NSError!) {
        self.connected = false
        Model.sharedInstance.loaded = false
        if timer == nil {
            if self.autoconnect {
                self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "connect", userInfo: nil, repeats: true)
                
            }
        }
    }
    
    func socket(socket: PKJSONSocket, didReceiveMessage dictionary: PKJSONSocketMessage) {
        println(dictionary.dictionaryRepresentation())
        if let method = dictionary.dictionaryRepresentation()["method"] as? String {
            if let params = dictionary.dictionaryRepresentation()["params"] as? Dictionary<String, AnyObject> {
                switch method {
                case "model":
                    Model.sharedInstance.isIniting = true
                    if let autoplay = params["autoplay"] as? Bool {
                        Model.sharedInstance.autoplay = autoplay
                    }
                    if let colorEffectsArray = params["colorEffects"] as? [Dictionary<String, AnyObject>] {
                        Model.sharedInstance.colorEffects = parseEffectsArray(colorEffectsArray)
                    }
                    if let channelsArray = params["channels"] as? [Dictionary<String, AnyObject>] {
                        Model.sharedInstance.channels = parseChannelsArray(channelsArray)
                        Model.sharedInstance.patterns = Model.sharedInstance.channels[0].patterns
                    }
                    if let activeColorEffectIndex = params["activeColorEffectIndex"] as? Int {
                        Model.sharedInstance.activeColorEffectIndex = activeColorEffectIndex
                    }
                    if let speed = params["speed"] as? Float {
                        Model.sharedInstance.speed = speed
                    }
                    if let spin = params["spin"] as? Float {
                        Model.sharedInstance.spin = spin
                    }
                    if let scrambleEffect = params["scramble"] as? Float {
                        Model.sharedInstance.scrambleEffect = scrambleEffect
                    }
                    if let blur = params["blur"] as? Float {
                        Model.sharedInstance.blur = blur
                    }
                    DisplayState.sharedInstance.selectedChannelIndex = 0
                    Model.sharedInstance.isIniting = false
                    Model.sharedInstance.loaded = true
                default:
                    break
                }
            }
        }
    }
    
    func parseEffectsArray(effectsArray: [Dictionary<String, AnyObject>]) -> [Effect] {
        var effects = [Effect]()
        for effectParams in effectsArray {
            let index = effectParams["index"] as! Int
            let name = effectParams["name"] as! String
            effects.append(Effect(index: index, name: name))
        }
        return effects
    }
    
    func parseChannelsArray(channelsArray: [Dictionary<String, AnyObject>]) -> [Channel] {
        var channels = [Channel]()
        for channelParams in channelsArray {
            let channelIndex = channelParams["index"] as! Int
            let currentPatternIndex = channelParams["currentPatternIndex"] as! Int
            let visibility = channelParams["visibility"] as! Float
            var patterns = [Pattern]()
            for (index, patternParams) in enumerate(channelParams["patterns"] as! [Dictionary<String, AnyObject>]) {
                let patternIndex = patternParams["index"] as! Int
                let name = patternParams["name"] as! String
                patterns.append(Pattern(index: patternIndex, name: name))
            }
            let currentPattern: Pattern? = currentPatternIndex == -1 ? nil : (channelIndex == 0 ? patterns[currentPatternIndex] : channels[0].patterns[currentPatternIndex])
            channels.append(Channel(index: channelIndex, patterns: patterns, currentPattern: currentPattern, visibility: visibility))
        }
        return channels
    }
    
    func send(method: String, params: Dictionary<String, AnyObject>? = nil) {
        if let params = params {
            socket.send(PKJSONSocketMessage(dictionary: ["method": method, "params": params]))
        } else {
            socket.send(PKJSONSocketMessage(dictionary: ["method": method]))
        }
    }
    
    func loadModel() {
        self.send("loadModel")
    }
    
    func setAutoplay(autoplay: Bool) {
        self.send("setAutoplay", params: ["autoplay": autoplay])
    }
    
    func setChannelPattern(channel: Channel) {
        let currentPatternIndex = channel.currentPattern == nil ? -1 : channel.currentPattern!.index
        self.send("setChannelPattern", params: ["channelIndex": channel.index, "patternIndex": currentPatternIndex])
    }
    
    func setChannelVisibility(channel: Channel) {
        self.send("setChannelVisibility", params: ["channelIndex": channel.index, "visibility": channel.visibility])
    }
    
    func setActiveColorEffect(activeColorEffectIndex: Int) {
        self.send("setActiveColorEffect", params: ["effectIndex": activeColorEffectIndex])
    }
    
    func setSpeed(amount: Float) {
        self.send("setSpeed", params: ["amount": amount])
    }
    
    func setSpin(amount: Float) {
        self.send("setSpin", params: ["amount": amount])
    }
    
    func setBlur(amount: Float) {
        self.send("setBlur", params: ["amount": amount])
    }
    
    func setScramble(amount: Float) {
        self.send("setScramble", params: ["amount": amount])
    }
   
}
