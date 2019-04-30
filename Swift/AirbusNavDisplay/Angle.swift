import UIKit

struct Angle {
    /// One revolution is 360 degrees
    static var rev: CGFloat = 360.0
    static var revInRadians: CGFloat = 2 * .pi
    
    var degrees : CGFloat
    var radians : CGFloat {
        return degrees * .pi / 180.0
    }
    
    init(_ degrees : CGFloat) {
        self.degrees = degrees
    }
    
    init(radians : CGFloat) {
        degrees = radians * 180.0 / .pi
    }
    
    static var max: Angle {
        return Angle(359.0)
    }
	
	static var maxDegrees: CGFloat {
		return Angle.max.degrees
	}
	
	static var maxRadians: CGFloat {
		return Angle.max.radians
	}
    
    static var min: Angle {
        return Angle(0.0)
    }
	
	static var minDegrees: CGFloat {
		return Angle.min.degrees
	}
	
	static var minRadians: CGFloat {
		return Angle.min.radians
	}
}

extension Angle: Comparable {
    static func ==(_ lhs: Angle, _ rhs: Angle) -> Bool {
        return lhs.degrees == rhs.degrees
    }
    
    static func <(_ lhs: Angle, _ rhs: Angle) -> Bool {
        return lhs.degrees < rhs.degrees
    }
    
    static func <=(_ lhs: Angle, _ rhs: Angle) -> Bool {
        return lhs.degrees <= rhs.degrees
    }
    
    static func >(_ lhs: Angle, _ rhs: Angle) -> Bool {
        return lhs.degrees > rhs.degrees
    }
    
    static func >=(_ lhs: Angle, _ rhs: Angle) -> Bool {
        return lhs.degrees >= rhs.degrees
    }
}

