-- Users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    phone VARCHAR(50) UNIQUE NOT NULL,
    join_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Admins table
CREATE TABLE IF NOT EXISTS admins (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    phone VARCHAR(50) UNIQUE NOT NULL,
    role INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Orders table
-- 订单信息，包括联系人、备注等等
CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    userid INT NOT NULL,
    roomid INT NOT NULL,
    out_trade_no VARCHAR(50) NOT NULL,
    discount_type INT NOT NULL,
    discount_value INT NOT NULL,
    check_in_date DATETIME NOT NULL,
    check_out_date DATETIME NOT NULL,
    guest_name VARCHAR(50) NOT NULL,
    guest_phone VARCHAR(50) NOT NULL,
    guest_idcard VARCHAR(50) NOT NULL,
    guest_desc VARCHAR(500) NOT NULL DEFAULT '',
    night_times INT NOT NULL,
    night_price INT NOT NULL,
    total_price INT NOT NULL,
    verification_code VARCHAR(50) NOT NULL,
    verification_code_used INT DEFAULT 0,
    status INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expired_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    cancel_at TIMESTAMP NULL DEFAULT NULL,
    deleted_at TIMESTAMP NULL DEFAULT NULL
);

-- Rooms table
CREATE TABLE IF NOT EXISTS rooms (
    id SERIAL PRIMARY KEY,
    door_number VARCHAR(50) UNIQUE NOT NULL,
    price INT NOT NULL,
    cover_image TEXT,
    slider_images TEXT,
    features TEXT,
    amentities TEXT,
    name VARCHAR(50) NOT NULL DEFAULT '大床房',
    status INT DEFAULT 0,
    description TEXT,
    area INT NOT NULL DEFAULT 40,
    typeid INT NOT NULL DEFAULT -1,
    capacity INT NOT NULL DEFAULT 1,
    created_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS room_type (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

-- mode为0，房间特点，mode为1，房间设施
CREATE TABLE IF NOT EXISTS room_feature (
    id SERIAL PRIMARY KEY,
    icon VARCHAR(100) NOT NULL,
    title VARCHAR(100) NOT NULL,
    mode INT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS booking (
    id SERIAL PRIMARY KEY,
    roomid INT NOT NULL,         -- 房间ID
    orderid INT NOT NULL UNIQUE, -- 订单ID（保持唯一性）
    book_start DATE NOT NULL,    -- 预订开始时间
    book_end DATE NOT NULL,      -- 预订结束时间
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL           -- 取消/退房时间（NULL表示有效订单）
);

CREATE TABLE IF NOT EXISTS sys_info (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    value VARCHAR(100)
);

-- 优惠券系统, 0是打折，按照100进制，1是优惠券,按照分数存储
CREATE TABLE IF NOT EXISTS coupon_definition (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    discount_type INT NOT NULL DEFAULT 0,
    discount_value INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL
);

-- 默认有效期为发卡7天, 默认可以使用次数为1
CREATE TABLE IF NOT EXISTS coupon_instance (
    id SERIAL PRIMARY KEY,
    coupon_id INT NOT NULL,
    user_id INT NOT NULL,
    validaty_times INT NOT NULL DEFAULT 1,
    validity_period DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL DEFAULT NULL,
    -- 组合唯一约束 (coupon_id + user_id 不可重复)
    UNIQUE KEY uk_coupon_user (coupon_id, user_id)
);


INSERT INTO sys_info (name, value) VALUES
('contact', '17323799333'),
('worktime', '周一至周日 9:00-21:00');

INSERT INTO admins (name, phone, role) VALUES
('jianguo', '13817914965', 10);
INSERT INTO admins (name, phone, role) VALUES
('wwqdrh', '15348247596', 10);

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