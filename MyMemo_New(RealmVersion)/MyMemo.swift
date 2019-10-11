//
//  MyMemo.swift
//  MyMemo_New(RealmVersion)
//
//  Created by 塩澤響 on 2019/09/07.
//  Copyright © 2019 塩澤響. All rights reserved.
//

import UIKit
import RealmSwift

class MyMemo: Object {
    @objc dynamic var text = ""
    @objc dynamic var order = 0
}
