---
name: "backend-generator"
description: "生成后端工程代码，包括API接口、数据库迁移、测试文件等。根据用户描述创建符合项目结构的Lua代码和配置文件。"
---

# 后端代码生成器

## 功能说明

本技能可以根据用户的描述，生成符合项目结构的后端工程代码，包括：

- **API接口**：根据目录结构自动生成URL路径，使用Lua代码实现业务逻辑
- **数据库迁移**：生成MySQL和SQLite3的迁移文件
- **测试文件**：生成按顺序执行的测试用例
- **全局函数**：生成可在API中调用的全局Lua函数
- **配置文件**：生成server.yaml配置文件

## 项目结构参考

```
├── api/             # API接口目录（按URL路径组织）
├── assets/          # 静态资源文件
├── funcs/           # 全局Lua函数
├── migrations/      # 数据库迁移文件
│   ├── mysql/       # MySQL迁移
│   └── sqlite3/     # SQLite3迁移
├── tests/           # 测试文件
└── server.yaml      # 服务配置文件
```

## API接口文件命名规则

- 文件命名格式：`{action}.{method}.lua`
- 例如：`login.post.lua` 表示POST请求的登录接口
- 目录结构对应URL路径，例如：`api/admin/auth/login.post.lua` 对应URL `/api/admin/auth/login`

## 接口描述参数

在API接口文件开头，需要添加以下注释参数：

### 1. 接口描述
```lua
-- description=查询未完成订单列表
```

### 2. 中间件配置
```lua
-- middlewares=jwt_admin@match,role,1|2|10
```
- 使用分号(`;`)分隔多个中间件
- 使用`@`处理中间件的函数和参数
- 中间件定义在`server.yaml`中

### 3. 请求参数
```lua
-- request=[
--   {"name": "json@phone", "type": "string", "required": true},
--   {"name": "header@token", "type": "string", "required": false},
--   {"name": "query@page", "type": "int", "required": false, "default": 1}
-- ]
```

#### 参数类型说明：
- `json@`：JSON请求体中的参数
- `header@`：请求头中的参数
- `query@`：URL查询参数

#### 数据类型说明：
- `string`：字符串类型
- `int`：整数类型
- `datetime`：日期时间类型
- `file`：文件类型

#### 其他属性：
- `required`：是否必填（true/false）
- `default`：默认值

## Lua代码示例

### 简单接口
```lua
-- description=健康检查接口
-- middlewares=
-- request=[]

ctx.json(200, {msg = "pong", time=osx.time_after_seconds(0)})
```

### 复杂接口
```lua
-- description=用户登录接口
-- middlewares=jwt_admin
-- request=[
--   {"name": "json@phone", "type": "string", "required": true},
--   {"name": "json@password", "type": "string", "required": true}
-- ]

local user_phone = ctx.req("phone")
local user_password = ctx.req("password")
local res = state.orm()
    .table({"admins"})
    .select({
        "id", "role"
    })
    .first({
        "phone=?", user_phone,
    })
    .exec("base", false)

if res.err ~= nil then
    ctx.json(400, {msg="登录失败", detail=res.err})
    return
end

-- 生成token等后续逻辑
```

## 测试文件格式

测试文件使用YAML格式，按顺序执行请求，示例：

```yaml
- url: /api/auth/login
  method: post
  args:
    json@phone: "15348247596"
    json@password: "123456"
  expect:
    json@msg: 登录成功
  action:
    json@data.accessToken: senv@token
```

## 使用方法

1. **描述需求**：详细描述您需要生成的后端功能，包括：
   - 接口路径和方法
   - 接口描述（description）
   - 中间件配置（middlewares）
   - 请求参数（名称、类型、是否必填、默认值）
   - 返回格式
   - 业务逻辑描述
   - 数据库操作需求

2. **生成代码**：本技能会根据您的描述，自动生成：
   - 对应的API接口文件（包含完整的接口描述参数）
   - 数据库迁移文件（如果需要）
   - 测试文件（如果需要）
   - 全局函数（如果需要）

3. **验证和调整**：生成代码后，您可以根据实际需求进行调整和修改。

## 示例使用场景

### 场景1：生成用户注册接口

**用户描述**：
> 创建一个用户注册接口，路径为 /api/users/register，使用POST方法。接口描述：用户注册并返回token。需要参数：phone（字符串，必填）、name（字符串，必填）、password（字符串，必填）。使用jwt中间件。注册成功后返回用户ID和token。

