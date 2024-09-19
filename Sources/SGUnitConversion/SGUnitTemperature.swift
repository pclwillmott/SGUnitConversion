// -----------------------------------------------------------------------------
// SGUnitTemperature.swift
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
//     19/09/2024  Paul Willmott - SGUnitTemperature.swift created
// -----------------------------------------------------------------------------

import Foundation

public enum SGUnitTemperature : UInt8, CaseIterable, Sendable {
  
  // MARK: Enumeration
  
  case celsius    = 0
  case fahrenheit = 1
  case kelvin     = 2

  // MARK: Public Properties
  
  public var title : String {
    return SGUnitTemperature.titles[self]!
  }

  public var symbol : String {
    return SGUnitTemperature.symbols[self]!
  }

  // MARK: Private Class Properties
  
  private static let titles : [SGUnitTemperature:String] = [
    .celsius    : String(localized: "Celsius"),
    .fahrenheit : String(localized: "Fahrenheit"),
    .kelvin     : String(localized: "Kelvin"),
  ]

  private static let symbols : [SGUnitTemperature:String] = [
    .celsius    : String(localized: "°C", comment: "Used for the abbreviation of Degrees Celsius"),
    .fahrenheit : String(localized: "°F", comment: "Used for the abbreviation of Degrees Fahrenheit"),
    .kelvin     : String(localized: "K", comment: "Used for the abbreviation of Kelvin"),
  ]

  private static var map : String {
    
    var map = "<map>\n"

    for item in SGUnitTemperature.allCases {
      map += "<relation><property>\(item.rawValue)</property><value>\(item.title)</value></relation>\n"
    }

    map += "</map>\n"
    
    return map
    
  }
  // MARK: Public Class Properties
  
  public static let mapPlaceholder = "%%UNIT_TEMPERATURE%%"

  // MARK: Public Class Methods
    
  public static func convert(fromValue:Double, fromUnits:SGUnitTemperature, toUnits:SGUnitTemperature) -> Double {
    
    var celsius : Double
    
    switch fromUnits {
    case .celsius:
      celsius = fromValue
    case .fahrenheit:
      celsius = (fromValue - 32.0) * 5.0 / 9.0
    case .kelvin:
      celsius = fromValue - 273.15
    }
    
    var result : Double
    
    switch toUnits {
    case .celsius:
      result = celsius
    case .fahrenheit:
      result = celsius * 9.0 / 5.0 + 32.0
    case .kelvin:
      result = celsius + 273.15
    }
    
    return result
    
  }

  public static func insertMap(cdi:String) -> String {
    return cdi.replacingOccurrences(of: mapPlaceholder, with: map)
  }

}
