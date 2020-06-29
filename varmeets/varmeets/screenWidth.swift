//
//  screenWidth.swift
//  varmeets
//
//  Created by 持田侑菜 on 2020/06/16.
//

class screenWidth: NSObject {
    /**
     * 使用端末のディスプレイサイズを返す
     * @return displaySize (.width と .height)
     */
    class func returnDisplaySize() -> CGSize {
        let displaySize = UIScreen.mainScreen().bounds.size
        
        return displaySize
}