**生成文件**：
- `api/users/register.post.lua`（包含完整的接口描述参数）
- `tests/test_users.yaml`（包含注册测试用例）

### 场景2：生成订单查询接口

**用户描述**：
> 创建一个订单查询接口，路径为 /api/orders/list，使用GET方法。接口描述：查询用户订单列表。需要参数：page（整数，默认1）、page_size（整数，默认10）。使用jwt中间件。返回用户的所有订单列表，包含分页信息。

**生成文件**：
- `api/orders/list.get.lua`（包含完整的接口描述参数）
- `tests/test_orders.yaml`（包含订单查询测试用例）

## 注意事项

1. **接口描述**：请在描述中明确接口的功能和用途
2. **中间件配置**：如果需要使用中间件，请明确中间件ID和参数
3. **参数验证**：请在描述中明确参数的类型、是否必填和默认值
4. **数据库操作**：请明确需要操作的表名和字段
5. **返回格式**：请明确返回的JSON格式和字段含义
6. **参数类型**：
   - `json@`：JSON请求体中的参数
   - `header@`：请求头中的参数
   - `query@`：URL查询参数
7. **数据类型**：
   - `string`：字符串类型
   - `int`：整数类型
   - `datetime`：日期时间类型
   - `file`：文件类型

## 内置模块

在生成的Lua代码中，可以使用以下内置模块：

- **ctx**：上下文对象，提供请求参数获取、响应返回等方法
- **state**：状态对象，提供ORM操作等方法
- **osx**：操作系统扩展方法
- **funcs**：全局函数调用，使用 `funcs.call("function_name", params)`

## 数据库操作示例

可以直接使用`ctx.req`获取接口参数在orm中使用，该模块对于不存在的`ctx.req`参数会自动过滤

find函数中支持自定义函数

1、unique: 根据id进行筛选，只保留第一个id对应的行，后续的相同的不保留

```lua
.find({
    {"unique", "id"}
})
```


### 新增用户

`[[password]]`前缀的字符串，orm模块会自动对尾部字符串进行加密

```lua
local res = state.orm()
    .table({"users"})
    .create({
        {
            name=ctx.req("name"),
            phone=ctx.req("phone"),
            password="[[password]]" .. ctx.req("password")
        }
    })
    .exec("base", false)
```

### 更新用户数据

```lua

local record = {
    name=ctx.req("name"),
    phone=ctx.req("phone")
}
if ctx.reqhas("password") then
    record.insert("password", "[[password]]" .. ctx.req("password"))
end

local res = state.orm()
    .table({"users"})
    .where({
        "id = ?", ctx.req("id")
    })
    .updates({record})
    .exec("base", false)
```

### 分页查询数据

```lua
local startidx = (ctx.req("page") - 1) * ctx.req("pagesize")
local res = state.orm()
    .table({"users"})
    .where({
        "role=?", 1
    })
    .limit({10})
	.offset({startidx})
    .find({})
    .exec("base", false)
```

### 总行数

```lua
local res = state.orm()
    .table({"users"})
    .count({})
    .exec("base", false)
```

### 联表查询

```lua
local res = state.orm()
    .table({"rooms"})
    .select({
        "rooms.*"
    })
    .joins({
        {"LEFT JOIN booking ON rooms.id = booking.roomid"}
    })
    .where({
        "booking.roomid = ? AND booking.deleted_at IS NULL AND (\
            (booking.book_start < ? AND booking.book_end > ?)\
        )", ctx.req("roomid"), ctx.req("end_date"), ctx.req("start_date")
    })
    .find({
        {"unique", "id"}
    })
    .exec("base", false)
```

### 查询，不存在就新增

```lua
local phone = ctx.req("phone")
local res = state.orm()
    .table({"users"})
    .first_or_create({
        {"phone=?", phone},
        {name="user"..phone, phone=phone,role=1}
    })
    .exec("base")
```

## 中间件使用示例

```lua
local tokenData, err = ctx.middleware("jwt", "token", {
    user={
        id=user_id,
        role=user_role
    }
})
```

## 全局函数调用示例

```lua
local result = funcs.call("checkbook", {
    room_id = room_id,
    start_date = start_date,
    end_date = end_date
})
```