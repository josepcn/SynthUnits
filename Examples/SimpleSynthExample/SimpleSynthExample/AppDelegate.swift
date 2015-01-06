//
//  AppDelegate.swift
//  CoreAudioTest
//
//  Created by Josep on 31/10/14.
//  Copyright (c) 2014 none. All rights reserved.
//

import Cocoa
import CoreAudio
import Foundation
import AudioToolbox


class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet var window: NSWindow?
    
    @IBOutlet weak var sliderFrqOsc1: NSSlider!
    @IBOutlet weak var sliderAmpOsc1: NSSlider!
    @IBOutlet weak var lblAmpOsc1: NSTextField!
    @IBOutlet weak var lblFrqOsc1: NSTextField!
    
    @IBOutlet weak var sliderFrqOsc2: NSSlider!
    @IBOutlet weak var sliderAmpOsc2: NSSlider!
    @IBOutlet weak var lblFrqOsc2: NSTextField!
    @IBOutlet weak var lblAmpOsc2: NSTextField!
    
    @IBOutlet weak var lblLowFilter1: NSTextField!
    @IBOutlet weak var lblHighFilter1: NSTextField!
    @IBOutlet weak var lblLowFilter2: NSTextField!
    @IBOutlet weak var lblHighFilter2: NSTextField!
    
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    
    @IBOutlet weak var comboOsc2WaveType: NSComboBox!
    @IBOutlet weak var comboOsc1WaveType: NSComboBox!
    
    @IBOutlet weak var sliderPreFilterMixer1: NSSlider!
    @IBOutlet weak var sliderPreFilterMixer2: NSSlider!
    @IBOutlet weak var sliderPostFiltersMixer: NSSlider!
    @IBOutlet weak var sliderFilter1LowCutOff: NSSlider!
    @IBOutlet weak var sliderFilter1HighCutOff: NSSlider!
    @IBOutlet weak var sliderFilter2LowCutOff: NSSlider!
    @IBOutlet weak var sliderFilter2HighCutOff: NSSlider!
    
    @IBOutlet weak var checkEnableFilter1: NSButton!
    @IBOutlet weak var checkEnableFilter2: NSButton!
    @IBOutlet weak var checkEnabledOsc1: NSButton!
    @IBOutlet weak var checkEnabledOsc2: NSButton!
    
    var osc1   : Oscillator = Oscillator()
    var osc2   : Oscillator = Oscillator()
    var filter1 : Filter = Filter()
    var filter2 : Filter = Filter()
    var mixerPreFilter1 : Mixer = Mixer()
    var mixerPreFilter2 : Mixer = Mixer()
    var mixerPostFilter : Mixer = Mixer()
    var output : Output = Output()
    
    
    @IBAction func sliderPostFilterMixerChanged(sender: NSSlider) {
        if( sender == sliderPostFiltersMixer ){
            var percentage = sliderPostFiltersMixer.doubleValue
            //synth.setVolumeOnMixerInput(postFiltersMixerID, bus: 0, volume: percentage)
            //synth.setVolumeOnMixerInput(postFiltersMixerID, bus: 1, volume: 1.0-percentage)
        }
    }
    
    
    @IBAction func sliderPreFilterChanged(sender: NSSlider) {
        
        if( sender == sliderPreFilterMixer1 ){
            var percentage = sliderPreFilterMixer1.floatValue
            mixerPreFilter1.setInputVolume(percentage, onBus: 0)
            mixerPreFilter1.setInputVolume(1.0-percentage, onBus: 1)
        }
        if( sender == sliderPreFilterMixer2 ){
            var percentage = sliderPreFilterMixer2.floatValue
            mixerPreFilter2.setInputVolume(percentage, onBus: 0)
            mixerPreFilter2.setInputVolume(1.0-percentage, onBus: 1)
        }
        
        
    }
    
    @IBAction func oscilatorEnabledChanged(sender: NSButton) {
        
        var checked = (sender.state == NSOnState) ? true : false;
        
        if( sender == checkEnabledOsc1 ){
            osc1.setEnabled(checked)
            //synth.setEnableOnOscilatorWithID(oscil1ID, enabled:checked )
        }
        else if( sender == checkEnabledOsc2 ){
            osc2.setEnabled(checked)
            //synth.setEnableOnOscilatorWithID(oscil2ID, enabled:checked )
        }else if( sender == checkEnableFilter1 ){
            filter1.setEnabled(checked);
            
        }else if( sender == checkEnableFilter2 ){
            filter2.setEnabled(checked);
        }
    }
    
    @IBAction func oscilatorTypeChanged(sender: NSComboBox) {
        var wave : WaveType = kWaveSine
        
        if( sender.indexOfSelectedItem == 0 ){
            wave = kWaveSine
        }
        else if( sender.indexOfSelectedItem == 1  ){
            wave = kWaveSquare
        }
        else if( sender.indexOfSelectedItem == 2  ){
            wave = kWaveSaw
        }
        else if( sender.indexOfSelectedItem == 3  ){
            wave = kWaveTriangle
        }
        
        if( sender == comboOsc1WaveType ){
            osc1.wave = wave
            //synth.setWaveformOnOscilatorWithID(oscil1ID, waveform: wave)
        }
        if( sender == comboOsc2WaveType ){
            osc2.wave = wave
            // synth.setWaveformOnOscilatorWithID(oscil2ID, waveform: wave)
        }
        
        
    }
    
    @IBAction func sliderChanged(sender: NSSlider) {
        
        if( sender == sliderFrqOsc1 ){
            var f: Double = Double(sender.integerValue)
            
            lblFrqOsc1!.stringValue = "\(f) hz"
            osc1.frequency = f
            //synth.setFrequencyOnOscilatorWithID(oscil1ID, frequency: f)
        }
        if( sender == sliderFrqOsc2 ){
            var f: Double = Double(sender.integerValue)
            
            lblFrqOsc2!.stringValue = "\(f) hz"
            osc2.frequency = f
            //synth.setFrequencyOnOscilatorWithID(oscil2ID, frequency: f)
        }
        if( sender == sliderAmpOsc1 ){
            var d = sender.doubleValue
            
            lblAmpOsc1!.stringValue = "\(d)"
            osc1.amplitude = d
            //synth.setAmplitudeOnOscilatorWithID(oscil1ID, amplitude: d)
        }
        if( sender == sliderAmpOsc2 ){
            var d = sender.doubleValue
            
            lblAmpOsc2!.stringValue = "\(d)"
            osc2.amplitude = d
            //synth.setAmplitudeOnOscilatorWithID(oscil2ID, amplitude: d)
        }
        if( sender == sliderFilter1LowCutOff ){
            var d = sender.doubleValue
            filter1.lowCutOffFreq = d
            lblLowFilter1.stringValue = "\(d) hz"
        }
        if( sender == sliderFilter1HighCutOff ){
            var d = sender.doubleValue
            filter1.highCutOffFreq = d
            lblHighFilter1.stringValue = "\(d) hz"
        }
        if( sender == sliderFilter2LowCutOff ){
            var d = sender.doubleValue
            filter2.lowCutOffFreq = d
            lblLowFilter2.stringValue = "\(d) hz"
        }
        if( sender == sliderFilter2HighCutOff ){
            var d = sender.doubleValue
            filter2.highCutOffFreq = d
            lblHighFilter2.stringValue = "\(d) hz"
        }
    }
    
    
    @IBAction func buttonClicked(sender: NSButton) {
        
        if( sender == startButton ){
            //generator.start()
            //synth.powerOn()
            output.start()
        }
        if( sender == stopButton ){
            //generator.stop()
            //synth.powerOff()
            output.stop()
        }
    }
    
    
    
    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        
        /*
        osc1.connectTo(mixerPreFilter1, fromBus: 0, toBus: 0)
        osc1.connectTo(mixerPreFilter1, fromBus: 1, toBus: 1)
        mixerPreFilter1.connectTo(output, fromBus: 0, toBus: 0)
        */
        
        osc1.connectTo(mixerPreFilter1, fromBus: 0, toBus: 0)
        osc2.connectTo(mixerPreFilter1, fromBus: 0, toBus: 1)
        mixerPreFilter1.connectTo(filter1, fromBus: 0, toBus: 0)
        filter1.connectTo(output, fromBus: 0, toBus: 0)
        
        
        osc1.initializeUnits()
        osc2.initializeUnits()
        mixerPreFilter1.initializeUnits()
        mixerPreFilter2.initializeUnits()
        filter1.initializeUnits()
        filter2.initializeUnits()
        mixerPostFilter.initializeUnits()
        output.initializeUnits()
        
        
        
        sliderChanged(sliderFrqOsc1)
        sliderChanged(sliderFrqOsc2)
        sliderChanged(sliderAmpOsc1)
        sliderChanged(sliderAmpOsc2)
        oscilatorEnabledChanged(checkEnabledOsc1)
        oscilatorEnabledChanged(checkEnabledOsc2)
        
    }
    
    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
        //generator.stop()
    }
    
    
}

