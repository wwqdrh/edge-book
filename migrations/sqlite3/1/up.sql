-- Users table
-- 0 plain 1 admin 2 superadmin
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE NOT NULL,
    phone TEXT UNIQUE NOT NULL,
    password TEXT,
    role INTEGER DEFAULT 0,
    join_time TIMESTAMP DEFAULT (datetime('now', '+8 hours'))
);

-- Orders table
-- status - 0 新建订单 0 未付款 1 未入住 2 已入住 3 已完成 4 订单取消
-- discount_type, discount_value, 是在创建订单时通过coupon_id获取到的内容，用于表示用户使用了哪个优惠券并加入到数据中，如果原来优惠券有次数限制，还需要减少次数
-- out_trade_no，商户订单号
CREATE TABLE IF NOT EXISTS orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    userid INTEGER NOT NULL,
    roomid INTEGER NOT NULL,
    out_trade_no TEXT KEY NOT NULL,
    discount_type INTEGER NOT NULL,
    discount_value INTEGER NOT NULL,
    check_in_date TEXT NOT NULL,
    check_out_date TEXT NOT NULL,
    guest_name TEXT NOT NULL,
    guest_phone TEXT NOT NULL,
    guest_idcard TEXT NOT NULL,
    guest_desc TEXT NOT NULL DEFAULT '',
    night_times INTEGER NOT NULL,
    night_price INTEGER NOT NULL,
    verification_code TEXT KEY NOT NULL,
    verification_code_used INTEGER DEFAULT 0,
    status INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT (datetime('now', '+8 hours')),
    expired_at TIMESTAMP DEFAULT (datetime('now', '+8 hours', '+15 minutes')),
    cancel_at TIMESTAMP,
    deleted_at TIMESTAMP
);

-- Rooms table
-- features, 使用,分割的id
CREATE TABLE IF NOT EXISTS rooms (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    door_number TEXT UNIQUE NOT NULL,
    price INTEGER NOT NULL,
    cover_image TEXT,
    slider_images TEXT,
    features TEXT,
    amentities TEXT,
    name TEXT NOT NULL DEFAULT `大床房`,
    status INTEGER DEFAULT 0,
    description TEXT NOT NULL DEFAULT `暂无房间描述`,
    created_time TIMESTAMP DEFAULT (datetime('now', '+8 hours')),
    area INTEGER NOT NULL DEFAULT 40,
    typeid INTEGER NOT NULL DEFAULT -1,
    capacity INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS room_type (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE NOT NULL
);

-- mode为0，房间特点，mode为1，房间设施
CREATE TABLE IF NOT EXISTS room_feature (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    icon TEXT NOT NULL,
    title TEXT NOT NULL,
    mode INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS booking (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    roomid INTEGER NOT NULL,         -- 房间ID
    orderid INTEGER NOT NULL UNIQUE, -- 订单ID（保持唯一性）
    book_start DATE NOT NULL,    -- 预订开始时间
    book_end DATE NOT NULL,      -- 预订结束时间
    created_at TIMESTAMP DEFAULT (datetime('now', '+8 hours')),
    deleted_at TIMESTAMP             -- 取消/退房时间（NULL表示有效订单）
);

CREATE TABLE IF NOT EXISTS sys_info (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE NOT NULL,
    value TEXT
);

-- 优惠券系统, 0是打折，按照100进制，1是优惠券,按照分数存储
CREATE TABLE IF NOT EXISTS coupon_definition (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT UNIQUE NOT NULL,
    discount_type INTEGER NOT NULL DEFAULT 0,
    discount_value INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT (datetime('now', '+8 hours')),
    deleted_at TIMESTAMP
);

-- 默认有效期为发卡7天, 默认可以使用次数为1
CREATE TABLE IF NOT EXISTS coupon_instance (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    coupon_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    validaty_times INTEGER NOT NULL DEFAULT 1,
    validity_period DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT (datetime('now', '+8 hours')),
    deleted_at TIMESTAMP,
    -- 组合唯一约束 (coupon_id + user_id 不可重复)
    UNIQUE(coupon_id, user_id)
);

INSERT INTO sys_info (name, value) VALUES
('contact', '17323799333'),
('worktime', '周一至周日 9:00-21:00');

INSERT INTO users (name, phone, role) VALUES
('jianguo', '13817914965', 1),
('wwqdrh', '15348247596', 2);

INSERT INTO coupon_definition (name, discount_type, discount_value) VALUES
('95折优惠券', 0, 95),
('10消费券', 1, 10);

INSERT INTO room_type (name) VALUES
('大床房'),
('大床房二'),
('大床房三'),
('大床房四'),
('大床房五'),
('亲子房'),
('套房'),
('双床房');

INSERT INTO room_feature (icon, title, mode) VALUES
('🌊', '一线海景', 0),
('🎯', '地理位置优越', 0),
('🚭', '无烟房', 0),
('📺', '液晶电视', 1),
('❄️', '空调', 1),
('🛁', '浴缸', 1),
('☕️', '咖啡机', 1),
('🧴', '洗漱用品', 1),
('📶', '免费WiFi', 1),
('🚿', '一线海景', 1),
('🎯', '淋浴', 1),
('🧊', '迷你吧', 1);