// -----------------------------------------------------------------------------
// SGUnitLength.swift
//
// This Swift source file is part of the SGUnitConversion package 
// by Paul C. L. Willmott.
//
// Copyright © 2024 Paul C. L. Willmott. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the “Software”), to deal 
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
// copies of the Software, and to permit persons to whom the Software is 
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in 
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
// SOFTWARE.
// -----------------------------------------------------------------------------
//
// Revision History:
//
//     19/09/2024  Paul Willmott - SGUnitLength.swift created
// -----------------------------------------------------------------------------

import Foundation
import AppKit

public enum SGUnitLength : UInt8, CaseIterable, Sendable {
  
  // MARK: Enumeration
  
  case millimeters = 0
  case centimeters = 1
  case meters      = 2
  case kilometers  = 3
  case inches      = 4
  case feet        = 5
  case miles       = 6
  case mileschains = 7

  // MARK: Public Properties
  
  public var title : String {
    return SGUnitLength.titles[self]!
  }

  public var symbol : String {
    return SGUnitLength.symbols[self]!
  }

  // MARK: Private Class Properties
  
  private static var map : String {
    
    var map = "<map>\n"

    for item in SGUnitLength.allCases {
      map += "<relation><property>\(item.rawValue)</property><value>\(item.title)</value></relation>\n"
    }

    map += "</map>\n"
    
    return map
    
  }

  // MARK: Private Class Properties
  
  private static let titles : [SGUnitLength:String] = [
    .millimeters : String(localized: "Millimeters"),
    .centimeters : String(localized: "Centimeters"),
    .meters      : String(localized: "Meters"),
    .kilometers  : String(localized: "Kilometers"),
    .inches      : String(localized: "Inches"),
    .feet        : String(localized: "Feet"),
    .miles       : String(localized: "Miles"),
    .mileschains : String(localized: "Miles.Chains"),
  ]

  private static let symbols : [SGUnitLength:String] = [
    .millimeters : String(localized: "mm",    comment: "Used for the abbreviation of millimeters"),
    .centimeters : String(localized: "cm",    comment: "Used for the abbreviation of centimeters"),
    .meters      : String(localized: "m",     comment: "Used for the abbreviation of meters"),
    .kilometers  : String(localized: "km",    comment: "Used for the abbreviation of kilometers"),
    .inches      : String(localized: "in.",   comment: "Used for the abbreviation of inches"),
    .feet        : String(localized: "ft.",   comment: "Used for the abbreviation of feet (length)"),
    .miles       : String(localized: "mi.",   comment: "Used for the abbreviation of miles"),
    .mileschains : String(localized: "mi.ch", comment: "Used for the abbreviation of miles.chains"),
  ]

  // MARK: Public Class Properties
  
  /*
  public static let defaultValue : UnitLength = .centimeters
  public static let defaultValueActualLength   : UnitLength = .centimeters
  public static let defaultValueScaleLength    : UnitLength = .meters
  public static let defaultValueActualDistance : UnitLength = .centimeters
  public static let defaultValueScaleDistance  : UnitLength = .kilometers
  */
  
  public static let mapPlaceholder = "%%UNIT_LENGTH%%"

  // MARK: Private Class Methods
  
  // The factor to be applied to a length in units to get a length in cm.
  public static func toCM(units: SGUnitLength) -> Double {
    
    switch units {
    case .millimeters:
      return 1.0 / 10.0
    case .centimeters:
      return 1.0
    case .meters:
      return 100.0
    case .kilometers:
      return 100000.0
    case .inches:
      return 2.54
    case .feet:
      return 30.48
    case .miles:
      return 160934.4
    case .mileschains:
      return 1.0
    }
    
  }
  
  // The factor to be applied to a length in cm to get a length in units.
  public static func fromCM(units: SGUnitLength) -> Double {
    return 1.0 / toCM(units: units)
  }

  // MARK: Public Class Methods

  public static func convert(fromValue:Double, fromUnits:SGUnitLength, toUnits:SGUnitLength) -> Double {

    var temp = fromValue
    
    var from = fromUnits
    
    if fromUnits == .mileschains {
      let miles = temp.rounded(.towardZero)
      let chains = temp - miles
      temp = miles + chains / 80.0
      from = .miles
    }
    
    temp *= toCM(units: from) * fromCM(units: toUnits == .mileschains ? .miles : toUnits)
    
    if toUnits == .mileschains {
      let miles = temp.rounded(.towardZero)
      let chains = (temp - miles) * 0.80
      temp = miles + chains
    }
    
    return temp // test

  }

  @MainActor public static func populate(comboBox: NSComboBox) {
    comboBox.removeAllItems()
    for item in SGUnitLength.allCases {
      comboBox.addItem(withObjectValue: item.title)
    }
  }
  
  public static func insertMap(cdi:String) -> String {
    return cdi.replacingOccurrences(of: mapPlaceholder, with: map)
  }

}
